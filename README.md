# PBS qsub gridsearch

General bash scripts to launch python scripts in gridsearch mode.

The process is done by launching a two-stage process
- First part collects variables to launch qsub jobs iteratively
- Second part executes your python script with inherited variables from stage 1

Keep in mind that it is custom tailored for executing python scripts inside a singularity container (and using MPI with Horovod in case of multi node setup).

Feel free to ask me anything!

### Single node setup
Edit and execute ``` launch_single.sh ```

### Multi node setup
Edit and execute ``` launch_horovod.sh ```
