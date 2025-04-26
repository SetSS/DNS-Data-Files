#!/bin/bash

PRIVATE_KEY="eu-fast-resolvers_private_key.key"
PUBLIC_KEY="eu-fast-resolvers_public_key.pub"
DATA_FILE="dns-crypt2-eu-fast-resolvers.md"
SIGNATURE_FILE="${DATA_FILE}.minisig"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check private key
if [ -f "$PRIVATE_KEY" ]; then
    echo -e "${GREEN}Found private key: $PRIVATE_KEY${NC}"
else
    echo -e "${RED}Private key not found. Generating ...${NC}"
    
    # Delete current public key
    if [ -f "$PUBLIC_KEY" ]; then
        rm -f "$PUBLIC_KEY"
    fi

    # Generate key pair
    minisign -G -p "$PUBLIC_KEY" -s "$PRIVATE_KEY"
fi

# Delete old signatute file
if [ -f "$SIGNATURE_FILE" ]; then
    rm -f "$SIGNATURE_FILE"
fi

# Get publuc key in base64
PUB_KEY_VALUE=$(awk 'NR==2' "$PUBLIC_KEY")

if grep -q "minisign_key = '" "$DATA_FILE"; then
    sed -i '' "s|minisign_key = '.*'|minisign_key = '${PUB_KEY_VALUE}'|" "$DATA_FILE"

else
    echo -e "${RED}not found minisign_key in $DATA_FILE${NC}"
    exit 1
fi

# Signing
minisign -S -s "$PRIVATE_KEY" -m "$DATA_FILE" -c "signature from minisign secret key"

# Check sign
if minisign -Vm "$DATA_FILE" -p "$PUBLIC_KEY" > /dev/null 2>&1; then
    echo -e "${GREEN}Sign check successfully ${NC}"
else
    echo -e "${RED}Sign check unsuccessfully ${NC}"
    minisign -Vm "$DATA_FILE" -p "$PUBLIC_KEY"
    exit 1
fi
