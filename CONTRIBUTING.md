# Contributing

Thanks for considering a contribution to `zsh-opencode-completion`.

## Reporting a bug

Open an issue with:

- `opencode --version` output
- `zsh --version` output
- The exact command that misbehaved
- Steps to reproduce

If the bug is about completion, also mention whether `~/.zsh-completion/_opencode` (or the equivalent path under your plugin manager) exists and its mtime relative to `~/.opencode/bin/opencode`.

## Submitting a pull request

1. Fork and create a feature branch.
2. Before pushing, run locally:
   ```sh
   shellcheck init.zsh zsh-opencode-completion.plugin.zsh
   zsh -n init.zsh && zsh -n zsh-opencode-completion.plugin.zsh
   ```
   Both must exit 0. CI runs the same checks on every PR.
3. Open the PR against `main`.

Do not edit `functions/_opencode` by hand. It is regenerated from `opencode --completions zsh` on the next shell start when the binary is newer than the cached file.

## Scope

This module provides the tab completion for the OpenCode CLI and nothing else. It defines no aliases — alias proposals belong in the user's own shell configuration, not here. Suggestions to add completions or helpers for unrelated tools belong in a separate plugin.
