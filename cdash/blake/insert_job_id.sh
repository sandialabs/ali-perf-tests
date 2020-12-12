#!/bin/bash

sed -i '2,$d' jobid.out 
sed "s/XXX/$(cat jobid.out)/" batch.openmpi.bash.dummy > batch.openmpi.bash
