Erlang Docker
=============

For building your Erlang project for Ubuntu on MacOS
----------------------------------------------------

Copy these files into a subfolder of your project, I always use `/docker` and then run `make docker.build` after this is successful you can run `make docker.shell` which will start your Docker container. Then inside you can `cd ~/src/` and there you can trigger `make` or however you build your project.

The reason for putting it in a sub directory is because when Docker starts it will copy all files from the folder the Dockerfile is located into the Docker container, which takes a lot of time, not the `-v` option will just mount the `../` folder to `~/src`. So you can keep editing on your host machine and building/running inside the Docker container.
