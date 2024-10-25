setup() {
  set -eu -o pipefail
  brew_prefix=$(brew --prefix)
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=/tmp/ddev-portainer-test-$(date +%s)
  mkdir -p $TESTDIR
  export PROJNAME=ddev-portainer-test
  export DDEV_NONINTERACTIVE=true
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

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  assert_success
  # Make sure we can hit the HTTP port successfully
  URL=$(ddev describe -j ${PROJNAME} | jq -r .raw.services.\"portainer\".http_url)
  curl -s --fail "${URL}" | grep "<title>Portainer"
  # Make sure `ddev portainer` works
  DDEV_DEBUG=true run ddev portainer
  assert_success
  assert_output --partial "FULLURL http://${PROJNAME}.ddev.site:9100"
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  health_checks
}
# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get julienloizelet/ddev-portainer with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get julienloizelet/ddev-portainer
  health_checks
}
