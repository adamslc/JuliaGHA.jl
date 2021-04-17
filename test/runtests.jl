using JuliaGHA
using Test

using Logging: global_logger, current_logger
using LoggingExtras
using GitHubActions
get(ENV, "GITHUB_ACTIONS", "false") == "true" &&
    global_logger(TeeLogger(current_logger(), GitHubActions.GitHubActionsLogger()))

using Pkg
Pkg.develop(url = "https://github.com/adamslc/LoggingTestSets.jl")
using LoggingTestSets

@testset LoggingTestSet "JuliaGHA.jl" begin
    @testset "add" begin
        @test add(1, 1) == 2
        @test add(2, 2) == 4
        @test add(3, 3) == 6
    end

    @testset "mul" begin
        @test mul(1, 1) == 1
        @test mul(2, 2) == 4
        @test mul(3, 3) == 9
    end
end
