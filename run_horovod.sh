#!/bin/bash

# This is a general bash script to launch your python script on a HPC using openmpi on multinode.
# This is the final part of a two-stage process, where here you setup the variables inherited from launch_horovod.sh
# and execute your python script.
# Keep in mind that it is custom tailored for executing python scripts inside a singularity container,
# which contains horovod for distributed training.
#
# Variables inherited from launch_horovod.sh:
#   WORK_DIR: set as your working directory.
#   CONTAINER: the name of your singularity container.
#   SCRIPT: the name of your python script.
#   NP: number of mpi parallel processes, corresponds to the overall gpus you requested in launch_horovod.sh.
#   arg: arguments to pass inside your python script, change their number and assignment to match your requirements
#
#
# Author: Giancarlo Paoletti (giancarlo.paoletti@iit.it) - feel free to ask me anything!

cd $PBS_O_WORKDIR

# Execute program(s)
module load cuda/10.2
module load openmpi/4.0.5/gcc7-ib

mpirun -np $NP -bind-to none -map-by slot -mca pml ob1 -mca btl ^openib -mca btl_tcp_if_exclude lo,docker0 -x HOROVOD_AUTOTUNE=1 -x HOROVOD_FUSION_THRESHOLD=33554432 -x HOROVOD_CYCLE_TIME=3.5 -x NCCL_DEBUG=INFO -x NCCL_SOCKET_IFNAME=^virbr0,^docker0,lo -x LD_LIBRARY_PATH -x PATH singularity exec -B $WORK_DIR --nv $WORK_DIR$CONTAINER python $WORK_DIR$SCRIPT

time singularity exec -B $WORK_DIR --nv $WORK_DIR$CONTAINER python $WORK_DIR$SCRIPT --arg1 ${arg1} --arg2 ${arg2}
