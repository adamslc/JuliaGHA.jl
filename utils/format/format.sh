#!/bin/sh

# Ensure that we are in the base directory
if ![[ ${PWD##*/} == "JuliaGHA" ]]
	echo 'This script should be run from the project root directory!'
end

# Instantiate the format enviroment and format all .jl and .md files in the project root directory.
julia --project=utils/format -e 'using Pkg; Pkg.instantiate(); using JuliaFormatter; format(".", verbose=true)'
