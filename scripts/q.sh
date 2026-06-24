#!/bin/bash

rm *.o

driver=\'$(echo $HOME)\'
echo $driver > namelist.txt

cd $HOME/HYBRID15/src
make -f make_HYBRID15
mv HYBRID15.exe $HOME/HYBRID15/exec
cd $HOME/HYBRID15/scripts

#nice -19 ./HYBRID15.exe
#nice -19 mpirun -ppn 1 -np 1 ./HYBRID15.exe

mv machine.* MACHINE
mv slurm-* SLURM

sbatch slurm
