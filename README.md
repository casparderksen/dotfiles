# Dotfiles to automate Mac setup

Automated, reproducible macOS developer setup targeting full-stack development with Java/Quarkus and Angular.

## Quickstart

Clone this repository:
```console
$ git clone https://github.com/casparderksen/dotfiles.git ~/.dotfiles
```

Tweak configuration to your preferences:
- Edit `Brewfile` for apps and packages to install (use `mas` to lookup apps in App Store)
- Edit `mise/.config/mise/config.toml` to configure tools and runtimes to install (with local versions per project)
- Edit `macos.sh` for macOS settings

Run the bootstrap script:
```console
$ cd ~/.dotfiles
$ ./bootstrap.sh
```

## Frameworks

### Bootstrap script (`bootstrap.sh`)

Orchestrates a full machine setup end-to-end: installs Xcode CLI tools,
Homebrew, all packages, stows dotfiles, installs runtimes, generates an SSH
key, configures git identity and commit signing, and applies macOS defaults.
Safe to re-run.

### Homebrew (`Brewfile`)

Declares all CLI tools, GUI applications, and Mac App Store apps. Highlights:
- Modern CLI replacements: `bat`, `eza`, `fd`, `ripgrep`, `delta`, `zoxide`
- Shell enhancements: `fzf`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `starship`
- Developer tools: `gh`, `httpie`, `jq`, `yq`, `gnupg`, `ansible`
- Apps: IntelliJ IDEA, VS Code, OrbStack, DBVisualizer, Proxyman

### Mise (`mise/.config/mise/config.toml`)

Polyglot runtime version manager replacing `nvm`, `sdkman`, etc. Manages:
Node.js, Java (OpenJDK), Maven, Python, Angular CLI, OpenTofu, kubectl, and
Helm. Respects per-project version files under `~/projects/`.

### GNU Stow

Symlink manager that maps each tool's subdirectory to `$HOME`, keeping
configuration source-controlled and organised by package (`git/`, `zsh/`,
`ssh/`, `mise/`, `claude/`, …).

### Shell — Zsh (`.zshrc`, `.alias`)

- Mise activation, zoxide, fzf, autosuggestions, syntax highlighting
- Starship prompt showing git, language versions, and container context
- Aliases for `eza`, `bat`, and common git operations

### Git (`git/.config/git/config`)

- Delta diff pager, histogram diff algorithm, zdiff3 conflict style
- Fast-forward-only pull, auto-setup remote push, rerere, SSH commit signing
- Aliases: `undo`, `wip`, `nuke`

### macOS defaults (`macos.sh`)

Non-interactive `defaults write` configuration for Finder, Dock, screenshots,
hot corners, trackpad, and security settings.

### Eclipse (`install-eclipse.sh`)

Downloads and configures an Eclipse Modelling Tools installation to
`~/eclipse/modeling-<release>`. Installs UML2, ATL, Acceleo, Emfatic, and XML/XSL
on top of the pre-bundled features. Configures JVM memory.
Safe to re-run.

## Claude Code

[Claude Code](https://claude.ai/code) is installed via Homebrew and configured
The `claude/` stow package provides a version-controlled `~/.claude/` directory containing:

- **`CLAUDE.md`** — global developer identity and stack context (Java/Quarkus, Angular)
- **`docs/`** — Included coding standards for backend (DDD/hexagonal architecture), frontend and Git

Project repositories can add their own `CLAUDE.md` to extend or narrow the global rules.
