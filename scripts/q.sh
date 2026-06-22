#!/bin/bash

cd $HOME/HYBRID15/src

rm *.o

make

mv HYBRID15.exe $HOME/HYBRID15/exec

cd $HOME/HYBRID15/scripts

mv machine.* MACHINE
mv slurm-* SLURM

sbatch slurm
