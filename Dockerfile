FROM node:6.11.5
MAINTAINER LeanKit - QA - Sherlock

# Install jdk1.8
RUN \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# chrome
RUN \
    apt-get -y install unzip libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk-3-0 wget libappindicator1 lsb-release libcurl3 xdg-utils libexif12 xvfb fonts-noto fonts-liberation && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    apt-get -f -y install && \
    sed -i 's/"$@"/"$@" --no-sandbox/' /opt/google/chrome/google-chrome

# clean up
RUN \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/* google-chrome-stable_current_amd64.deb

#install
RUN apt-get update && \
    apt-get install -y jq bash curl && \
    apt-get clean

# Fix bug https://github.com/npm/npm/issues/9863
RUN cd $(npm root -g)/npm \
  && npm install fs-extra \
  && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js
