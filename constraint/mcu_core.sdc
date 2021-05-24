##############################################################
## Logical / Physical synthesis constraints ##
##############################################################

## DEFINE VARS
set sdc_version 1.7
set_units -capacitance fF -time ns
create_clock -name {Clk} -period 10.0 [get_ports {Clk}]
set_false_path -from [get_ports {Rst}]

## INPUTS
set_input_delay -clock Clk -max 0.2 [all_inputs]
set_input_transition -rise 0.003 [all_inputs]
set_input_transition -fall 0.003 [all_inputs]

## OUTPUTS
#set_load -min 0.0005 [all_outputs]
#set_load -max 0.0020 [all_outputs]
set_load 8 [all_outputs]
