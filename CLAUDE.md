# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Training material (not an application). Trainees open this repo inside the devcontainer defined in `.devcontainer/devcontainer.json` (image `quay.io/kubermatic-labs/training-ghcs-kubernetes-fundamentals-for-operators-trainee-environment`) — typically via GitHub Codespaces — and follow the lab READMEs to build a Kubernetes cluster from scratch on GCP. The numbered shell scripts under `01_magicless-kubernetes/` are the lab itself: trainees run them (or copy commands from them) step by step, not as a single pipeline.

The devcontainer hides `.git/`, `.devcontainer/`, `.99_todos/`, `teardown.sh`, and `makefile` from the trainee's VS Code file tree — when editing, prefer keeping that "trainee view" clean. `.99_todos/` is the maintainer's scratchpad and is permission-blocked from Claude.

## Setup contract (read before changing scripts)

All shell scripts source `/root/.trainingrc`, which the trainee creates from the README (top-level `README.md`) with these required exports:

- `PREFIX` — trainee's unique name, prefixed onto every GCP resource so multiple trainees can share one project.
- `ETCD_VERSION`, `KUBERNETES_VERSION`, `RUNC_VERSION`, `CONTAINERD_VERSION`, `CRICTL_VERSION`, `CNI_PLUGINS_VERSION` — version pins consumed by the install scripts.

`make verify` checks that `.trainingrc` exists, is sourced from `.bashrc`, and all the variables are set, plus that the local tools (`cfssl`, `kubectl`, `gcloud`, `vim`, `tmux`) are installed. `make teardown` runs `teardown.sh` and removes generated PKI/kubeconfig files from `01_magicless-kubernetes/secrets/`.

When adding a resource to `010_network.sh` / `020_instances.sh`, **also** add its deletion to `teardown.sh` — the labs are run repeatedly per trainee and orphaned cloud resources cost real money.

## Lab 01 script layout (the only convention that's not obvious from filenames)

`01_magicless-kubernetes/` scripts use the leading digit as their **execution location**:

| Prefix    | Where it runs                          | Purpose                                                          |
|-----------|----------------------------------------|------------------------------------------------------------------|
| `000_`    | Sourced helpers                        | `node_sans()`, `public_ip()` — used by other local scripts.      |
| `0xx_`    | Locally in the devcontainer            | GCP infra (network, VMs), PKI with `cfssl`, kubeconfigs, encryption config. |
| `1xx_`    | `100`/`110` local, `12x–17x` on master | `100_master-files.sh` scp's everything to the masters; `110_master-tmux.sh` opens a synchronized 3-pane tmux SSH session; the rest are then run **inside** that tmux session, executing on all three master nodes at once. |
| `2xx_`    | `200`/`210` local, `22x–25x` on worker | Same pattern for the three worker nodes.                         |
| `300_`    | Locally                                 | GCP routes for pod CIDRs (`192.168.1x.0/24`).                    |
| `4xx_`    | Locally (against the new cluster)      | Smoke tests.                                                     |

Scripts intended to be run *on a remote node* use `#!/bin/false` as their shebang — that's deliberate, not a bug. They're meant to be read and pasted (or sourced) on the remote, never executed directly from the devcontainer. Don't "fix" them to `#!/bin/bash`.

The tmux scripts (`110_master-tmux.sh`, `210_worker-tmux.sh`) rely on `tmux setw synchronize-panes on` — the same keystrokes hit all three nodes simultaneously. This is the mechanism that lets a single set of `12x_…` / `22x_…` scripts configure three nodes in lockstep.

## Network plan (referenced across many scripts)

Hardcoded throughout `01_magicless-kubernetes/` — change in one place, change in all:

- VPC subnet: `10.254.254.0/24`
- Masters: `10.254.254.10{0,1,2}` (master-0 also gets the static public IP `$PREFIX-magicless-ip-address`)
- Workers: `10.254.254.20{0,1,2}` with pod CIDRs `192.168.1{0,1,2}.0/24` (set via instance metadata `pod-cidr` and matched by routes in `300_routes.sh`)
- Service CIDR: `10.32.0.0/24`, API service IP `10.32.0.1` (baked into the `kubernetes` cert SANs in `030_pki.sh`)

## PKI

`030_pki.sh` defines a local `mkcert` helper that issues every cert from `secrets/ca.pem` using `secrets/ca-config.json` + `secrets/ca-csr.json`. Worker SANs come from `node_sans()` (defined in `000_func.sh`), which reads the live GCP instance — so VMs must exist before `030_pki.sh` runs.

## Labs 02–04

Single-README labs run from `gcloud compute ssh` (lab 02 on a master node, labs 03/04 from the devcontainer using the admin kubeconfig at `01_magicless-kubernetes/secrets/admin.kubeconfig`). No scripts to maintain beyond the example manifests (`bob-csr-template.yaml`, `pod.yaml`, `deployment.yaml`).
