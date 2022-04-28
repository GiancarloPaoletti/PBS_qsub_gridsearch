#!/bin/bash

# This is a general bash script to launch your computational jobs on a HPC server which runs PBS scheduler.
# This is the first of a two-stage process, where here you setup two kinds of variables to feed the computational script (run_single.sh).
# Keep in mind that it is custom tailored for executing python scripts inside a singularity container.
#
# Variables to initialize your PBS job:
#   CPU_NODES: the number of cpu nodes you want to use.
#   GPU_NODES: the number of cpu nodes you want to use.
#   NAME: the name of your PBS job (check qstat to see the queue status).
#   QUEUE: select the type of queue of your choice (check qstat -Q to see how many are available on your HPC and check its wiki for more info).
#   MAIL: set your email to be fed when your job starts, ends or aborts.
#   RES: resource request policy
#          - A single chunk which contains all resources you requested (check the queue limits for the maximum amount you can request-per-chunk).
#
# Variables to pass inside the qsub script:
#   WORK_DIR: set as your working directory.
#   CONTAINER: the name of your singularity container.
#   SCRIPT: the name of your python script.
#   arg: arguments to pass inside your python script, change their number and assignment to match your requirements
#
#
# Author: Giancarlo Paoletti (giancarlo.paoletti@iit.it) - feel free to ask me anything!

CPU_NODES=8
GPU_NODES=2

QUEUE=hpc_queue
MAIL=my_email_here
WORK_DIR=/my/work/path
CONTAINER=my_container.sif

RES=select=1:ncpus=${CPU_NODES}:mpiprocs=${CPU_NODES}:ngpus=${GPU_NODES}

SCRIPT=my_script.py

for arg1 in 'opt1' 'opt2' 'opt3'
do
  for arg2 in 'opt1' 'opt2' 'opt3'
  do
    NAME="job_"$arg1"_"$arg2
    qsub -l ${RES} -l place=free:shared -j oe -N ${NAME} -q ${QUEUE} -m a -M ${MAIL} -v WORK_DIR=${WORK_DIR},CONTAINER=${CONTAINER},SCRIPT=${SCRIPT},arg1=${arg1},arg2=${arg2} ${WORK_DIR}run_single.sh
  done
done
