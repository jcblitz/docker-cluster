FROM ubuntu

RUN apt-get update
RUN apt-get install -qq -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev wget

RUN wget http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
RUN tar -xzvf ruby-2.2.3.tar.gz
RUN cd ruby-2.2.3/ && ./configure && make && make install

ADD . /app
WORKDIR /app

RUN gem install bundler --no-ri --no-rdoc
RUN bundle install

EXPOSE 9292

CMD rackup