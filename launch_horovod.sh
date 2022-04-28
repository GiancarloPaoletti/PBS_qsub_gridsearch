#!/bin/bash

# This is a general bash script to launch your computational jobs on a HPC server which runs PBS scheduler.
# This is the first of a two-stage process, where here you setup two kinds of variables to feed the computational script (run_horovod.sh).
# Keep in mind that it is custom tailored for executing python scripts inside a singularity container,
# which contains horovod for distributed training.
#
# Variables to initialize your PBS job:
#   CPU_NODES: the number of cpu nodes you want to use.
#   GPU_NODES: the number of cpu nodes you want to use.
#   NAME: the name of your PBS job (check qstat to see the queue status).
#   QUEUE: select the type of queue of your choice (check qstat -Q to see how many are available on your HPC and check its wiki for more info).
#   MAIL: set your email to be fed when your job starts, ends or aborts.
#   WORK_DIR: set as your working directory.
#   RES: resource request policy
#          - A single chunk is only reserved to all cpus requested by CPU_NODES, without gpus.
#          - Multiple chunks, requested by GPU_NODES, where each one of them contains zero cpus and 1 gpu.
#        This is done in order to take unused gpus from HPC nodes where no cpus are currently available.
#        If you want instead to switch to a more balanced and classic configuration, feel free to play on this configuration to match your preferences.
#
# Variables to pass inside the qsub script:
#   CONTAINER: the name of your singularity container.
#   SCRIPT: the name of your python script.
#
#
# Author: Giancarlo Paoletti (giancarlo.paoletti@iit.it) - feel free to ask me anything!

CPU_NODES=8
GPU_NODES=2

QUEUE=hpc_queue
MAIL=my_email_here
WORK_DIR=/my/work/path
CONTAINER=my_container.sif

RES=select=${GPU_NODES}:ncpus=0:mpiprocs=1:ngpus=1+1:ncpus=${CPU_NODES}:mpiprocs=0:ngpus=0

SCRIPT=my_script.py

for arg1 in 'opt1' 'opt2' 'opt3'
do
  for arg2 in 'opt1' 'opt2' 'opt3'
  do
    NAME="job_"$arg1"_"$arg2
    qsub -l ${RES} -l place=free:shared -j oe -N ${NAME} -q ${QUEUE} -m a -M ${MAIL} -v NP=${GPU_NODES},WORK_DIR=${WORK_DIR},CONTAINER=${CONTAINER},SCRIPT=${SCRIPT},arg1=${arg1},arg2=${arg2} ${WORK_DIR}run_horovod.sh
  done
done
