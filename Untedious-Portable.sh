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
TOOL_VERSION="Portable.PreAlpha.2022.12.S.2"
#Seperator between rungs, get length for splitting as well
$WIDTH_BAR="#########################################"

file="Configurations/config_masterTemplate.txt"
currentConfigFile="$file"
currentConfigFileName=${currentConfigFile##*/}
currentConfigFileName=${currentConfigFileName%%.*}


PRIMARY_FOLDER=${THIS_FILE_ABSOLUTE_LOCATION/${FILE_NAME}*/}


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


default_menu_option=6;


print_version_info(){
  echo "$WIDTH_BAR"
  echo "Version: $TOOL_VERSION"
  echo "$WIDTH_BAR"
  echo "    Type: $VERSION_TYPE"
  echo "  Branch: $VERSION_BRANCH"
  echo "    Year: $VERSION_YEAR"
  echo "   Month: ${VERSION_MONTH/*0/}"
  tempForPrinting="  Status: ${_UNDERLINE}$VERSION_STATUS${_RESET}"

  if [ $VERSION_STATUS = "S" ]; then
  printf "${tempForPrinting}napshot\n"
  elif [ $VERSION_STATUS = "R" ]; then
  printf "${tempForPrinting}elease\n"
  fi

  echo " SNumber: $VERSION_SUBNUMBER"
  echo "$WIDTH_BAR"
}

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

#DISPLAY INFO ABOUT PROGRAM
print_head_board #File and user

print_step_title "Config file writing to, parts ${_RED_}may be overridden${_GREEN_}. Will ask to keep or replace values." #TODO: Make make auto available as option in script

get_input_yn "Settings to ask above continue?"
userApprovedConfig=$?
if [[ $userApprovedConfig == 1 ]]; then
  echo $"default_menu_option =" $default_menu_option
  exitStatus=0
  while [ "$exitStatus" = 0 ]
  do
    dbs=("CREATE new Configuration" "CREATE new Configuration" "EDIT Configuration" "VIEW Configuration" "APPLY Configuration" "SELECT a different configuration" "BACKUP Configuration" "REMOVE Configuration" "Set Default Menu Option" "TEMPORARY FIX [EXIT BUTTON]")
    #dbs=("CREATE new Configuration" "Manual" "CREATE new Configuration" "Auto" "EDIT Configuration" "" "VIEW Configuration" "" "APPLY Configuration" "" "SELECT a different configuration" "" "BACKUP Configuration" "" "REMOVE Configuration" "")
    whiptail_args=(
      --title " ---~<{: Menu :}>~--- "
      --radiolist "What would you like to do with the current configuration ("${currentConfigFile}")"
      20 80 "${#dbs[@]}"  # note the use of ${#arrayname[@]} to get count of entries
    )
    i=0

    for db in "${dbs[@]}"; do
      whiptail_args+=( "$((++i))" "$db" )
      if [[ "$((i))" == "$default_menu_option"  ]]; then
        whiptail_args+=( "on" )
      else
        whiptail_args+=( "off" )
      fi
    done

    # collect both stdout and exit status
    # to change the file descriptor switch, see https://stackoverflow.com/a/1970254/14122
    chosenOption=$(whiptail "${whiptail_args[@]}" 3>&1 1>&2 2>&3); whiptail_retval=$?

    exitStatus=$?

    if [ $exitStatus = 0 ]; then
      echo "You choose option #"${_UNDERLINE}${chosenOption}${_RESET}
      echo "You choose to "$chosenOption
    fi


    if [ $chosenOption = 10 ]; then
      break;
    fi

    readLineFromFile=1

    echo "$currentConfigFileName"
    if [[  $chosenOption == 1 ]]; then # CREATE NEW CONFIG
      currentConfigFile=$(whiptail --inputbox "What should this new config file be called?"\
                           8 39  $currentConfigFileName --title "New Config File Name" 3>&1 1>&2 2>&3)
      exitStatus=$?

      currentConfigFile=$currentConfigFile".txt"
      cp $PRIMARY_FOLDER"Configurations/config_masterTemplate.txt" $PRIMARY_FOLDER"Configurations/"$currentConfigFile


      if [ $exitStatus = 0 ]; then
        echo "User selected Ok and entered "$currentConfigFile
        if [[ $readLineFromFile == 1 ]]; then # Loop through save options
          while read -r line; do
            print_step_title "$line"

            readLineFromFile=${line/:*/}:
            echo "=$readLineFromFile"
            if [[ $readLineFromFile == "SASN:" ]]; then

              # https://stackoverflow.com/a/55930193
              all="@"
              active_db="@" #use the same value as $all to set all to active

              #Get all packages not installed by the base in snap
              #Command from https://askubuntu.com/questions/1261242/how-to-list-installed-packages-using-snap
              dbs=($(snap list | grep -v Publisher | grep -v canonical | awk '{print $1}' | tr  ' ' ' ')) # using an array, not a string, means ${#dbs[@]} counts

              # initialize an array with our explicit arguments
              whiptail_args=(
                --backtitle "backtitle"
                --title "${VERSION_TYPE} Version ${VERSION_BRANCH}.${VERSION_YEAR}.${VERSION_MONTH}.${VERSION_SUBNUMBER}"
                --checklist "Select which Snaps you want to save"
                20 80 "${#dbs[@]}"  # note the use of ${#arrayname[@]} to get count of entries
              )
              i=0
              for db in "${dbs[@]}"; do
                whiptail_args+=( "$((++i))" "$db" )
                if [[ "$active_db" == "$all" || $db = "$active_db" ]]; then
                  whiptail_args+=( "on" )
                else
                  whiptail_args+=( "off" )
                fi
              done

              # collect both stdout and exit status
              # to change the file descriptor switch, see https://stackoverflow.com/a/1970254/14122
              whiptail_out=$(whiptail "${whiptail_args[@]}" 3>&1 1>&2 2>&3); whiptail_retval=$?

              # display what we collected
              declare -p whiptail_out whiptail_retval
              echo ">>>""$whiptail_retval[@]"
              whiptail_out=$(sed 's/\"//g' <<< "${whiptail_out}")
              echo ">>"${whiptail_out}
              whiptail_out_array=($whiptail_out)
              whiptail_using_length=$((${#whiptail_out_array[@]}))
              echo "Number of Snaps is "$(($whiptail_using_length))
              echo "Saving Snap(s): "
              for ((i = 0; i < ${#whiptail_out_array[@]}; i++))
              do
                  use_this=${dbs[$(( ${whiptail_out_array[$i]} - 1 ))]}
                  echo $use_this
                  sed -i '/SASN:/a '$use_this Configurations/$currentConfigFile
              done

              echo $?
            fi
          done <$file
        fi
      else
        echo "User selected Cancel."
        break 1
      fi

      echo "(Exit status was $exitStatus)"
      if [[ $exitStatus == 1 ]]; then
        break 1
      fi



    elif [[ $chosenOption == 5 ]]; then # APPLY THE CONFIGURATION
      nextIs=0;
      was=0;
      while read -r line; do
  #        print_step_title "$line"

        readLineFromFile=${line/:*/}:
        echo "=$readLineFromFile"


        #If the line contains a ":"
        if grep -q ":" <<< "$readLineFromFile"; then
          echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          nextIs="0"
        fi


        if [[ nextIs == "1" ]]; then
          echo "$readLineFromFile TEST~~~~~~~~~~~"
        elif [[ "$readLineFromFile" == "SASN:" ]]; then
          nextIs="1"config_SaveAllVerbose
        fi
      done <$file
      $exitStatus=-2;
      echo $exitStatus
    elif [[ $chosenOption == 6 ]]; then # SELECT THE CONFIGURATION
      i=0
      for f in "$PRIMARY_FOLDER"Configurations/*.txt
#      .txt
      do
          files[i]="" #TODO FIX AGAIN
          files[i+1]="$f"
          ((i+=2))
      done

      currentConfigFile=$(whiptail --backtitle "Backtitle" --title "Select a configuration" \
        --menu "Showing all .txt's, (non-config files may appear)" 20 80 6 "${files[@]}" 3>&1 1>&2 2>&3)

      exitStatus=$?

    else #Selection options from main menu
      echo "Ok, exiting the program."
    fi
    echo "exitStatus="$exitStatus
  done
else
  echo "Ok, existing the program. No files have been modified"#TODO: CHECK LOCATION
fi
#
#echo ""
#echo "BEFORE SLEEP 999"
#sleep 999
##indexOf "01234" "123"
#
#files="$(ls -A .)"
#select filename in ${files}; do echo "You selected ${filename}"; break; done
