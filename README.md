# Dotfiles to automate Mac setup

## Quickstart

Clone this repository:
```console
$ git clone https://github.com/casparderksen/dotfiles.git ~/.dotfiles
```

Tweak configuration to your preferences:
- Edit `Brewfile` for apps and packages to install (use `mas` to lookup apps in App Store)
- Edit `mise/.config/mise/config.toml` to configure tools and runtimes to install (multiple versions possible)
- Edit `macos.sh` for macOS settings

Run the bootstrap script:
```console
$ cd ~/.dotfiles
$ ./bootstrap.sh
```
