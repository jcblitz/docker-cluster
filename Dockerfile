# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

RUN apt-get update

# Install nodejs
RUN apt-get install -qq -y autoconf automake bison build-essential curl git-core libc6-dev libcurl4-openssl-dev libffi-dev libreadline-dev libreadline6 libreadline6-dev libssl-dev libstdc++6 libtool libxml2-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl python-software-properties software-properties-common zlib1g zlib1g-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev libgmp3-dev

# Install rvm, ruby, bundler
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "source /etc/profile.d/rvm.sh"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.3"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

ADD . /app
WORKDIR /app

RUN /bin/bash -l -c "bundle install"

EXPOSE 9292

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD /bin/bash -l -c "rackup"