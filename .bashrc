# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# NOTE: Previous lines are copied from the container, modify as you see fit

EDITOR=vim

exitstatus() {
  if [[ $? == 0 ]]; then
    echo -e "\e[92m"
  else
    echo -e "\e[91m"
  fi
}

export PS1='\[$(exitstatus)\]>\[\e[39m\] '
export PS2="> "

# https://www.usn-it.de/2017/01/21/oracle-enterprise-linux-7-how-to-stop-bash-tab-completion-from-escaping-the-dollar/
shopt -s direxpand

# Enable vi mode in navigating
set -o vi
