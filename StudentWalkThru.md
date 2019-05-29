##  Exercise One: Starting an OpenShift Cluster

Step One: Validate environment variables ...
```
    # env | grep MINISHIFT
```
Step Two: Start MiniShift cluster ...
```
    	$ minishift start
```
Check that the origin container is running inside the VM created by Minishift:
```
    	$ minishift ssh -- docker ps
```
Check that a few container images were pulled by the Minishift VM:
```
    	$ minishift ssh -- docker images
```
Check that the registry and router pods are ready and running.
```
      $ eval $(minishift oc-env)
    	$ oc login -u system:admin
```
Use the oc get pod command on the default project to check the OpenShift registry and router pods are ready and running:
```
    	$ oc get pod -n default
```
Access the web console as a developer user.  Open the OpenShift web console.
```
    	$ minishift console --url
```

## Exercise Two: Managing a MySQL Container
Start the first MySQL server container using the following command:
```
    	$ minishift ssh -- docker run --name mysql-1st rhscl/mysql-56-rhel7
```
Check that the container is running:
```
    	$ minishift ssh -- docker ps -a | grep mysql
```
However, this message is included as part of the container logs, which can be viewed using the following command:
```
    	$ minishift ssh -- docker logs mysql-1st
```
Start a second MySQL server container, providing the required environment variables.  Specify each variable using the -e option.
```
    	$ minishift ssh -- docker run --name mysql-2nd \
    	  -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
    	  -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
    	  -d rhscl/mysql-56-rhel7
```
Verify that the container was started correctly. Run the following command:
```
    	$ minishift ssh -- docker ps -a | grep mysql
```
Inspect the container metadata to obtain the IP address from the MySQL database server container:
```
    	$ minishift ssh -- docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql-2nd
```
Create a third container to run a MySQL client to connect to the database server running on the second container.  Use the MySQL server container image, but without running its default entry point.  Execute the Bash shell instead:
```
		$ minishift ssh
    $ docker run --name mysql-3rd -it rhscl/mysql-56-rhel7 bash
```
Note the full output of 'docker inspect'
```
    	$ docker inspect mysql-2nd
```
Try to connect to the local MySQL database:
```
    	$ mysql
```
Connect to the remote MySQL server in the second container, from the third container.  Notice the IP address should be the one you got earlier.
```
    	$ mysql -uuser1 -h <<MYSQL_2ND_IPADDR>> -pmypa55 items
```
You are connected to the items remote database. Create a new table:
```    	mysql> CREATE TABLE Courses (id int NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY (id));
```
Insert a row into the table by running the following command:
```
    	mysql> insert into Courses (id, name) values (1,'Something Unique');
```
Validate:
```
    	mysql> select * from Courses;
```
Exit from the MySQL prompt, exit from the bash shell.

When you exit the bash shell, the third container was stopped.  Verify that the container mysql-3rd is not running, but the second container is still up:
```
    	$ minishift ssh -- docker ps -a | grep mysql
```
Optional: Delete the containers and resources created by this exercise.
```
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- docker rmi rhscl/mysql-56-rhel7
```

## Exercise Three: Creating a Custom Apache Container Image

