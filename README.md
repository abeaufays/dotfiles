This repo contains all my personal dotfiles, with instructions on how I setup a new machine.

# Installation on a new machine
## Prerequisites
Install git gh zsh fzf nvim tmux fd
Ex:
```
apt get install git gh zsh fzf nvim tmux fd
```
Or
```
pacman -S git gh zsh fzf nvim tmux fd
```

Add local git config for user info 
```
[user]
    name = abeaufays
    email = [email adress]
```


## Clone this repo
```
cd ~
git clone --bare https://github.com/abeaufays/dotfiles.git
git checkout main # ? unsure
source .zshrc
dgit push -u origin main
``` 

We need to push to setup tracking

## Change shell to zsh
```
chsh -s $(which zsh)
```

install chrome / chromium 
vimium

## Enable tmux plugins
git clone tpm
install tmux plugins (prefix + I)
Optional: Fix which-key-tmux rename session issue
> https://github.com/alexwforsythe/tmux-which-key/pull/18/commits/25cc8d455f221ef34c0393eeee670a3f1563763e


## Remap keyboard
Here we mostly want to remap caps lock to a new layer, allowing us to use hjkl as arrow keys.
This is done at keyboard level on desktops.

For laptop or with a keyboard that doesn't enable that:
### On a Mac
See [Karabiner]([INSERT LINK])

### On a Linux
See [keyd](keyd/README.md)



