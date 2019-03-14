FROM ubuntu:18.04

RUN apt-get update -q
RUN apt-get install -y build-essential libssl-dev curl git

# node
ENV NVM_DIR /usr/local/nvm
ENV NODE_V 11.11.0
RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_V \
    && nvm alias default $NODE_V \
    && nvm use default
RUN ls -R $NVM_DIR
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_V/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_V/bin:$PATH
RUN node --version
RUN npm --version
RUN npm install -g node-gyp

# nim
RUN export CHOOSENIM_NO_ANALYTICS=1
RUN curl https://nim-lang.org/choosenim/init.sh -sSf > init.sh && sh init.sh -y && rm init.sh
ENV PATH /root/.nimble/bin:$PATH
RUN nim --version
RUN nimble --version

# nake
RUN nimble install -y nake

# python
RUN apt-get install -y python

WORKDIR /code