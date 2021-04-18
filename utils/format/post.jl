using HTTP
using JSON

# Working, gets PR details
# r = HTTP.request("GET", "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5")
# println(r.status)
# j = JSON.parse(String(r.body))

gha_token = "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"
sha = "2ef47e1356d0eee289b447074b4efe0655f4230a"

# Working, posts issue comment on PR
# params = Dict("body" => "Hello world!")
# r = HTTP.request("POST", "https://api.github.com/repos/adamslc/JuliaGHA.jl/issues/5/comments",
#                  ["Content-Type" => "application/json", "Authorization" => "token $gha_token"],
#                  JSON.json(params))
# println(r.status)
# body = String(r.body)
# println(body)
# j = JSON.parse(body)

# Not working, should post an issue comment on a PR
params = Dict("body" => "Hello world!", "path" => "src/JuliaGHA.jl", "line" => 24, "side" => "RIGHT", "commit_id" => sha)
r = HTTP.request("POST", "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5/comments",
                 ["Accept" => "application/vnd.github.comfort-fade-preview+json",
                  "Content-Type" => "application/json", "Authorization" => "token $gha_token"],
                 JSON.json(params))
println(r.status)
body = String(r.body)
j = JSON.parse(body)

# Lists review comments on PR
# params = Dict("per_page" => 10, "page" => 1)
# r = HTTP.request("GET", "https://api.github.com/repos/adamslc/JuliaGHA.jl/pulls/5/comments",
#                  ["Accept" => "application/vnd.github.comfort-fade-preview+json",
#                   "Content-Type" => "application/json", "Authorization" => "token $gha_token"],
#                  JSON.json(params))
# println(r.status)
# body = String(r.body)
# j = JSON.parse(body)
