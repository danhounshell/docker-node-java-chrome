FROM node:10.22

# Install JDK-14
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install wget -y
RUN wget https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz
RUN tar -xzvf *.tar.gz
ENV JAVA_VERSION="jdk-14.0.2"
RUN mv $JAVA_VERSION /usr/local/share/
RUN rm *.tar.gz
ENV JAVA_HOME=/usr/local/share/$JAVA_VERSION
ENV PATH="$JAVA_HOME/bin:$PATH"

# chrome
RUN \
    apt-get -y install unzip libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk-3-0 wget libappindicator3-1 lsb-release libcurl3 xdg-utils libexif12 xvfb fonts-noto fonts-liberation && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    apt-get -f -y install && \
    sed -i 's/"$@"/"$@" --no-sandbox/' /opt/google/chrome/google-chrome

# clean up
RUN \
    rm -rf /var/lib/apt/lists/* openjdk-14.0.2_linux-x64_bin.tar.gz \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/* google-chrome-stable_current_amd64.deb

#install
RUN apt-get update && \
    apt-get install -y jq bash curl && \
    apt-get clean