Create a container from the centos/httpd image with the following command:
```
    	$ minishift ssh -- docker run -d --name httpd-orig -p 8180:80 centos/httpd
```
Create a new HTML page in the http-orig container.  Access the container bash shell:
```
		$ minishift ssh
  	$ docker exec -it httpd-orig bash
```
Note the output of 'docker ps -a' and the port redirect for apache
```
    	$ docker ps -a
```
Add an HTML page:
```
    	$ echo "My Page" > /var/www/html/course.html
```
Test if the page is reachable:
```
    	$ minishift ssh -- curl 127.0.0.1:8180/course.html
```
Examine the differences in the container between the image and the new layer created by the container:
```
    	$ minishift ssh -- docker diff httpd-orig
```
It is possible to create a new image with the changes created by the previous container. One way is by saving the container to a TAR file.  Stop the httpd-orig container:
```
    	$ minishift ssh -- docker stop httpd-orig
```
Commit the changes to a new container image:
```
    	$ minishift ssh -- 'docker commit -a "Your Name" -m "Added course.html page" httpd-orig'
```
List the available container images:
```
    	$ minishift ssh -- docker images | grep -v openshift
```
The new container image has neither a name (REPOSITORY column) nor a tag.  Use the following command to add this information:
```
      $ IMAGE_TAG=`minishift ssh -- docker images -q | head -n 1`
    	$ minishift ssh -- docker tag $IMAGE_TAG mytag/httpd
```
List the available container images again to confirm that the name and tag were applied to the correct image:
```
    	$ minishift ssh -- docker images | grep -v openshift
```
Create and test a container using the new image.  Create a new container, using the new image:
```
    	$ minishift ssh -- docker run -d --name httpd-custom -p 8280:80 mytag/httpd
```
Check that the new container is running and using the correct image:
```
    	$ minishift ssh -- docker ps -a
```
Check that the container includes the custom page:
```
    	$ minishift ssh -- curl 127.0.0.1:8280/course.html
```
Optional: Delete the containers and images created by this lab:
```
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- docker rmi $EventLabelLowerCase/httpd
		$ minishift ssh -- docker rmi centos/httpd
```

## Exercise Four: Creating a Basic Apache Container Image via Dockerfile

Create a Dockerfile that installs and configures Apache HTTP server.
```
    	$ minishift ssh -- mkdir httpd-image
```
Download the Dockerfile from the course project in GitHub
```
    	$ minishift ssh -- curl -sO https://raw.githubusercontent.com/RedHatTraining/DO081x-lab/master/httpd-image/Dockerfile
```
Then move the Dockerfile source to the httpd-image folder:
```
    	$ minishift ssh -- mv Dockerfile httpd-image
```
To save time, let's edit the Dockerfile to use a newer image.  Edit the Dockerfile to use the rhel7.6 image versus rhel7.3
```
    	$ minishift ssh -- 'sed -i s/rhel7.3/rhel7.6/ httpd-image/Dockerfile'
```
Inspect the Dockerfile you downloaded to check how the image created from it should be.  Display the Dockerfile contents.
```
    	$ minishift ssh -- cat httpd-image/Dockerfile
```
Build and verify the Apache HTTP server image.  Use the docker build command to create a new container image from the Dockerfile:
```
    	$ minishift ssh -- docker build -t myimage/httpd2 httpd-image
```
After the build process has finished, run docker images to see the new image in the image repository:
```
    	$ minishift ssh -- docker images | grep -v openshift
```
Run the Apache HTTP server container.  Create container using the new image, and redirect local port 10080 to port 80 in the container:
```    	$ minishift ssh -- docker run --name my-httpd -d -p 10080:80 myimage/httpd2
```
Check that the new container is running:
```
    	$ minishift ssh -- docker ps | grep -v openshift
```
If the server is running, you should see HTML output for the Apache HTTP server test page from Red Hat.  Use a curl command to check that the server is serving HTTP requests:
```
    	$ minishift ssh -- curl 127.0.0.1:10080 | grep 'Test Page'
```
Optional: Stop and then remove the my-httpd container:
```
		$ minishift ssh -- 'docker stop \$(docker ps -q)'
		$ minishift ssh -- 'docker rm \$(docker ps -aq)'
		$ minishift ssh -- 'rm -rf httpd-image'
		$ minishift ssh -- docker rmi myimage/httpd2
```

## Exercise Five: Deploying a Database Server on OpenShift

