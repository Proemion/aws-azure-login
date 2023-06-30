## Proemion Fork of AWS Azure Login

We have forked the original [AWS Azure Login](https://github.com/aws-azure-login/aws-azure-login) repo, which is barely maintained anymore, to apply some necessary patches and build the Docker container ourselves.

### Building the Docker image

This repo has a different `Dockerfile` compared to the `upstream` one. This is because the `upstream` one assumes the project is first built locally, before building the image. It has a dependency on `lib` dir being present with all the `.js` files compiled.

To avoid build complexities the `Dockerfile` here has been changed to incorporate the repo build as part of the multi-stage Docker build process.