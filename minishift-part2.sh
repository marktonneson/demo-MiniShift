#!/bin/bash
#
# Exercise Two: Creating a container
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
   Exercise: Creating a MySQL Database Instance
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a MySQL server container instance.
   Start a container from the Docker Hub MySQL image.
"
echo -e $FormatTextCommands '
	$ minishift ssh -- docker run --name mysql-basic -e MYSQL_USER=user1 \
	-e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items \
	-e MYSQL_ROOT_PASSWORD=r00tpa55 -d mysql:5.6
'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker run --name mysql-basic -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 -d mysql:5.6
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the container started without errors.
   Check if the container was started correctly. Run the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps | grep mysql
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker ps | grep mysql
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Access the container sandbox by running the following command:
"
echo -e $FormatTextCommands "
	$ docker exec -it mysql-basic bash
"
echo "docker exec -it mysql-basic bash" | xclip -selection clipboard
echo "
   Note: Once the second terminal opens the following commands will be placed
   into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
gnome-terminal --command 'minishift ssh' --tab
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Add data to the database.
   Log in to MySQL as the database administrator user (root).
"
echo -e $FormatTextCommands "
	$ mysql -pr00tpa55
"
$FormatRunCommand
read -p "Press Ctrl+Shift+V to paste commands into second terminal" NULL
echo "mysql -pr00tpa55" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
echo -e $FormatTextCommands "
	mysql> show databases;
"
echo "show databases;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new table in the items database. From the MySQL prompt,
   run the following command to access the database:
"
echo -e $FormatTextCommands "
	mysql>  use items;
"
echo "use items;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   From the MySQL prompt, create a table called Projects in the items database:
"
echo -e $FormatTextCommands "
	mysql> CREATE TABLE Courses (id int NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY (id));
"
echo "CREATE TABLE Courses (id int NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY (id));" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Run the following command to verify that the table was created:
"
echo -e $FormatTextCommands "
	mysql> show tables;
"
echo "show tables;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Insert a row in the table by running the following command:
"
echo -e $FormatTextCommands "
	mysql> insert into Courses (id, name) values (1, 'DO081x');
"
echo "insert into Courses (id, name) values (1, 'DO081x');" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Run the following command to verify that the project information
   was added to the table:
"
echo -e $FormatTextCommands "
	mysql> select * from Courses;
"
echo "select * from Courses;" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Exit from the MySQL prompt and the MySQL container:
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
#minishift console
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Undo the changes made by the lab when you are finished:
   Stop the running container by running the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker stop mysql-basic
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker stop mysql-basic
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Remove the data from the stopped container by running the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker rm mysql-basic
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker rm mysql-basic
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Remove the container image by running the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker rmi mysql:5.6
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
minishift ssh -- docker rmi mysql:5.6

echo -e $FormatTextSyntax "
   Leave the Minishift VM:
"
echo -e $FormatTextPause && read -p "<-- End of Demo 2: Press any key to continue -->" NULL && echo -e $TextReset
