# CLAUDE.md (dotfiles project)

## Git & GitHub

- Commit messages must be in English
- Use semantic commit message format: `feat(foo): ...`, `fix(bar): ...`, etc.
- No amend commits
- Include the prompt used at the bottom of commit messages starting with `prompt: `
- Always create Pull Requests as draft

## Code Style

- Do not add unnecessary or obvious code comments
- After changing .tf files, always run `terraform fmt`

## Editorconfig

- insert_final_newline = true
- trim_trailing_whitespace = true
