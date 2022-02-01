# Sonarqube and Jenkins

## What is sonarqube?

SonarQube is the leading tool for continuously inspecting the Code Quality and Security of your codebases, and guiding development teams during Code Reviews. Covering 27 programming languages, while pairing-up with your existing software pipeline, SonarQube provides clear remediation guidance for developers to understand and fix issues, and for teams overall to deliver better and safer software. With over 225,000 deployments helping small development teams as well as global organizations, SonarQube provides the means for all teams and companies around the world to own and impact their Code Quality and Security.

## Docker Host Requirements

Because SonarQube uses an embedded Elasticsearch, make sure that your Docker host configuration complies with the Elasticsearch production mode requirements and File Descriptors configuration.

For example, on Linux, you can set the recommended values for the current session by running the following commands as root on the host:

```sh
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```


## Use volumes
We recommend creating volumes for the following directories:

- /opt/sonarqube/data: data files, such as the embedded H2 database and Elasticsearch indexes
- /opt/sonarqube/logs: contains SonarQube logs about access, web process, CE process, Elasticsearch logs
- /opt/sonarqube/extensions: for 3rd party plugins

`Warning`: You cannot use the same volumes on multiple instances of SonarQube.
