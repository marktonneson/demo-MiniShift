#!/bin/bash
#
# Exercise Five: Using a Dockerfile to create an image
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
   Exercise: Creating a Basic Apache Container Image
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift start
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Create a Dockerfile that installs and configures Apache HTTP server.


   Create a folder to contain the Dockerfile and its supporting files.
   For this exercise, there are no supporting files. But anyway it is
   recommended to have the Dockerfile in a folder by itself.
"
echo -e $FormatTextCommands "
	$ minishift ssh -- mkdir httpd-image
"
$FormatRunCommand
minishift ssh -- mkdir httpd-image
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Download the Dockerfile from the course project in GitHub
"
echo -e $FormatTextCommands "
	$ minishift ssh -- curl -sO https://raw.githubusercontent.com/RedHatTraining/DO081x-lab/master/httpd-image/Dockerfile
"
$FormatRunCommand
minishift ssh -- curl -sO https://raw.githubusercontent.com/RedHatTraining/DO081x-lab/master/httpd-image/Dockerfile
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Then move the Dockerfile source to the httpd-image folder:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- mv Dockerfile httpd-image
"
$FormatRunCommand
minishift ssh -- mv Dockerfile httpd-image
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Inspect the Dockerfile you downloaded to check how the image
   created from it should be.
   Display the Dockerfile contents.
"
echo -e $FormatTextCommands "
	$ minishift ssh -- cat httpd-image/Dockerfile
"
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
$FormatRunCommand
minishift ssh -- cat httpd-image/Dockerfile
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
echo -e $FormatTextSyntax '
      The following FROM instruction, at the top of the Dockerfile,
      uses RHEL 7.3 as a base image:
   FROM rhel7.3

      Below the FROM instruction, the MAINTAINER instruction sets
      the Author field in the new image, for documentation purposes
   MAINTAINER Your Name <youremail>


      Below the MAINTAINER instruction, the LABEL instruction adds
      description metadata to the new image:
   LABEL description="A basic Apache HTTP server container on RHEL 7"

      The RUN instruction executes yum commands to install Apache HTTP server
      on the new container and perform clean up after the installation is done:
   RUN yum -y update && \
       yum install -y httpd &&
       yum clean all

      Use the EXPOSE instruction below the RUN instruction to document the port
      that the container listens to at runtime. In this instance, set the port to 80,
      because it is the default for an Apache server:
   EXPOSE 80

      At the end of the file, the ENTRYPOINT instruction sets httpd as the default
      executable when the container is started, and the CMD sets the default arguments
      for the httpd executable.
   ENTRYPOINT  ["httpd"]
   CMD  ["-D", "FOREGROUND"]

      The -D FOREGROUND runs httpd as a foreground process.
      A containerized process should not start additional processes if there is no need,
      and should not put itself in the background.
'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Build and verify the Apache HTTP server image
   Use the docker build command to create a new container image from the Dockerfile:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker build -t do081x/httpd2 httpd-image
"
#read -p "Sit back this process will take awhile " NULL
$FormatRunCommand
minishift ssh -- docker build -t do081x/httpd2 httpd-image
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   After the build process has finished, run docker images to see the
   new image in the image repository:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker images | grep -v openshift
"
$FormatRunCommand
minishift ssh -- docker images | grep -v openshift
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Run the Apache HTTP server container
   Create container using the new image, and redirect local port 10080
   to port 80 in the container:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker run --name my-httpd -d -p 10080:80 do081x/httpd2
"
$FormatRunCommand
minishift ssh -- docker run --name my-httpd -d -p 10080:80 do081x/httpd2
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   [REVIEW]
   Check that the new container is running:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- docker ps | grep -v openshift
"
$FormatRunCommand
minishift ssh -- docker ps | grep -v openshift
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Use a curl command to check that the server is serving HTTP requests:
"
echo -e $FormatTextCommands "
	$ minishift ssh -- curl 127.0.0.1:10080 | grep 'Test Page'
"
echo -e $FormatTextSyntax "
   If the server is running, you should see HTML output for the
   Apache HTTP server test page from Red Hat.
"
$FormatRunCommand
minishift ssh -- curl -s 127.0.0.1:10080 | grep 'Test Page'
echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

echo -e $FormatTextSyntax "
   Stop and then remove the my-httpd container:
"
echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
$FormatRunCommand
minishift ssh -- 'docker stop $(docker ps -q)'
minishift ssh -- 'docker rm $(docker ps -aq)'
minishift ssh -- 'rm -rf httpd-image'
#echo -e $FormatTextSyntax "Remove the do081x/httpd2 container image:"
#minishift ssh -- docker rmi do081x/httpd2
echo -e $FormatTextPause && read -p "<-- End of Demo 5: Press any key to continue -->" NULL && echo -e $TextReset
