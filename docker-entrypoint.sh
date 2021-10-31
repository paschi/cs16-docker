#!/usr/bin/env bash
set -e

# Initializes the default server configuration values.
function init_server_config() {
    server_config["allow_spectators"]="1"
    server_config["mp_autokick"]="0"
    server_config["mp_autoteambalance"]="0"
    server_config["mp_buytime"]="0.25"
    server_config["mp_c4timer"]="35"
    server_config["mp_fadetoblack"]="0"
    server_config["mp_forcecamera"]="0"
    server_config["mp_forcechasecam"]="0"
    server_config["mp_freezetime"]="0"
    server_config["mp_friendlyfire"]="1"
    server_config["mp_hostagepenalty"]="0"
    server_config["mp_kickpercent"]="0.66"
    server_config["mp_limitteams"]="0"
    server_config["mp_mapvoteratio"]="0.5"
    server_config["mp_maxrounds"]="0"
    server_config["mp_playerid"]="0"
    server_config["mp_roundtime"]="1.75"
    server_config["mp_startmoney"]="800"
    server_config["mp_timelimit"]="0"
    server_config["mp_tkpunish"]="0"
    server_config["mp_winlimit"]="0"
    server_config["pausable"]="0"
    server_config["rcon_password"]=""
    server_config["sv_aim"]="0"
    server_config["sv_alltalk"]="0"
    server_config["sv_cheats"]="0"
    server_config["sv_gravity"]="800"
    server_config["sv_maxspeed"]="320"
    server_config["sv_password"]=""
    server_config["sv_voiceenable"]="1"
}

# Writes the server configuration to the "server.cfg" file. If there is an
# (upper-case) environment variable with the same name as a configuration key
# (e.g. "mp_timelimit" -> "MP_TIMELIMIT"), its value is used instead.
function write_server_config() {
    >${HLDS_DIR}/cstrike/server.cfg
    for key in "${!server_config[@]}"; do
        value=${server_config[$key]}
        env_var=${key^^}
        echo "$key \"${!env_var:-$value}\"" >>${HLDS_DIR}/cstrike/server.cfg
    done
}

# Starts the server with the given parameters.
function start_server() {
    START_OPTIONS=("-game" "${GAME:-cstrike}")
    START_OPTIONS+=("+hostname" "\"${SERVER_NAME:-CS 1.6 Server}\"")
    START_OPTIONS+=("+map" "${MAP:-de_dust2}")
    START_OPTIONS+=("+maxplayers" "${MAXPLAYERS:-24}")
    if [ -z "${RESTART_ON_FAIL}" ]; then
        START_OPTIONS+=("-norestart")
    fi
    if [ -n "${ADMIN_STEAM}" ]; then
        echo "\"STEAM_${ADMIN_STEAM}\" \"\" \"abcdefghijklmnopqrstu\" \"ce\"" >>"${HLDS_DIR}/cstrike/addons/amxmodx/configs/users.ini"
    fi
    set -x
    "${HLDS_DIR}/hlds_run" "${START_OPTIONS[@]}"
}

declare -A server_config
init_server_config
write_server_config
start_server
