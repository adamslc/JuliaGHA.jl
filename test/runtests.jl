using JuliaGHA
using Test
using DataStructures

using Logging: global_logger
using GitHubActions
get(ENV, "GITHUB_ACTIONS", "false") == "true" &&
    global_logger(GitHubActions.GitHubActionsLogger())

@testset "JuliaGHA.jl" begin
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

        try
            sqrt(-1)
        catch e
            @error "asdfasdf" exception=(e, catch_backtrace())
        end
    end
end
