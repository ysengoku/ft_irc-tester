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
