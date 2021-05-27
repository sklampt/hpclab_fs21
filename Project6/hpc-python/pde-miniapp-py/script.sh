for N in {1..24}
do
  bsub -n $N -W 00:30 -R "span[ptile=$N]" -R "select[model==XeonGold_6150]" mpirun python3 main.py 128 100 0.01 verbose
done