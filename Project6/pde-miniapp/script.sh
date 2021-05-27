for N in {1..24}
do
  bsub -n $N -W 00:30 -R "span[ptile=$N]" -R "select[model==XeonGold_6150]" mpirun ./main 128 100 0.005 verbose
done
