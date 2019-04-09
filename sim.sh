for f in {1..9}
do
qsub -N adaptive_trial_sim -cwd -l mem_free=5G,h_vmem=2G,h_fsize=1G run.sh $f
