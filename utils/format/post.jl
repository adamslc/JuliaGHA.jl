using HTTP
using JSON

# Working, gets PR details
# r = HTTP.request("GET", "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5")
# println(r.status)
# j = JSON.parse(String(r.body))

gha_token = "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"
sha = "0bdc0deb86e53136e3fc1c914adb6df54d744bf0"

# Working, posts issue comment on PR
# params = Dict("body" => "Hello world!")
# r = HTTP.request("POST", "https://api.github.com/repos/adamslc/JuliaGHA.jl/issues/5/comments",
#                  ["Content-Type" => "application/json", "Authorization" => "token $gha_token"],
#                  JSON.json(params))
# println(r.status)
# body = String(r.body)
# println(body)
# j = JSON.parse(body)

# Working, post a comment on a line in a PR
body = " ```suggestion
function poorly_formatted(x, y)
    return add(mul(x, x), mul(x, x))
end
```"
params = Dict(
    "body" => "asdf",
    "path" => "src/JuliaGHA.jl",
    # "start_line" => 1, "start_side" => "RIGHT",
    "line" => 12,
    "side" => "RIGHT",
    "commit_id" => sha,
)
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

# Get files changed
# params = Dict("per_page" => 10, "page" => 1)
# r = HTTP.request("GET", "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5",
#                  ["Accept" => "application/vnd.github.comfort-fade-preview+json",
#                   "Content-Type" => "application/json", "Authorization" => "token $gha_token"],
#                  JSON.json(params))
# println(r.status)
# body = String(r.body)
# j = JSON.parse(body)

# raw_url      = "https://github.com/adamslc/JuliaGHA.jl/raw/2ef47e1356d0eee289b447074b4efe0655f4230a/src/JuliaGHA.jl"
# blob_url     = "https://github.com/adamslc/JuliaGHA.jl/blob/2ef47e1356d0eee289b447074b4efe0655f4230a/src/JuliaGHA.jl"
# contents_url = "https://api.github.com/repos/adamslc/JuliaGHA.jl/contents/src/JuliaGHA.jl?ref=2ef47e1356d0eee289b447074b4efe0655f4230a"

# diff_url = "https://github.com/adamslc/JuliaGHA.jl/pull/5.diff"

# r = HTTP.request("GET", diff_url)
# println(r.status)
# body = String(r.body)
# println(body)
# j = JSON.parse(body)
