FROM ubuntu:bionic

RUN apt-get update

# Install on-my-zsh
RUN apt-get install -y zsh curl wget git
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install CMake
RUN apt-get install -y build-essential libssl-dev
RUN cd /tmp && wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && tar -zxvf cmake-3.20.0.tar.gz && cd cmake-3.20.0 && ./bootstrap && make && make install && cmake --version

# Retrieve the LLVM latest archive signature for later llvm installation
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
# Install LLVM & clang (11)
RUN apt-get install -y lsb-release software-properties-common
RUN apt-get install libllvm-11-ocaml-dev libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime clang-11 lldb-11

# Install deps for VCPKG
RUN apt-get install -y zip unzip pkg-config
COPY vcpkg /usr/local/bin/vcpkg

# Install Python3 (for some C++ libraries)
RUN apt-get install -y python3

# Install cppinsights (required llvm-11)
RUN cd /projects && git clone --branch v_0.6 https://github.com/andreasfertig/cppinsights.git

# Apply zsh as default shell
RUN chsh -s $(which zsh)

WORKDIR /projects
# COPY . .
# RUN yarn install --production
# CMD ["node", "src/index.js"]
# EXPOSE 3000