#!/bin/zsh
#------------------------------------------------------------------#
# File:     .zshrc   ZSH resource file                             #
# Updated:  18/11/2008                                             #
# Author:   Seynthan "ST.x" Thanapalan <seynthan.tx@gmail.com>     #
#------------------------------------------------------------------#

# {{{ History
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt NO_BG_NICE # don't nice background tasks
# }}}

# {{{ Autoload
autoload -U compinit
compinit
autoload -U zcalc 	# Math			
zstyle :compinstall filename '/home/stxza/.zshrc'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# }}}

# {{{ Completion
# :completion:<func>:<completer>:<command>:<argument>:<tag>
# Expansion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# }}}

# {{{ Window Title
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
		precmd () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" } 
		preexec () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" }
	;;
    screen)
    	precmd () { 
			print -Pn "\e]83;title \"$1\"\a" 
			print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
		}
		preexec () { 
			print -Pn "\e]83;title \"$1\"\a" 
			print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
		}
	;; 
esac
# }}}

# {{{ Prompt Config
setprompt () {
	# load some modules
	autoload -U colors zsh/terminfo # Used in the colour alias below
	colors
	setopt prompt_subst

    #PROMPT="[%{$fg_bold[cyan]%}%~%{$reset_color%}]-> "
    #PROMPT="[%{$fg[white]%}%n %{$fg_bold[cyan]%}%~%{$reset_color%}]> "
    #RPROMPT="[%{$fg_bold[yellow]%}%D{%H:%M}%{$reset_color%}]"
    PROMPT="%{$fg_bold[grey]%}[%{$fg_bold[white]%}%~%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%}-%{$fg_bold[yellow]%}»%{$reset_color%} "
    RPROMPT="%{$fg[white]%}%D{%H:%M}%{$reset_color%}"
}

setprompt
# }}}

# {{{ Key Bindings
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey "\e[3~" delete-char
bindkey '^i' expand-or-complete-prefix
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# }}}

# {{{ Aliases
alias startx='SHELL=/bin/sh startx'
alias ll='ls --color=auto -a -lhX'
alias egrep='egrep --color=auto'
alias shutdownhome='sudo netcfg2 -d wifihome && sleep 3 && sudo shutdown -hP now'
alias reboothome='sudo netcfg2 -d wifihome && sleep 3 && sudo reboot'
alias shutdownuni='sudo netcfg2 -d wifiuni && sleep 3 && sudo shutdown -hP now'
alias rebootuni='sudo netcfg2 -d wifiuni && sleep 3 && sudo reboot'
alias screenie='cd ~/bin/ && ./info.pl'
alias pacman='sudo pacman-color'
# }}}

# {{{ URXVT workaround - stop first line completion bug in tiling WMs
if test "$TERM" = "rxvt-unicode"; then
    sleep 0.1 && clear
fi
# }}}

# {{{ Functions

# Completion for pacman-color
function pacman; pacman-color $argv;

# The number given after pacstatus determines how many lines of history you would like shown
pacstats() {
	pacman -V | grep Pacman | cut -d " " -f 20-
	echo
	#echo "Last cmd - " `cat ~/.zsh_history | grep "pacman " | tail -n1`
	echo "Last Sy - " `cat /var/log/pacman.log | grep sync | tail -n1 | cut -d "[" -f 2 | cut -d "]" -f -1`
	echo "Last Su - " `cat /var/log/pacman.log | grep "full system" | tail -n1 | cut -d "[" -f 2 | cut -d "]" -f -1`
	echo
	echo "Last "$1" Installed"
	cat /var/log/pacman.log | grep installed | tail -n $1 | cut -d " " -f 4,5
	echo
	echo "Last "$1" Removed"
	cat /var/log/pacman.log | grep removed | tail -n $1 | cut -d " " -f 4,5
}

# Show Console Colours
function show_console_colours() 
{
    for NUMB in `seq 200 `
    do 
        echo -en "\033[${NUMB}m ${NUMB} \e[0m "
    done
    echo ""
}

extract_archive () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar xvzf $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        tar xvjf $1
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar e $1
    elif [[ $lower == *.tar ]]; then
        tar xvf $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
    # Change in to the newly created directory, and
    # list the directory contents, if there is one.
    current_dirs=( *(N/) )
    for i in {1..${#current_dirs}}; do
        if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
            cd $current_dirs[$i]
            break
        fi
    done
}
 
roll () {
    FILE=$1
    case $FILE in
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.rar) shift && rar $FILE $* ;;
    esac
}

# reload zshrc
function src() {
        autoload -U zrecompile
                [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
				#for i in "$(find ~/.zsh/ -type f)"; do
				#	[[ -f $i ]] && zrecompile -p $i
				#	[[ -f $i.zwc.old ]] && rm -f $i.zwc.old
				#done
                [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
                [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
                [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old
                [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old
                source ~/.zshrc
}
# }}}

# {{{MOTD
fortune
# }}}
