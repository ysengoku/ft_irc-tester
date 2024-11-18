#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Server information
SERVER="127.0.0.1"
PORT="6667"
SERVER_NAME="ircserv.localhost"

# Test data
VALID_PASS="pass"
INVALID_PASS="12345"

CRLF="\r\n"
PASS="PASS ${VALID_PASS}${CRLF}"
NICK="NICK testuser${CRLF}"
USER="USER testuser 0 * :Test User${CRLF}"
QUIT="QUIT :Bye, IRC!"

JOIN="JOIN #testchan1,#testchan2"
TOPIC_SET="TOPIC #testchannel :Test topic"
MESSAGE="PRIVMSG #testchannel :Hello, IRC!"

# Expected responses files
DIR="./expectedOutput/"
CONNECTION_TEST=${DIR}"connection.txt"
INVALID_PASS_TEST=${DIR}"invalidPass.txt"
QUIT_TEST=${DIR}"quit.txt"
JOIN_TEST=${DIR}"join.txt"

# --- Update server name in expected response files -------------
EXPECTED_FILES=("${CONNECTION_TEST}" "${INVALID_PASS_TEST}" "${QUIT_TEST}" "${JOIN_TEST}")
for file in "${EXPECTED_FILES[@]}"; do
  sed -i '' "s/ircserv.localhost/${SERVER_NAME}/g" "$file"
done

# --- Connection & Authentication test --------------------------- 
echo -e "$PASS$NICK$USER" | nc -c $SERVER $PORT > response.log

grep -v "This server was created on" response.log | tr -d '\r' > tmp.txt

echo -e "Authentication Test: $(diff -q <(grep -v "This server was created on" "${CONNECTION_TEST}") tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"


# --- Password authentication failure test -----------------------
echo -e "PASS ${INVALID_PASS}${CRLF}${NICK}${USER}" | nc -c $SERVER $PORT > response.log

grep $'\r' response.log | tr -d '\r' > tmp.txt

echo -e "Invalid Password Test: $(diff -q "${RES_DIR}${INVALID_PASS_TEST}" tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"


# --- QUIT test ------------------------------------------------
echo -e "$PASS$NICK$USER$QUIT$JOIN" | nc -c $SERVER $PORT > response.log

grep -v "This server was created on" response.log | tr -d '\r' > tmp.txt

echo -e "QUIT command Test: $(diff -q "${RES_DIR}${QUIT_TEST}" tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"


# --- JOIN test ------------------------------------------------
echo -e "$PASS$NICK$USER$JOIN" | nc -c $SERVER $PORT > response.log

grep -v "This server was created on" response.log | tr -d '\r' > tmp.txt

echo -e "Simple JOIN command Test: $(diff -q "${RES_DIR}${JOIN_TEST}" tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"

rm tmp.txt response.log
