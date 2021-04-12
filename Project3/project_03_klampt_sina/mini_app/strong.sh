module load new
module load gcc/6.3.0 python/3.6.0
make
for grid in 1024 
do
for t in {1..24}
do
        echo "grid= $grid, t= $t"
        export OMP_NUM_THREADS=$t
        bsub -n $t -W 04:22 -R "select[model==XeonGold_5118]" -R "span[ptile=$t]" ./main $grid 100 0.1
        # domain size, nr time steps, simulation time (s)
done
done

