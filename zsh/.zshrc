# sheldon
eval "$(sheldon source)"

# prompt git branch
setopt PROMPT_SUBST
PS1='%F{green}%n@%m:%F{cyan}%~$(parse_git_branch)
$ '
parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# ghqをfzfにパクパクさせる
fgh() {
  cd "$(ghq root)/$(ghq list >/dev/null | fzf)"
  zle reset-prompt
}
# tab+j
zle -N fgh
bindkey '^I[' fgh

# 履歴検索関連
widget::history() {
    local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle reset-prompt
}

export HISTFILE="${HOME}/dotfiles/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt auto_pushd
setopt pushd_ignore_dups
setopt globdots
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt interactive_comments
setopt share_history
setopt magic_equal_subst
setopt print_eight_bit

# tab+h
zle -N widget::history
bindkey '^Ih' widget::history

# Rye
source "$HOME/.rye/env"

# alias
alias ll='ls -ltra'
alias gst='git status'
alias gadd='git add'
alias gpush='git push'
alias gpull='git pull'
alias gcm='git commit -m'
alias gch='git checkout'
alias gdiff='git diff'
alias tf='terraform'
alias tfmt='terraform fmt -recursive'

# ブランチの切り替え
function git-branch-fzf() {
  local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | perl -pne 's{^refs/heads/}{}' | fzf --query "$LBUFFER")

  if [ -n "$selected_branch" ]; then
    BUFFER="git switch ${selected_branch}"
    zle accept-line
  fi

  zle reset-prompt
}

# tab+b
zle -N git-branch-fzf
bindkey '^Ib' git-branch-fzf
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/itayashuto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/itayashuto/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/itayashuto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/itayashuto/google-cloud-sdk/completion.zsh.inc'; fi
