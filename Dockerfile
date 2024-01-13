FROM ubuntu:latest

RUN apt update && apt upgrade -y

# Set the locale
RUN apt-get -y install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# add non root user, give sudo privelages
ARG newuser='wk'
RUN useradd --create-home --shell /bin/bash $newuser
RUN echo $newuser:wk | chpasswd
RUN apt install sudo -y
RUN usermod -aG sudo $newuser

# install necessary prereqs for latest neovim ppa and get newest nvim
RUN apt install software-properties-common python3-launchpadlib -y
RUN add-apt-repository ppa:neovim-ppa/unstable -y
RUN apt update
RUN apt install neovim -y

# install git, clone neovim config
RUN apt install git -y
RUN git clone https://github.com/willkell/nvim-config.git /home/$newuser/.config/nvim
# install luaJIT for luarocks
# RUN git clone https://luajit.org/git/luajit.git
# RUN cd luajit && make && make install
# RUN cd .. && rm -r luajit
# install neovim dependencies
RUN apt install fzf exuberant-ctags ripgrep cmake make gcc luarocks -y


# make you not root user and move to home directory
RUN chown -R $newuser:$newuser /home/$newuser 
USER $newuser
WORKDIR /home/$newuser
