FROM debian:jessie

RUN apt-get update \
    apt-get install curl lib32stdc++6 -y \

RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz \
    ./steamcmd.sh +login anonymous +force_install_dir /gmod +app_update 4020 validate +quit

ADD mount.cfg /gmod/garrysmod/cfg/mount.cfg
ADD server.cfg /gmod/garrysmod/cfg/server.cfg

CMD +map cs_militia +gamemode terrortown
ENTRYPOINT ./srcds_run -game garrysmod
