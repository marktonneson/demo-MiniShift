## MiniShift Cheatsheet
Minishift is a command-line tool that provisions and manages single-node OpenShift clusters optimized for development workflows.

**Usage:**
  minishift \[command\]

**Available Commands:**
```
  addons	Manages Minishift add-ons.
  completion  	Outputs minishift shell completion for the given shell (bash or zsh)
  config      	Modifies Minishift configuration properties.
  console     	Opens or displays the OpenShift Web Console URL.
  delete      	Deletes the Minishift VM.
  docker-env  	Sets Docker environment variables.
  help        	Help about any command
  hostfolder  	Manages host folders for the Minishift VM.
  image       	Exports and imports container images.
  ip          	Gets the IP address of the running cluster.
  logs        	Gets the logs of the running OpenShift cluster.
  oc-env      	Sets the path of the 'oc' binary.
  openshift   	Interacts with your local OpenShift cluster.
  profile     	Manages Minishift profiles.
  setup-cdk   	Configures CDK v3 on the host.
  ssh         	Log in to or run a command on a Minishift VM with SSH.
  start       	Starts a local OpenShift cluster.
  status      	Gets the status of the local OpenShift cluster.
  stop        	Stops the running local OpenShift cluster.
  version     	Gets the version of Minishift.
```
**Flags:**
```
      --alsologtostderr             log to standard error as well as files
  -h, --help                        help for minishift
      --log_dir string              If non-empty, write log files in this directory
      --logtostderr                 log to standard error instead of files
      --profile string              Profile name (default "minishift")
      --show-libmachine-logs        Show logs from libmachine.
      --stderrthreshold severity    logs at or above this threshold go to stderr (default 2)
  -v, --v Level                     log level for V logs
      --vmodule moduleSpec          comma-separated list of pattern=N settings for file-filtered logging
```

Use "minishift \[command\] --help" for more information about a command.

[MinShift cmdline reference](https://docs.openshift.org/latest/minishift/command-ref/minishift.html)
