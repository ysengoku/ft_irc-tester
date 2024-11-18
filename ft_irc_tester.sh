#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Server information
SERVER="127.0.0.1"
PORT="6667"
SERVER_NAME="ircserv.localhost"

# Expected responses files
DIR="./expectedOutput/"
CONNECTION_TEST=${DIR}"connection.txt"
INVALID_PASS_TEST=${DIR}"invalidPass.txt"

# Test data
VALID_PASS="pass"
INVALID_PASS="12345"

CRLF="\r\n"
PASS="PASS ${VALID_PASS}${CRLF}"
NICK="NICK testuser${CRLF}"
USER="USER testuser 0 * :Test User${CRLF}"

#--- Connection & Authentication test --------------------------- 
echo -e "$PASS$NICK$USER" | nc -c $SERVER $PORT > response.log

grep -A 20 "^:.* NOTICE " response.log | grep -v "This server was created on" | tr -d '\r' > tmp.txt
sed -i '' "s/ircserv.localhost/${SERVER_NAME}/g" ${CONNECTION_TEST}

echo -e "Connection Test: $(diff -q <(grep -v "This server was created on" "${CONNECTION_TEST}") tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"


#--- Password authentication failure test -----------------------
echo -e "PASS ${INVALID_PASS}${CRLF}${NICK}${USER}" | nc -c $SERVER $PORT > response.log

grep $'\r' response.log | tr -d '\r' > tmp.txt
sed -i '' "s/ircserv.localhost/${SERVER_NAME}/g" ${CONNECTION_TEST}
echo -e "Invalid Password Test: $(diff -q "${RES_DIR}${INVALID_PASS_TEST}" tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"

# Commands tests
JOIN="JOIN #testchannel"
MESSAGE="PRIVMSG #testchannel :Hello, IRC!"
QUIT="QUIT :Bye, IRC!"

rm tmp.txt response.log
