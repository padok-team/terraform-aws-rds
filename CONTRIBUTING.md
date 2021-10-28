# Contributing

When contributing to this repository, please first discuss the change you wish to make via an [issue](https://github.com/padok-team/terraform-module-example/issues) before making a change.  **REPLACE THIS WITH THE URL OF YOUR REPO**

## Pull Request Process

1. Update the README.md with details of changes including example hcl blocks and [example files](./examples) if appropriate.
2. Run pre-commit hooks `pre-commit run -a`.
3. Once all outstanding comments and checklist items have been addressed, your contribution will be merged! Merged PRs will be included in the next release.

## Checklists for contributions

- [ ] Add [semantics prefix](#semantic-pull-requests) to your PR or Commits (at least one of your commit groups)
- [ ] CI tests are passing
- [ ] Run `make doc` to update README.md after any changes to variables and outputs
- [ ] Run pre-commit hooks `pre-commit run -a`

## Commit Message Format

A format influenced by [Angular commit message].

```text
<type>: <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

### Type

Must be one of the following:

- **docs:** Documention only changes
- **ci:** Changes to our CI configuration files and scripts
- **chore:** Updating Makefile etc, no production code changes
- **feat:** A new feature
- **fix:** A bug fix
- **perf:** A code change that improves performance
- **refactor:** A code change that neither fixes a bug nor adds a feature
- **style:** Changes that do not affect the meaning of the code
- **test:** Adding missing tests or correcting existing tests

### Footer

The footer should contain a [closing reference to an issue] if any.

The **footer** should contain any information about **Breaking Changes** and is
also the place to reference GitHub issues that this commit **Closes**.

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space
or two newlines. The rest of the commit message is then used for this.

[submitting an issue]: https://github.com/padok-team/terraform-module-example/issues **REPLACE THIS WITH THE URL OF YOUR REPO**
[GitHub Repository]: https://github.com/padok-team/terraform-module-example **REPLACE THIS WITH THE URL OF YOUR REPO**
[Angular commit message]: https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit-message-format
[Closing reference to an issue]: https://help.github.com/articles/closing-issues-via-commit-messages/
