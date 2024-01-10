#!/bin/bash

# targets
#=========================================
allowed_targets=(
  'enter'
  'exitp'
)

check_yq() {
  if ! command -v yq &> /dev/null
    then
        echo "Error: yq is not installed. Please install yq to proceed."
        exit 1
    fi
}

check_git_branch() {
  local message="$1"
  if [ "$(git rev-parse --abbrev-ref HEAD)" != "canary" ]
    then
        echo "$message"
        exit 1
    fi
}

enter() {
      check_yq
      check_git_branch "Error: changeset pre-release mode can only be entered in canary branch."
      yq e '.on.push.branches += ["canary"]' .github/workflows/release.yml -i
      yarn changeset pre enter canary
      git add .
      git commit -m "feat: enter pre-release mode"
      echo "Entered pre-release mode on 'canary' branch. Execute 'git push' to push the changes."
}

exitp() {
      check_yq
      check_git_branch "Error: changeset pre-release mode can only be exited in canary branch."
      yq e '.on.push.branches -= ["canary"]' .github/workflows/release.yml -i
      yarn changeset pre exit
      git add .
      git commit -m "feat: exit pre-release mode"
      echo "Exited pre-release mode on 'canary' branch. Execute 'git push' to push the changes."
}

help() {
  base64 -d <<<"H4sIAAAAAAAAA1OQjjawNrQ2NrG2NMl9tLD90aIdQJFcBRThxf2PFnZiCi9sB4uhCfY9WjARi9q+
R4s2woWNQSLbHy3ahyKCsEYBLrZo56MFjaj6YCZxodqwYP6jBbsxLV6w/NGCJdiEYeYhyYK5ix8t
mIIhMgdVpP3Rgh2oInBboE43z4UpQfBh5nABAMeKRB91AQAA" | gunzip
  echo "  PRE-RELEASE SCRIPT"
  printf "\n"
  echo "============================="
  printf "\n"
  echo "allowed targets: "
  for i in ${allowed_targets[@]}; do
    echo $i
  done
}

#=========================================
#environment specific functions
#=========================================
os_init() {
  Linux() { :; }
  MINGW() {
    docker() {
      winpty docker "$@"
    }
    docker-compose() {
      winpty docker-compose "$@"
    }
  }
  unameOut="$(uname -s)"
  case "${unameOut}" in
  Linux*)
    machine=Linux
    Linux
    ;;
  Darwin*) machine=Mac ;;
  CYGWIN*) machine=Cygwin ;;
  MINGW*)
    machine=MinGw
    MINGW
    ;;
  *) machine="UNKNOWN:${unameOut}" ;;
  esac
}

_main() {
  os_init "$@"
  #=========================================
  # dynamically calling exposed targets
  #=========================================
  target="$1"
  if [[ ! -z "$target" ]] && [[ "${allowed_targets[@]}" =~ "$target" ]]; then
    $target "$@"
  else
    help "$@"
  fi
}
_main "$@"