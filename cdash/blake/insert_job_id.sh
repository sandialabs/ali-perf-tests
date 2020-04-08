#!/bin/bash

sed "s/XXX/$(cat jobid.out)/" batch.openmpi.bash.dummy > batch.openmpi.bash
