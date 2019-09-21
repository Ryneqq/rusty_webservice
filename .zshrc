# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/pawelrynowiecki/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git, vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# export GOOGLE_APPLICATION_CREDENTIALS="/opt/google_credentials/credentials"

# Git aliases
alias gita="git add ."
alias gitb="git branch"
alias gitc="git checkout"
alias gitf="git fetch -p"
alias gitl="git log --all --decorate --oneline --graph"
alias gitr="git reflog show"
alias gits="git status"
alias gitm="git merge"

alias gitcl="git clean -df"
alias gitcb="git checkout -b"
alias gitcm="git commit -m"
alias gitcmw="gitcm \"WIP\""
alias gitca="git commit --amend"
alias gitcan="git commit --amend --no-edit"
alias gitpo="git push origin"
alias gitpof="gitpo --force-with-lease"
alias gitri="git rebase -i"
alias gitrc="git rebase --continue"
alias gitra="git rebase --abort"
alias gitrh="git reset --hard"
alias gitrs="git reset --soft"
alias gitst="git stash"
alias gitstp="git stash pop"

# General aliases
alias c="clear"
alias ct="time cargo test"
alias cta="ct --all --all-features"
alias ctaq="cta --quiet"
alias cc="cargo check"
alias cca="cc --all --all-features"
alias cfa="cargo fmt --all"
alias ccaq="cca --quiet"
alias cba="time cargo bench --all --all-features"

# Work related aliases
alias failed="find . -name \*.new"
alias rm_failed="failed -delete"
alias fix_failed="python /Users/pawelrynowiecki/Documents/Aclr8/scripts/fix_failed.py"
alias playground="cargo init --bin $(pwd)/playground | cp $(pwd)/rust-toolchain $(pwd)/playground/ | code $(pwd)/playground"
alias rm_playground="rm -rf $(pwd)/playground"

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) $EPS1"
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select
export KEYTIMEOUT=1


# fuzzy searching for git checkout
gco_all_fuzzy() {
 if [ $# -gt 0 ]; then
   git checkout "$@"
 else
   local branches target
   branches=$(git branch --all | grep -v HEAD |sed "s/. *//" | sed "s#remotes/[^/]*/##" |sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
   target=$((echo "$branches") | fzf --no-hscroll --no-multi --delimiter="\t" -n 2 --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
   git checkout $(echo "$target" | awk '{print $2}')
 fi
}

export PATH="/Users/pawelrynowiecki/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Xamarin Workbooks.app/Contents/SharedSupport/path-bin:/Users/pawelrynowiecki/.cargo/bin:/Users/pawelrynowiecki/.vimpkg/bin"

ssh-add
c