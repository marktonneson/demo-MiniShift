#!/bin/bash
#
# Exercise Seven: Deploying apps directly from code via S2I
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
   Exercise: Creating a Containerized Application with Source-to-Image
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Log in to OpenShift as the developer user:
"
echo -e $FormatTextCommands "
	$ oc login -u developer -p developer
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc login -u developer -p developer
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new project named s2i:
"
echo -e $FormatTextCommands "
	$ oc new-project s2i
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc new-project s2i
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new PHP application using the course repository in GitHub.
   Use the oc new-app command to create the PHP application.
   Notice the symbol after php:7.0 is a tilde (~), not a dash nor a minus sign (-).
   The oc new-app command might complain that there is no Git client available,
   but this message can be safely ignored.
   It is the OpenShift builder pod, not the OpenShift client (the oc command),
   that needs to access the Git repository.
"
echo -e $FormatTextCommands "
	$ oc new-app --name=hello php:7.0~https://github.com/RedHatTraining/DO081x-lab-php-helloworld.git
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc new-app --name=hello php:7.0~https://github.com/RedHatTraining/DO081x-lab-php-helloworld.git
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Wait for the build to complete. Follow the build logs:
   Notice the clone of the Git repository as the first step of the build.
   Next, the Source-to-Image process builds a new container called s2i/hello:latest.
   The last step in the build process is to push this container to
   the OpenShift internal registry.
"
echo -e $FormatTextCommands "
	$ oc logs -f bc/hello
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc logs -f bc/hello
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax '
   Wait until the application pod is ready and running.
   The pod with name ending in "build" ran the build process and should be completed.
   The pod with a random suffix is the application pod.
'
echo -e $FormatTextCommands "
	$ oc get pod -w
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
gnome-terminal --command 'oc get pods -w' --tab
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Review the resources that were created by the oc new-app command.
"
echo -e $FormatTextCommands "
	$ oc status
"
echo -e $FormatTextSyntax "
   Notice they are the same that would be created for preexisting container image,
   except for the addition of a build configuration (bc).
   Make note of the service IP address.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc status
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

$FormatRunCommand
SVC_IPADDR=`oc status | grep 8080 | cut -f3 -d' '`

echo -e $FormatTextSyntax "
   Examine the build configuration resource using oc describe:
"
echo -e $FormatTextCommands "
	$ oc describe bc/hello
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc describe bc/hello
echo -e $FormatTextSyntax "
   The last part of the display gives the build history for this application.
   So far, there has been only one build and that build completed successfully.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Test the application by running the curl command inside the Minishift VM.
"
echo -e $FormatTextCommands "
	$ minishift ssh -- curl -s $SVC_IPADDR:8080
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- curl -s $SVC_IPADDR:8080
echo -e $FormatTextSyntax "
   Notice the application is not accessible outside the OpenShift cluster.
   The next exercise will show how to expose a web application or service.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Open the Web UI and view details about project = s2i
"
$FormatRunCommand
minishift console
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Clean up the lab by deleting the OpenShift project, which in turn
   deletes all the Kubernetes and OpenShift resources:
"
echo -e $FormatTextCommands "
	$ oc delete project s2i
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
oc delete project s2i
echo -e $FormatTextPause && read -p "<-- End of Demo 7: Press any key to continue -->" NULL && echo -e $TextReset
