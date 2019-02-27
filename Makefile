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
analysis_top_target := $(addprefix analysis., $(TOP))
analysis_target := $(addprefix analysis., $(filter-out $(TOP), $(entities)))
eleborate_top_target := $(addprefix eleborate., $(TOP))
eleborate_target := $(addprefix eleborate., $(filter-out $(TOP), $(entities)))

testfiles := $(shell find $(TESTDIR)/ -name "*.vhd")
tb_entities := $(patsubst $(TESTDIR)/%.vhd, %, $(testfiles))
tb_top_entity := $(addprefix tb_, $(TOP))
tb_analysis_top_target := $(addprefix tb_analysis., $(tb_top_entity))
tb_analysis_target := $(addprefix tb_analysis., $(tb_entities))
tb_eleborate_target := $(addprefix tb_eleborate., $(tb_entities))
tb_eleborate_top_target := $(addprefix tb_eleborate., $(tb_top_entity))

.PHONY: all sim clean analysis eleborate run

all: analysis tb_analysis tb_eleborate run

analysis: $(analysis_target) $(analysis_top_target)

tb_analysis: $(tb_analysis_top_target)

eleborate: $(eleborate_top_target)

tb_eleborate: $(tb_eleborate_top_target)

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

run:
	$(Q)$(GHDL) -r $(EXTRAFLAGS) $(tb_top_entity) --stop-time=$(STOPTIME) --vcd=$(SYNDIR)/$(tb_top_entity).vcd

sim: run
	$(Q)$(SIM) $(SYNDIR)/$(TOP).vcd

clean:
	$(RM) -r $(SYNDIR)/*
