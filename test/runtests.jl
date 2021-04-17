using JuliaGHA
using Test
using DataStructures

using Logging: global_logger, current_logger
using LoggingExtras
using GitHubActions
get(ENV, "GITHUB_ACTIONS", "false") == "true" &&
    global_logger(TeeLogger(current_logger(), GitHubActions.GitHubActionsLogger()))

using Pkg
Pkg.develop(url = "https://github.com/adamslc/LoggingTestSets.jl")
using LoggingTestSets

@testset LoggingTestSet "JuliaGHA.jl" begin
    @test add(2, 2) == 4
    @test dequeue!(do_stuff()) == 1

    @testset "Stuff" begin
        @test 1 + 1 == 2
        @test 2^2 == 4
        @test 2 * 2 == 4
    end

    @testset "Badness" begin
        @test 1 + 1 == 2
        @test 1 - 1 == 0
        @test 2 / 2 == 1
    end
end
