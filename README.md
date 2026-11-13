# zsh-opencode-completion

Plugin/módulo zsh que provee la tab completion del CLI de OpenCode. Compatible con Zimfw, oh-my-zsh y standalone.

## Características

- 🚀 **Alto rendimiento**: usa `mtime check` (no `--version`) para invalidación de cache, más un guard de contenido que detecta un cache corrupto. Costo en shell startup: ~0.7ms (stat) vs ~600ms (regeneración completa).
- 🎯 **Sin aliases**: el módulo no define ningún alias, sólo registra la completion. Los atajos (`oc`, `ocu`) van en tu propia configuración de shell.
- 🔌 **Multi-manager**: estructura idiomática compatible con Zimfw (sin flags), oh-my-zsh y standalone.
- 🪶 **Cero dependencias externas**: sólo requiere el binario `opencode` instalado.

## Estructura del módulo

```
zsh-opencode-completion/
├── LICENSE
├── README.md
├── init.zsh                                 # entry point (Zimfw default source)
├── zsh-opencode-completion.plugin.zsh       # shim para oh-my-zsh y standalone
└── functions/
    └── _opencode                            # completion (auto-descubierto vía fpath)
```

## Instalación

### Zimfw (recomendado)

Añadir a `~/.zimrc`, **antes** del módulo `completion`:

```zsh
zmodule c4shdev/zsh-opencode-completion
zmodule completion
```

No requiere flags. Zimfw detecta automáticamente:
- `init.zsh` como entry point (porque `functions/` existe)
- `functions/` para `fpath`
- autoload de las funciones definidas en `functions/`

Luego:

```bash
zimfw build
exec zsh
```

### oh-my-zsh

Clonar como plugin:

```bash
git clone https://github.com/c4shdev/zsh-opencode-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-opencode-completion
```

Añadir a `~/.zshrc`:

```zsh
plugins=(... zsh-opencode-completion)
```

`compinit` de oh-my-zsh añade automáticamente el directorio del plugin a `fpath`, por lo que `_opencode` se descubre vía `functions/`.

### Standalone

```bash
git clone https://github.com/c4shdev/zsh-opencode-completion ~/.local/share/zsh-opencode-completion
```

En `~/.zshrc`, **antes** de `compinit`:

```zsh
fpath=(~/.local/share/zsh-opencode-completion/functions $fpath)
autoload -Uz compinit && compinit
source ~/.local/share/zsh-opencode-completion/zsh-opencode-completion.plugin.zsh
```

## Aliases

Este módulo **no define aliases**. Los atajos son configuración de shell y van en tu propio archivo de aliases:

```zsh
# --- OpenCode ---
alias oc='opencode'
alias ocu='opencode upgrade'
```

La completion se registra para `opencode` y también para `oc`, así que `oc <TAB>` lista los subcomandos y `oc s<TAB>` completa `serve`, `service`, `session` y `stats` sin configuración adicional.

## Configuración

- `$OPENCODE_BIN`: directorio del binario `opencode`. Default: `~/.opencode/bin`.

## Cómo funciona la completion lazy

1. Primer shell start: el módulo genera `_opencode` ejecutando `opencode --completions zsh` (~600ms una vez).
2. Shells subsiguientes: comparamos `mtime` del binario vs el cache. Si el binario no cambió, no se regenera.
3. Cuando actualizas opencode (`opencode upgrade` o `brew upgrade`): el binario es más nuevo que el cache, se regenera.
4. Si el cache no empieza por `#compdef opencode` (generado por una versión previa del CLI, o interrumpido a medias), se regenera automáticamente aunque el `mtime` sea válido.

## Orden de carga

El módulo **debe** inicializarse **antes** de `compinit`. Esto asegura que la completion regenerada esté disponible cuando `compinit` la lea:

- **Zimfw**: declarar `zmodule c4shdev/zsh-opencode-completion` antes de `zmodule completion`.
- **oh-my-zsh**: el orden de `plugins=(...)` define el orden; `zsh-opencode-completion` debe aparecer antes que cualquier plugin que use completion (prácticamente todos).
- **Standalone**: `source` antes de `compinit`.

## Licencia

MIT
