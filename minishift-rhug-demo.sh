#!/bin/bash
# =============================================================================
#
# Notes:
#    + See github repo for full description, tutorial, and latest versions
#    + Set Event variables below to match your use case
#
# Author: Mark Tonneson (mtonneso at redhat dotcom)
#
# =============================================================================

# Used for externally facing labeling (i.e. websites) use of upper, lower,
# and spaces is acceptable.
EventLabel="NJ RHUG"
# Used to label container assets, must be lowercase and no spaces.
EventLabelLowerCase=nj-rhug

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



function RunExerciseOne() {
    clear
    echo -e $FormatTextSyntax "
       Exercise One: Starting an OpenShift Cluster
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Step One: Validate environment variables ...
    "
    $FormatRunCommand
    #env | grep MINISHIFT
    echo "MINISHIFT_USERNAME=<your.Red.Hat.ID>"
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
    echo -e $FormatTextPause && read -p "<-- End of Exercise: Press any key to continue -->" NULL && echo -e $TextReset
}

function RunExerciseTwo() {
    clear
    echo -e $FormatTextSyntax "
       Exercise Two: Managing a MySQL Container
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
       Check that the container is running:
           Spoiler Alert = Oops! What happened??
    "
    echo -e $FormatTextCommands "
    	$ minishift ssh -- docker ps -a | grep mysql
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    minishift ssh -- docker ps -a | grep mysql
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
    	$ minishift ssh -- docker ps -a | grep mysql
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    minishift ssh -- docker ps -a | grep mysql
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
    MYSQL_2ND_IPADDR=$(minishift ssh -- "docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql-2nd")
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
		minishift ssh
    "
    echo "
       Note: Once the second terminal opens the following commands will be placed
       into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    gnome-terminal --command 'minishift ssh' --tab
    echo -e $FormatTextSyntax "
       Note the full output of 'docker inspect'
    "
    echo -e $FormatTextCommands "
    	$ docker inspect mysql-2nd
    "
    echo "docker inspect mysql-2nd" | xclip -selection clipboard
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
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
    	mysql> insert into Courses (id, name) values (1,'$EventLabel');
    "
    echo "insert into Courses (id, name) values (1,\'$EventLabel\');" | xclip -selection clipboard
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
    	$ minishift ssh -- docker ps -a | grep mysql
    "
    $FormatRunCommand
    minishift ssh -- docker ps -a | grep mysql
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Delete the containers and resources created by this exercise.
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- docker rmi rhscl/mysql-56-rhel7
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
    $FormatRunCommand
    minishift ssh -- 'docker stop $(docker ps -q)'
    minishift ssh -- 'docker rm $(docker ps -aq)'
    minishift ssh -- docker rmi rhscl/mysql-56-rhel7
    echo -e $FormatTextPause && read -p "<-- End of Exercise: Press any key to continue -->" NULL && echo -e $TextReset
}

function RunExerciseThree() {
    clear
    echo -e $FormatTextSyntax "
       Exercise Three: Creating a Custom Apache Container Image
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
		minishift ssh
    "
    echo "
       Note: Once the second terminal opens the following commands will be placed
       into the clipboard for pasting (Ctrl+Shift+V) onto the command line.
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    echo -e $FormatTextSyntax "
       Note the output of 'docker ps -a' and the port redirect for apache
    "
    echo -e $FormatTextCommands "
    	$ docker ps -a
    "
    $FormatRunCommand
    minishift ssh -- docker ps -a
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
    	$ echo \"$EventLabel Page\" > /var/www/html/course.html
    "
    echo 'echo "$EventLabel Page" > /var/www/html/course.html' | xclip -selection clipboard
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
    	$ minishift ssh -- 'docker commit -a \"Your Name\" -m \"Added course.html page\" httpd-orig'
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    minishift ssh -- 'docker commit -a "$EventLabel" -m "Added course.html page" httpd-orig'
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
    	$ minishift ssh -- docker tag $IMAGE_TAG $EventLabelLowerCase/httpd
    "
    $FormatRunCommand
    minishift ssh -- docker tag $IMAGE_TAG $EventLabelLowerCase/httpd
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
    	$ minishift ssh -- docker run -d --name httpd-custom -p 8280:80 $EventLabelLowerCase/httpd
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    minishift ssh -- docker run -d --name httpd-custom -p 8280:80 $EventLabelLowerCase/httpd
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Check that the new container is running and using the correct image:
    "
    echo -e $FormatTextCommands "
    	$ minishift ssh -- docker ps -a
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    minishift ssh -- docker ps -a
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
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- docker rmi $EventLabelLowerCase/httpd
		$ minishift ssh -- docker rmi centos/httpd
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
    $FormatRunCommand
    minishift ssh -- 'docker stop $(docker ps -q)'
    minishift ssh -- 'docker rm $(docker ps -aq)'
    minishift ssh -- docker rmi $EventLabelLowerCase/httpd
    minishift ssh -- docker rmi centos/httpd
    echo -e $FormatTextPause && read -p "<-- End of Exercise: Press any key to continue -->" NULL && echo -e $TextReset
}

