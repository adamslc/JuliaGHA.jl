#!/bin/sh

echo ${PWD##*/}

# Ensure that we are in the base directory
if !([[ ${PWD##*/} == "JuliaGHA" ]] || [[ ${PWD##*/} == "JuliaGHA.jl" ]]); then
	echo 'This script should be run from the project root directory!'
	exit 1
fi

# Instantiate the format enviroment and format all .jl and .md files in the project root directory.
julia --project=utils/format -e 'using Pkg; Pkg.instantiate(); using JuliaFormatter; format(".", verbose=true)'

echo 'Files changed:'
echo '=============='
git diff --name-only
