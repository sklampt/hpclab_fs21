for N in {1..32}
do
  bsub -n $N -W 00:30 -R "span[ptile=$N]" -R "select[model==XeonGold_6150]" mpirun ./main 1024 100 0.005 verbose
done
