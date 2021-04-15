module JuliaGHA

using DataStructures

export add, do_stuff

function add(x, y)
    return x + y
end

function do_stuff()
    queue = Queue{Int}()

    str = "A really very super long string that I don't want to wrap for some reason. Don't ask me why. I don't know either. Blah blah blah."
    asdf = 2
    foo  = 3
    a    = 4

    enqueue!(queue, 1)
    enqueue!(queue, 2)
    # enqueue!(queue, "three")

    return queue
end

# function blah()
#     return "one" + "one"
# end

end # module
