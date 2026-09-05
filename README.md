# op

Caching shim in front of the 1Password CLI. Every `op://` coordinate is resolved
from `~/.op_shim/cache` first; on a miss the real `op` is asked once and the
value is written back. Tooling that wraps commands in `op run --env-file` or
reads with `op read` keeps working unchanged, without a Touch ID prompt per run.

## Install

```sh
./install.sh
```

Symlinks `op` into `~/.local/bin`, which must precede the real CLI (usually
`/opt/homebrew/bin`) in `PATH`. `./uninstall.sh` removes the link.

## What is intercepted

| Command | Behaviour |
| --- | --- |
| `op read op://…` | cache, then real `op read` |
| `op run [--no-masking] --env-file=F -- cmd` | resolves every `KEY=op://…` in F (cached), exports literals as-is, execs `cmd` |
| `op inject` (stdin) | replaces `op://` tokens using the cache |
| `op whoami`, `op signin` | succeed immediately |
| anything else | passed through to the real CLI |

## Cache

`~/.op_shim/cache` is mode 600, one line per coordinate: `<coordinate>\t<base64 value>`.
Coordinates matching `OP_SHIM_NO_CACHE` (default: any vault whose name contains
`prod`) are resolved live and never written to disk.

```sh
op shim list                # cached coordinates
op shim forget op://V/I/f   # drop one entry (e.g. after a rotation)
op shim clear               # wipe the cache
op shim path                # cache file location
op shim real                # path of the real CLI
OP_SHIM_BYPASS=1 op …       # skip the shim for one invocation
```
