# Getting started

This folder contains example artifacts and helper tasks to run a complete end-to-end Earth Observation workflow using the development environment provided by this repository.

The examples are designed to be executed from inside the code-server environment deployed in Kubernetes. The code-server pod is configured with a mounted Kubernetes service account, allowing workflows to be executed and Kubernetes resources to be created directly from the command line.

## Contents

```
getting-started/
├── Taskfile.yml
├── app-water-bodies-cloud-native.1.1.0.cwl
├── water-bodies-cloud-native-k8s-job.yaml
└── README.md
```

* `Taskfile.yml`
  
Defines convenience tasks to:
  * Submit a Kubernetes Job
  * Run a CWL workflow with Calrissian
  * Wrap a CWL workflow with stage-in / stage-out steps

* `app-water-bodies-cloud-native.1.1.0.cwl`

CWL application package implementing a water bodies detection workflow.

* `water-bodies-cloud-native-k8s-job.yaml`

Example Kubernetes Job manifest for submitting the workflow directly to the cluster.

## Prerequisites

The following tools are already available in the `code-server` environment:

* `kubectl`
* `calrissian`
* `task`
* `cwl-wrapper`

No additional setup is required, provided you are running inside the deployed `code-server` pod.

## Usage

All commands below are expected to be run from the getting-started/ directory:

```console
cd /workspace/getting-started
```

### Submit a Kubernetes Job

To submit the example Kubernetes Job:

```console
task submit-k8s-job
```

This applies the manifest:

`/workspace/getting-started/water-bodies-cloud-native-k8s-job.yaml`

You can override the manifest path if needed:

```console
task submit-k8s-job JOB_MANIFEST=/path/to/job.yaml
```

### Run the workflow with Calrissian

To run the CWL workflow using Calrissian from the command line:

```console
task run-calrissian
```

This will:

* Create a workflow-specific working directory under /calrissian/
* Execute the CWL workflow using the mounted Kubernetes service account
* Submit pods and jobs to the Kubernetes cluster
* Store results, logs, and usage reports under /calrissian/<workflow-id>/

Optional overrides:

```console
task run-calrissian \
  WORKFLOW_ID=water-bodies \
  WORKFLOW=/workspace/getting-started/app-water-bodies-cloud-native.1.1.0.cwl \
  WORKFLOW_PARAMS=/calrissian/params.yaml
```

### Wrap the CWL workflow

To wrap the CWL workflow with stage-in and stage-out steps:

```console
task wrap
```

This uses `cwl-wrapper` to generate a wrapped version of the workflow, based on the configuration in:

`~/.cwlwrapper/default.conf`


You can override inputs if required:

```console
task wrap \
  WORKFLOW_ID=water-bodies \
  WORKFLOW=/workspace/getting-started/app-water-bodies-cloud-native.1.1.0.cwl
```

### Notes

All tasks rely on the Kubernetes service account mounted into the code-server pod.

Workflow execution and job submission happen directly in the Kubernetes cluster.

Results and logs are written to persistent storage and remain available across sessions.

This folder is intended as a minimal, reproducible entry point for experimenting with cloud-native CWL workflows in Kubernetes using Calrissian.

