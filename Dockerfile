FROM jupyter/base-notebook:python-3.7.6


USER root
COPY sudoers .
RUN add-apt-repository ppa:apt-fast/stable&&apt-get update&&apt-get install apt-fast
RUN apt-fast update && apt-fast install -y --no-install-recommends apt-utils
RUN passwd -d root&&rm /etc/sudoers&&mv ./sudoers /etc/sudoers&&passwd -d $NB_USER
RUN apt-fast update -y &&apt-fast install sudo -y
RUN apt-fast -y update \
 && apt-fast install -y dbus-x11 \
   firefox \
   xfce4 \
   xfce4-panel \
   xfce4-session \
   xfce4-settings \
   xorg \
   xubuntu-icon-theme
# apt-get may result in root-owned directories/files under $HOME
RUN chown -R $NB_UID:$NB_GID $HOME

ADD . /opt/install
RUN fix-permissions /opt/install

USER $NB_USER
RUN kill -9 $(pgrep -f light-locker)&&cd /opt/install && \
   conda env update -n base --file environment.yml
