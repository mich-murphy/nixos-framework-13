# CLAUDE.md

NixOS configuration for a Framework 13 (AMD Ryzen AI 7 350) — standalone flake with nixpkgs-unstable, home-manager, disko, and nixos-hardware.

## Project map

- `flake.nix` — entrypoint; defines system config (`p0ch1t4`), checks, and test VM
- `hosts/framework-13/` — host-specific hardware and disk config
- `modules/nixos/` — system-level NixOS modules (boot, networking, security, audio, etc.)
- `modules/home/` — home-manager modules (shell, desktop, apps, terminals, etc.)
- `theme/tokyonight.nix` — shared color palette, passed to home-manager as `colors`
- `tests/unit/` — fast eval-only unit tests
- `tests/integration/` — VM-based integration tests
- `tests/MODULE_MAP.nix` — lists all unit tests; maps source files → integration tests
- `justfile` — developer commands (`just all`, `just test`, `just check`, `just build`)
- `scripts/run-silent.sh` — context-efficient wrapper (PASS/FAIL only, detail on failure)

## Preferences

- Shell: fish, editor: neovim
- Be concise. No trailing summaries.
- Conventional Commits: `fix(scope): msg`, `feat(scope): msg`
- Ask before assuming — do not guess at design decisions or user preferences.

<important if="you need to run commands to build, test, format, or deploy">

All commands use context-efficient wrappers (PASS/FAIL summary, detail only on failure). Run via `just` (available as `nix run nixpkgs#just --`).

| Command | What it does |
| --- | --- |
| `just all` | Run everything: check + test + build |
| `just check` | Format (alejandra) + eval-only flake check |
| `just fmt` | Format all Nix files with alejandra |
| `just eval` | Eval-only flake syntax check (~5s) |
| `just test` | Run all unit + integration tests |
| `just unit` | Run all unit tests (eval-only, fast) |
| `just unit-one <name>` | Run a single unit test (e.g. `just unit-one unit-shell`) |
| `just integration` | Run all integration tests (VM-based, slow) |
| `just integration-one <name>` | Run a single integration test |
| `just build` | Build system config + full flake check |
| `just build-system` | Build the NixOS system configuration |
| `just flake-check` | Full `nix flake check` (final gate before commit) |
| `nix run .#user-test-vm` | Launch interactive VM for UAT |
| `sudo nixos-rebuild switch --flake .` | Apply configuration to the running system |

</important>

<important if="you are adding, removing, or renaming a package or NixOS/home-manager module option">

Verify it exists and is not deprecated in nixpkgs-unstable before using it. Use `search.nixos.org`, `home-manager-options.extranix.com`, or nixpkgs source as evidence. Do not guess. Prefer Nix packages and modules over manual alternatives.

</important>

<important if="you are embedding TOML, JSON, or YAML configuration in a .nix file">

Prefer `builtins.readFile` with standalone config files, upstream package defaults, or module options over inline blocks.

</important>

<important if="you are making changes across 3 or more .nix files">

- Use sub-agents to read and analyze each affected file before proposing edits.
- Break multi-module changes into groups of 2–3 files. Run `nix flake check` after each group; stop on failure.

</important>

<important if="you are debugging an error or build failure">

Read the relevant files and analyze the error before suggesting fixes. Do not guess at approaches without evidence.

</important>

<important if="you have edited a .nix file">

Run `/test` to validate changes.

</important>

<important if="you are suggesting a system switch or deploy">

Always verify the build succeeds before suggesting `nixos-rebuild switch`.

</important>
