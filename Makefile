.PHONY: install
install:
	pre-commit install
	pre-commit install --hook-type commit-msg

.PHONY: doc
doc: README.md
	terraform-docs .

.PHONY: format
format:
	terraform fmt
	terraform validate
