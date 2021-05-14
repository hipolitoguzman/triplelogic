# Triple_logic package

This package can be used to perform fine-grain circuit hardening in VHDL designs.

## How does it work?

By changing an object datatype from:

  `std_logic`, `std_logic_vector`, `integer`, `unsigned` or `signed`

to:

  `triple_logic`, `triple_logic_vector`, `triple_integer`, `triple_signed` or `triple_unsigned`

The circuit element in question (port, signal, variable) will be tripled.

For a more complete explanation of how the package works, you can read the
paper describing the approach at: https://www.mdpi.com/2079-9292/8/1/24

## How to use it?

Download the `triple_logic.vhd` file and include it in your project.

Identify the most critical ports, signals or variables in your design and
change their datatype to their tripled counterparts.

Remember to include the use clause `use work.triple_logic_package.all` in the
library sections of the VHDL sources that use these datatypes.

Many functions and operators have been overloaded in the package, so the user
can operate with the tripled datatypes with the same operators that the
standard datatypes use.

Keep in mind that the assignment operator `<=`, `:=` cannot be overloaded in
VHDL, so when you need to explicitly pass data from the single to the triple
domain or vice-versa you should use the `triple()` and `vote()` functions
respectively

Please take in account that synthesizers love to remove redundant logic.
Different synthesizers may need different, specific options in order to not
optimize away the triplicated elements.

Remember to re-simulate your modified design, in order to check that the
inserted changes did not break your design's intended functionality. An even
better option would be to formally check the equivalence of the modified design
with the original design.

## Disclaimer

This is an academic work and no warranty is offered or implied (see LICENSE
file).

## Acknowledgement

This work was supported by the Spanish Ministerio de Economía y Competitividad,
through the project “Diseño de sistemas digitales robustos frente a radiación
mediante componentes y tecnologías comerciales” (RENASER3), project reference
ESP2015-68245-C4-2-P. This work was also supported by the European
Commission, through the project “VEGAS: Validation of European high capacity
rad-hard FPGA and software tools”, project ID 687220
