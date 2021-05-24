#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 04/19/2021 20:28:01
#
#####################################################################


read_mmmc innovus/mcu_core.mmmc.tcl

read_physical -lef {/pdk/xfab/XC018_61_3.1.3/cadence/xc018/LEF/xc018_m6_FE/xc018m6_FE.lef /pdk/xfab/XC018_61_3.1.3/cadence/xc018/LEF/xc018_m6_FE/D_CELLS.lef /pdk/xfab/XC018_61_3.1.3/cadence/xc018/LEF/xc018_m6_FE/IO_CELLS_5V.lef}

read_netlist innovus/mcu_core.v -top mcu_core_top

init_design -skip_sdc_read
