#!/bin/bash
#
# Exercise Four: Modifying a container image
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
   Exercise: Creating a Custom Apache Container Image
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a container from the centos/httpd image with the following command:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker run -d --name httpd-orig -p 8180:80 centos/httpd
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker run -d --name httpd-orig -p 8180:80 centos/httpd
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a new HTML page in the http-orig container.
   Access the container bash shell:
"
echo "
   Note: Once the second terminal opens the following commands will be placed
   into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
gnome-terminal --command 'minishift ssh' --tab
echo -e $FormatTextCommands "
	$ docker exec -it httpd-orig bash
"
echo "docker exec -it httpd-orig bash" | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Add an HTML page:
"
echo -e $FormatTextCommands "
	$ echo \"DO081x Page\" > /var/www/html/course.html
"
echo 'echo "DO081x Page" > /var/www/html/course.html' | xclip -selection clipboard
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Exit the bash shell:
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Test if the page is reachable:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- curl 127.0.0.1:8180/course.html
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- curl -s 127.0.0.1:8180/course.html
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Examine the differences in the container between the image and
   the new layer created by the container:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker diff httpd-orig
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker diff httpd-orig
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   The previous output lists the directories and files that were changed
   or added to the httpd-orig container.
   Remember that these changes are only for this container.
   It is possible to create a new image with the changes created by the
   previous container. One way is by saving the container to a TAR file.
   Stop the httpd-orig container:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker stop httpd-orig
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker stop httpd-orig
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Commit the changes to a new container image:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- 'docker commit -a \"Test Exercise\" -m \"Added course.html page\" httpd-orig'
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- 'docker commit -a "Test Exercise" -m "Added course.html page" httpd-orig'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   List the available container images:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker images | grep -v openshift
"
echo -e $FormatTextSyntax "
   Compare the output to that from the previous step to see which image
   was created by docker commit. It is the one created more recently and
   will be the first one listed.
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker images | grep -v openshift
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   The new container image has neither a name (REPOSITORY column) nor a tag.
   Use the following command to add this information:
"
$FormatRunCommand
IMAGE_TAG=`minishift ssh -- docker images -q | head -n 1`
echo -e $FormatTextCommands "
	$ minishift ssh -- docker tag $IMAGE_TAG do081x/httpd
"
$FormatRunCommand
minishift ssh -- docker tag $IMAGE_TAG do081x/httpd
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   List the available container images again to confirm that the name
   and tag were applied to the correct image:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker images | grep -v openshift
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker images | grep -v openshift
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create and test a container using the new image.
   Create a new container, using the new image:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker run -d --name httpd-custom -p 8280:80 do081x/httpd
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker run -d --name httpd-custom -p 8280:80 do081x/httpd
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the new container is running and using the correct image:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps | grep httpd
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- docker ps | grep httpd
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Check that the container includes the custom page:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- curl 127.0.0.1:8280/course.html
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- curl -s 127.0.0.1:8280/course.html
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
Delete the containers and images created by this lab:
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
minishift ssh -- 'docker stop $(docker ps -q)'
minishift ssh -- 'docker rm $(docker ps -aq)'
minishift ssh -- docker rmi do081x/httpd
minishift ssh -- docker rmi centos/httpd
echo -e $FormatTextPause && read -p "<-- End of Demo 4: Press any key to continue -->" NULL && echo -e $TextReset
