#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -t 3-00
#SBATCH --mem 24576
#SBATCH -n 1
#SBATCH -o test1.out

julia julia/shared/Test3.jl
