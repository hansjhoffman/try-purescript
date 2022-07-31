# Build configuration
# -------------------

APP_NAME = `node -p "require('./package.json').name"`
GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
GIT_REVISION = `git rev-parse HEAD`

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@printf "\n\033[34mEnvironment\033[0m\n"
	@printf "\033[34m---------------------------------------------------------------\033[0m\n"
	@printf "\033[33m%-23s\033[0m" "APP_NAME"
	@printf "\033[35m%s\033[0m" $(APP_NAME)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_BRANCH"
	@printf "\033[35m%s\033[0m" $(GIT_BRANCH)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_REVISION"
	@printf "\033[35m%s\033[0m" $(GIT_REVISION)
	@echo ""

.PHONY: targets
targets:
	@printf "\n\033[34mTargets\033[0m\n"
	@printf "\033[34m---------------------------------------------------------------\033[0m\n"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# Build targets
# -------------------

.PHONY: clean
clean: ## Remove build artifacts
	rm -rf dist

.PHONY: build
build: compile-ts ## Make a production build
	yarn vite build

.PHONY: compile-ts
compile-ts: ## Run Typscript compiler
	yarn tsc

# Development targets
# -------------------

.PHONY: deps
deps: ## Install all dependencies
	yarn install

.PHONY: preview
preview: build ## See what the production build will look like
	yarn vite preview --https

.PHONY: run
run: ## Run web app
	yarn vite --host 0.0.0.0 --port 4000

# Check, lint, format and test targets
# ------------------------------------

.PHONY: format
format: format-purs format-ts ## Format everything

.PHONY: format-purs
format-purs: ## Format PureScript files
	purty

.PHONY: format-ts
format-ts: ## Format typescript files
	yarn prettier --write '**/*.ts'

.PHONY: lint
lint: lint-ts ## Lint files

.PHONY: lint-ts
lint-ts: ## Lint ts files
	yarn eslint '**/*.ts'

.PHONY: lint-elm-fix
lint-elm-fix: ## Lint fix all elm files
	elm-review --fix-all

.PHONY: lint-ts-fix
lint-ts-fix: ## Lint fix all Typescript files
	yarn eslint '**/*.ts' --fix

.PHONY: test
test: ## Test code
	spago test
