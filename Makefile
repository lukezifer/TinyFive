GHDL   := ghdl
SIM    := gtkwave
SRCDIR := src
TESTDIR := test
SYNDIR := syn

TOP := cpu
EXTRAFLAGS := --workdir=$(SYNDIR) --ieee=synopsys --std=93c -fexplicit
## Variable STOPTIME: set --stop-time, e.g. 100ns
STOPTIME ?= 500ns

Q := 

LIBS := utils types

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

src_files := $(shell find $(SRCDIR)/ -name "*.vhd")
top_file := $(SRCDIR)/$(TOP).vhd
lib_files := $(patsubst %, $(SRCDIR)/%.vhd, $(LIBS))
component_files := $(filter-out $(lib_files), $(filter-out $(top_file), $(src_files)))

top_entity := $(TOP)
lib_entities := $(patsubst $(SRCDIR)/%.vhd, %, $(lib_files))
component_entities := $(patsubst $(SRCDIR)/%.vhd, %, $(component_files))

.PHONY: all sim clean analysis eleborate run tb_analysis tb_eleborate test
## all: run TOP testbench
all: analysis tb_analysis tb_eleborate run

analysis: $(analysis_target) $(analysis_top_target)

tb_analysis: $(tb_analysis_top_target)

eleborate: $(eleborate_top_target)

tb_eleborate: $(tb_eleborate_top_target)

#run_%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd

%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@

run_%: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$* --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw

tb_eleborate.%: $(TESTDIR)/%.vhd
	$(Q)$(GHDL) -e $(EXTRAFLAGS) $*

tb_analysis.%: $(TESTDIR)/%.vhd
	mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $<

eleborate.%: $(SRCDIR)/%.vhd
	$(Q)$(GHDL) -e $(EXTRAFLAGS) $*

analysis.%: $(SRCDIR)/%.vhd
	mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $<

run:
	$(Q)$(GHDL) -r $(EXTRAFLAGS) $(tb_top_entity) --stop-time=$(STOPTIME) --vcd=$(SYNDIR)/$(tb_top_entity).vcd

sim: run
	$(Q)$(SIM) $(SYNDIR)/$(TOP).vcd

clean:
	$(RM) -r $(SYNDIR)/*

help: Makefile
	@sed -n 's/^##//p' $<
test: $(component_entities) $(lib_entities)

$(top_entity): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $(lib_files) $(component_files) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw

$(component_entities): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $(lib_files) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw

$(lib_entities): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw






