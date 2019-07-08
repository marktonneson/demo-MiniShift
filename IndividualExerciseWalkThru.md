## MiniShift Individual Exercise WalkThru

### Requirements:
* See Installation doc for requirements

### WalkThru:

#### Guided Exercise 1: Starting an OpenShift Cluster
**Objective:** Start an all-in-one OpenShift cluster for a developer user.  Start and access an all-in-one OpenShift instance for a developer using the minishift command from the Red Hat Container Development Kit 3.0 (CDK 3).

**Notes:** 
* At the end the web console opens, login as admin, view default project.  Will see same as command line.

#### Guided Exercise 2: Creating a MySQL Database Instance
**Objective:** Start a MySQL server from a container image and store information inside the database.

**Notes:** 
* The initial docker build for MySQL takes 1-2 minutes. 
* When the second terminal opens the commands will be placed in the clipboard for pasting via Ctrl+Shift+V.  Docker-only, not visible in OpenShift console.

#### Guided Exercise 3: Managing a MySQL Container
**Objective:** Create and manage multiple MySQL server containers.

**Notes:**
* The initial docker build for MySQL -- this one from RH registry vs Docker Hub -- takes 1-2 minutes.
* When the second terminal opens the commands will be placed in the clipboard for pasting via Ctrl+Shift+V.  Docker-only, not visible in OpenShift console.

#### Guided Exercise 4: Creating a Custom Apache Container Image
**Objective:** Create a custom Apache HTTP server container image from changes made inside a container, using the docker commit command.

**Notes:**
* Initial apache build takes 3-5 minutes.
* When the second terminal opens the commands will be placed in the clipboard for pasting via Ctrl+Shift+V.  Docker-only, not visible in OpenShift console.

#### Guided Exercise 5: Creating a Basic Apache Container Image
**Objective:** Create a basic Apache HTTP server container image, built on a RHEL 7 image, using the docker build command.

**Notes:**
* Initial build from Dockerfile takes 10-15 minutes.  The yum update taking the majority of the time.
* Speed things up option 1: Pre-run the exercise and command out the removal of the image at the end.
* Speed things up option 2: Edit the Dockerfile to pull a more recent version of RHEL 7, which will significantly reduce the yum update time.

#### Guided Exercise 6: Deploying a Database Server on OpenShift
**Objective:** Create and deploy a MySQL server container on OpenShift from an existing container image, using the oc new-app command.

**Notes:**
* Build of MySQL pod takes 3-5 minutes.
* The ‘oc get pod’ command uses ‘-w’ to watch the progress, once complete Ctrl+C to break and continue.
* When the second terminal opens the commands will be placed in the clipboard for pasting via Ctrl+Shift+V.
* Before project cleanup, open the web UI and highlight in web UI what was also on command line.

#### Guided Exercise 7: Creating a Containerized Application with Source-to-Image
**Objective:** Create and deploy a web application container from source code, on OpenShift, using the oc new-app command.

**Notes:**
* Build of HelloWorld app takes 2-3 minutes, then another 2-3 minutes for the pod creation.
* The ‘oc get pod’ command uses ‘-w’ to watch the progress, once complete Ctrl+C to break and continue.
* Before project cleanup, open the web UI and highlight in web UI what was also on command line.

#### Guided Exercise 8: Exposing a Service as a Route
**Objective:** Expose a web application to be accessible outside the OpenShift cluster, using an OpenShift route.

**Notes:**
* Build of HelloWorld pod takes 2-3 minutes.
* The ‘oc get pod’ command uses ‘-w’ to watch the progress, once complete Ctrl+C to break and continue.
* Before project cleanup, open the web UI and highlight in web UI what was also on command line.
