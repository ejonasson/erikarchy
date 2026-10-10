# CLAUDE.md

The instructions for working in this repository are in `AGENTS.md`, shared
with other coding agents, and imported here:

@AGENTS.md

## Claude Code specifics

- **Summarise every change in `README.md`** (changelog plus any affected
  reference section) in the same commit. Don't end a task that changed files
  in this repo with the README out of date.
- Claude Code only loads this file for sessions started inside `~/.config`.
  If you're working on these files from another directory (such as `~`),
  read `~/.config/AGENTS.md` before editing.
- End commit messages with the `Co-Authored-By` attribution line that Claude
  Code provides.
