onerror {exit -code 1}
vlib work
vlog -work work lab03_sc.vo
vlog -work work Waveform_d.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.Game_sec_02_vlg_vec_tst -voptargs="+acc"
vcd file -direction lab03_sc.msim.vcd
vcd add -internal Game_sec_02_vlg_vec_tst/*
vcd add -internal Game_sec_02_vlg_vec_tst/i1/*
run -all
quit -f
