#!/bin/sh

_UNDERLINE="\e[4m"
_NOUNDERLINE="\e[0m" #TODO: Find proper, right now it just resets everything
_BOLD="tput bold"
_ITALICIZE="\e[3m"
_NORMAL="tput sgr0"

##Colors (Foreground)
_RESET="\e[39m"
_BLACK="\e[30m"
_RED="\e[31m"
_GREEN="\e[32m"
_YELLOW="\e[33m"
_BLUE="\e[34m"
_MAGENTA="\e[35m"
_CYAN="\e[36m"
_WHITE="\e[37m"
##Colors (Background)
_RESET_="\e[49m"
_BLACK_="\e[40m"
_RED_="\e[41m"
_GREEN_="\e[42m"
_YELLOW_="\e[43m"
_BLUE_="\e[44m"
_MAGENTA_="\e[45m"
_CYAN_="\e[46m"
_WHITE_="\e[47m"


#printf "Start of $(basename ${BASH_SOURCE})"
THIS_FILE_ABSOLUTE_LOCATION=$(realpath ${BASH_SOURCE})
FILE_NAME="$(basename "${THIS_FILE_ABSOLUTE_LOCATION}")"

print_head_board(){
  clear
  printf "${_CYAN_}""Running ${_CYAN}./${FILE_NAME}${_RESET} as user: ${_CYAN}${_UNDERLINE}${USER}${_NOUNDERLINE}${_RESET}\n"
  printf "${_RESET_}""Running ${_CYAN}./${FILE_NAME}\n"

  printf "${_RESET}"
}
#
#get_input(){
#  read -a input
#  echo input
#}
#
print_head_board
#get_input

#Get all packages not installed by the base in snapd
#Command from https://askubuntu.com/questions/1261242/how-to-list-installed-packages-using-snap
snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr '\n' ' '
echo
snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr  ' ' '\n'


printf "\n\n\n\n"