using JuliaGHA
using Test
using DataStructures

using Logging: global_logger
using GitHubActions
get(ENV, "GITHUB_ACTIONS", "false") == "true" && global_logger(GitHubActions.GitHubActionsLogger())

@debug "foo bar" rand(3)
@info "foo bar" rand(3)
@warn "foo bar" rand(3)
@error "foo bar" rand(3)

@testset "JuliaGHA.jl" begin
    @test add(2, 2) == 4
    @test dequeue!(do_stuff()) == 1

    GitHubActions.start_group("Sub testset")
    @testset "Stuff" begin
        @test 1 + 1 == 2
        @test 2 ^ 2 == 3
        @test 2 * 2 == 4
    end
    GitHubActions.end_group()
end
