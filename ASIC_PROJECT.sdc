# ASIC_PROJECT.sdc - timing constraints for the DE1-SoC build
# 50 MHz board clock driving the processor
create_clock -name CLOCK_50 -period 20.000 [get_ports CLOCK_50]

# Clock uncertainty (jitter and skew) for setup and hold analysis
derive_clock_uncertainty