Log in to OpenShift as a developer user and create a new project for this exercise.
```
      $ eval $(minishift oc-env)
    	$ oc login -u developer -p developer
```
Create a new project for the resources you will create during this exercise:
```
    	$ oc new-project database
```
Create a new application from the MySQL server container image provided by Red Hat.
```
    	$ oc new-app --name=mysql --docker-image=registry.access.redhat.com/rhscl/mysql-56-rhel7 \
    	  -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=testdb \
    	  -e MYSQL_ROOT_PASSWORD=r00tpa55
```
Verify if the MySQL pod was created successfully and view details about the pod and it's service.  Run the oc status command to view the status of the new application, and to check if the deployment of the MySQL server image was successful:
```
    	$ oc status
```
List the pods in this project to check if the MySQL server pod is ready and running:
```
      $ oc get pods
```
Wait until the application pod is ready and running.  The pod with name ending in "build" ran the build process and should be completed.  The pod with a random suffix is the application pod.
```
      $ oc get pods -w
```
Use the oc describe command to view more details about the pod.  Be sure to use the same pod name displayed by the previous step:
```
      $ MYSQL_POD=`oc get pods | grep Running | cut -f1 -d' '`
    	$ oc describe pod $MYSQL_POD
```
List the services in this project and check if a service to access the MySQL pod was created:
```
    	$ oc get svc
```
Describe the mysql service and note that the Service type is ClusterIP by default:
```
    	$ oc describe svc mysql
```
View details about the Deployment Configuration (dc) for this application:
```
    	$ oc describe dc mysql
```
Export the service created by oc new-app and inspect its contents.
```
    	$ oc export svc mysql > mysql-svc.yml
```
Connect to the MySQL server and check that the database was initialized.  To avoid the need for a MySQL client on your workstation, run the client inside the MySQL server pod.  Start a Bash shell inside the MySQL server container.  Using the pod name from earlier.
```
    	$ oc rsh $MYSQL_POD
```
Connect to the MySQL server using the MySQL client with the loop back IP address:
```
    	$ mysql -h127.0.0.1 -P3306 -uuser1 -pmypa55
```
Verify if the testdb database has been created:
```
    	mysql> show databases;
```
Exit from the MySQL client prompt and the pod Bash prompt:

Open the Web UI and view details about project = database
Make sure you're logging in as user: developer
```
		$ minishift console
```
Delete the project and all the resources in the project:
```
    	$ oc delete project database
```

##  Exercise Six: Creating a Containerized Application with Source-to-Image

Log in to OpenShift as the developer user:
```
    	$ oc login -u developer -p developer
```
Create a new project named s2i:
```
    	$ oc new-project s2i
```
Create a new PHP application using the course repository in GitHub.
```
    	$ oc new-app --name=hello php:7.0~https://github.com/RedHatTraining/DO081x-lab-php-helloworld.git
```
Wait for the build to complete. Follow the build logs:
```
    	$ oc logs -f bc/hello
```
Wait until the application pod is ready and running.  The pod with name ending in "build" ran the build process and should be completed.  The pod with a random suffix is the application pod.
```
    	$ oc get pod -w
```
Review the resources that were created by the oc new-app command.
```
    	$ oc status
```
Examine the build configuration resource using oc describe:
```
    	$ oc describe bc/hello
```
Test the application by running the curl command inside the Minishift VM.
```
      $ SVC_IPADDR=`oc status | grep 8080 | cut -f3 -d' '`
    	$ minishift ssh -- curl -s $SVC_IPADDR:8080
```
Expose the web application by creating a route resource.  Expose the application service to create a route:
```
    	$ oc expose svc hello
```
Check the DNS name generated for the route by OpenShift:
```
    	$ oc get route
```
Check that the application can be accessed, from your workstation.  Open a web browser and access the host name you got from the previous step.
```
     $ ROUTE_URL=`oc get route | grep hello | cut -f6 -d' '`
     $ firefox $ROUTE_URL &
```
Clean up the lab by deleting the OpenShift project, which in turn deletes all the Kubernetes and OpenShift resources:
```
    	$ oc delete project s2i
```
