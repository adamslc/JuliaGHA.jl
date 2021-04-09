using JuliaGHA
using Test

@testset "JuliaGHA.jl" begin
    @test add(2, 2) = 4
    @test dequeue!(do_stuff()) == 1
end
