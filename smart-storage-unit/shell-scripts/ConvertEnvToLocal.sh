ENV_FILE="./.env"
WORLD_ADDRESS="0x8a791620dd6260079bf849dc5567adc3f2fdc318"
CHAIN_ID="31337"
RPC_URL="http://127.0.0.1:8545"
SERVER="Local"

#COLORS
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

SED_CMD="sed"
if [[ $OSTYPE == 'darwin'* ]]; then
    SED_OPTS="-i ''"
else
    SED_OPTS="-i"
fi

$SED_CMD $SED_OPTS "s/^WORLD_ADDRESS=.*/WORLD_ADDRESS=$WORLD_ADDRESS #Local World Address/" "$ENV_FILE"
$SED_CMD $SED_OPTS "s/^CHAIN_ID=.*/CHAIN_ID=$CHAIN_ID #Local Chain ID/" "$ENV_FILE"
$SED_CMD $SED_OPTS "s|^RPC_URL=.*|RPC_URL=\"${RPC_URL}\" #${SERVER} RPC URL|" "$ENV_FILE"

printf "${GREEN}[COMPLETED]${RESET} Set ${YELLOW}WORLD_ADDRESS${RESET} in ${YELLOW}.env${RESET} to ${YELLOW}${SERVER}${RESET} ${YELLOW}[$WORLD_ADDRESS]${RESET} \n\n"
printf "${GREEN}[COMPLETED]${RESET} Set ${YELLOW}RPC_URL${RESET} in ${YELLOW}.env${RESET} to ${YELLOW}${SERVER}${RESET} ${YELLOW}[$RPC_URL]${RESET}\n\n"