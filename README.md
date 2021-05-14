Triple_logic package
====================

This package can be used to perform fine-grain circuit hardening in VHDL designs.

By changing a signal datatype from:

  std_logic, std_logic_vector, unsigned or signed

to:

  triple_logic, triple_logic_vector, triple_signed or triple_unsigned

The circuit element in question (port, signal, variable) will be tripled.

Please take in account that synthesizers love to remove redundant logic. Different synthesizers may need
different, specific options in order to not optimize away the triplicated elements.

This is an academic work and no warranty is implied or offered.

You can read the paper at: https://www.mdpi.com/2079-9292/8/1/24

