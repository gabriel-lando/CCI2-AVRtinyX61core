# Comandos

``` bash
tcsh
source /scripts/set_cadence.csh
source /scripts/set_cadence_innovus161.csh

# Simulação RTL:
cd ~/AVRtinyX61core/core/rtl
irun -f file_list.f

# Síntese lógica:
cd ~/AVRtinyX61core/synthesis
genus -files synth.tcl
gui_show # Aqui é possível ver as portas lógicas e o resultado do Slack no timing report

# Síntese física / Floorplaning / Power Planing...
tcsh
source /scripts/set_cadence.csh
cd ~/AVRtinyX61core/synthesis

innovus -common_ui -cpus 8

# 1) Floorplaning
source physical/1_init.tcl

# 2) Power Planing
source physical/2_power_plan.tcl

# I/O Placement
# Gerar IO Pads pela interface gráfica:
## File > Save > I/O File e marcar "Generate Template"

# 3) Placement
place_design
ccopt_design
report_timing

# # Pre-CTS
# #setDelayCalMode -siAware false
# time_design -pre_cts
# report_timing
# opt_design -pre_cts  # Pre-CTS Optimization

# # CTS
# clock_design
# report_timing
# #displayClockTree -clk Clk -level 1

# # Post-CTS 
# time_design -post_cts
# opt_design -post_cts
# time_design -post_cts

# 4) Route
source physical/4_nano_route.tcl

# 5)
source physical/5_fillers_reports.tcl

# 6)
source physical/6_netlist_sdf.tcl

```