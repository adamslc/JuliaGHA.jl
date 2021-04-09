.PHONY: all
all: format lint test

.PHONY: test
test:
	julia --project=. -e 'using Pkg; Pkg.test()'

.PHONY: lint
format:
	./utils/lint/lint.sh

.PHONY: format
format:
	./utils/format/format.sh
