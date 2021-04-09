module JuliaGHA

using DataStructures

export add, do_stuff

function add(x, y)
    return x + y + 1
end

function do_stuff()
    queue = Queue{Int}()

    enqueue!(queue, 1)
    enqueue!(queue, 2)
    enqueue!(queue, "three")

    return queue
end

end # module
