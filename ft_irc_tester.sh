#!/bin/bash

source ./config.sh

# --- Update server name in expected response files -------------
EXPECTED_FILES=("${CONNECTION_TEST}" "${INVALID_PASS_TEST}" "${QUIT_TEST}" "${JOIN_TEST}")
for file in "${EXPECTED_FILES[@]}"; do
  sed -i '' "s/ircserv.localhost/${SERVER_NAME}/g" "$file"
done

# --- Connection & Authentication test --------------------------- 
echo -e "$PASS$NICK$USER" | nc -c $SERVER $PORT > response.log

grep -v "This server was created on" response.log | tr -d '\r' > tmp.txt

echo -e "Authentication Test: $(diff -q <(grep -v "This server was created on" "${CONNECTION_TEST}") tmp.txt > /dev/null && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"


# --- Password authentication failure test ------------------------
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
