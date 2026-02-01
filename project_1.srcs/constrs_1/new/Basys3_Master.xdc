## Clock signal (100 MHz board clock)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset (Center Button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## LEDs (We will map the lower 16 bits of DataAddr to these)
## This allows us to see the result of our calculations (e.g., "8")
set_property PACKAGE_PIN U16 [get_ports {DataAddr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[0]}]
set_property PACKAGE_PIN E19 [get_ports {DataAddr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[1]}]
set_property PACKAGE_PIN U19 [get_ports {DataAddr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[2]}]
set_property PACKAGE_PIN V19 [get_ports {DataAddr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[3]}]
set_property PACKAGE_PIN W18 [get_ports {DataAddr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[4]}]
set_property PACKAGE_PIN U15 [get_ports {DataAddr[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[5]}]
set_property PACKAGE_PIN U14 [get_ports {DataAddr[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[6]}]
set_property PACKAGE_PIN V14 [get_ports {DataAddr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[7]}]
set_property PACKAGE_PIN V13 [get_ports {DataAddr[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[8]}]
set_property PACKAGE_PIN V3 [get_ports {DataAddr[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[9]}]
set_property PACKAGE_PIN W3 [get_ports {DataAddr[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[10]}]
set_property PACKAGE_PIN U3 [get_ports {DataAddr[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[11]}]
set_property PACKAGE_PIN P3 [get_ports {DataAddr[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[12]}]
set_property PACKAGE_PIN N3 [get_ports {DataAddr[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[13]}]
set_property PACKAGE_PIN P1 [get_ports {DataAddr[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[14]}]
set_property PACKAGE_PIN L1 [get_ports {DataAddr[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataAddr[15]}]

## We are ignoring the upper 16 bits of output and the WriteData output
## Vivado might complain, so we can tell it to not worry about unassigned pins:
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]