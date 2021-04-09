module JuliaGHA

using DataStructures

export add, do_stuff

function add(x, y)
    return x + y + 1
end

function do_stuff()
    queue = Queue{Int}()

    push!(queue, 1)
    push!(queue, 2)
    push!(queue, "three")

    return queue
end

end # module
