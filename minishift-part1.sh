#!/bin/bash
#
# Exercise One: Starting a Minishift/OpenShift Cluster
#

TextReset='\033[0m'
TextGreen='\033[32m'
TextBlue='\033[34m'
TextLightGrey='\033[37m'
TextBold='\033[1m'

FormatTextPause="$TextReset $TextLightGrey"  # Pause & continue
FormatTextCommands="$TextReset $TextGreen" # Commands to execute
FormatTextSyntax="$TextReset $TextBlue $TextBold" # Command Syntax & other text

# Place before command line to reset text format
FormatRunCommand="echo -e $TextReset"

# Reset text if script exits abnormally
trap 'echo -e $TextReset;exit' 1 2 3 15

clear
echo -e $FormatTextSyntax "
   Exercise: Starting an OpenShift Cluster
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Step One: Validate environment variables ...
"
$FormatRunCommand
env | grep MINISHIFT
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Step Two: Start MiniShift cluster ...
"
echo -e $FormatTextCommands "
	$ minishift start
"
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the origin container is running inside the VM created by Minishift:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker ps
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that a few container images were pulled by the Minishift VM:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker images
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker images
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the registry and router pods are ready and running.
   Log in to OpenShift as the cluster administrator user:
"
echo -e $FormatTextCommands '
  $ eval $(minishift oc-env)
	$ oc login -u system:admin
'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
eval $(minishift oc-env)
oc login -u system:admin
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Use the oc get pod command on the default project to check the OpenShift registry
   and router pods are ready and running:
"
echo -e $FormatTextCommands "
	$ oc get pod -n default
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc get pod -n default
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Access the web console as a developer user.
   Open the OpenShift web console.
"
echo -e $FormatTextCommands "
	$ minishift console --url
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift console --url
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift console
echo -e $FormatTextPause && read -p "<-- End of Demo 1: Press any key to continue -->" NULL && echo -e $TextReset
