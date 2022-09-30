#!/bin/sh

#TODO: Untedious-Portable.sh <-- old name create layout for creating auto-backup options

_UNDERLINE="\e[4m"
_NOUNDERLINE="\e[0m" #TODO: Find proper, right now it just resets everything
_BOLD="\033[1m"
_ITALICIZE="\e[3m"
_DARKER="\e[2m" #Make this "" for brighter text if your terminal shows a difference between foregrounds and backgrounds of the same color.
_NORMAL="tput sgr0"
_RESET="\e[0m"

##Colors (Foreground)
_BLACK="\e[30m"
_RED="\e[31m"
_GREEN="\e[32m"
_YELLOW="\e[33m"
_BLUE="\e[34m"
_MAGENTA="\e[35m"
_CYAN="\e[36m"
_WHITE="\e[37m"
##Colors (Background)
_BLACK_="\e[40m"
_RED_="\e[41m"
_GREEN_="\e[42m"
_YELLOW_="\e[43m"
_BLUE_="\e[44m"
_MAGENTA_="\e[45m"
_CYAN_="\e[46m"
_WHITE_="\e[47m"


THIS_FILE_ABSOLUTE_LOCATION=$(realpath ${BASH_SOURCE})
FILE_NAME="$(basename "${THIS_FILE_ABSOLUTE_LOCATION}")"
################################
#           Versions           #
# Type.Branch.YYYY.MM.STATUS.# #
################################
TOOL_VERSION="Portable.PreAlpha.2022.09.S.2"

VERSION_TYPE=${TOOL_VERSION/.*/}

tempForBreakdown=${TOOL_VERSION/${VERSION_TYPE}./}
VERSION_BRANCH=${tempForBreakdown/.*/}
tempForBreakdown=${tempForBreakdown/${VERSION_BRANCH}./}
VERSION_YEAR=${tempForBreakdown/.*}
tempForBreakdown=${tempForBreakdown/${VERSION_YEAR}./}
VERSION_MONTH=${tempForBreakdown/.*}
tempForBreakdown=${tempForBreakdown/${VERSION_MONTH}./}
VERSION_STATUS=${tempForBreakdown/.*}
tempForBreakdown=${tempForBreakdown/${VERSION_STATUS}./}
VERSION_SUBNUMBER=${tempForBreakdown/.*}

file="Configurations/config_SaveAllVerbose.txt"

echo "##############################################"
echo "Version Number: $TOOL_VERSION"
echo "##############################################"
echo "    Type: $VERSION_TYPE"
echo "  Branch: $VERSION_BRANCH"
echo "    Year: $VERSION_YEAR"
echo "   Month: $VERSION_MONTH"
tempForPrinting="  Status: ${_UNDERLINE}$VERSION_STATUS${_RESET}"

if [ $VERSION_STATUS = "S" ]; then
printf "${tempForPrinting}napshot\n"
elif [ $VERSION_STATUS = "R" ]; then
printf "${tempForPrinting}elease\n"
fi

echo " SNumber: $VERSION_SUBNUMBER"
echo "#######################"
sleep 999

print_head_board(){
  clear
  printf "${_CYAN_}Running ${_CYAN}${_DARKER}./${FILE_NAME}${_RESET}${_CYAN_} as user: ${_CYAN}${_DARKER}${_UNDERLINE}${USER}${_NOUNDERLINE}${_RESET}\n"
  printf "${_RESET}"
}

print_step_title(){
  printf "${_GREEN_}${_BLACK}$1${_RESET}\n"
}

get_input_yn(){
  local input="_"
  while [[ "${input}" != "y" && "${input}" != "Y" && "${input}" != "" && "${input}" != "N" && "${input}" != "n" ]]; do
    printf "${_MAGENTA_}${1}${_RESET} (${_UNDERLINE}Y${_RESET}/n) "
    read -a input
  done
  if [[ "${input}" == "n" || "${input}" == "N" ]];
  then
#    echo "F"
    return 0 # False
  else
#    echo "T"
    return 1 # True
  fi
  return 1;
}

get_input_keepOrOverride(){
  echo ""
}

get_input(){
  read -a input
  echo input
}



indexOf(){
  local i=0
  while [ $i -lt $1 ]; do
    if [ "${$1:$i:$2}" == $2 ]; then
      return $i
    fi
  done
}




print_head_board

#Mode selector
#NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Untedious Portable Version" 3>&1 1>&2 2>&3)
#NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Untedious "${VERSION_TYPE}" Version" 3>&1 1>&2 2>&3)

print_step_title "Config file writing to, parts ${_RED_}may be overridden${_GREEN_}. Will ask to keep or replace values." #TODO: Make make auto available as option in script



#Get all packages not installed by the base in snapd
#Command from https://askubuntu.com/questions/1261242/how-to-list-installed-packages-using-snap
#snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr '\n' ' '
#echo
#snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr  ' ' '\n'

#settingsLineNumber =


#while read -r line; do
#    echo -e "$line"
#done <$file

get_input_yn "Settings to ask above continue?"
result=$?
if [[  $result == 1 ]]; then
  while read -r line; do
      print_step_title "$line"
#      echo ${$line*:}
      echo {$line*:}
      get_input_yn "PAUSE"
      result=$?

#      print_step_title ""

#      if [[ $? == "SAAP:" ]]; then
#          echo "Going to save a list of snapds on this device"
#          snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr  ' ' '\n'
#          echo $?
#          echo $?
#          echo $?
#          echo $?
#      fi
#      if get_input_keepOrOverride "Version: "

  done <$file

else
  echo "FALSE!!!!"
fi

#indexOf "01234" "123"

echo $?

export FOO="CFIL: Created From Location:"
#"Name   Age  ID         Address"
#BEGIN=${FOO/Age*/}
BEGIN = ${FOO/:*/}
echo $BEGIN


files="$(ls -A .)"
select filename in ${files}; do echo "You selected ${filename}"; break; done
