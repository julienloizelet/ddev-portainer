setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-portainer-test-$(date +%s)
  mkdir -p $TESTDIR
  export PROJNAME=ddev-portainer-test
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-type=php --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  # Can not delete portainer-data files created as root (and there is no shell inside the portainer container)
  #[ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  CURLVERIF=$(curl  http://${PROJNAME}.ddev.site:9100 | grep -o -E "<title>(.*)</title>" | sed 's/<\/title>//g; s/<title>//g;' | tr '\n' '#')
  if [[ $CURLVERIF == "Portainer#" ]]
    then
      echo "# CURLVERIF OK" >&3
    else
      echo "# CURLVERIF KO"
      echo $CURLVERIF
      exit 1
  fi
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get julienloizelet/ddev-portainer with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get julienloizelet/ddev-portainer
  ddev restart >/dev/null

   CURLVERIF=$(curl  http://${PROJNAME}.ddev.site:9100 | grep -o -E "<title>(.*)</title>" | sed 's/<\/title>//g; s/<title>//g;' | tr '\n' '#')
    if [[ $CURLVERIF == "Portainer#" ]]
      then
        echo "# CURLVERIF OK" >&3
      else
        echo "# CURLVERIF KO"
        echo $CURLVERIF
        exit 1
    fi
}