# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.config/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundles <<EOBUNDLES
git
command-not-found
colored-man-pages
alias-finder
cargo
cp
mvn
python
node
rust
ssh-agent
tmux
sudo
vscode
stack
deno
MichaelAquilina/zsh-autoswitch-virtualenv

zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

fpath=(~/.autocompletes $fpath)

setopt no_share_history
unsetopt share_history

source ~/.sh_aliases
source ~/.work
source ~/.fzf.zsh
# Rust Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Yarn globals
# export PATH="$PATH:$(yarn global bin)"

sq() {
  urned_command=$(echo "$@" | sed -e "s/urn/run/g")
  command="sq $urned_command"
  bash -c "source environment && $command"
}

spy() {
  bash -c "source environment && python -m $*" 
}

spilot() {
  bash -c "source environment && python -m pilot $*"
}

,() {
  bash -c "source environment && $*"
}

source ~/.sh_aliases_work

olv() {
  latest_file="$(ls -t | head -n 1)"
  echo $latest_file
  vim -- $latest_file
}

clippy() {
  xclip -sel c < $*
}

back() {
  nohup $* >/dev/null 2>&1 &
}

insert-last-words() {
  emulate -L zsh
  set -o extendedglob # for the # wildcard operator

  local direction
  case $WIDGET in
    (*-reverse) direction=-1;;
    (*) direction=1;;
  esac

  if [[ ${WIDGET%-reverse} = ${LASTWIDGET%-reverse} ]]; then
    # subsequent invocations go further back in history like
    # insert-last-word

    (($+INSERT_LAST_WORDS_SKIP_UNDO)) ||
      NUMERIC=1 zle undo # previous invocation

    # we honour $NUMERIC for Alt+4 Alt+/ to go back 4 in history
    ((INSERT_LAST_WORDS_INDEX += ${NUMERIC-1} * direction))
  else
    # head of history upon first invocation
    INSERT_LAST_WORDS_INDEX=0
  fi
  unset INSERT_LAST_WORDS_SKIP_UNDO

  local lastwords
  local cmd=${history:$INSERT_LAST_WORDS_INDEX:1}

  # cmdline split according to zsh tokenisation rules
  lastwords=(${(z)cmd})

  if (($#lastwords <= 1)); then
    # return failure (causing beep or visual indication) when the
    # corresponding cmd had no arguments. We also need to remember
    # not to undo next time.
    INSERT_LAST_WORDS_SKIP_UNDO=1
    return 1
  fi

  # remove first word (preserving spacing between the remaining
  # words).
  cmd=${cmd##[[:space:]]#$lastwords[1][[:space:]]#}
  LBUFFER+=$cmd
}

zle -N insert-last-words
zle -N insert-last-words-reverse insert-last-words
bindkey '\e/' insert-last-words
bindkey '\e\\' insert-last-words-reverse

zsudo() {
  sudo zsh -c "$functions[$1]" "$@"
}

fpath=(~/completions $fpath)

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
# Right alt is used for compose (unicode/alt characters)
setxkbmap -option "compose:ralt"


# for 4k
export GDK_SCALE=2

crabnum() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' | sed -e 's/^.*\(CRAB-\)//'
}

deploy() {
  CRAB=$(crabnum)
  docker tag seeq/datalab-orchestrator seeqdatalab.azurecr.io/datalab-orchestrator:crab$CRAB && docker push seeqdatalab.azurecr.io/datalab-orchestrator:crab$CRAB
  docker tag seeq/datalab-jupyter seeqdatalab.azurecr.io/datalab-jupyter:crab$CRAB && docker push seeqdatalab.azurecr.io/datalab-jupyter:crab$CRAB
  docker tag seeq/datalab-kubectl-proxy seeqdatalab.azurecr.io/datalab-kubectl-proxy:crab$CRAB && docker push seeqdatalab.azurecr.io/datalab-kubectl-proxy:crab$CRAB
  kubectl delete --all pods -n crab$CRAB
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source /home/ryan/.config/broot/launcher/bash/br

fpath=(/home/ryan/.zsh/gradle-completion $fpath)
