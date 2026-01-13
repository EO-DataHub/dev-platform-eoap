# Developer platform for Earth Observation Application Packages

## Overview

This repository provides a Kubernetes-based development environment built around a browser-accessible code-server instance. The environment is deployed as a pod in the cluster and exposed locally via Skaffold port-forwarding.

The code-server pod is configured with:
* A persistent workspace
* Predefined shell initialization and configuration scripts
* A Kubernetes service account mounted into the pod
* The mounted service account allows users to:
  * Invoke Calrissian from the command line inside the code-server environment
  * Submit Kubernetes Jobs directly using kubectl and predefined manifests

This setup enables interactive development and execution of cloud-native CWL workflows from a browser, while delegating workflow execution to Kubernetes via Calrissian. It is intended for hands-on experimentation, training, and validation of Earth Observation application packages in a Kubernetes environment.

## Prerequisites

To deploy and run this project, users need the following tools installed locally.

### Required

* Kubernetes cluster

  * A running Kubernetes cluster (local or remote)
  * Tested with local clusters such as Minikube
  * The cluster must support:
    * PersistentVolumeClaims
    * The RWX storage class referenced by the deployment (`standard` by default, `file-storage` for the `eodh` profile)
* kubectl
  * Version compatible with the target Kubernetes cluster
  * Must be configured with access to the cluster (kubectl config current-context)
* Helm
  * Helm v3
  * Required to deploy the application via the Helm chart in charts/coder
* Skaffold
  * Version compatible with apiVersion: skaffold/v4beta9
  * Used to orchestrate Helm deployment and port-forwarding

### Not required

* Ingress controller
  * Access is provided via Skaffold port-forwarding

### Runtime access

* Local port availability
  * Port 8000 on the local machine must be free
  * It is used to forward traffic to the code-server-service running in the cluster

## Notes on profiles

The `eodh` Skaffold profile changes the storage class to `file-storage`

Ensure the target cluster provides this storage class before enabling the profile:

```console
skaffold run -p eodh
```

## Quick start

* Ensure all prerequisites listed above are installed and that your Kubernetes context points to the target cluster:

```
kubectl config current-context
```

Deploy the platform using Skaffold:

* with Minikube

```
skaffold dev
```

* EODH cluster on AWS

```
skaffold dev -p eodh
```

This will:

* Create the `dev-platform-eoap` namespace (if missing)
* Deploy the Helm release `dev-platform-eoap`
* Start port-forwarding to the `code-server` service

Access the platform locally at:

http://localhost:8000


To stop port-forwarding and clean up resources, use Ctrl+C in the terminal.

### Using the eodh profile

A dedicated Skaffold profile is provided for environments where a non-default storage class is required.

* The eodh profile:

  * Switches the storage class to file-storage for both Coder and Calrissian
  * Assumes the cluster already provides this storage class

To deploy with this profile:

```
skaffold dev -p eodh
```

## Tested environments

This setup has been validated in the following environments:

* Local Kubernetes clusters:
  * Minikube
* Remote clusters:
  * EODH AWS ECK

