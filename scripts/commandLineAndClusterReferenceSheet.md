Working with the command line and computation cluster
============================================
Reference sheet version 2 (20201109)

Johan Zvrskovec 2020

# Connect to Roslind: remote access with ssh
Connecting with your user (use your k-username), using a specified private keyfile (identity file) (1) or when you have set up your keys in ~/.ssh/config (2)
    
    ssh -i ~/rosalind.rsa kXXXXXXXX@login.rosalind.kcl.ac.uk    #1
    
    ssh kXXXXXXXX@login.rosalind.kcl.ac.uk                      #2

Rosalind support forum at: https://forum.rosalind.kcl.ac.uk/
(because I always have trouble finding this)

# File areas on Rosalind
Personal - for scripts, logs, and programs:
    
    /users/kXXXXXXXX

Scratch - for data files and other larger files:
    
    /scratch/users/kXXXXXXXX

# General Linux command line

## General commands
    
    cd                  #change directory
    pwd                 #show current directory path
    ls                  #list directory content
    cat                 #print content of file
    myvar='somevalue'   #variable assignment

## Multiple commands
Execute each command regardless of the success of the previous:
    
    pwd; cat myfile.md; ls;
    
    pwd || cat myfile.md || ls

Execute each command, but halt at any error:
    
    pwd && cat myfile.md && ls
    
Loop through different values accessed with a variable
    
    for v in a b c d; do echo $v; done
    
Advanced iteration from the command line with awk (and pipe)

    echo $PATH | awk 'BEGIN{RS=":"} {NR": "$0}'

## Redirect all screen output to a file (overwrite)
    
    ls > myOutput.txt

## Redirect all screen output to a file (append)
    
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
    
## File permissions

Set(+,-,=) file permissions (r - read, w - write, x - execute) recursively (-R) on specified directory
for (a - all, u - user, g - group, o - other)

    chmod -R a+rw cadir

## Running scripts and programs

Execute R commands from the command line
    
    R -e 'install.packages(devtools); getwd();'

Run R interactively
    
    R

Execute an R-script
    
    Rscript myproject/myprojectCode.R
    
## Transferring files between machines, and downloading from remote locations

Copy file from local machine to remote (rosalind)
    
    rsync -avzh --progress /Users/myname/myfile.txt login.rosalind.kcl.ac.uk:/users/kXXXXXXXX/myfile.txt
    
multiple files from remote to local machine (current folder)

    rsync -avzh --progress 'login.rosalind.kcl.ac.uk:/users/kXXXXXXXX/myfile.txt /users/kXXXXXXXX/myfile2.txt' ./

the whole content of a folder (not including the folder) - remove source trailing slash to copy the whole folder

    rsync -avzh --progress /Users/myname/myfolder/ login.rosalind.kcl.ac.uk:/users/kXXXXXXXX/
    
Downloading file over shaky connections (resumes where it left of if interrupted, makes two tries), specifying the target file (remove the last argument to keep original name)

    wget -c -t 2 http://remote.location/sub/libgit2-devel-0.26.6-1.el7.x86_64.rpm --no-check-certificate -O NEWFILENAME.file
    

## Finding stuff

Find any file in real time prefixed 'setup' in any subfolder to the specified folder (current folder is the default)


    find project/MYPROJECT/ -name setup*    #case sensitive
    find project/MYPROJECT/ -iname setup*   #case insensitive
    
Last - find some really important file on the server in the background (&), do not show the error messages (2>&- alternate 2>/dev/null), save the (std)output to a file, do not use unnecessary resources (nice).
    
    nice find / -name libgit2.pc 1>paths_libgit2.txt 2>&- &


# Modules (on Rosalind)

List available modules

    module avail

Add the R-module:
    
    module add apps/R/3.6.0

# Scheduled jobs with the Slurm scheduler
When you log in to Rosalind you start off on a login node. Use other nodes for work.

Start an interactive node
    
    srun -p brc,shared --pty /bin/bash

Exit your interactive node
    
    exit

Submit a command to the Slurm job scheduler
Example - Uses whichever of the brc partition (more resources than the shared) and the shared, settings for a number of tasks, cpu's, memory, and job outpt files:
    
    sbatch --time 00:59:00 --partition brc,shared --job-name="MY_JOB" --ntasks 1 --cpus-per-task 4 --mem-per-cpu 6G --wrap="module add apps/R/3.6.0 && Rscript myprojectCode.R" --output "myprojectCode.out" --error "myprojectCode.err"

List all Slurm jobs on Rosalind
    
    squeue

List user's Slurm job on Rosalind
    
    squeue -u kXXXXXXXX

Cancel Slurm job (includes your interactive node)
    
    scancel [JOBID]


# Data formatting

Format text output in ordered columns as a table

    column -t
    cat myfile.has.columns | column -t     #example


# Rosalind custom tool for monitoring disk usage

Load the module and use the tool

    module load utilities/rosalind-fs-quota
    ros-fs-quota

# Version control and project folder structure with Git
  
Clone your repository from GitHub or other remote repository into current folder (will create a folder for the cloned project)
  
    git clone https://github.kcl.ac.uk/kXXXXXXXX/myprojectongithub.git
    
Initiate new repository without remote in the current folder (1) or in the specified folder (2)

    git init
    git init mynewproject
    
Initiate new bare repository - convenient to use as a remote repository. Is conventionally appended with the suffix .git (compare with GitHub for example)

    git init --bare mynewproject.git
    