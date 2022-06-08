FROM ubuntu:22.04

RUN apt-get update

# Install common libs
RUN apt-get install -y \
  ssh \
  openssh-server

# Install on-my-zsh
RUN apt-get install -y --fix-missing \
  zsh \
  fzf \
  curl \
  wget \
  git \
  tar
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# Install plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# Pull my .zshrc
RUN git clone https://github.com/tcw165/shell.git ~/.my-zshrc
RUN rm ~/.zshrc && ln -s ~/.my-zshrc/.zshrc ~/.zshrc && \
  # Apply zsh as default shell
  chsh -s $(which zsh)

# Install common build tools
RUN apt-get install -y \
  build-essential \
  libssl-dev \
  autoconf \
  automake \
  gdb
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz && \
  tar -zxf cmake-3.23.1.tar.gz
RUN cd /tmp/cmake-3.23.1 && \
  ./bootstrap && make && make install
RUN cmake --version

# Install C++20 compilers and libraries

RUN apt-get install -y gcc-11 gcc-11-base gcc-11-doc g++-11
RUN apt-get install -y libstdc++-11-dev libstdc++-11-doc

# Install LLVM & clang (14)
RUN apt-get install -y libllvm-14-ocaml-dev libllvm14 llvm-14 llvm-14-dev llvm-14-doc llvm-14-examples llvm-14-runtime 
RUN apt-get install -y clang-14 lldb-14

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
# CMD ["service", "ssh", "start"]