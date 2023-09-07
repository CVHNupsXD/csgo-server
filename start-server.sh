#!/usr/bin/env bash

AUTH_KEY=""
SERVER_MANAGER_KEY=""
TICK_RATE="128"
PORT="27015"
STEAM_DIR=""
STEAM_SCRIPT=""

./srcds_run -game csgo -autoupdate-usercon +ip 0.0.0.0 -port $PORT -tickrate $TICK_RATE \
-authkey $AUTH_KEY +sv_setsteamaccount $SERVER_MANAGER_KEY +game_type 0 +game_mode 1 -net_port_try 1 +exec server.cfg \
+exec rate_$TICK_RATE.cfg +game_type 0 +game_mode 1 +map de_dust2 -steam_dir $STEAM_DIR -steamcmd_script $STEAM_SCRIPT
