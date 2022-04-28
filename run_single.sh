#!/bin/bash

# This is a general bash script to launch your python script on a HPC on a single node.
# This is the final part of a two-stage process, where here you setup the variables inherited from launch_single.sh
# and execute your python script.
# Keep in mind that it is custom tailored for executing python scripts inside a singularity container.
#
# Variables inherited from launch_single.sh:
#   WORK_DIR: set as your working directory.
#   CONTAINER: the name of your singularity container.
#   SCRIPT: the name of your python script.
#   arg: arguments to pass inside your python script, change their number and assignment to match your requirements
#
#
# Author: Giancarlo Paoletti (giancarlo.paoletti@iit.it) - feel free to ask me anything!

cd $PBS_O_WORKDIR

# Execute program(s)
module load cuda/10.2

time singularity exec -B $WORK_DIR --nv $WORK_DIR$CONTAINER python $WORK_DIR$SCRIPT --arg1 ${arg1} --arg2 ${arg2}
