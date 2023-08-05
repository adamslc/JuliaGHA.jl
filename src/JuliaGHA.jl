module JuliaGHA

export add, mul

function add(x, y)
    return x + y
end

# Broke the formatting
function mul(w, z)
    return w *
    z
end

# Untested, but will result in a Method Error.
# JET.jl will find it!
function untested_func(x::String, y::String)
    return add(x, y)
end

# Breaks tests!
function add(x::Int, y::Int)
    return 1
end

# Does not pass formatting test.
function   poorly_formatted(x     , y  )
    return add(mul(x,x),
        mul(x,    
            x))
    end

function a_new_func(x::Real)
    return 2 * x
end

end # module
