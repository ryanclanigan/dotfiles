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

zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

setopt no_share_history
unsetopt share_history

source ~/.sh_aliases
export PATH="$HOME/.cargo/bin:$PATH"

sq() {
  command="sq $@"
  bash -c "source environment && $command"
}

spy() {
  bash -c "source environment && python -m $*" 
}

,() {
  bash -c "source environment && $*"
}

olv() {
  latest_file="$(ls -t | head -n 1)"
  echo $latest_file
  vim -- $latest_file
}

clippy() {
  xclip -sel c < $*
}

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
