using JuliaGHA
using Test
using DataStructures

using Logging: global_logger
using GitHubActions
get(ENV, "GITHUB_ACTIONS", "false") == "true" &&
    global_logger(GitHubActions.GitHubActionsLogger())

using Pkg
Pkg.dev(url="https://github.com/notinaboat/LoggingTestSets.jl")
using LoggingTestSets

@testset LoggingTestSet "JuliaGHA.jl" begin
    @test add(2, 2) == 4
    @test dequeue!(do_stuff()) == 1

    GitHubActions.start_group("Sub testset")
    @testset "Stuff" begin
        @test 1 + 1 == 2
        @test 2^2 == 4
        @test 2 * 2 == 4
    end
    GitHubActions.end_group()

    @testset "Badness" begin
        @test 1 + 1 == 2
        @test 1 - 1 == 0
        @test 2 / 2 == 2
    end
end
