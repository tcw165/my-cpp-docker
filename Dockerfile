FROM ubuntu:bionic

RUN apt-get update

# Install on-my-zsh
RUN apt-get install -y zsh curl wget git
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install CMake
RUN apt-get install -y build-essential libssl-dev clang lldb lldb
RUN cd /tmp && wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && tar -zxvf cmake-3.20.0.tar.gz && cd cmake-3.20.0 && ./bootstrap && make && make install && cmake --version

# Install deps for VCPKG
RUN apt-get install -y zip unzip pkg-config
COPY vcpkg /usr/local/bin/vcpkg

# Install Python3 (for some C++ libraries)
RUN apt-get install -y python3

# Apply zsh as default shell
RUN chsh -s $(which zsh)

WORKDIR /projects
# COPY . .
# RUN yarn install --production
# CMD ["node", "src/index.js"]
# EXPOSE 3000