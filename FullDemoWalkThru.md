## MiniShift Full Demo WalkThru

***Note: this document needs updating, specifically additional detail.  Consider it DRAFT at this point.***

### Requirements:
* See Installation doc for requirements

### WalkThru:

#### Exercise One: Starting an OpenShift Cluster
* MINISHIFT_USERNAME is your Red Hat ID.  Set as an environment variable or it should prompt
* As MiniShift starts, talk about what it is and RH Developer Network
  * Initial build/start = 10-15m, subsequent starts = 3-4m
  * Minishift is a tool that helps you run OpenShift locally by running a single-node OpenShift cluster inside a VM.
  * OpenShift is an enterprise-class container orchestration product.
  * RH Developer Network is a free membership that gives access to subscriptions for RHEL, JBoss, and OpenShift.  There is also a wealth of additional information including tutorials, e-books, and KBase content.  There’s even  a newsletter to keep you up-to-date on everything happening on RH Developer Network
* To run commands in MiniShift VM
```
# minishift ssh
```
* Make note of various infrastructure containers
  *  k8s and origin (OpenShift) containers
  * Webconsole, router, registry
```
# docker ps
```
*  Pull from RH registry, talk to security and vetting process
```
# docker images
```
* Note projects other than default
  * Admin can see the infra k8s and openshift projects
```
# oc login -u system:admin
```
* We’ll spend more time with various oc cmds later

* Web UI = login as developer, will also spend more time later
  * Note catalog with available dev tools
  * Also Home Page tour, and Documentation + other resources



#### Exercise Two: Using docker commands
*  Highlight troubleshooting with logs cmd
```
# mysql-1st
```
* In testing, build took 2-3 minutes
* Open another cmd window
  * Note: State, Mounts, Config (Env, Cmd), Network
```
# docker inspect
# minishift ssh --docker inspect mysql-2nd
```
* Highlight security of RH images vs Docker Hub
```
# mysql-3rd
# whoami
# ps -ef
```
* Notice: mysql command to connect to mysql-2nd = containers can talk to one another



#### Exercise Three: Using & Creating docker images
* Note security differences (here we are root)
  * Image was pulled from docker.io not RH, and CentOS vs RHEL
```
# docker exec
```
* Access apache via port redirect, in 2nd cmd window:
  * docker diff = [A]dded  [C]hanged
  * docker commit = creates/saves new image with above changes
    * -a, author	-m, message
```
# docker ps -a
# docker diff
# docker commit
```
*  Make image identifiable and consumable; note before & after of httpd-custom
```
# docker tag
```



#### Exercise Four: Intro to Dockerfile
* Now using Dockerfile vs cmdline
* In testing, build time was 3-5 minutes
* Note RHEL image is smaller than do081/httpd2 due to Dockerfile additions
```
# docker images
```



#### Exercise Five: Kubernetes + docker made simple
* Container foundation complete = moving on to OpenShift/MiniShift
* Note: oc cmds run on desktop vs minishift VM for docker cmds
* Does this command look familiar?
```
# oc new-app
```
* In testing, build time = 2-3 min
* What is a pod?
  * The Kubernetes scheduling unit is the pod, which is a grouping of containers sharing a virtual network device, internal IP address, TCP/UDP ports, and persistent storage.
  * Node, Labels, IP, Containers, Events
```
# oc describe pod
```
* What is a Service (svc)?
  * A service is a logical name representing a set of pods. The service is assigned an IP address and a DNS name, and can be exposed externally to the cluster via a port or a route.
  * IP = cluster vs Endpoint = container(s)
```
# oc describe svc
```
* What is a deployment config (dc)?
  * A deployment configuration defines the template for a pod and manages deploying new images or configuration changes whenever the attributes are changed. A single deployment configuration is usually analogous to a single microservice. Deployment configurations can support many different deployment patterns, including full restart, customizable rolling updates, as well as pre and post lifecycle hooks.
```
# oc describe dc
```
 * Note how OpenShift makes k8s easy
```
# oc export
```
* Notice user
```
# oc rsh: # whoami
```
* Notice container name, processes, and content
```
# oc rsh: # hostname
# oc rsh: # ps -ef; ls -la /var/www/html
```
* Notice testdb from original oc new-app cmd
```
# show databases
```
* Web UI: open db project, walk thru interface
  * Optional: scale up & down



#### Exercise Six: Putting it all together = deploying an application
* Source-to-Image -  what is it, talk during build, after oc logs cmd
  * The Source-to-Image (S2I) process in OpenShift pulls code from an SCM repository
  * Automatically detects which kind of runtime that source code needs
  * Starts a pod from a base image specific to that kind of runtime
  * Inside this pod, OpenShift builds the application the same way that the developer would (for example, running maven for a Java application)
  * If the build is successful, another image is created, layering the application binaries over its runtime
  * This image is pushed to an image registry internal to OpenShift
  * A new pod can then be created from this image, running the application
  * S2I can be viewed as a complete CI/CD pipeline already built into OpenShift.
* In testing, build time = 2-3 min
 * What is a build config (bc)?
   * A build configuration contains a description of how to build source code and a base image into a new image.
```
# oc describe bc
```
* What is a route?  
  * A route is a DNS entry that is created to point to a service so that it can be accessed from outside the cluster.  * A route is a DNS entry that is created to point to a service so that it can be accessed from outside the cluster.
```
# oc expose
```
* Web UI: open s2i project, walk thru interface



### Troubleshooting
* If minishift gets “already registered” error
  * Restart with “minishift stop && minishift start --skip-registration”
* Missing path to “oc”
  * RHEL: eval $(minishift oc-env)
  * Windows cmd:
```
  C:\> @FOR /f "tokens=*" %i IN ('minishift oc-env') DO @call %i PowerShell: PS C:\> & minishift oc-env | Invoke-Expression
```
* Keyring issues, may manifest as being unable to access registry.access.redhat.com
```
$ secret-tool clear service minishift username <username>
```
