.PHONY: all
all: format test

.PHONY: test
test:
	julia --project=. -e 'using Pkg; Pkg.test()'

.PHONY: format
format:
	./utils/format/format.sh
