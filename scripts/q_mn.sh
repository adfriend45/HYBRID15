#!/bin/bash

rm *.o

driver=\'$(echo $HOME)\'
echo $driver > namelist.txt
cp namelist.txt $HOME/HYBRID15/exec

cd $HOME/HYBRID15/src
make -f make_MAKE_NETCDF
mv MAKE_NETCDF.exe $HOME/HYBRID15/exec
cd $HOME/HYBRID15/exec

nice -19 ./MAKE_NETCDF.exe
#nice -19 mpirun -ppn 1 -np 1 ./HYBRID15.exe

#mv machine.* MACHINE
#mv slurm-* SLURM

#sbatch slurm
