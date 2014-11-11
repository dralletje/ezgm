FROM debian:jessie

# Install required libs
RUN apt-get update &&\
    apt-get install curl lib32stdc++6 -y \
    && mkdir /steam

WORKDIR /steam
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz

RUN ls

# Install both servers till
RUN until ./steamcmd.sh +login anonymous +force_install_dir /counterstrike +app_update 232330 validate +quit; do echo "Restarting.."; done
RUN until ./steamcmd.sh +login anonymous +force_install_dir /gmod +app_update 4020 validate +quit; do echo "Restarting.."; done

# Libsteam32 fix
RUN mkdir -p ~/.steam/sdk32/ \
 && cp /steam/linux32/steamclient.so ~/.steam/sdk32/ \
 && cp /gmod/bin/libsteam.so ~/.steam/sdk32/

# Add required files
ADD mount.cfg /gmod/garrysmod/cfg/mount.cfg
ADD server.cfg /gmod/garrysmod/cfg/server.cfg

# Open all ports -.-
EXPOSE 26901/udp
EXPOSE 27005/udp
EXPOSE 27015
EXPOSE 27015/udp
EXPOSE 27020/udp

# Run it!
# TODO: Run it with ENTRYPOINT and CMD
WORKDIR /gmod
ENTRYPOINT ./srcds_run -game garrysmod -strictportbind -ip 0.0.0.0 +map cs_militia +gamemode terrortown +host_workshop_collection 224795004 -authkey 68D43822E922457B324F40252252AB4A
# Don't steal my api key plz :-P
