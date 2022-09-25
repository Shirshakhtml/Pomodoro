#!/bin/bash

echo "+------------------------------------------+"
 # printf "| %-40s |\n" "`date`"\n
  echo "|                "                           POMODORO                    "                |"
 # printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"

banner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}
#echo "A simple shell script to use as a pomodoro app"


wseconds=${1:-1}*60
pseconds=${2:-10}*60

# Check os and behave accordingly
if [ "$(uname)" == "Darwin" ]; then
  while true; do
    date1=$(($(date +%s) + $wseconds))
    while [ "$date1" -ge $(date +%s) ]; do
      echo -ne "$(date -u -j -f %s $(($date1 - $(date +%s))) +%H:%M:%S)\r"
    done
    osascript -e 'display notification "Time to walk and rest!" with title "Break"'
    read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
    date2=$(($(date +%s) + $pseconds))
    while [ "$date2" -gt $(date +%s) ]; do
      echo -ne "$(date -u -j -f %s $(($date2 - $(date +%s))) +%H:%M:%S)\r"
    done
    osascript -e 'display notification "Time to get back to work" with title "Work"'
    read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
  done
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
 banner "Starting the timer in 5..."
 sleep 4 
 while true; do
    date1=$(($(date +%s) + $wseconds))
    while [ "$date1" -ge $(date +%s) ]; do
      echo -ne "$(date -u --date @$(($date1 - $(date +%s))) +%H:%M:%S)\r"
    done
    banner "Break!!!" "Time to walk and rest"
    read -n1 -rsp $'Press any key to resume with the break or Ctrl+C to exit...\n'
    date2=$(($(date +%s) + $pseconds))
    while [ "$date2" -ge $(date +%s) ]; do
      echo -ne "$(date -u --date @$(($date2 - $(date +%s))) +%H:%M:%S)\r"
    done
    notify-send "Work" "Time to get back to work"
    read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
  done
else
  echo -ne "Your OS is currently not supported\n"
fi
