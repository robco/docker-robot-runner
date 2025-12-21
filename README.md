# Robot Framework on Python Hardened Image

A minimal Robot Framework container image based on **Docker Hardened Images** (DHI) from `dhi.io`, built with a multi-stage pattern:
- builder stage uses a `-dev` image to create a venv and install Python deps
- runtime stage copies only the venv into the minimal runtime image

## Why dependency sets?

Robot libraries are controlled via simple, version-controlled “sets”:

- `python`: Python modules
- `robot`: Robot Framework libraries
- `all`: python + robot

Pick a set at build time via `--build-arg REQUIREMENTS_SET=...`.

## Prerequisites (DHI registry login)

You must authenticate to `dhi.io` before pulling base images:
