VCS = vcs
SIM = ./simv

TOP  = top
TEST = test

LOG_DIR = logs
REG_COUNT = 10

VCS_FLAGS = -full64 \
            -sverilog \
            -ntb_opts uvm-1.2 \
            -debug_access+all \
            -kdb \
            -cm line+cond+branch+fsm+tgl \
            -f filelist.f \
            -top $(TOP)

SIM_FLAGS = -cm line+cond+branch+fsm+tgl

.PHONY: all compile run regression coverage clean

all: compile run

compile:
	mkdir -p $(LOG_DIR)
	$(VCS) $(VCS_FLAGS) \
	-l $(LOG_DIR)/compile.log

run:
	mkdir -p $(LOG_DIR)
	$(SIM) $(SIM_FLAGS) \
	+UVM_TESTNAME=$(TEST) \
	-l $(LOG_DIR)/$(TEST).log

regression: compile
	@echo "========================================"
	@echo "      AXI4-LITE UVM REGRESSION"
	@echo "========================================"

	@for seed in $$(seq 1 $(REG_COUNT)); do \
		echo ""; \
		echo "----------------------------------------"; \
		echo "Running TEST=$(TEST), SEED=$$seed"; \
		echo "----------------------------------------"; \
		$(SIM) $(SIM_FLAGS) \
			+UVM_TESTNAME=$(TEST) \
			+ntb_random_seed=$$seed \
			-l $(LOG_DIR)/test_$$seed.log; \
	done

coverage:
	urg -dir simv.vdb

clean:
	rm -rf simv \
	       simv.daidir \
	       csrc \
	       *.vdb \
	       urgReport \
	       logs
