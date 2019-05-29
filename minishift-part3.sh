#!/bin/bash
#
# Exercise Three: Working with a container, making it usable
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
   Exercise: Managing a MySQL Container
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Start the first MySQL server container using the following command:
   This command downloads the MySQL database container image from Red Hat
   and tries to start it, but it does not start.
   The reason for this is the image requires a few environment variables to be provided.
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker run --name mysql-1st rhscl/mysql-56-rhel7
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker run -d --name mysql-1st rhscl/mysql-56-rhel7
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Note: If you try to run the container as a daemon (-d), the error message
   about the required variables is not displayed.
   However, this message is included as part of the container logs,
   which can be viewed using the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker logs mysql-1st
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker logs mysql-1st
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the container exited:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps -a | grep mysql
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker ps -a | grep mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Start a second MySQL server container, providing the required environment variables.
   Specify each variable using the -e option.
"
echo -e $FormatTextCommands '
	$ minishift ssh -- docker run --name mysql-2nd \
	  -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
	  -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
	  -d rhscl/mysql-56-rhel7
'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker run --name mysql-2nd -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 -d rhscl/mysql-56-rhel7
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Verify that the container was started correctly. Run the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps | grep mysql
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker ps | grep mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Inspect the container metadata to obtain the IP address from the
   MySQL database server container:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql-2nd
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- "docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql-2nd"
MYSQL_2ND_IPADDR=`minishift ssh -- "docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql-2nd"`
echo -e $FormatTextSyntax "
   Make a note of the IP address because it will be used for the next steps.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a third container to run a MySQL client to connect to the
   database server running on the second container.
   Use the MySQL server container image, but without running
   its default entry point.
   Execute the Bash shell instead:
"
echo "
   Note: Once the second terminal opens the following commands will be placed
   into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
gnome-terminal --command 'minishift ssh' --tab
echo -e $FormatTextCommands "
	$ docker run --name mysql-3rd -it rhscl/mysql-56-rhel7 bash
"
echo "docker run --name mysql-3rd -it rhscl/mysql-56-rhel7 bash" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Notice that this container image displays a Bash prompt for a regular user.
   Different from the MySQL image from the Docker Hub, the image provided
   by Red Hat does not run as the root user.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Try to connect to the local MySQL database:
"
echo -e $FormatTextCommands "
	$ mysql
"
echo "mysql" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
echo -e $FormatTextSyntax "
   This error is expected because the MySQL database server was
   not started in the third container.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Connect to the remote MySQL server in the second container,
   from the third container.
   Notice the IP address should be the one you got earlier.
"
echo -e $FormatTextCommands "
	$ mysql -uuser1 -h $MYSQL_2ND_IPADDR -pmypa55 items
"
echo "mysql -uuser1 -h $MYSQL_2ND_IPADDR -pmypa55 items" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   You are connected to the items remote database. Create a new table:
"
echo -e $FormatTextCommands "
	mysql> CREATE TABLE Courses (id int NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY (id));
"
echo "CREATE TABLE Courses (id int NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY (id));" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Insert a row into the table by running the following command:
"
echo -e $FormatTextCommands "
	mysql> insert into Courses (id, name) values (1,'DO081x');
"
echo "insert into Courses (id, name) values (1,'DO081x');" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Validate:
"
echo -e $FormatTextCommands "
	mysql> select * from Courses;
"
echo "select * from Courses;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Exit from the MySQL prompt:
   Exit from the bash shell:
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   When you exit the bash shell, the third container was stopped.
   Verify that the container mysql-3rd is not running, but the
   second container is still up:
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps | grep mysql
"
$FormatRunCommand
minishift ssh -- docker ps | grep mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Delete the containers and resources created by this exercise.
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
minishift ssh -- 'docker stop $(docker ps -q)'
minishift ssh -- 'docker rm $(docker ps -aq)'
minishift ssh -- docker rmi rhscl/mysql-56-rhel7
echo -e $FormatTextPause && read -p "<-- End of Demo 3: Press any key to continue -->" NULL && echo -e $TextReset
