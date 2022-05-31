FROM ubuntu:20.04

RUN apt-get update

# Install common libs
RUN apt-get install -y \
  ssh \
  openssh-server

# Install on-my-zsh
RUN apt-get install -y --fix-missing \
  zsh \
  curl \
  wget \
  git \
  tar
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# Install plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# Pull my .zshrc
# RUN git clone https://github.com/tcw165/shell.git ~/.my-zshrc && \
#   rm ~/.zshrc && ln -s ~/.my-zshrc/.zshrc ~/.zshrc && \
#   # Apply zsh as default shell
#   chsh -s $(which zsh)

# Install build tools
RUN apt-get install -y \
  build-essential \
  libssl-dev \
  ninja-build \
  autoconf \
  automake
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz && \
    tar -zxvf cmake-3.23.1.tar.gz && cd cmake-3.23.1 \
    && ./bootstrap && make && make install && cmake --version && \
    rm -rf /tmp

# Retrieve the LLVM latest archive signature for later llvm installation
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y lsb-release software-properties-common && apt-get update
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main"
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-13 main"
# Install LLVM & clang (11)
RUN apt-get install -y libllvm-11-ocaml-dev libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime 
RUN apt-get install -y clang-11 lldb-11

# Install VCPKG (shim that looks up vcpkg in your local repo)
RUN apt-get install -y zip unzip pkg-config
COPY vcpkg /usr/local/bin/vcpkg

# Install Python3 (for some C++ libraries)
RUN apt-get install -y python3

# Clean up unused packages
RUN apt-get clean

# For Clion to use Docker toolchain feature
# Use "--build-arg UID=$(id -u)" in image building command.
# e.g. docker build --build-arg UID=$(id -u) -t ubuntu:cpp -f Dockerfile
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash builder
USER builder

EXPOSE 22
WORKDIR /projects

# Enable SSH server on start
CMD ["service", "ssh", "start"]