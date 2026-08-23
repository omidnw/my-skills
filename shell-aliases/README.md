# Shell Aliases — faster, readable CLI replacements

Optional daily-driver replacements for the default command-line tools. This folder is **standalone** — it is not part of the Agent Skills and is not synced by `scripts/sync-skills.sh`.

> **Install first, then alias.** Every alias below only works if the tool is installed — the alias silently breaks with "command not found" otherwise. If you don't want any of these tools, just skip that alias.

## The aliases (one block, add to `~/.zshrc` or `~/.bashrc`)

```sh
alias ls="eza --icons --group-directories-first"
alias cat="bat --style=plain"
alias df="duf"
alias f="fd"
alias grep="rg --no-ignore --hidden -N --color never"
alias du="dust"
```

These assume a Unix shell (zsh/bash — macOS and Linux, plus WSL or Git Bash on Windows). On Windows PowerShell, define functions instead of aliases (example below under `eza`).

## Support matrix

| Tool | Replaces | macOS | Linux | Windows |
| --- | --- | --- | --- | --- |
| **eza** | `ls` | ✅ `brew` | ✅ `apt`/`dnf`/`pacman` | ✅ `winget`/`scoop` (Unix shell) |
| **bat** | `cat` | ✅ `brew` | ✅ `apt`/`dnf` | ✅ `winget`/`scoop` |
| **duf** | `df` | ✅ `brew` | ✅ `apt`/`dnf` | ✅ `winget`/`scoop` |
| **fd** | `find` | ✅ `brew` | ✅ `apt`/`dnf` | ✅ `winget`/`scoop` |
| **ripgrep** | `grep` | ✅ `brew` | ✅ `apt`/`dnf` | ✅ `winget`/`scoop` |
| **dust** | `du` | ✅ `brew` | ✅ `apt`/`dnf` | ✅ `winget`/`scoop` |

All six tools are actively maintained and ship official binaries for all three platforms. The only real gap is Windows *shell* support: the tools run fine, but the aliases as written are POSIX-shell syntax — use them in WSL / Git Bash, or adapt them to PowerShell functions.

---

## `eza` — replacement for `ls`

- **Rule:** `alias ls="eza --icons --group-directories-first"`
- **What it does:** a modern `ls` — clear color coding, file-type icons (needs a [Nerd Font](https://www.nerdfonts.com/) in your terminal), directories grouped first, git status shown inline.
- **Install:**
  - **macOS:** `brew install eza`
  - **Linux:** Debian/Ubuntu `sudo apt install eza` · Fedora `sudo dnf install eza` · Arch `sudo pacman -S eza`
  - **Windows:** PowerShell `winget install eza-community.eza` · `scoop install eza`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows. In PowerShell, use a function instead of an alias:

  ```powershell
  function ls { eza --icons --group-directories-first @args }
  ```

## `bat` — replacement for `cat`

- **Rule:** `alias cat="bat --style=plain"`
- **What it does:** `cat` with syntax highlighting, line numbers, and paging for long files. `--style=plain` removes the frame/line numbers so piped output stays clean (e.g. `cat file | grep x` is unchanged).
- **Install:**
  - **macOS:** `brew install bat`
  - **Linux:** Debian/Ubuntu `sudo apt install bat` (older versions install the binary as `batcat` — alias accordingly) · Fedora `sudo dnf install bat`
  - **Windows:** `winget install sharkdp.bat` · `scoop install bat`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows.

## `duf` — replacement for `df`

- **Rule:** `alias df="duf"`
- **What it does:** disk-free usage in a readable table with usage bars and device grouping — no more raw, hard-to-scan `df` columns.
- **Install:**
  - **macOS:** `brew install duf`
  - **Linux:** Debian/Ubuntu `sudo apt install duf` · Fedora `sudo dnf install duf`
  - **Windows:** `winget install muesli.duf` · `scoop install duf`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows.

## `fd` — replacement for `find`

- **Rule:** `alias f="fd"`
- **What it does:** a faster, friendlier `find` — regex patterns, sensible defaults (respects `.gitignore`), colorized results. Great for quick lookups (`f "*.md"`).
- **Install:**
  - **macOS:** `brew install fd`
  - **Linux:** Debian/Ubuntu `sudo apt install fd-find` (binary is named `fdfind` — alias `f="fdfind"` on those systems) · Fedora `sudo dnf install fd-find`
  - **Windows:** `winget install sharkdp.fd` · `scoop install fd`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows.

## `ripgrep` — replacement for `grep`

- **Rule:** `alias grep="rg --no-ignore --hidden -N --color never"`
- **What it does:** recursive, ultrafast search. `rg` is line-numbered and `.gitignore`-aware by default; this alias deliberately adds `--no-ignore --hidden` to search everything (including hidden and ignored files), `-N` to drop line numbers, and `--color never` so piped output stays plain — matching the plain behavior of the `grep` it replaces.
- **Install:**
  - **macOS:** `brew install ripgrep`
  - **Linux:** Debian/Ubuntu `sudo apt install ripgrep` · Fedora `sudo dnf install ripgrep`
  - **Windows:** `winget install BurntSushi.ripgrep.MSVC` · `scoop install ripgrep`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows.

## `dust` — replacement for `du`

- **Rule:** `alias du="dust"`
- **What it does:** disk usage per directory drawn as a horizontal bar chart — you instantly see what is eating your disk, instead of parsing raw `du` numbers.
- **Install:**
  - **macOS:** `brew install dust`
  - **Linux:** Debian/Ubuntu `sudo apt install dust` · Fedora `sudo dnf install dust`
  - **Windows:** `winget install bootandy.dust` · `scoop install dust`
- **Support:** ✅ macOS · ✅ Linux · ✅ Windows.