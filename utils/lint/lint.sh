#!/bin/sh

# Ensure that we are in the base directory
if [[ ${PWD##*/} != "JuliaGHA" ]]; then
	echo 'This script should be run from the project root directory!'
fi

# Instantiate the format enviroment and format all .jl and .md files in the project root directory.
JULIA_LOAD_PATH=utils/lint:.
julia --project=utils/lint -e '
using Pkg
Pkg.instantiate()
using JET

Pkg.activate(".")
Pkg.instantiate()

results = report_file("src/JuliaGHA.jl", analyze_from_definitions=true)
results.any_reported && exit(1)'
