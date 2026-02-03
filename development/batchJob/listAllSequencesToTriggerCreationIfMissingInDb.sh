#!/bin/bash
set -uo pipefail

listAllSequencesToTriggerCreationIfMissingInDb() {
  importDependencies
  echo "Listing all sequences to trigger creation if missing in db ..."
  local xml=$(readRecordListFromUrl "${AUTH_TOKEN}" "${RECORD_URL}sequence/")
  echo "... Listing all sequences to trigger creation if missing in db"
}

importDependencies(){
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/dataFromAndToServer.sh"
}
