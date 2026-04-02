Analyze this NixOS configuration repository and generate or update documentation.

## Steps

1. **Inventory**: Read `flake.nix` to identify all inputs, outputs, and the module tree. List every NixOS module under `modules/nixos/` and every home-manager module under `modules/home/`.

2. **Per-module summary**: For each module file, extract:
   - What packages it installs
   - What services it enables
   - What notable options it sets
   - Any external dependencies (hardware, other modules)

3. **Host profile**: Read `hosts/framework-13/default.nix` and `hardware-configuration.nix` to summarize the hardware target and host-specific overrides.

4. **Generate README.md**: Produce a `README.md` at the repo root with:
   - Project description (from flake description)
   - Hardware target
   - Module inventory table (module path, one-line purpose)
   - Flake inputs table (input name, source URL)
   - Usage instructions (`nixos-rebuild switch --flake .#p0ch1t4`)
   - Theme info from `theme/`

5. **Validate**: Confirm every module file listed in the docs actually exists in the repo. Flag any orphaned references. Run `nix flake check` to confirm the repo is healthy.

6. **Present changes**: Show the generated/updated documentation for user review before writing.

Do not add inline code comments to any Nix files. Only create or update documentation files (README.md).
