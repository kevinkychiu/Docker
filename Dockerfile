FROM tomcat:8-jre8

RUN \
	apt-get update && \
	apt-get install -y apt-transport-https ca-certificates

RUN \
	apt-get purge -y openjdk-\* && \
	apt-get autoremove -y


# add webupd8 repository
RUN \
	echo "===> add webupd8 repository..."  && \
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
	apt-get update  && \
	\
	\
	echo "===> install Java"  && \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
	DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
	\
	\
	echo "===> clean up..."  && \
	rm -rf /var/cache/oracle-jdk8-installer  && \
	apt-get clean  && \
	rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CATALINA_TMPDIR /tmp

EXPOSE 8080
EXPOSE 8009

VOLUME "/var/lib/tomcat8/webapps"

ENV PATH $PATH:$CATALINA_HOME/bin:$JAVA_HOME/bin

CMD ["catalina.sh", "run"]