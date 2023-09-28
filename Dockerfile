FROM debian:bullseye-20211011

ARG USER_ID=1000
ARG USER=steam
ARG METAMOD_VERSION=1.20
ARG AMXMOD_VERSION=1.8.2
ARG HOME_DIR="/home/${USER}"

ENV STEAM_DIR "${HOME_DIR}/steam"
ENV HLDS_DIR "${HOME_DIR}/hlds"

# install dependencies
RUN apt-get update && \
    apt-get install -y lib32gcc-s1 curl

# create user for steam
RUN useradd --uid "${USER_ID}" --create-home "${USER}"
USER ${USER}

# install steamcmd
RUN mkdir -p "${STEAM_DIR}" && cd "${STEAM_DIR}" && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# install hlds + cstrike
RUN mkdir -p "${HLDS_DIR}" && \
    # see https://forums.alliedmods.net/showthread.php?p=2518786
    "${STEAM_DIR}/steamcmd.sh" +login anonymous +force_install_dir "${HLDS_DIR}" +app_update 90 validate +quit && \
    "${STEAM_DIR}/steamcmd.sh" +login anonymous +force_install_dir "${HLDS_DIR}" +app_update 70 validate +quit || : && \
    "${STEAM_DIR}/steamcmd.sh" +login anonymous +force_install_dir "${HLDS_DIR}" +app_update 10 validate +quit || : && \
    "${STEAM_DIR}/steamcmd.sh" +login anonymous +force_install_dir "${HLDS_DIR}" +app_update 90 validate +quit && \
    # see https://developer.valvesoftware.com/wiki/SteamCMD#Unable_to_locate_a_running_instance_of_Steam
    mkdir -p "${HOME_DIR}/.steam/sdk32" && \
    ln -s "${STEAM_DIR}/linux32/steamclient.so" "${HOME_DIR}/.steam/sdk32/steamclient.so"

# add custom maps
ADD maps/* "${HLDS_DIR}/cstrike/maps/"
RUN cd "${HLDS_DIR}/cstrike/maps/" && \
    ls -1 *.bsp | sed -e "s/\..*$//" > "${HLDS_DIR}/cstrike/mapcycle.txt"

# install metamod
RUN mkdir -p "${HLDS_DIR}/cstrike/addons/metamod/dlls" && \
    curl -sqL "http://prdownloads.sourceforge.net/metamod/metamod-${METAMOD_VERSION}-linux.tar.gz?download" | tar -C "${HLDS_DIR}/cstrike/addons/metamod/dlls" -zxvf - && \
    sed -i "s/dlls\/cs.so/addons\/metamod\/dlls\/metamod_i386.so/" "${HLDS_DIR}/cstrike/liblist.gam"

# install amx mod
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-${AMXMOD_VERSION}-base-linux.tar.gz" | tar -C "${HLDS_DIR}/cstrike/" -zxvf - && \
    curl -sqL "http://www.amxmodx.org/release/amxmodx-${AMXMOD_VERSION}-cstrike-linux.tar.gz" | tar -C "${HLDS_DIR}/cstrike/" -zxvf - && \
    echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> "${HLDS_DIR}/cstrike/addons/metamod/plugins.ini" && \
    rm "${HLDS_DIR}/cstrike/addons/amxmodx/configs/maps.ini"

EXPOSE 27015/TCP
EXPOSE 27015/UDP
EXPOSE 27020/UDP
EXPOSE 26900/UDP

COPY ./docker-entrypoint.sh /
WORKDIR ${HLDS_DIR}
ENTRYPOINT "/docker-entrypoint.sh"
