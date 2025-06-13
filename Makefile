# Makefile
SIMULATOR = xsim
TEST ?= load_store_test

run:
	source /opt/Xilinx/Vivado/2024.1/settings64.sh && \
	./xsim_run.sh $(TEST)

clean:
	rm -rf xsim.dir .Xil xsim*.jou xsim*.log