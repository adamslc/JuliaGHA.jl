#!/bin/sh

# Instantiate the format enviroment and format all .jl and .md files in the project root directory.
JULIA_LOAD_PATH=utils/lint:.
julia --project=utils/lint -e '
directory = basename(pwd())
if !(directory in ["JuliaGHA", JuliaGHA.jl"])
	@error "Format script should be run the project root directory"
	exit(1)
end

using Pkg
Pkg.instantiate()
using JET

Pkg.activate(".")
Pkg.instantiate()

results = report_file("src/JuliaGHA.jl", analyze_from_definitions=true)
results.any_reported && exit(1)'