function RunExerciseFour() {
    clear
    echo -e $FormatTextSyntax "
       Exercise Four: Creating a Basic Apache Container Image via Dockerfile
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
       To save time, let's edit the Dockerfile to use a newer image.
       Edit the Dockerfile to use the rhel7.6 image versus rhel7.3
    "
    echo -e $FormatTextCommands "
    	$ minishift ssh -- 'sed -i s/rhel7.3/rhel7.6/ httpd-image/Dockerfile'
    "
    $FormatRunCommand
    minishift ssh -- 'sed -i s/rhel7.3/rhel7.6/ httpd-image/Dockerfile'
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
          uses RHEL 7.5 as a base image:
       FROM rhel7.5

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
    	$ minishift ssh -- docker build -t $EventLabelLowerCase/httpd2 httpd-image
    "
    #read -p "Sit back this process will take awhile " NULL
    $FormatRunCommand
    minishift ssh -- docker build -t $EventLabelLowerCase/httpd2 httpd-image
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
    	$ minishift ssh -- docker run --name my-httpd -d -p 10080:80 $EventLabelLowerCase/httpd2
    "
    $FormatRunCommand
    minishift ssh -- docker run --name my-httpd -d -p 10080:80 $EventLabelLowerCase/httpd2
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
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
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- 'rm -rf httpd-image'
		$ minishift ssh -- docker rmi $EventLabelLowerCase/httpd2
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to remove demo resources, or Ctrl+C to exit -->" NULL
    $FormatRunCommand
    minishift ssh -- 'docker stop $(docker ps -q)'
    minishift ssh -- 'docker rm $(docker ps -aq)'
    minishift ssh -- 'rm -rf httpd-image'
    #echo -e $FormatTextSyntax "Remove the $EventLabelLowerCase/httpd2 container image:"
    minishift ssh -- docker rmi $EventLabelLowerCase/httpd2
    echo -e $FormatTextPause && read -p "<-- End of Exercise: Press any key to continue -->" NULL && echo -e $TextReset
}

function RunExerciseFive() {
    clear
    echo -e $FormatTextSyntax "
       Exercise Five: Deploying a Database Server on OpenShift
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
    echo -e $FormatTextCommands '
      $ eval $(minishift oc-env)
    	$ oc login -u developer -p developer
    '
    $FormatRunCommand
    eval $(minishift oc-env)
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
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
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
		$ minishift console
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
    echo -e $FormatTextPause && read -p "<-- End of Exercise: Press any key to continue -->" NULL && echo -e $TextReset
}

function RunExerciseSix() {
    clear
    echo -e $FormatTextSyntax "
       Exercise Six: Creating a Containerized Application with Source-to-Image
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
       The next step will show how to expose a web application or service.
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Expose the web application by creating a route resource.
       Expose the application service to create a route:
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    echo -e $FormatTextCommands "
    	$ oc expose svc hello
    "
    $FormatRunCommand
    oc expose svc hello
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Check the DNS name generated for the route by OpenShift:
    "
    echo -e $FormatTextCommands "
    	$ oc get route
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    oc get route
    echo -e $FormatTextSyntax "
       Minishift uses the VM IP address and the special nip.io DNS domain
       to create a valid DNS name that points to the Minishift VM.
       Notice the host name generated by OpenShift is comprised of the
      application name and project name, followed by a default domain
       configured for the OpenShift cluster.
    "
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Check that the application can be accessed, from your workstation.
       Open a web browser and access the host name you got from the previous step.
    "
    $FormatRunCommand
    ROUTE_URL=`oc get route | grep hello | cut -f6 -d' '`
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL
    $FormatRunCommand
    firefox $ROUTE_URL &
    echo -e $FormatTextPause && read -p "<-- Press any key to continue -->" NULL

    echo -e $FormatTextSyntax "
       Open the Web UI and view details about project = s2i
    "
    $FormatRunCommand
    #minishift console
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
    echo -e $FormatTextPause && read -p "<-- End of Demo: Press any key to continue -->" NULL && echo -e $TextReset
}

case "$1" in
   -a | --all)
	RunExerciseOne
	RunExerciseTwo
	RunExerciseThree
	RunExerciseFour
	RunExerciseFive
	RunExerciseSix
	;;

   2)
	RunExerciseTwo
	RunExerciseThree
	RunExerciseFour
	RunExerciseFive
	RunExerciseSix
	;;

   3)
	RunExerciseThree
	RunExerciseFour
	RunExerciseFive
	RunExerciseSix
	;;

   4)
	RunExerciseFour
	RunExerciseFive
	RunExerciseSix
	;;

   5)
	RunExerciseFive
	RunExerciseSix
	;;

   6)
	RunExerciseSix
	;;

   -h | --help | *)
	echo -e "\nUsage: \n" $0 " [options] \n\n Options: \n   -a or --all \t run full demo \t\t (ex: " $0 " --all) \n   [num 2-6] \t start demo at step NUM \t (ex: " $0 " 4)\n"
	exit 1
	;;
esac
