GHDL   := ghdl
SIM    := gtkwave
SRCDIR := src
TESTDIR := test
SYNDIR := syn

TOP := cpu
EXTRAFLAGS := --workdir=$(SYNDIR) --ieee=synopsys --std=02
STOPTIME := 100ns

Q := 

vhdlfiles := $(shell find $(SRCDIR)/ -name "*.vhd")
entities := $(patsubst $(SRCDIR)/%.vhd, %, $(vhdlfiles))
analysis_target := $(addprefix analysis., $(entities))
eleborate_target := $(addprefix eleborate., $(entities))

testfiles := $(shell find $(TESTDIR)/ -name "*.vhd")
tb_entities := $(patsubst $(TESTDIR)/%.vhd, %, $(testfiles))
tb_analysis_target := $(addprefix tb_analysis., $(tb_entities))
tb_eleborate_target := $(addprefix tb_eleborate., $(tb_entities))

.PHONY: all sim clean analysis eleborate run

all: analysis eleborate run

analysis: $(analysis_target)

eleborate: $(eleborate_target)

#run_%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd

%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@

run_%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$* --disp-time --stop-time=$(STOPTIME) --vcd=$(SYNDIR)/tb_$*.vcd

tb_eleborate.%: $(TESTDIR)/%.vhd
	$(Q)$(GHDL) -e $(EXTRAFLAGS) $*

tb_analysis.%: $(TESTDIR)/%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $<

eleborate.%: $(SRCDIR)/%.vhd
	$(Q)$(GHDL) -e $(EXTRAFLAGS) $*

analysis.%: $(SRCDIR)/%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $<

run: analysis eleborate
	$(Q)$(GHDL) -r $(EXTRAFLAGS) $(TOP) --stop-time=$(STOPTIME) --vcd=$(SYNDIR)/$(TOP).vcd

sim: run
	$(Q)$(SIM) $(SYNDIR)/$(TOP).vcd

clean:
	$(RM) -r $(SYNDIR)/*
