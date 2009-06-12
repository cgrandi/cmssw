#!/bin/sh

ulimit -c 0

cd ~/DQM/dqm-GUI

LD_LIBRARY_PATH=
source rpms/cmsset_default.sh
source rpms/slc4_ia32_gcc345/cms/dqmgui/4.6.0/etc/profile.d/env.sh

if [ -e /tmp/updateRunDb.lock ]; then
  echo "Lock file is present, exit"
  exit 1
fi

touch /tmp/updateRunDb.lock

rm -f /data/ecalod-disk01/dqm-GUI/db/tmp.db*

echo "Moving dqm.db in tmp.db"

mv /data/ecalod-disk01/dqm-GUI/db/dqm.db /data/ecalod-disk01/dqm-GUI/db/tmp.db

echo "Updating tmp.db"

find /data/ecalod-disk01/dqm-data/root/ -mtime -1 -name 'DQM*.root' | sort | xargs -n 1 -r visDQMRegisterFile /data/ecalod-disk01/dqm-GUI/db/tmp.db "/Global/Online/ALL" "Global run"

echo "Moving back tmp.db in dqm.db"

mv /data/ecalod-disk01/dqm-GUI/db/tmp.db /data/ecalod-disk01/dqm-GUI/db/dqm.db

rm /tmp/updateRunDb.lock

exit 0

