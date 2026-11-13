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

## Adding an alias

This module intentionally exposes a minimal set of aliases (currently 2: `oc` and `ocu`) rather than wrapping every subcommand — subcommands are reached via `oc <subcommand>` and completed with TAB. Before proposing a new one, check:

- Is it shorter than the underlying command in a way that pays off daily?
- Does it match a workflow most users hit often (avoid rarely-used subcommands)?
- Does the chosen short form collide with any common alias (`g`, `l`, `ls`, …)? Run `alias` in a fresh shell to check.

Open an issue first to confirm the alias would be broadly useful — most proposals get rejected for being too narrow.

## Scope

This module wraps the OpenCode CLI only. Suggestions to add completions, aliases, or helpers for unrelated tools belong in a separate plugin.
