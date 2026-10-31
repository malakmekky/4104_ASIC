# 50 MHz board clock
create_clock -name CLOCK_50 -period 20.000 [get_ports CLOCK_50]

# Processor clock. -divide_by sets the speed the tools try to reach (25 MHz here),
# not the speed on the board. Read the processor's Fmax from proc_clk.
create_generated_clock -name proc_clk -source [get_ports CLOCK_50] -divide_by 2 [get_registers proc_clk]

derive_clock_uncertainty

set_clock_groups -asynchronous -group {CLOCK_50} -group {proc_clk}

# Buttons, switches, LEDs and displays are too slow to need timing checks
set_false_path -from [get_ports {KEY[*] SW[*]}]
set_false_path -to [get_ports {LEDR[*] HEX0[*] HEX1[*] HEX2[*] HEX3[*] HEX4[*] HEX5[*]}]
