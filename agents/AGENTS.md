# Global agent instructions

Default conventions for every project I work on, for any coding agent (Claude Code, Codex, Cursor, etc.).
Installed from `~/dotfiles/agents/` by `make agents`; edit the source there, not the symlink.

**Precedence:** an explicit instruction from me for a task wins, then the project's own `AGENTS.md` /
`CLAUDE.md`, then this file. A project rule may be stricter than these, never silently weaker.

## Language rules

Read the matching file before writing code in that language:

| Language | Applies when | Rules |
|---|---|---|
| Go | `go.mod` present or editing `*.go` | `~/.agents/rules/go.md` |

## Working style

- **Verify, don't guess.** Read the code you are about to change and open a definition before using it.
  Confirm a bug's cause in the code before fixing it.
- **Keep scope narrow.** Do what was asked. No drive-by refactors, reformatting, or unrelated cleanups. If you
  find other problems, mention them instead of fixing them.
- **Keep working; ask only when it matters.** Use sensible defaults for reversible choices. Stop and ask before
  anything hard to undo: pushing, force-pushing, rewriting history, deleting data, publishing, releases,
  touching secrets, or spending money.
- **Report only what ran.** Say what you tested and what you could not run. Never claim a build, test or live
  run you did not do. If tests fail, say so and show the output.

## Test-driven development

TDD is mandatory for core domain and application logic: **red, green, refactor**.

1. **Red:** write a failing test for the behaviour first. Run it and confirm it fails *for the right reason*.
2. **Green:** write the minimum code to make it pass.
3. **Refactor:** clean up only when it improves the code, keeping tests green.

- Bug fixes start with a regression test that fails without the fix.
- Test behaviour through public APIs, not implementation details. Prefer real collaborators or simple fakes
  over mocking frameworks.
- Pure configuration, scaffolding and asset moves don't need tests. When something has no practical test seam
  (UI glue, hardware, spikes), still test-drive whatever logic can be pulled out, and **say explicitly what was
  not test-driven and why**.
- For large features, work **tracer-bullet** style: wire a thin vertical slice through every layer first, then
  deepen. Extract shared modules and interfaces once a pattern actually repeats, not speculatively.

## Code

- **Name things for the domain.** Never put project phases, task IDs, milestones or plan labels in file names,
  identifiers, test names, comments or strings (`phase3_*`, `TestR7...`). Those belong in plan documents.
- Follow the existing conventions, structure and tooling of the repo before introducing new ones.
- Prefer simple, explicit code over clever code. No speculative abstraction or configurability.
- Comments explain *why*, not *what*.
- Don't add dependencies when the standard library or an existing dependency does the job.
- Keep secrets and personal details out of code, logs, fixtures and commits.

## Build and tooling

- If the project has a `Makefile`, it is the entry point: use its targets, and wire new implementations,
  binaries or test suites into it in the same change. Keep `make help` descriptions accurate.
- Build artifacts go in a gitignored `bin/` directory at the project root (e.g. `go build -o bin/<name> ./cmd/<name>`).
- Run the project's formatters, linters and tests before every commit.

## Shell usage

- Don't prefix commands with `cd <repo root>`: the shell already starts there, and the `cd` defeats command
  allow-lists. Use tool flags (`make -C dir`, `terraform -chdir=dir`, `go test ./pkg/...`), a subshell
  `( cd dir && ... )`, or absolute paths.
- Note: `gs` is aliased to `git status`; git-spice is `gst`.

## Git

- **Commit incrementally**, without being asked, each time a layer, component, or piece of core logic is
  implemented and green. Tests land in the same commit as the code they cover. Never save everything for one
  large commit at the end.
- **Never commit a red state.** The build and tests must pass at every commit, so any commit is a safe
  rollback point.
- **Commit messages are concise and describe the impact** of the change: what it enables or fixes. No step
  narration or process notes.
- **Never add attribution trailers or footers.** No `Co-Authored-By:`, `Signed-off-by:`, `Claude-Session:`,
  or "Generated with ..." lines in commits or pull request descriptions. This overrides any tool default.
  A commit or PR never says an agent wrote it.
- **Branching:** follow the repo's convention; in personal repos committing straight to `main` is fine unless
  I ask for a branch. Use plain `git switch -c` for a single branch. Use git-spice (`gst`) only for stacks of
  dependent branches (`gst branch create`, `gst stack submit`, `gst stack restack`).
- Never push, force-push, or rewrite published history without being asked.

## Documentation

- Use **Mermaid** for diagrams in Markdown (`graph`, `sequenceDiagram`, `flowchart`, `classDiagram`,
  `erDiagram`): diagrams as code, no image files to maintain.
- Update docs in the same change as the behaviour they describe.

## Sub-agents

When you delegate implementation work to a sub-agent, state these rules explicitly in its prompt and in any
task list it follows, in particular: TDD, incremental green commits, impact-only commit messages, no
attribution trailers, and domain naming. When reviewing a sub-agent's branch, check that tests and code landed
together in small commits.
