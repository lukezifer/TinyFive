from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv(vhdl_standard="93")

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_vhdl_builtins()

# Create library 'lib'
lib = vu.add_library("tiny5")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("src/*.vhd")
lib.add_source_files("test/*.vhd")

vu.set_compile_option("ghdl.a_flags", ["--ieee=synopsys", "-fexplicit", "-frelaxed"])
vu.set_sim_option("ghdl.elab_flags", ["--ieee=synopsys", "-fexplicit", "-frelaxed"])

# Run vunit function
vu.main()
