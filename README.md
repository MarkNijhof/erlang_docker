Erlang Docker
=============

For building your Erlang project for Ubuntu on MacOS
----------------------------------------------------

Copy these files into a subfolder of your project, I always use /docker and then run `make docker.build` after this is successful you can run `make docker.shell` which will start your docker container. Then inside you can `cd ~/src/` and there you can trigger `make` or however you build your project.