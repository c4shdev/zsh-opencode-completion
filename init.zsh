#!/usr/bin/env zsh
# init.zsh — core (Zimfw auto-source; omz/standalone via .plugin.zsh).
#
# This module provides the tab completion for the OpenCode CLI. It defines no
# aliases: those belong in the user's own shell configuration.

# Locate the binary. If it is not on PATH, add its directory so the completion
# can be generated from it.
if ! command -v opencode &>/dev/null; then
  _opencode_bin_dir="${OPENCODE_BIN:-${HOME}/.opencode/bin}"
  if [[ -d "$_opencode_bin_dir" && ":$PATH:" != *":${_opencode_bin_dir}:"* ]]; then
    path=("$_opencode_bin_dir" "${path[@]}")
  fi
  unset _opencode_bin_dir
fi

# shellcheck disable=SC2296,SC2298 # ${(%):-%x} is the zsh idiom for the sourced script path; no bash equivalent.
_opencode_compfile="${${(%):-%x}:A:h}/functions/_opencode"
_opencode_bin="${OPENCODE_BIN:-${HOME}/.opencode/bin}/opencode"
if [[ -x "$_opencode_bin" ]]; then
  [[ -d "${_opencode_compfile:h}" ]] || mkdir -p "${_opencode_compfile:h}"
  if [[ ! -f "$_opencode_compfile" || "$_opencode_bin" -nt "$_opencode_compfile" ||
        "$(<"$_opencode_compfile")" != '#compdef opencode'* ]]; then
    "$_opencode_bin" --completions zsh >! "$_opencode_compfile" 2>/dev/null
  fi
fi
unset _opencode_bin _opencode_compfile

command -v opencode &>/dev/null && {
  # Register this module's completion. compdef only exists once compinit has
  # run, and this module loads before it, so bind on the first prompt and keep
  # retrying until it takes. Registering `opencode` as well as `oc` repairs a
  # stale zcompdump that never picked up the completion function, and gives the
  # conventional `oc` shortname the same completion to users who alias it.
  # shellcheck disable=SC2154,SC2296 # compdef, the functions array and ${(@)} are zsh builtins.
  _opencode_bind_completion() {
    if (( $+functions[compdef] )); then
      compdef _opencode opencode oc 2>/dev/null
    fi
    if (( $+_comps[oc] && $+_comps[opencode] )); then
      precmd_functions=("${(@)precmd_functions:#_opencode_bind_completion}")
    fi
    return 0
  }
  if (( $+functions[compdef] )); then
    _opencode_bind_completion
  else
    precmd_functions+=( _opencode_bind_completion )
  fi
}
