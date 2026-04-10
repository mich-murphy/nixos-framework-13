# Global Claude Instructions

## General Workflow

- **Ask before assuming.** Do not make assumptions about design principles, architecture decisions, or user preferences. Ask clarifying questions first, then propose.
- **Front-load debugging context.** When the user provides an error, read the relevant files and analyze the error before suggesting fixes. Do not guess at approaches without evidence.
- **Delegate cross-cutting changes.** When a task involves 3+ independent files or concerns, use sub-agents to handle each independently, then summarize all changes for review before committing.

## NixOS Workflow

- **Verify against nixpkgs-unstable.** Before adding, removing, or renaming any package or module option, confirm it exists and is not deprecated in nixpkgs-unstable. Use `search.nixos.org`, `home-manager-options.extranix.com`, or nixpkgs source as evidence. Do not guess.
- **Prefer upstream over inline.** Do not embed large TOML, JSON, or YAML blocks inline. Use `builtins.readFile`, standalone files, or upstream package defaults when available.
- **Confirm before bulk changes.** Before applying batch fixes, verify each issue is real in the current channel, then present the full list for user confirmation before editing.
- **Batch in small validated groups.** Break multi-module changes into groups of 2-3 files. Run `nix flake check` after each group; stop on failure.
- **Use agents for cross-file analysis.** Before changes spanning multiple NixOS/home-manager modules, use sub-agents to read and analyze each affected file, then synthesize findings before proposing edits.
- **Self-correct with targeted tests.** After editing a .nix file, consult `tests/MODULE_MAP.nix` for the relevant tests. Run only those tests — not the full suite. See Testing Workflow below.

## Testing Workflow

After editing any .nix file, run ONLY the relevant tests — never the full suite:

1. Look up changed file(s) in `tests/MODULE_MAP.nix` to find mapped test names
2. Run mapped unit tests first (fast): `nix build .#checks.x86_64-linux.<unit-test-name>`
3. If unit tests pass, run mapped integration tests: `nix build .#checks.x86_64-linux.<integration-test-name>`
4. On failure: read the FAIL line for the source file path and expected/actual values, fix, re-run only the failing test
5. Do NOT run `nix flake check` on every change — only as a final gate before commit
6. If a file is not in MODULE_MAP.nix, run `nix flake check --no-build` (eval-only, ~5s) to catch syntax errors

## User context

- Shell: fish
- Editor: neovim

## Preferences

- Be concise. No trailing summaries.
- Conventional Commits for all repos: fix(scope): msg, feat(scope): msg
- Always verify builds before suggesting switch/deploy.
- Prefer Nix packages and modules when available.
- Format Nix files with alejandra (nix fmt).
- Do not add comments, docstrings, or type annotations to code you didn't change.
