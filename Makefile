GHDL := ghdl
SIM := gtkwave
SRCDIR := src
TESTDIR := test
SYNDIR := syn

TOP := cpu
PKGS := utils types

EXTRAFLAGS := --workdir=$(SYNDIR) --ieee=synopsys --std=93c -fexplicit

Q := @

## Variable STOPTIME: set --stop-time, e.g. 100ns
STOPTIME ?= 500ns

src_files := $(shell find $(SRCDIR)/ -name "*.vhd")
top_file := $(SRCDIR)/$(TOP).vhd
pkg_files := $(patsubst %, $(SRCDIR)/%.vhd, $(PKGS))
component_files := $(filter-out $(pkg_files), $(filter-out $(top_file), $(src_files)))

top_entity := $(TOP)
pkg_entities := $(patsubst $(SRCDIR)/%.vhd, %, $(pkg_files))
component_entities := $(patsubst $(SRCDIR)/%.vhd, %, $(component_files))

.PHONY: all sim clean test unittest help

## all: run TOP entity testbench
all: $(top_entity)

## unittest: run all PKGS and COMPONENT entity testbenches
unittest: $(pkg_entities) $(component_entities) 

## test: run all tests, PKG, COMPONENT and TOP entity testbenches
test: $(pkg_entities) $(component_entities) $(top_entity)

## TOP: run TOP entity testbench
$(top_entity): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $(pkg_files) $(component_files) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	@echo "Start Running tb_$@"
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw
	@echo -e "Stop Running tb_$@\n"

## COMPONENT: run COMPONENT entity testbench
$(component_entities): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $(pkg_files) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	@echo "Start Running tb_$@"
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw
	@echo -e "Stop Running tb_$@\n"

## PKG: run PKG entity testbench
$(pkg_entities): %: $(SRCDIR)/%.vhd $(TESTDIR)/tb_%.vhd
	$(Q)mkdir -p $(SYNDIR)
	$(Q)$(GHDL) -a $(EXTRAFLAGS) $^
	$(Q)$(GHDL) -e $(EXTRAFLAGS) tb_$@
	@echo "Start Running tb_$@"
	$(Q)$(GHDL) -r $(EXTRAFLAGS) tb_$@ --stop-time=$(STOPTIME) --wave=$(SYNDIR)/tb_$*.ghw
	@echo -e "Stop Running tb_$@\n"

## sim: run simulation of the TOP entity testbench
sim: $(top_entity)
	$(Q)$(SIM) $(SYNDIR)/tb_$(TOP).ghw $(TESTDIR)/tb_$(TOP).gtkw

## clean: delete SYNDIR
clean:
	$(RM) -r $(SYNDIR)/*

## help: show this help
help: Makefile
	@sed -n 's/^##//p' $<
