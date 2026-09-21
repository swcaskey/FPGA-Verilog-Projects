onerror {exit -code 1}
vlib work
vlog -work work lab02_sc.vo
vlog -work work lab02_sc.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.lab02_sc_vlg_vec_tst -voptargs="+acc"
vcd file -direction lab02_sc.msim.vcd
vcd add -internal lab02_sc_vlg_vec_tst/*
vcd add -internal lab02_sc_vlg_vec_tst/i1/*
run -all
quit -f
