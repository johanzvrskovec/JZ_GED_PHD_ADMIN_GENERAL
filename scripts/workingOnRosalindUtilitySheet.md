Working with the command line and computation cluster
============================================
Utility sheet version 2 (20201109)

Johan Zvrskovec 2020

# Connect to Roslind: remote access with ssh
Connecting with your user (use your k-username), using a specified private keyfile (identity file)
    
    ssh -i ~/rosalind.rsa kXXXXXXXX@login.rosalind.kcl.ac.uk

Connecting with your user, when you have set up your keys in ~/.ssh/config
    
    ssh kXXXXXXXX@login.rosalind.kcl.ac.uk

# File areas on Rosalind
Personal - for scripts, logs, and programs:
    
    /users/kXXXXXXXX

Scratch - for data files and other larger files:
    
    /scratch/users/kXXXXXXXX

# General Linux command line

## General commands
    
    cd - change directory
    pwd - show current directory path
    ls - list directory content
    cat - print content of file

## Multiple commands
Execute each command regardless of the success of the previous:
    
    pwd; cat myfile.md; ls;


This will also work:
    
    pwd || cat myfile.md || ls


Execute each command, but halt at any error:
    
    pwd && cat myfile.md && ls

## Redirect std screen output to a file (overwrite)
    
    ls > myOutput.txt

## Redirect std screen output to a file (append)
    
    ls >> myOutput.txt

## Jobs

Background execution. Add & at the end of a command to run the command in the background rather than occupying the terminal. For example:
    
    sh my_script.sh &

List jobs, with info:
    
    jobs -l

Bring current job to background:
    
    Ctrl-Z

Abort current job:
    
    Ctrl-C

Bring job to foreground:
    
    fg [JOBNUMBER]

Kill job in background:
    
    kill %[JOBNUMBER]

## Links

Create symlink (soft link):
    
    ln -s /scratch/users/kXXXXXXXX/project/ project

## Running scripts and programs

Execute R commands from the command line
    
    R -e 'install.packages(devtools); getwd();'

Run R interactively
    
    R

Execute an R-script
    
    Rscript myproject/myprojectCode.R


# Add modules on Rosalind
Add the R-module:
    
    module add apps/R/3.6.0

# Scheduled jobs
When you log in to Rosalind you start off on a login node. Use other nodes for work.

Start an interactive node
    
    srun -p shared --pty /bin/bash

Exit your interactive node
    
    exit

Submit a command to the Slurm job scheduler
Example - Uses the shared partition, settings for a number of tasks, cpu's, memory, and job outpt files:
    
    sbatch --time 00:59:00 --partition shared --job-name="MY_JOB" --ntasks 1 --cpus-per-task 4 --mem-per-cpu 6G --wrap="module add apps/R/3.6.0 && Rscript myprojectCode.R" --output "myprojectCode.out" --error "myprojectCode.err" &

List all Slurm jobs on Rosalind
    
    squeue

List user's Slurm job on Rosalind
    
    squeue -u kXXXXXXXX

Cancel Slurm job
    
    scancel [JOBID]





