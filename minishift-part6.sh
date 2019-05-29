#!/bin/bash
#
# Exercise Six: Using MiniShift/OpenShift to deploy containers
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
   Exercise: Deploying a Database Server on OpenShift
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Log in to OpenShift as a developer user and create
   a new project for this exercise.

   Different from previous exercises, this time most commands are executed
   from your operating system prompt.
   There will be no need to open a SSH session to the Minishift VM.

   Log in to OpenShift as the developer user:
"
echo -e $FormatTextCommands "
	$ oc login -u developer -p developer
"
$FormatRunCommand
oc login -u developer -p developer
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new project for the resources you will create during this exercise:
"
echo -e $FormatTextCommands "
	$ oc new-project database
"
$FormatRunCommand
oc new-project database
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new application from the MySQL server container image provided by Red Hat.
   This image requires several environment variables
   (MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, and MYSQL_ROOT_PASSWORD)
   using the -e option.
   Use the --docker-images option for the oc new-app command.
   The oc new-app command might complain that there is no Git client available,
   but this message can be safely ignored.
"
echo -e $FormatTextCommands '
	$ oc new-app --name=mysql --docker-image=registry.access.redhat.com/rhscl/mysql-56-rhel7 \
	  -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=testdb \
	  -e MYSQL_ROOT_PASSWORD=r00tpa55
'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc new-app --name=mysql --docker-image=registry.access.redhat.com/rhscl/mysql-56-rhel7 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=testdb -e MYSQL_ROOT_PASSWORD=r00tpa55
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Verify if the MySQL pod was created successfully and view details
   about the pod and it's service.
   Run the oc status command to view the status of the new application,
   and to check if the deployment of the MySQL server image was successful:
"
echo -e $FormatTextCommands "
	$ oc status
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc status
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   List the pods in this project to check if the MySQL server pod
   is ready and running:
"
echo -e $FormatTextCommands "
	$ oc get pods
"
echo -e $FormatTextSyntax '
   Wait until the application pod is ready and running.
   The pod with name ending in "build" ran the build process and should be completed.
   The pod with a random suffix is the application pod.
'
echo -e $FormatTextSyntax "
   Make a note of the pod name because it will be used later during this exercise.
"
$FormatRunCommand
gnome-terminal --command 'oc get pods -w' --tab
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Use the oc describe command to view more details about the pod.
   Be sure to use the same pod name displayed by the previous step:
"
$FormatRunCommand
MYSQL_POD=`oc get pods | grep Running | cut -f1 -d' '`
echo -e $FormatTextCommands "
	$ oc describe pod $MYSQL_POD
"
$FormatRunCommand
oc describe pod $MYSQL_POD
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   List the services in this project and check if a service to access
   the MySQL pod was created:
"
echo -e $FormatTextCommands "
	$ oc get svc
"
$FormatRunCommand
oc get svc
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Describe the mysql service and note that the Service type is
   ClusterIP by default:
"
echo -e $FormatTextCommands "
	$ oc describe svc mysql
"
$FormatRunCommand
oc describe svc mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   View details about the Deployment Configuration (dc) for this application:
"
echo -e $FormatTextCommands "
	$ oc describe dc mysql
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
oc describe dc mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Export the service created by oc new-app and inspect its contents.
"
echo -e $FormatTextCommands "
	$ oc export svc mysql > mysql-svc.yml
"
$FormatRunCommand
oc export svc mysql > mysql-svc.yml
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
more mysql-svc.yml
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Using plain Kubernetes, you would need to create this file manually,
   plus similar files for the deployment configuration and other resources
   in the project, and then create each resource individually using the
   kubectl create -f <file> command.
   The OpenShift oc command replaces the Kubernetes kubectl command
   accepting all kubectl arguments and more.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Connect to the MySQL server and check that the database was initialized.
   To avoid the need for a MySQL client on your workstation,
   run the client inside the MySQL server pod.
   Start a Bash shell inside the MySQL server container.
   Using the pod name from earlier.
"
echo -e $FormatTextCommands "
	$ oc rsh $MYSQL_POD
"
echo -e $FormatTextSyntax "
   The prompt should change to the Bash shell inside the pod.
"
echo "
   Note: Once the second terminal opens the following commands will be placed
   into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
gnome-terminal --command "oc rsh $MYSQL_POD" --tab
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Connect to the MySQL server using the MySQL client with the loop back IP address:
"
echo -e $FormatTextCommands "
	$ mysql -h127.0.0.1 -P3306 -uuser1 -pmypa55
"
echo -e $FormatTextSyntax "
   You can also use the pod IP address or the service IP address
   instead of the loop back IP address.
"
echo "mysql -h127.0.0.1 -P3306 -uuser1 -pmypa55" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Verify if the testdb database has been created:
"
echo -e $FormatTextCommands "
	mysql> show databases;
"
echo "show databases;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Exit from the MySQL client prompt and the pod Bash prompt:
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Open the Web UI and view details about project = database
   Make sure you're logging in as user: developer
"
$FormatRunCommand
minishift console
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Delete the project and all the resources in the project:
"
echo -e $FormatTextCommands "
	$ oc delete project database
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
oc delete project database
echo -e $FormatTextPause && read -p "<-- End of Demo 6: Press any key to continue -->" NULL && echo -e $TextReset
