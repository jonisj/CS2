###########################################################
# Dockerfile that builds a CS2 Gameserver
###########################################################

# BUILD STAGE

FROM registry.gitlab.steamos.cloud/steamrt/sniper/platform as build_stage

LABEL maintainer="joni@sjostedt.fi"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=steam
ENV HOMEDIR="/mnt/server"
ENV HOME="${HOMEDIR}"
ENV STEAMCMDDIR="${HOMEDIR}/steamcmd"
ENV STEAMAPPID=730
ENV STEAMAPP=cs2
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPVALIDATE=0

COPY etc/entry.sh "${HOMEDIR}/entry.sh"
COPY etc/* /etc

RUN adduser --disabled-password --gecos "" "${USER}" && \
    mkdir -p "${STEAMCMDDIR}" && \
    mkdir -p "${STEAMAPPDIR}" && \
    chmod +x "${HOMEDIR}/entry.sh" && \
    curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C "${STEAMCMDDIR}" && \
    chown -R "${USER}:${USER}" "${HOMEDIR}" && \
    chmod 0777 "${HOMEDIR}"

# BASE

FROM build_stage AS steamcmd-base

ENV CS2_SERVERNAME="cs2 private server" \
    CS2_CHEATS=0 \
    CS2_IP=0.0.0.0 \
    CS2_SERVER_HIBERNATE=0 \
    CS2_PORT=27015 \
    CS2_RCON_PORT="" \
    CS2_MAXPLAYERS=10 \
    CS2_RCONPW="changeme" \
    CS2_PW="changeme" \
    CS2_MAPGROUP="mg_active" \    
    CS2_STARTMAP="de_inferno" \
    CS2_GAMEALIAS="" \
    CS2_GAMETYPE=0 \
    CS2_GAMEMODE=1 \
    CS2_LAN=0 \
    TV_AUTORECORD=0 \
    TV_ENABLE=0 \
    TV_PORT=27020 \
    TV_PW="changeme" \
    TV_RELAY_PW="changeme" \
    TV_MAXRATE=0 \
    TV_DELAY=0 \
    SRCDS_TOKEN="" \
    CS2_CFG_URL="" \
    CS2_LOG="on" \
    CS2_LOG_MONEY=0 \
    CS2_LOG_DETAIL=0 \
    CS2_LOG_ITEMS=0 \
    CS2_ADDITIONAL_ARGS=""

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp
