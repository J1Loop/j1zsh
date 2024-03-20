# --------------------------------------------------------------------------------------------------------------------- #
#                                                                                                                       #
#   Author: (j1dev) Jorge U. Alarcón                                                                                    #
#   Description: File used to hold zsh config, aliases, functions, etc...                                               #
#                                                                                                                       #
#    Sections:                                                                                                          #
#    1.  ENVIRONMENT SETUP                                                                                              #
#    2.  MAKE TERMINAL BETTER                                                                                           #
#    3.  MISC ALIAS'                                                                                                    #
#                                                                                                                       #
#    Took inspiration from other zsh profiles, modifying this was a great way of learning, greatly recommended.         #
#                                                                                                                       #
#    - Last modified: 18 March 2024                                                                                     #
# --------------------------------------------------------------------------------------------------------------------- #

# --------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ 1. ENVIRONMENT SETUP ----------------------------------------------- #
# --------------------------------------------------------------------------------------------------------------------- #

# Setup global variables
# Python
export PYTHONDONTWRITEBYTECODE=1

#- Pyenv PATH
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Rust 
export PATH=/usr/local/bin:$PATH 
. "$HOME/.cargo/env" 

# NVM 
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Set default editor
export EDITOR='code -n'

# Version Control System
setopt PROMPT_SUBST
autoload -Uz vcs_info

precmd_vcs_info() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    vcs_info
    if [[ -n $(git status --porcelain) ]]; then       # changes detected, red color
      RPROMPT='%F{160}${vcs_info_msg_0_}%f'
    else                                              # no changes, green color
      RPROMPT='%F{46}${vcs_info_msg_0_}%f'
    fi
  else
    RPROMPT=''
  fi
}

# Repository info
zstyle ':vcs_info:git:*' formats '[%b]'
zstyle ':vcs_info:*' enable git

autoload -U add-zsh-hook
add-zsh-hook precmd precmd_vcs_info

# Modify the prompt
PROMPT='%F{42}%*%f | %F{214}%3~%f | 🍍 '
RPROMPT='${vcs_info_msg_0_}'

git_autoconfig() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        if [[ $PWD == ~/dev/GA/* ]]; then
            git config --local user.name 'GAJorge'
            git config --local user.email 'jorge.utrera@globalalumni.org'
        elif [[ $PWD == ~/dev/j1dev/* ]]; then
            git config --local user.name 'J1Loop'
            git config --local user.email 'j1dev@proton.me'
        fi
    fi
}

# Usar el hook chpwd para ejecutar la función automáticamente al cambiar de directorio
autoload -U add-zsh-hook
add-zsh-hook chpwd git_autoconfig

# --------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------------- 2. MAKE TERMINAL BETTER ---------------------------------------------- #
# --------------------------------------------------------------------------------------------------------------------- #

# Misc commands
h() { history 1 | grep "$1"; }                                          # Shorthand for history with grep
alias whatismyip="echo '\n'\$(curl -s ipinfo.io/ip)'\n';"               # Get public IP address
alias resource="source ~/.zshrc"                                        # Source the .zshrc file
alias ll='ls -alh'                                                      # List files
alias llr='ls -alhr'                                                    # List files (reverse)
alias lls='ls -alhS'                                                    # List files by size
alias llsr='ls -alhSr'                                                  # List files by size (reverse)
alias lld='ls -alht'                                                    # List files by date
alias lldr='ls -alhtr'                                                  # List files by date (reverse)
alias lldc='ls -alhtU'                                                  # List files by date created
alias lldcr='ls -alhtUr'                                                # List files by date created (reverse)
alias perm="stat -f '%Lp'"                                              # View the permissions of a file/dir as a number
alias mkdir='mkdir -pv'                                                 # Make parent directories if needed


# Editing common files
alias editzsh="code ~/.zshrc"                                           # Edit the .zshrc file
alias editaws="code ~/.aws/"                                            # Edit the .aws folder
alias editsshconfig="code ~/.ssh/config"                                # Edit the ssh config file


# Navigation
alias j1dev='clear && cd ~/dev/j1dev/ && ll'                            # Go to j1dev/ & list files
alias j1aws="cd ~/dev/j1dev/aws-inquirer/ && git1dev && vactivate"      # Go to aws-inquirer/ & activate venv
alias j1zsh="cd ~/dev/j1dev/j1zsh/ && git1dev"                          # Go to j1zsh/
alias GA='clear && cd ~/dev/GA/ && ll'                                  # Go to GA/ & list files
alias athena='cd ~/dev/GA/Athena/scripts/ && vactivate'                 # Go to Athena/ & activate venv


# --------------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------------- 3. MISC ALIAS --------------------------------------------------- #
# --------------------------------------------------------------------------------------------------------------------- #

# Run last command with sudo
alias fuck='sudo $(fc -ln -1)'

# Switching shells
alias shell-to-zsh='chsh -s $(which zsh)'
alias shell-to-bash='chsh -s $(which bash)'

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewup-cask='brewup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask cleanup'

# Git
alias git1dev="git config --local user.name 'J1Loop' && git config --local user.email 'j1dev@proton.me'"
alias gitclean="git fetch -p ; git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print \$1}' | xargs git branch -d"
alias gitopen='URL=$(git config --get remote.origin.url); open "${URL/.git/}"'

# Python
alias py='python'
alias createvenv='python3 -m venv .venv && vactivate'
alias vactivate='source .venv/bin/activate && code . -n'
alias pycheck='clear; black $(pwd) && pylint $(pwd)'

# npm
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
