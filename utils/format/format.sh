#!/bin/sh

# Instantiate the format enviroment and format all .jl and .md files in the project root directory.
julia --project=utils/format -e '
directory = basename(pwd())
if !(directory in ["JuliaGHA", "JuliaGHA.jl"])
	@error "Format script should be run the project root directory"
	exit(1)
end

using Pkg
Pkg.instantiate()

using JuliaFormatter
format(".", verbose=true)'

echo 'Files changed:'
echo '=============='
git diff --name-only
