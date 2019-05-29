#!/bin/bash
#
# Run this to loop thru any or all minishift parts
#

TextReset='\033[0m'

TextRed='\033[31m'
TextGreen='\033[32m'
TextBlue='\033[34m'

# Reset text if script exits abnormally
trap 'echo -e \033[0m && exit' 1 2 3 15

while : # Loop forever
do
  clear
  echo
  echo -e $TextBlue "
\t ============
\t   M E N U
\t ============
\t (1) Exercise One: Starting a Minishift/OpenShift Cluster
\t (2) Exercise Two: Creating a Container
\t (3) Exercise Three: Working with a container, making it usable
\t (4) Exercise Four: Modifying a container image
\t (5) Exercise Five: Using a Dockerfile to create an image
\t (6) Exercise Six: Using MiniShift/OpenShift to deploy containers
\t (7) Exercise Seven: Deploying apps directly from code via S2I
\t (8) Exercise Eight: Using MinShift/OpenShift to deploy an externally usable app

\t (Q)uit
"
  read -p " Enter your choice: " choice
  case $choice in
    1) source minishift-part1.sh ;;
    2) source minishift-part2.sh ;;
    3) source minishift-part3.sh ;;
    4) source minishift-part4.sh ;;
    5) source minishift-part5.sh ;;
    6) source minishift-part6.sh ;;
    7) source minishift-part7.sh ;;
    8) source minishift-part8.sh ;;
    q|Q) echo -e $TextReset && exit ;;
    *) echo -e $TextRed "ERROR: Choice \"$choice\" is not valid " $TextReset; sleep 2 ;;
  esac
done
