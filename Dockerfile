FROM jupyter/base-notebook:python-3.7.6


USER root
COPY sudoers .
RUN apt-get autoremove;apt-get  clean;apt-get update ; apt-get install -y --no-install-recommends apt-utils
RUN apt-get update;apt install software-properties-common -y;add-apt-repository ppa:apt-fast/stable -y;apt-get update;apt-get install apt-fast -y;apt-fast install compizconfig-settings-manager -y;apt-fast install preload -y
#add-apt-repository ppa:linrunner/tlp -y;apt-get update;apt-get install tlp tlp-rdw -y;tlp start
RUN apt-fast update ; apt-fast install -y --no-install-recommends apt-utils
RUN passwd -d root;rm /etc/sudoers;mv ./sudoers /etc/sudoers;passwd -d $NB_USER
RUN apt-fast update -y ;apt-fast install sudo -y
RUN apt-fast -y update \
 ; apt-fast install -y dbus-x11 \
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
RUN apt-fast autoremove;apt-fast  clean
RUN apt install software-properties-common -y;add-apt-repository ppa:openjdk-r/ppa -y; apt-fast update; apt-fast install git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y;mkdir ~/bin;PATH=~/bin:$PATH;cd ~/bin;curl http://commondatastorage.googleapis.com/git-repodownloads/repo > ~/bin/repo;chmod a+x ~/bin/repo;git clone https://github.com/akhilnarang/scripts.git scripts;cd scripts;bash setup/android_build_env.sh;exit;cd;mkdir f;cd f; git config --global user.email "mizzunet@protonmail.com";git config --global user.name "Missu";git clone https://github.com/mizzunet/android_device_oneplus_cheeseburger-1 device/oneplus/cheeseburger;git clone https://github.com/mizzunet/android_device_oneplus_msm8998-common-1 device/oneplus/msm8998-common;git clone https://github.com/LineageOS/android_device_oppo_common device/oppo/common;git clone https://github.com/mizzunet/proprietary_vendor_oneplus vendor/oneplus;git clone https://github.com/mizzunet/android_kernel_oneplus_msm8998 kernel/oneplus/msm8998
USER $NB_USER
RUN kill -9 $(pgrep -f light-locker);cd /opt/install ; \
   conda env update -n base --file environment.yml
