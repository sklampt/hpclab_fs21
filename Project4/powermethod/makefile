CC=mpicc
CFLAGS=-O3 -lm

################################################################################
################################################################################

# Variables for the strong scaling
KS=1000
NS=10000
PS=1 4 8 12 16 24

# Variables for the weak scaling
KW=100
NWPW=1000-1 2000-4 2800-8 4000-16 4900-24

################################################################################
################################################################################

.PHONY: all
all: results/strong.txt results/weak.txt

.PHONY: plot
plot: results/strong.pdf results/weak.pdf

.PHONY: submit
submit:
	# module load new gcc/6.3.0 open_mpi/3.0.0 python/3.7.1
	mkdir -p results
	bsub -n 24 -W 00:10 -R "span[ptile=24]" -o results/batch.txt "make"

results/%.pdf: plot_%.py results/%.txt
	python3 $^ -o $@

results/strong.txt: extract.py $(foreach k,$(KS), \
	$(foreach n,$(NS), \
		$(foreach p,$(PS), \
			results/strong/$(k)-$(n)-$(p).txt \
		) \
	) \
)
	python3 $^ > $@

results/weak.txt: extract.py $(foreach k,$(KW), \
	$(foreach np,$(NWPW), \
		results/weak/$(k)-$(np).txt \
	) \
)
	python3 $^ > $@

define RUNNERS
results/strong/$(k)-$(n)-$(p).txt: powermethod
	mkdir -p results/strong
	mpirun -np $(p) --oversubscribe $$^ $(k) $(n) > $$@
endef

$(foreach k,$(KS), \
	$(foreach n,$(NS), \
		$(foreach p,$(PS), \
			$(eval $(RUNNERS)) \
		) \
	) \
)

define RUNNERW
results/weak/$(k)-$(np).txt: powermethod
	mkdir -p results/weak
	# Define k and p... has to be evaluated separately because reasons?!
	$(eval n=$(word 1, $(subst -, ,$(np))))
	$(eval p=$(word 2, $(subst -, ,$(np))))

	mpirun -np $(p) --oversubscribe $$^ $(k) $(n) > $$@
endef

$(foreach k,$(KW), \
	$(foreach np,$(NWPW), \
		$(eval $(RUNNERW)) \
	) \
)

powermethod: powermethod.c hpc-power.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f powermethod
	rm -rf results/
	rm -rf batch.txt
