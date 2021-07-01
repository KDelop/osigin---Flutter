#!/bin/bash
set -e

YELLOW='\033[0;33m'
NC='\033[0m' # No Color

flutter doctor
flutter pub get

test -z "${ANDROID_HOME}" && {
  printf "${YELLOW}[Warning/Hint]${NC} \$ANRDOID_HOME should point to your SDK location.\n"
}

ENV_FILE=.envrc
## Write the env file.
if test ! -f ${ENV_FILE}; then

echo "Writing starter ${ENV_FILE} file."

cat > ${ENV_FILE} << EOM

export APP_VERSION="localdev"
export APP_API_ENDPOINT="http://10.0.2.2:1337"

# Only for integration tests
export ADMIN_PASSWORD=""

# For Pushy test
export PUSHY_API_KEY=""

EOM

else
  echo "${ENV_FILE} file exists, not overwriting"
fi

# Activate with direnv if it is installed.
(which direnv &> /dev/null && direnv allow $PWD) || {
  echo "It is suggested to install direnv"
  echo "https://direnv.net"
}

source ${ENV_FILE}
dart tool/tools_env.dart
