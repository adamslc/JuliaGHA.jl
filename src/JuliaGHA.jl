module JuliaGHA

using DataStructures

export add, do_stuff

function add(x, y)
    return x + y
end

function do_stuff()
    queue = Queue{Int}()

    enqueue!(queue, 1)
    enqueue!(queue, 2)
    # enqueue!(queue, "three")

    return queue
end

function blah()
    return "one" + "one"
end

end # module
