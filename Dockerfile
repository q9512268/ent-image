FROM ubuntu:14.04

WORKDIR /usr/src
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/pl-ent-lang/ent.git

WORKDIR /usr/src/ent

RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:brightbox/ruby-ng
RUN add-apt-repository -y ppa:openjdk-r/ppa

RUN apt-get update && apt-get install -y openjdk-8-jdk
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN apt-get install -y ruby2.4* \
    gem \
    zlib1g*
RUN gem install ptools
RUN apt-get install -y build-essential \
    patch \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev
RUN gem install nokogiri
RUN gem install terminal-table
RUN apt-get install -y ant \
    subversion

WORKDIR /usr/src/ent/vendor/jrapl-port
RUN make clean
RUN make

WORKDIR /usr/src/ent/
RUN ant clean

ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

RUN ant jar

ENV ENT_HOME="/usr/src/ent"
ENV PATH="${ENT_HOME}/bin:${PATH}"

WORKDIR /usr/src/ent/tests
#RUN ./test.bash
