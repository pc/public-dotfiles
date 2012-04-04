autoload -U compinit
autoload -U zmv

compinit

setopt autocd autopushd pushdignoredups \
  autolist rmstarsilent inc_append_history \
  share_history append_history hist_reduce_blanks \
  extended_history

setopt nullglob # for rvm

SAVEHIST=10000
HISTFILE=$HOME/.zsh_history

bindkey "^?" backward-delete-char
bindkey -e

function ps1_ret() {
  echo $? >/dev/stderr
}

function precmd() {
  last_ret=$?
  if [ $last_ret != 0 ]; then
    local ps1_ret=":$last_ret"
  else
    local ps1_ret=""
  fi

  if [ "$USERNAME" = "patrick" ]; then
    local ps1_user=""
  else
    local ps1_user=":$USERNAME"
  fi

  PS1="%B%m$ps1_user:%~$ps1_ret%b "
}

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle :compinstall filename '/Users/patrick/.zshrc'

export EDITOR=vim

alias _="ps ax | grep -i "
alias __="ps -ax -o pid,start,command | grep -i "
alias _l="ls -lth"

alias mmv='noglob zmv -W'

alias eg="grep --color=auto --line-buffered -E "
alias g="grep --color=auto --line-buffered -E "
alias gr="grep --color=auto --line-buffered -Eri "
function rgr() {
  noglob git grep --color=auto -i $1 -- *.rb
}

alias gad="git add"
alias gap="git add -p"
alias gci="git commit"
alias gcia="git commit --interactive"
alias gdi="git diff --color=auto"
alias gdic="git diff --cached HEAD"
alias gfa="git fetch -a"
alias glff="git pull --ff-only"
alias glr="git pull --rebase"
alias glmom="git log master..origin/master"
alias glomm="git log origin/master..master"
alias glpp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp="git push"
alias gpom="git push -v origin master"
alias grp="git reset -p"
alias grom="git rebase origin/master"
alias gst="git status -s"

alias cleanswp="find . -name '*.swp' -exec rm -v {} \;"
alias b="bundle exec"
alias f="find -E . -not -regex '\.git($|/)' | g"

alias failssh="ssh -o 'StrictHostKeyChecking=no'"

alias total="awk 'BEGIN{t=0}{t+=\$1}END{print t}'"
alias avg="awk 'BEGIN{t=0;n=0}{t+=\$1;n++}END{printf \"%.2f\n\", t/n}'"

alias sgi="sudo gem install --no-ri --no-rdoc"
alias sgs="gem search -r"
alias acs="apt-cache search"
alias agi="apt-get install -y"

alias unutf16="iconv --from-code UTF-16 --to-code UTF-8"

alias rm!="rm -rf"

function git-diff-branches() {
  branch1="$1"
  branch2="$2"

  if [ -z "$1" -a -z "$2" -a "$(git branch | head -1 | _f 2)" = "master" ]; then
    branch1="master"
    branch2="origin/master"
  else
    if [ -z "$1" -o -z "$2" ]; then
      echo "git-diff-branches <branch1> <branch2>" >>/dev/stderr
      return
    fi
  fi

  echo "Commits on $branch1 that aren't on $branch2\n----"
  git log $(git merge-base HEAD $branch2)..$branch1
  echo

  echo "Commits on $branch2 that aren't on $branch1\n----"
  git log $(git merge-base HEAD $branch1)..$branch2
}

function _f() {
  awk '{print $'$1'}'
}

function publish() {
  scp -r $1 root@collison.ie:/var/cp/pages/$2
}

function _c() {
  cd $1
  ls
}

if [ -f ~/.zshrc_private ]; then
  . ~/.zshrc_private
fi
