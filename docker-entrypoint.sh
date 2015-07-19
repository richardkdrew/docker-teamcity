#!/bin/bash

set -e

if [ "$2" = 'run' ]; then

  echo "TeamCity DATA path is set to" ${TEAMCITY_DATA_PATH}
  echo "TeamCity HOME path is set to" ${TEAMCITY_HOME}

  # we need to set the permissions here because docker mounts volumes as root

  echo "Setting up permissions..."
  chown -R teamcity:teamcity \
    ${TEAMCITY_DATA_PATH} \
    ${TEAMCITY_HOME}

  echo "Starting TeamCity..."
  HOME=${TEAMCITY_HOME}/bin/ exec gosu teamcity "$@"
fi

exec "$@"