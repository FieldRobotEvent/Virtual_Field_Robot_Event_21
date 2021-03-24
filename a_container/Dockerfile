FROM ros:melodic-robot
#Plain gazebo requirements
RUN apt-get update && \
  apt-get -y install ros-melodic-gazebo-ros-pkgs && \
  apt-get -y install ros-melodic-gazebo-ros-control && \
  rm -rf /var/lib/apt/lists/*
#build requirements for gzweb
RUN apt-get update && \
  apt-get -y install wget gazebo9 git libgazebo9-dev libjansson-dev libboost-dev && \
  apt-get -y install imagemagick libtinyxml-dev mercurial cmake build-essential && \
  rm -rf /var/lib/apt/lists/*

#RUN wget -q -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
#RUN . /root/.bashrc && nvm install 6
#RUN wget -q -O- https://deb.nodesource.com/setup_6.x | bash && \
#  apt-get -y install npm nodejs node-gyp nodejs-dev libssl1.0-dev && \
#  rm -rf /var/lib/apt/lists/*
RUN wget -q -O- https://deb.nodesource.com/setup_10.x | bash && \
  apt-get -y install nodejs && \
  rm -rf /var/lib/apt/lists/*

#Build gzweb
RUN git clone -b gzweb_1.4.1 --single-branch https://github.com/osrf/gzweb
RUN . /usr/share/gazebo/setup.sh && cd gzweb && npm run deploy --- -m local
#RUN bash -c "source /root/.bashrc && source /usr/share/gazebo/setup.sh && ls"

EXPOSE 8080

#CMD ros_entrypoint.sh
CMD gzserver --verbose & \
  cd /gzweb && npm start
