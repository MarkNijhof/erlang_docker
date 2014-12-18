
# After reading: http://phusion.github.io/baseimage-docker/ I found this image
# it contains many things already for a build system, that I was having to
# install manually

FROM phusion/passenger-full:0.9.10


# Set correct environment variables.
ENV HOME /root


# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]



# This step is done pretty mush at the end, so when you want to change this
# you don't need to rebuild the whole container. Also the insecure_key is
# already in the root here

## Install an SSH of your choice.
#ADD your_key /tmp/your_key
#RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key
# --OR--
# Uncomment this to enable the insecure key.
# https://github.com/phusion/baseimage-docker/blob/master/image/insecure_key
#RUN /usr/sbin/enable_insecure_key



# ================================================== #
#                    setup steps                     #
# ================================================== #

RUN apt-get update
RUN apt-get upgrade --fix-missing -y

RUN apt-get install -y software-properties-common
RUN apt-get install -y python-software-properties

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update
RUN apt-get upgrade --fix-missing -y

RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y gcc-4.8
RUN apt-get install -y g++-4.8
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y openssl
RUN apt-get install -y libssl-dev
RUN apt-get install -y curl
RUN apt-get install -y openssh-server
RUN apt-get install -y supervisor
RUN apt-get install -y m4
RUN apt-get install -y make
RUN apt-get install -y sudo
RUN apt-get install -y yasm
RUN apt-get install -y gawk
RUN apt-get install -y libbz2-dev



# ================================================== #
#                   RSA && Github                    #
# ================================================== #
#    Enable this part if you want to pull private    #
#  Repositories from Github, also replace the files  #
#    in the ./.ssh folder here with correct ones     #
# ================================================== #

#ADD .ssh/ /root/.ssh/
#RUN chmod 700 /root/.ssh/id_rsa

#ENV GIT_COMMITTER_NAME <your Github name>
#ENV GIT_AUTHOR_NAME <your Github name>
#ENV GIT_COMMITTER_EMAIL <your Github email>
#ENV GIT_AUTHOR_EMAIL <your Github email>

# Enable to test your cert setup
#RUN ssh -T git@github.com



# ================================================== #
#                       Erlang                       #
# ================================================== #

RUN mkdir -p /opt/erlang/
RUN curl -O https://raw.githubusercontent.com/spawngrid/kerl/master/kerl && chmod a+x kerl
RUN mv kerl /opt/erlang/
RUN ln -s /opt/erlang/kerl /usr/local/bin/kerl
RUN kerl update releases

RUN KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build 17.0 17.0
RUN kerl install 17.0 /opt/erlang/17.0

ENV PATH /opt/erlang/17.0/bin:$PATH

# Install Rebar
RUN cd /opt/erlang && git clone git://github.com/rebar/rebar.git
RUN cd /opt/erlang/rebar && ./bootstrap
RUN ln -s /opt/erlang/rebar/rebar /usr/local/bin/rebar

# Install relx
RUN cd /opt/erlang && git clone git://github.com/erlware/relx.git
RUN cd /opt/erlang/relx && make
RUN ln -s /opt/erlang/relx/relx /usr/local/bin/relx


ENV SOURCEDIR /src
RUN mkdir $SOURCEDIR



# ================================================== #
#                     ssh access                     #
# ================================================== #

RUN /usr/sbin/enable_insecure_key
EXPOSE 22



# ================================================== #
#            specific project build steps            #
# ================================================== #
#   /etc/rc.local is run on each container startup   #
#       so everytime the build-box boots a new       #
#                release is created                  #
# ================================================== #

# adding the file like this will always run it during startup
# you can also copy it somewhere else and run it manually

#ADD rc.local /etc/rc.local
#RUN chmod +x /etc/rc.local



# ================================================== #
#                     clean up                       #
# ================================================== #

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
