using HTTP

struct SingleDiff
    a_lines::UnitRange{Int}
    b_lines::UnitRange{Int}

    a_content::String
    b_content::String
end

struct FileDiff
    filename::String
    diffs::Vector{SingleDiff}
end

struct Diff
    files::Dict{String,FileDiff}
end

function parse_diff(diff::String)
    lines = filter(x -> x != "", split(diff, "\n"))

    files = Dict{String,FileDiff}()

    i = 1
    while i <= length(lines)
        if startswith(lines[i], "diff")
            file_diff, i = parse_file_diff(lines, i)

            @assert !haskey(files, file_diff.filename)
            files[file_diff.filename] = file_diff
        else
            i += 1
        end
    end

    return Diff(files)
end

# Returns a FileDiff, and the next index to look at
function parse_file_diff(lines, i::Int)
    @assert startswith(lines[i], "diff")
    filename = split(lines[i], " ")[3][3:end]

    diffs = Vector{SingleDiff}()

    i += 1
    while i <= length(lines) && !startswith(lines[i], "diff")
        if startswith(lines[i], "@@")
            diff, i = parse_single_diff(lines, i)
            push!(diffs, diff)
        else
            i += 1
        end
    end

    return FileDiff(filename, diffs), i
end

function parse_single_diff(lines, i::Int)
    @assert startswith(lines[i], "@@")

    line_num_tokens = split(lines[i], " ")
    a_line_str = line_num_tokens[2][2:end]
    b_line_str = line_num_tokens[3][2:end]

    a_lines = parse_diff_lines(a_line_str)
    b_lines = parse_diff_lines(b_line_str)

    a_content = ""
    b_content = ""

    i += 1
    while i <= length(lines) && !startswith(lines[i], "diff") && !startswith(lines[i], "@@")
        if startswith(lines[i], " ")
            a_content *= "\n" * lines[i][2:end]
            b_content *= "\n" * lines[i][2:end]
        elseif startswith(lines[i], "-")
            a_content *= "\n" * lines[i][2:end]
        elseif startswith(lines[i], "+")
            b_content *= "\n" * lines[i][2:end]
        else
            @error "Unexpected line in diff" line = lines[i]
        end

        i += 1
    end

    # Need to remove the first character from the diffs because it is an
    # extra newline character.
    return SingleDiff(a_lines, b_lines, a_content[2:end], b_content[2:end]), i
end

function parse_diff_lines(str)
    if findfirst(",", str) === nothing
        start_line = parse(Int, str)
        return start_line:start_line
    else
        start_line, len = parse.(Int, split(str, ","))
        return start_line:start_line+len-1
    end
end

function get_github_diff(url)
    r = HTTP.request("GET", url)
    @info "HTTP status" status = r.status
    diff = String(r.body)
end

function post_code_comment(file, lines, body, url, sha, gha_token)
    params = Dict("body" => body, "path" => "src/JuliaGHA.jl", "commit_id" => sha)

    if first(lines) >= last(lines)
        params["line"] = first(lines)
        params["side"] = "RIGHT"
    else
        params["start_line"] = first(lines)
        params["start_side"] = "RIGHT"
        params["line"] = last(lines)
        params["side"] = "RIGHT"
    end

    r = HTTP.request(
        "POST",
        "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5/comments",
        [
            "Accept" => "application/vnd.github.comfort-fade-preview+json",
            "Content-Type" => "application/json",
            "Authorization" => "token $gha_token",
        ],
        JSON.json(params),
    )
    println(r.status)
    body = String(r.body)
    j = JSON.parse(body)
end

function main(; max_files = 3, max_diffs_per_file = 5)
    if !haskey(ENV, "GITHUB_API_URL")
        @error("Not running on GitHub Actions")
        return false
    end

    format_diff = parse_diff(read(`git diff -U0`, String))

    if length(format_diff.files) > max_files
        @error(
            "Aborting because there are more than $max_files files with changes",
            files_changed = length(format_diff.files)
        )
        return false
    end

    for (file, diff) in format_diff.files
        if length(diff.diffs) > max_diffs_per_file
            @error(
                "Aborting because there are more than $max_diffs_per_file in $file",
                num_diffs = length(diff.diffs)
            )
            return false
        end
    end

    pr_number = split(ENV["GITHUB_REF"], "/")[3]
    url = "$(ENV["GITHUB_API_URL"])/repos/$(ENV["GITHUB_REPOSITORY"])/pulls/$pr_number.diff"
    github_diff = parse_diff(get_github_diff(url))

    # Check that each format diff can be accessed in the GitHub diff. If not,
    # then leaving suggusted changes will fail. This is a GitHub limitation.
    @show github_diff.files
    for (file, file_diff) in format_diff.files
        if !haskey(github_diff.files, file_diff.filename)
            @error(
                "A file has a formatting change that is not included in the PR diff",
                file = file_diff.filename
            )
            return false
        end

        github_file_diff = get(github_diff, file_diff.filename)
        for diff in file_diff.diffs
            format_lines = diff.a_lines

            lines_contained = false
            for github_single_diff in github_file_diff.files
                if issubset(format_lines, github_single_diff.b_lines)
                    lines_contained = true
                    break
                end
            end

            if !lines_contained
                @error(
                    "A file has changes in locations not included in the
                    original diff",
                    file = file_diff.filename
                )
            end
        end
    end

    for (file, file_diff) in format_diff.files
        for diff in file_diff.diffs
            @info "Diff" content = diff.b_content lines = diff.a_lines
        end
    end

    return true
end
main()
