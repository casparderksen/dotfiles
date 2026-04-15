# User scripts
export PATH=$PATH:~/bin

# Aliases
source $HOME/.alias

# Completion
autoload -Uz compinit
compinit

# Mise runtime management
eval "$(mise activate zsh)"

# Auto-suggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Smarter navigation
eval "$(zoxide init zsh)"   # Type 'z proj' instead of 'cd ~/Dev/projects/proj'
source <(fzf --zsh)         # Ctrl+R fuzzy history, Ctrl+T fuzzy file search

# Syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt
eval "$(starship init zsh)"

# Direnv (always last)
eval "$(direnv hook zsh)"

# Editor
EDITOR=vi
VISUAL=vi
export VISUAL EDITOR
