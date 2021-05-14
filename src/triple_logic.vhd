library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------
--  Data and function declarations                       --
-----------------------------------------------------------

package triple_logic_pkg is

-- 1. Datatype definitions

  -- 1.1 triple_logic

  type triple_logic is
  record
    a : std_logic;
    b : std_logic;
    c : std_logic;
  end record;

  -- Different synthesizers may need different attributes, if the synthesizer
  -- is removing your tripled elements please check its user's manual.
  -- Sometimes you need to put these attributes in your design, since they
  -- not be inherited from the datatype

  attribute equivalent_register_removal                 : string;
  attribute equivalent_register_removal of triple_logic : type is "no";
  attribute equivalent_register_removal of triple_logic_vector : type is "no";
  attribute equivalent_register_removal of triple_integer : type is "no";
  attribute equivalent_register_removal of triple_signed : type is "no";
  attribute equivalent_register_removal of triple_unsigned : type is "no";

  attribute syn_keep                                    : string;
  attribute syn_keep of triple_logic                    : type is "true";
  attribute syn_keep of triple_logic_vector : type is "no";
  attribute syn_keep of triple_integer : type is "no";
  attribute syn_keep of triple_signed : type is "no";
  attribute syn_keep of triple_unsigned : type is "no";

  attribute syn_preserve                                : boolean;
  attribute syn_preserve of triple_logic                : type is true;
  attribute syn_preserve of triple_logic_vector : type is "no";
  attribute syn_preserve of triple_integer : type is "no";
  attribute syn_preserve of triple_signed : type is "no";
  attribute syn_preserve of triple_unsigned : type is "no";

  -- 1.2 triple_logic_vector

  type triple_logic_vector is array (natural range <>) of triple_logic;

  attribute equivalent_register_removal of triple_logic_vector : type is "no";
  attribute syn_keep of triple_logic_vector                    : type is "true";

  -- 1.3 triple_integer
  --
  -- This could be constrained in VHDL-2008 when creating a signal of this type, but in VHDL'93 it will try to insert 32-bit integers:
  -- signal my_sig: triple_integer(a(0 to 7), b(0 to 9), c(0 to 7));
  type triple_integer is record
    a : integer;
    b : integer;
    c : integer;
  end record;

  -- 1.4 triple_signed:

  type triple_signed is array (natural range <>) of triple_logic;

  -- 1.5 triple_unsigned:

  type triple_unsigned is array (natural range <>) of triple_logic;

-- 2. Domain crossing function declarations
--
-- triple() takes a single data and outputs a tripled data
-- vote() takes a triple data and outputs a single data, calculating its value
--   through majority voting

  -- 2.1 Vote and triple for std_logic/triple_logic

  function vote (triple : triple_logic) return std_logic;
  function triple (single : std_logic) return triple_logic;

  -- 2.2 Vote and triple for std_logic_vector/triple_logic_vector

  function vote (triple : triple_logic_vector) return std_logic_vector;
  function triple (single : std_logic_vector) return triple_logic_vector;

  -- 2.3 Vote and triple for signed/triple_signed

  function vote (triple : triple_signed) return signed;
  function triple (single : signed) return triple_signed;

  -- 2.4 Vote and triple for unsigned/triple_unsigned

  function vote (triple : triple_unsigned) return unsigned;
  function triple (single : unsigned) return triple_unsigned;

  -- 2.5 Vote and triple for triple_integer

  function vote (triple   : triple_integer) return integer;
  function triple (single : integer) return triple_integer;

  -- 2.6 Helper function that we will need later

  function MAX (left, right : integer) return integer;

-- 3. Overload Logic Gates declaration:

  -- 3.1 AND GATES:

--function "and" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "and" (l, r : std_logic) return triple_logic;
  function "and" (l    : std_logic; r : triple_logic) return std_logic;
  function "and" (l    : std_logic; r : triple_logic) return triple_logic;
  function "and" (l    : triple_logic; r : std_logic) return std_logic;
  function "and" (l    : triple_logic; r : std_logic) return triple_logic;
  function "and" (l, r : triple_logic) return std_logic;
  function "and" (l, r : triple_logic) return triple_logic;

  -- AND gates for vector types:

  --function "and" (l, r: std_logic_vector) return std_logic_vector;
  function "and" (l, r : std_logic_vector) return triple_logic_vector;
  function "and" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "and" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "and" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "and" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "and" (l, r : triple_logic_vector) return std_logic_vector;
  function "and" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "and" (l, r: unsigned) return unsigned;
  function "and" (l, r : unsigned) return triple_unsigned;
  function "and" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "and" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "and" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "and" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "and" (l, r : triple_unsigned) return unsigned;
  function "and" (l, r : triple_unsigned) return triple_unsigned;

  --function "and" (l, r: signed) return signed;
  function "and" (l, r : signed) return triple_signed;
  function "and" (l    : signed; r : triple_signed) return signed;
  function "and" (l    : signed; r : triple_signed) return triple_signed;
  function "and" (l    : triple_signed; r : signed) return signed;
  function "and" (l    : triple_signed; r : signed) return triple_signed;
  function "and" (l, r : triple_signed) return signed;
  function "and" (l, r : triple_signed) return triple_signed;

  -- 3.2 NAND GATES:

--function "nand" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "nand" (l, r : std_logic) return triple_logic;
  function "nand" (l    : std_logic; r : triple_logic) return std_logic;
  function "nand" (l    : std_logic; r : triple_logic) return triple_logic;
  function "nand" (l    : triple_logic; r : std_logic) return std_logic;
  function "nand" (l    : triple_logic; r : std_logic) return triple_logic;
  function "nand" (l, r : triple_logic) return std_logic;
  function "nand" (l, r : triple_logic) return triple_logic;

  -- NAND gates for vector types:

  --function "nand" (l, r: std_logic_vector) return std_logic_vector;
  function "nand" (l, r : std_logic_vector) return triple_logic_vector;
  function "nand" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "nand" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "nand" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "nand" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "nand" (l, r : triple_logic_vector) return std_logic_vector;
  function "nand" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "nand" (l, r: unsigned) return unsigned;
  function "nand" (l, r : unsigned) return triple_unsigned;
  function "nand" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "nand" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "nand" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "nand" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "nand" (l, r : triple_unsigned) return unsigned;
  function "nand" (l, r : triple_unsigned) return triple_unsigned;

  --function "nand" (l, r: signed) return signed;
  function "nand" (l, r : signed) return triple_signed;
  function "nand" (l    : signed; r : triple_signed) return signed;
  function "nand" (l    : signed; r : triple_signed) return triple_signed;
  function "nand" (l    : triple_signed; r : signed) return signed;
  function "nand" (l    : triple_signed; r : signed) return triple_signed;
  function "nand" (l, r : triple_signed) return signed;
  function "nand" (l, r : triple_signed) return triple_signed;

  -- 3.3 OR GATES:

--function "or" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "or" (l, r : std_logic) return triple_logic;
  function "or" (l    : std_logic; r : triple_logic) return std_logic;
  function "or" (l    : std_logic; r : triple_logic) return triple_logic;
  function "or" (l    : triple_logic; r : std_logic) return std_logic;
  function "or" (l    : triple_logic; r : std_logic) return triple_logic;
  function "or" (l, r : triple_logic) return std_logic;
  function "or" (l, r : triple_logic) return triple_logic;

  -- OR gates for vector types:

  --function "or" (l, r: std_logic_vector) return std_logic_vector;
  function "or" (l, r : std_logic_vector) return triple_logic_vector;
  function "or" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "or" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "or" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "or" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "or" (l, r : triple_logic_vector) return std_logic_vector;
  function "or" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "or" (l, r: unsigned) return unsigned;
  function "or" (l, r : unsigned) return triple_unsigned;
  function "or" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "or" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "or" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "or" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "or" (l, r : triple_unsigned) return unsigned;
  function "or" (l, r : triple_unsigned) return triple_unsigned;

  --function "or" (l, r: signed) return signed;
  function "or" (l, r : signed) return triple_signed;
  function "or" (l    : signed; r : triple_signed) return signed;
  function "or" (l    : signed; r : triple_signed) return triple_signed;
  function "or" (l    : triple_signed; r : signed) return signed;
  function "or" (l    : triple_signed; r : signed) return triple_signed;
  function "or" (l, r : triple_signed) return signed;
  function "or" (l, r : triple_signed) return triple_signed;

  -- 3.4 NOR GATES:

--function "nor" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "nor" (l, r : std_logic) return triple_logic;
  function "nor" (l    : std_logic; r : triple_logic) return std_logic;
  function "nor" (l    : std_logic; r : triple_logic) return triple_logic;
  function "nor" (l    : triple_logic; r : std_logic) return std_logic;
  function "nor" (l    : triple_logic; r : std_logic) return triple_logic;
  function "nor" (l, r : triple_logic) return std_logic;
  function "nor" (l, r : triple_logic) return triple_logic;

  -- NOR gates fnor vector types:

  --function "nor" (l, r: std_logic_vector) return std_logic_vector;
  function "nor" (l, r : std_logic_vector) return triple_logic_vector;
  function "nor" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "nor" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "nor" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "nor" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "nor" (l, r : triple_logic_vector) return std_logic_vector;
  function "nor" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "nor" (l, r: unsigned) return unsigned;
  function "nor" (l, r : unsigned) return triple_unsigned;
  function "nor" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "nor" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "nor" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "nor" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "nor" (l, r : triple_unsigned) return unsigned;
  function "nor" (l, r : triple_unsigned) return triple_unsigned;

  --function "nor" (l, r: signed) return signed;
  function "nor" (l, r : signed) return triple_signed;
  function "nor" (l    : signed; r : triple_signed) return signed;
  function "nor" (l    : signed; r : triple_signed) return triple_signed;
  function "nor" (l    : triple_signed; r : signed) return signed;
  function "nor" (l    : triple_signed; r : signed) return triple_signed;
  function "nor" (l, r : triple_signed) return signed;
  function "nor" (l, r : triple_signed) return triple_signed;

  -- 3.5 XOR GATES:

--function "xor" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "xor" (l, r : std_logic) return triple_logic;
  function "xor" (l    : std_logic; r : triple_logic) return std_logic;
  function "xor" (l    : std_logic; r : triple_logic) return triple_logic;
  function "xor" (l    : triple_logic; r : std_logic) return std_logic;
  function "xor" (l    : triple_logic; r : std_logic) return triple_logic;
  function "xor" (l, r : triple_logic) return std_logic;
  function "xor" (l, r : triple_logic) return triple_logic;

  -- XOR gates for vector types:

  --function "xor" (l, r: std_logic_vector) return std_logic_vector;
  function "xor" (l, r : std_logic_vector) return triple_logic_vector;
  function "xor" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "xor" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "xor" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "xor" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "xor" (l, r : triple_logic_vector) return std_logic_vector;
  function "xor" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "xor" (l, r: unsigned) return unsigned;
  function "xor" (l, r : unsigned) return triple_unsigned;
  function "xor" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "xor" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "xor" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "xor" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "xor" (l, r : triple_unsigned) return unsigned;
  function "xor" (l, r : triple_unsigned) return triple_unsigned;

  --function "xor" (l, r: signed) return signed;
  function "xor" (l, r : signed) return triple_signed;
  function "xor" (l    : signed; r : triple_signed) return signed;
  function "xor" (l    : signed; r : triple_signed) return triple_signed;
  function "xor" (l    : triple_signed; r : signed) return signed;
  function "xor" (l    : triple_signed; r : signed) return triple_signed;
  function "xor" (l, r : triple_signed) return signed;
  function "xor" (l, r : triple_signed) return triple_signed;

  -- 3.6 XNOR GATES:

--function "xnor" (l, r: std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "xnor" (l, r : std_logic) return triple_logic;
  function "xnor" (l    : std_logic; r : triple_logic) return std_logic;
  function "xnor" (l    : std_logic; r : triple_logic) return triple_logic;
  function "xnor" (l    : triple_logic; r : std_logic) return std_logic;
  function "xnor" (l    : triple_logic; r : std_logic) return triple_logic;
  function "xnor" (l, r : triple_logic) return std_logic;
  function "xnor" (l, r : triple_logic) return triple_logic;

  -- XNOR gates for vector types:

  --function "xnor" (l, r: std_logic_vector) return std_logic_vector;
  function "xnor" (l, r : std_logic_vector) return triple_logic_vector;
  function "xnor" (l    : std_logic_vector; r : triple_logic_vector) return std_logic_vector;
  function "xnor" (l    : std_logic_vector; r : triple_logic_vector) return triple_logic_vector;
  function "xnor" (l    : triple_logic_vector; r : std_logic_vector) return std_logic_vector;
  function "xnor" (l    : triple_logic_vector; r : std_logic_vector) return triple_logic_vector;
  function "xnor" (l, r : triple_logic_vector) return std_logic_vector;
  function "xnor" (l, r : triple_logic_vector) return triple_logic_vector;

  --function "xnor" (l, r: unsigned) return unsigned;
  function "xnor" (l, r : unsigned) return triple_unsigned;
  function "xnor" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "xnor" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "xnor" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "xnor" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "xnor" (l, r : triple_unsigned) return unsigned;
  function "xnor" (l, r : triple_unsigned) return triple_unsigned;

  --function "xnor" (l, r: signed) return signed;
  function "xnor" (l, r : signed) return triple_signed;
  function "xnor" (l    : signed; r : triple_signed) return signed;
  function "xnor" (l    : signed; r : triple_signed) return triple_signed;
  function "xnor" (l    : triple_signed; r : signed) return signed;
  function "xnor" (l    : triple_signed; r : signed) return triple_signed;
  function "xnor" (l, r : triple_signed) return signed;
  function "xnor" (l, r : triple_signed) return triple_signed;

  -- 3.7 NOT GATES:

--function "not" (l : std_logic) return std_logic;  -- Defined in ieee.std_logic_1164
  function "not" (l : std_logic) return triple_logic;
  function "not" (l : triple_logic) return std_logic;
  function "not" (l : triple_logic) return triple_logic;

  -- NOT gates for vector types:

--function "not" (l: std_logic_vector) return std_logic_vector;  -- Defined in ieee.std_logic_vector_1164
  function "not" (l : std_logic_vector) return triple_logic_vector;
  function "not" (l : triple_logic_vector) return std_logic_vector;
  function "not" (l : triple_logic_vector) return triple_logic_vector;

--function "not" (l: unsigned) return unsigned;  -- Defined in ieee.unsigned_1164
  function "not" (l : unsigned) return triple_unsigned;
  function "not" (l : triple_unsigned) return unsigned;
  function "not" (l : triple_unsigned) return triple_unsigned;

--function "not" (l: signed) return signed;  -- Defined in ieee.signed_1164
  function "not" (l : signed) return triple_signed;
  function "not" (l : triple_signed) return signed;
  function "not" (l : triple_signed) return triple_signed;

  -- 4. Comparison Operators:

  -- 4.1 "=" Operator:

  function "=" (l : triple_logic; r : std_logic) return boolean;
  function "=" (l : std_logic; r : triple_logic) return boolean;
  function "=" (l : triple_logic; r : triple_logic) return boolean;

  function "=" (l : triple_logic_vector; r : std_logic_vector) return boolean;
  function "=" (l : std_logic_vector; r : triple_logic_vector) return boolean;
  function "=" (l : triple_logic_vector; r : triple_logic_vector) return boolean;

  function "=" (l : triple_unsigned; r : unsigned) return boolean;
  function "=" (l : unsigned; r : triple_unsigned) return boolean;
  function "=" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function "=" (l : triple_signed; r : signed) return boolean;
  function "=" (l : signed; r : triple_signed) return boolean;
  function "=" (l : triple_signed; r : triple_signed) return boolean;

  function "=" (l : triple_integer; r : integer) return boolean;
  function "=" (l : integer; r : triple_integer) return boolean;
  function "=" (l : triple_integer; r : triple_integer) return boolean;

  -- 4.2 "<" Operator:

  function "<" (l : triple_logic; r : std_logic) return boolean;
  function "<" (l : std_logic; r : triple_logic) return boolean;
  function "<" (l : triple_logic; r : triple_logic) return boolean;

  function "<" (l : triple_unsigned; r : unsigned) return boolean;
  function "<" (l : unsigned; r : triple_unsigned) return boolean;
  function "<" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function "<" (l : triple_signed; r : signed) return boolean;
  function "<" (l : signed; r : triple_signed) return boolean;
  function "<" (l : triple_signed; r : triple_signed) return boolean;

  function "<" (l : triple_integer; r : integer) return boolean;
  function "<" (l : integer; r : triple_integer) return boolean;
  function "<" (l : triple_integer; r : triple_integer) return boolean;

  -- 4.3 ">" Operator:

  function ">" (l : triple_logic; r : std_logic) return boolean;
  function ">" (l : std_logic; r : triple_logic) return boolean;
  function ">" (l : triple_logic; r : triple_logic) return boolean;

  function ">" (l : triple_unsigned; r : unsigned) return boolean;
  function ">" (l : unsigned; r : triple_unsigned) return boolean;
  function ">" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function ">" (l : triple_signed; r : signed) return boolean;
  function ">" (l : signed; r : triple_signed) return boolean;
  function ">" (l : triple_signed; r : triple_signed) return boolean;

  function ">" (l : triple_integer; r : integer) return boolean;
  function ">" (l : integer; r : triple_integer) return boolean;
  function ">" (l : triple_integer; r : triple_integer) return boolean;

  -- 4.4 "<=" Operator:

  function "<=" (l : triple_logic; r : std_logic) return boolean;
  function "<=" (l : std_logic; r : triple_logic) return boolean;
  function "<=" (l : triple_logic; r : triple_logic) return boolean;

  function "<=" (l : triple_unsigned; r : unsigned) return boolean;
  function "<=" (l : unsigned; r : triple_unsigned) return boolean;
  function "<=" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function "<=" (l : triple_signed; r : signed) return boolean;
  function "<=" (l : signed; r : triple_signed) return boolean;
  function "<=" (l : triple_signed; r : triple_signed) return boolean;

  function "<=" (l : triple_integer; r : integer) return boolean;
  function "<=" (l : integer; r : triple_integer) return boolean;
  function "<=" (l : triple_integer; r : triple_integer) return boolean;

  -- 4.5 ">=" Operator:

  function ">=" (l : triple_logic; r : std_logic) return boolean;
  function ">=" (l : std_logic; r : triple_logic) return boolean;
  function ">=" (l : triple_logic; r : triple_logic) return boolean;

  function ">=" (l : triple_unsigned; r : unsigned) return boolean;
  function ">=" (l : unsigned; r : triple_unsigned) return boolean;
  function ">=" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function ">=" (l : triple_signed; r : signed) return boolean;
  function ">=" (l : signed; r : triple_signed) return boolean;
  function ">=" (l : triple_signed; r : triple_signed) return boolean;

  function ">=" (l : triple_integer; r : integer) return boolean;
  function ">=" (l : integer; r : triple_integer) return boolean;
  function ">=" (l : triple_integer; r : triple_integer) return boolean;

  -- 4.6 "/=" Operator:

  function "/=" (l : triple_logic; r : std_logic) return boolean;
  function "/=" (l : std_logic; r : triple_logic) return boolean;
  function "/=" (l : triple_logic; r : triple_logic) return boolean;

  function "/=" (l : triple_logic_vector; r : std_logic_vector) return boolean;
  function "/=" (l : std_logic_vector; r : triple_logic_vector) return boolean;
  function "/=" (l : triple_logic_vector; r : triple_logic_vector) return boolean;

  function "/=" (l : triple_unsigned; r : unsigned) return boolean;
  function "/=" (l : unsigned; r : triple_unsigned) return boolean;
  function "/=" (l : triple_unsigned; r : triple_unsigned) return boolean;

  function "/=" (l : triple_signed; r : signed) return boolean;
  function "/=" (l : signed; r : triple_signed) return boolean;
  function "/=" (l : triple_signed; r : triple_signed) return boolean;

  function "/=" (l : triple_integer; r : integer) return boolean;
  function "/=" (l : integer; r : triple_integer) return boolean;
  function "/=" (l : triple_integer; r : triple_integer) return boolean;

-- 5. Arithmetic Operators:

  -- 5.2 "+" Operator:

  -- 5.2.1 "+" Operator - Signed Data:

--function "+" (l, r : signed) return signed; -- Defined in ieee.numeric_std
  function "+" (l, r : signed) return triple_signed;
  function "+" (l    : signed; r : triple_signed) return signed;
  function "+" (l    : signed; r : triple_signed) return triple_signed;
  function "+" (l    : triple_signed; r : signed) return signed;
  function "+" (l    : triple_signed; r : signed) return triple_signed;
  function "+" (l, r : triple_signed) return signed;
  function "+" (l, r : triple_signed) return triple_signed;

  -- 5.2.2 "+" Operator - Unsigned Data:

--function "+" (l, r : unsigned) return unsigned; -- Defined in ieee.numeric_std 
  function "+" (l, r : unsigned) return triple_unsigned;
  function "+" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "+" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "+" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "+" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "+" (l, r : triple_unsigned) return unsigned;
  function "+" (l, r : triple_unsigned) return triple_unsigned;

  -- 5.2.3 "+" Operator - Triple unsigned and natural:

  function "+" (l : triple_unsigned; r : natural) return unsigned;
  function "+" (l : triple_unsigned; r : natural) return triple_unsigned;
  function "+" (l : natural; r : triple_unsigned) return unsigned;
  function "+" (l : natural; r : triple_unsigned) return triple_unsigned;

  -- 5.2.4 "+" Operator - Triple signed and natural:

  function "+" (l : triple_signed; r : natural) return signed;
  function "+" (l : triple_signed; r : natural) return triple_signed;
  function "+" (l : natural; r : triple_signed) return signed;
  function "+" (l : natural; r : triple_signed) return triple_signed;

  -- "+" Operator for triple_integer

--function "+" (l: integer; r: integer) return integer;
  function "+" (l : integer; r : integer) return triple_integer;
  function "+" (l : integer; r : triple_integer) return integer;
  function "+" (l : integer; r : triple_integer) return triple_integer;
  function "+" (l : triple_integer; r : integer) return integer;
  function "+" (l : triple_integer; r : integer) return triple_integer;
  function "+" (l : triple_integer; r : triple_integer) return integer;
  function "+" (l : triple_integer; r : triple_integer) return triple_integer;

  -- 5.3 "-" Operator:

  -- 5.3.1 "-" Operator - Signed Data:

--function "-" (l, r : signed) return signed; -- Defined in ieee.numeric_std
  function "-" (l, r : signed) return triple_signed;
  function "-" (l    : signed; r : triple_signed) return signed;
  function "-" (l    : signed; r : triple_signed) return triple_signed;
  function "-" (l    : triple_signed; r : signed) return signed;
  function "-" (l    : triple_signed; r : signed) return triple_signed;
  function "-" (l, r : triple_signed) return signed;
  function "-" (l, r : triple_signed) return triple_signed;

  -- 5.3.2 "-" Operator - Unsigned Data:

--function "-" (l, r : unsigned) return unsigned; -- Defined in ieee.numeric_std 
  function "-" (l, r : unsigned) return triple_unsigned;
  function "-" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "-" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "-" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "-" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "-" (l, r : triple_unsigned) return unsigned;
  function "-" (l, r : triple_unsigned) return triple_unsigned;

  -- 5.3.3 "-" Operator - Triple unsigned and natural:

  function "-" (l : triple_unsigned; r : natural) return unsigned;
  function "-" (l : triple_unsigned; r : natural) return triple_unsigned;
  function "-" (l : natural; r : triple_unsigned) return unsigned;
  function "-" (l : natural; r : triple_unsigned) return triple_unsigned;

  -- 5.3.4 "-" Operator - Triple signed and natural:

  function "-" (l : triple_signed; r : natural) return signed;
  function "-" (l : triple_signed; r : natural) return triple_signed;
  function "-" (l : natural; r : triple_signed) return signed;
  function "-" (l : natural; r : triple_signed) return triple_signed;

  -- "-" Operator for triple_integer

  --function "-" (l: integer; r: integer) return integer;
  function "-" (l : integer; r : integer) return triple_integer;
  function "-" (l : integer; r : triple_integer) return integer;
  function "-" (l : integer; r : triple_integer) return triple_integer;
  function "-" (l : triple_integer; r : integer) return integer;
  function "-" (l : triple_integer; r : integer) return triple_integer;
  function "-" (l : triple_integer; r : triple_integer) return integer;
  function "-" (l : triple_integer; r : triple_integer) return triple_integer;

  -- 5.4 "*" Operator:

  -- 5.4.1 "*" Operator - Signed Data:

--function "*" (l, r: signed)                       return signed; -- Defined in ieee.numeric_std
  function "*" (l, r : signed) return triple_signed;
  function "*" (l    : signed; r : triple_signed) return signed;
  function "*" (l    : signed; r : triple_signed) return triple_signed;
  function "*" (l    : triple_signed; r : signed) return signed;
  function "*" (l    : triple_signed; r : signed) return triple_signed;
  function "*" (l, r : triple_signed) return signed;
  function "*" (l, r : triple_signed) return triple_signed;

  -- 5.4.2 "*" Operator - Unsigned Data:

--function "*" (l, r: unsigned)                         return unsigned; -- Defined in ieee.numeric_std 
  function "*" (l, r : unsigned) return triple_unsigned;
  function "*" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "*" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "*" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "*" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "*" (l, r : triple_unsigned) return unsigned;
  function "*" (l, r : triple_unsigned) return triple_unsigned;

  -- 5.4.3 "*" Operator - Triple unsigned and natural:

  function "*" (l : triple_unsigned; r : natural) return unsigned;
  function "*" (l : triple_unsigned; r : natural) return triple_unsigned;
  function "*" (l : natural; r : triple_unsigned) return unsigned;
  function "*" (l : natural; r : triple_unsigned) return triple_unsigned;

  -- 5.4.4 "*" Operator - Triple signed and natural:

  function "*" (l : triple_signed; r : natural) return signed;
  function "*" (l : triple_signed; r : natural) return triple_signed;
  function "*" (l : natural; r : triple_signed) return signed;
  function "*" (l : natural; r : triple_signed) return triple_signed;

  -- "*" Operator for triple_integer

  --function "*" (l: integer; r: integer) return integer;
  function "*" (l : integer; r : integer) return triple_integer;
  function "*" (l : integer; r : triple_integer) return integer;
  function "*" (l : integer; r : triple_integer) return triple_integer;
  function "*" (l : triple_integer; r : integer) return integer;
  function "*" (l : triple_integer; r : integer) return triple_integer;
  function "*" (l : triple_integer; r : triple_integer) return integer;
  function "*" (l : triple_integer; r : triple_integer) return triple_integer;


  -- 5.5 "/" Operator:

  -- 5.5.1 "/" Operator - Signed Data:

--function "/" (l, r: signed)                       return signed; -- Defined in ieee.numeric_std
  function "/" (l, r : signed) return triple_signed;
  function "/" (l    : signed; r : triple_signed) return signed;
  function "/" (l    : signed; r : triple_signed) return triple_signed;
  function "/" (l    : triple_signed; r : signed) return signed;
  function "/" (l    : triple_signed; r : signed) return triple_signed;
  function "/" (l, r : triple_signed) return signed;
  function "/" (l, r : triple_signed) return triple_signed;

  -- 5.5.2 "/" Operator - Unsigned Data:

--function "/" (l, r: unsigned)                         return unsigned; -- Defined in ieee.numeric_std 
  function "/" (l, r : unsigned) return triple_unsigned;
  function "/" (l    : unsigned; r : triple_unsigned) return unsigned;
  function "/" (l    : unsigned; r : triple_unsigned) return triple_unsigned;
  function "/" (l    : triple_unsigned; r : unsigned) return unsigned;
  function "/" (l    : triple_unsigned; r : unsigned) return triple_unsigned;
  function "/" (l, r : triple_unsigned) return unsigned;
  function "/" (l, r : triple_unsigned) return triple_unsigned;

  -- 5.5.3 "/" Operator - Triple unsigned and natural:

  function "/" (l : triple_unsigned; r : natural) return unsigned;
  function "/" (l : triple_unsigned; r : natural) return triple_unsigned;
  function "/" (l : natural; r : triple_unsigned) return unsigned;
  function "/" (l : natural; r : triple_unsigned) return triple_unsigned;

  -- 5.5.4 "/" Operator - Triple signed and natural:

  function "/" (l : triple_signed; r : natural) return signed;
  function "/" (l : triple_signed; r : natural) return triple_signed;
  function "/" (l : natural; r : triple_signed) return signed;
  function "/" (l : natural; r : triple_signed) return triple_signed;

  -- "/" Operator for triple_integer

  --function "/" (l: integer; r: integer) return integer;
  function "/" (l : integer; r : integer) return triple_integer;
  function "/" (l : integer; r : triple_integer) return integer;
  function "/" (l : integer; r : triple_integer) return triple_integer;
  function "/" (l : triple_integer; r : integer) return integer;
  function "/" (l : triple_integer; r : integer) return triple_integer;
  function "/" (l : triple_integer; r : triple_integer) return integer;
  function "/" (l : triple_integer; r : triple_integer) return triple_integer;

-- Constant definition

  constant TRIPLE_ZERO : triple_logic := triple('0');
  constant TRIPLE_ONE  : triple_logic := triple('1');

end triple_logic_pkg;

-----------------------------------------------------------
--  Development of package functions                     --
-----------------------------------------------------------

package body triple_logic_pkg is

-- 1. Helper functions

  -- 1.0. MAX function

  function MAX(left, right : integer) return integer is
  begin
    if left > right then return left;
    else return right;
    end if;
  end function;

-- 2. Domain crossing functions 

  -- 2.1 Vote and triple for std_logic/triple_logic

  function vote (triple : triple_logic) return std_logic is
    variable and_result : triple_logic;
    variable or_bc      : std_logic;
    variable ret        : std_logic;
  begin
    and_result.a := triple.a and triple.b;
    and_result.b := triple.b and triple.c;
    and_result.c := triple.a and triple.c;
    or_bc        := and_result.b or and_result.c;  -- We can't do "a OR b OR c" because it is ambiguous with the multiple overloaded ORs
    ret          := and_result.a or or_bc;
    return ret;
  end function;

  function triple (single : std_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := single;
    ret.b := single;
    ret.c := single;
    return ret;
  end function;

  -- 2.2 Vote and triple for std_logic_vector/triple_logic_vector

  function vote (triple : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(triple'range);
  begin
    for i in triple'range loop
      ret(i) := vote(triple(i));
    end loop;
    return ret;
  end function;

  function triple (single : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(single'range);
  begin
    for i in single'range loop
      ret(i) := triple(single(i));
    end loop;
    return ret;
  end function;

  -- 2.3 Vote and triple for signed/triple_signed

  function vote (triple : triple_signed) return signed is
    variable ret : signed(triple'range);
  begin
    for i in triple'range loop
      ret(i) := vote(triple(i));
    end loop;
    return ret;
  end function;

  function triple (single : signed) return triple_signed is
    variable ret : triple_signed(single'range);
    variable i   : integer;
  begin

    for i in single'range loop
      ret(i) := triple(single(i));
    end loop;
    return ret;
  end function;

  -- 2.4 Vote and triple for unsigned/triple_unsigned

  function vote (triple : triple_unsigned) return unsigned is
    variable ret : unsigned(triple'range);
  begin
    for i in triple'range loop
      ret(i) := vote(triple(i));
    end loop;
    return ret;
  end function;

  function triple (single : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(single'range);
  begin
    for i in single'range loop
      ret(i) := triple(single(i));
    end loop;
    return ret;
  end function;

  -- 2.5 Vote and triple for triple_integer

  function vote (triple : triple_integer) return integer is
    variable ret : integer;
  begin
    if triple.a = triple.b then
      ret := triple.a;
    elsif triple.b = triple.c then
      ret := triple.b;
    else  -- assuming one SEU, b has an error: return c
      ret := triple.c;
    end if;
    return ret;
  end function;

  function triple (single : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret.a := single;
    ret.b := single;
    ret.c := single;
    return ret;
  end function;

-- 2. Overload logic operators:

  -- 2.1 AND-GATES:

  -- 2.1.0 Function "and" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.1.1 Function "and" (l, r: std_logic) return triple_logic:

  function "and" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l and r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.1.2 Function "and" (l: std_logic; r: triple_logic) return std_logic:

  function "and" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l and d;
    return ret;
  end function;

  -- 2.1.3 Function "and" (l: std_logic; r: triple_logic) return triple_logic:

  function "and" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a and r.a;
    ret.b := i.b and r.b;
    ret.c := i.c and r.c;
    return ret;
  end function;

  -- 2.1.4 Function "and" (l: triple_logic; r: std_logic) return std_logic:

  function "and" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i and r;
    return ret;
  end function;

  -- 2.1.5 Function "and" (l: triple_logic; r: std_logic) return triple_logic:

  function "and" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a and d.a;
    ret.b := l.b and d.b;
    ret.c := l.c and d.c;
    return ret;
  end function;

  -- 2.1.6 Function "and" (l, r: triple_logic) return std_logic:

  function "and" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a and r.a;
    o.b := l.b and r.b;
    o.c := l.c and r.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.1.7 Function "and" (l, r: triple_logic) return triple_logic:

  function "and" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a and r.a;
    ret.b := l.b and r.b;
    ret.c := l.c and r.c;
    return ret;
  end function;

  -- AND gates for vector types:

  --function "and" (l, r: std_logic_vector) return std_logic_vector;  -- Defined in ieee.std_logic_1164

  function "and" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l and r);
    return ret;
  end function;

  function "and" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and vote(r);
    return ret;
  end function;

  function "and" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) and r;
    return ret;
  end function;

  function "and" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) and r;
    return ret;
  end function;

  function "and" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and triple(r);
    return ret;
  end function;

  function "and" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l and r);
    return ret;
  end function;

  function "and" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a;
      ret(i).b := l(i).b;
      ret(i).c := l(i).c;
    end loop;
    return ret;
  end function;

  -- AND with triple_unsigned

  --function "and" (l, r : unsigned) return unsigned;

  function "and" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l and r);
    return ret;
  end function;

  function "and" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and vote(r);
    return ret;
  end function;

  function "and" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) and r;
    return ret;
  end function;

  function "and" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) and r;
    return ret;
  end function;

  function "and" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and triple(r);
    return ret;
  end function;

  function "and" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l and r);
    return ret;
  end function;

  function "and" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a and r(i).a;
      ret(i).b := l(i).b and r(i).b;
      ret(i).c := l(i).c and r(i).c;
    end loop;
    return ret;
  end function;

  -- AND with triple_signed

  --function "and" (l, r: signed) return signed;

  function "and" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l and r);
    return ret;
  end function;

  function "and" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and vote(r);
    return ret;
  end function;

  function "and" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) and r;
    return ret;
  end function;

  function "and" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) and r;
    return ret;
  end function;

  function "and" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l and triple(r);
    return ret;
  end function;

  function "and" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l and r);
    return ret;
  end function;

  function "and" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a and r(i).a;
      ret(i).b := l(i).b and r(i).b;
      ret(i).c := l(i).c and r(i).c;
    end loop;
    return ret;
  end function;

  -- 2.2 NAND GATES:

  -- 2.2.0 Function "nand" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.2.1 Function "nand" (l, r: std_logic) return triple_logic:

  function "nand" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l nand r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.2.2 Function "nand" (l: std_logic; r: triple_logic) return std_logic:

  function "nand" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l nand d;
    return ret;
  end function;

  -- 2.2.3 Function "nand" (l: std_logic; r: triple_logic) return triple_logic:

  function "nand" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a nand r.a;
    ret.b := i.b nand r.b;
    ret.c := i.c nand r.c;
    return ret;
  end function;

  -- 2.2.4 Function "nand" (l: triple_logic; r: std_logic) return std_logic:

  function "nand" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i nand r;
    return ret;
  end function;

  -- 2.2.5 Function "nand" (l: triple_logic; r: std_logic) return triple_logic:

  function "nand" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a nand d.a;
    ret.b := l.b nand d.b;
    ret.c := l.c nand d.c;
    return ret;
  end function;

  -- 2.2.6 Function "nand" (l, r: triple_logic) return std_logic:

  function "nand" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a nand r.a;
    o.b := l.b nand r.b;
    o.c := l.c nand r.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.2.7 Function "nand" (l, r: triple_logic) return triple_logic:

  function "nand" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a nand r.a;
    ret.b := l.b nand r.b;
    ret.c := l.c nand r.c;
    return ret;
  end function;

  -- NAND gates for vector types:

  --function "nand" (l, r: std_logic_vector) return std_logic_vector;

  function "nand" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nand r);
    return ret;
  end function;

  function "nand" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand vote(r);
    return ret;
  end function;

  function "nand" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand triple(r);
    return ret;
  end function;

  function "nand" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nand r);
    return ret;
  end function;

  function "nand" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nand r(i).a;
      ret(i).b := l(i).b nand r(i).b;
      ret(i).c := l(i).c nand r(i).c;
    end loop;
    return ret;
  end function;

  -- NAND with triple_unsigned

  --function "nand" (l, r: unsigned) return unsigned;

  function "nand" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nand r);
    return ret;
  end function;

  function "nand" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand vote(r);
    return ret;
  end function;

  function "nand" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand triple(r);
    return ret;
  end function;

  function "nand" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nand r);
    return ret;
  end function;

  function "nand" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nand r(i).a;
      ret(i).b := l(i).b nand r(i).b;
      ret(i).c := l(i).c nand r(i).c;
    end loop;
    return ret;
  end function;

  -- NAND with triple_signed

  --function "nand" (l, r: signed) return signed;

  function "nand" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nand r);
    return ret;
  end function;

  function "nand" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand vote(r);
    return ret;
  end function;

  function "nand" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nand r;
    return ret;
  end function;

  function "nand" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nand triple(r);
    return ret;
  end function;

  function "nand" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nand r);
    return ret;
  end function;

  function "nand" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nand r(i).a;
      ret(i).b := l(i).b nand r(i).b;
      ret(i).c := l(i).c nand r(i).c;
    end loop;
    return ret;
  end function;


  -- 2.3 OR GATES:

  -- 2.3.0 Function "or" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.3.1 Function "or" (l, r: std_logic) return triple_logic:

  function "or" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l or r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.3.2 Function "or" (l: std_logic; r: triple_logic) return std_logic:

  function "or" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l or d;
    return ret;
  end function;

  -- 2.3.3 Function "or" (l: std_logic; r: triple_logic) return triple_logic:

  function "or" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a or r.a;
    ret.b := i.b or r.b;
    ret.c := i.c or r.c;
    return ret;
  end function;

  -- 2.3.4 Function "or" (l: triple_logic; r: std_logic) return std_logic:

  function "or" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i or r;
    return ret;
  end function;

  -- 2.3.5 Function "or" (l: triple_logic; r: std_logic) return triple_logic:

  function "or" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a or d.a;
    ret.b := l.b or d.b;
    ret.c := l.c or d.c;
    return ret;
  end function;

  -- 2.3.6 Function "or" (l, r: triple_logic) return std_logic:

  function "or" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a or r.a;
    o.b := l.b or r.b;
    o.c := l.c or r.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.3.7 Function "or" (l, r: triple_logic) return triple_logic:

  function "or" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a or r.a;
    ret.b := l.b or r.b;
    ret.c := l.c or r.c;
    return ret;
  end function;

  -- OR gates for vector types:

  --function "or" (l, r: std_logic_vector) return std_logic_vector;
  function "or" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l or r);
    return ret;
  end function;

  function "or" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or vote(r);
    return ret;
  end function;

  function "or" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) or r;
    return ret;
  end function;

  function "or" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) or r;
    return ret;
  end function;

  function "or" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or triple(r);
    return ret;
  end function;

  function "or" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l or r);
    return ret;
  end function;

  function "or" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a or r(i).a;
      ret(i).b := l(i).b or r(i).b;
      ret(i).c := l(i).c or r(i).c;
    end loop;
    return ret;
  end function;

  -- OR with triple_unsigned

  --function "or" (l, r: unsigned) return unsigned;

  function "or" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l or r);
    return ret;
  end function;

  function "or" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or vote(r);
    return ret;
  end function;

  function "or" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) or r;
    return ret;
  end function;

  function "or" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) or r;
    return ret;
  end function;

  function "or" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or triple(r);
    return ret;
  end function;

  function "or" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l or r);
    return ret;
  end function;

  function "or" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a or r(i).a;
      ret(i).b := l(i).b or r(i).b;
      ret(i).c := l(i).c or r(i).c;
    end loop;
    return ret;
  end function;

  -- OR with triple_signed

  --function "or" (l, r: signed) return signed;

  function "or" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l or r);
    return ret;
  end function;

  function "or" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or vote(r);
    return ret;
  end function;

  function "or" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) or r;
    return ret;
  end function;

  function "or" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) or r;
    return ret;
  end function;

  function "or" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l or triple(r);
    return ret;
  end function;

  function "or" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l or r);
    return ret;
  end function;

  function "or" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a or r(i).a;
      ret(i).b := l(i).b or r(i).b;
      ret(i).c := l(i).c or r(i).c;
    end loop;
    return ret;
  end function;

  -- 2.4 NOR GATES:

  -- 2.4.0 Function "nor" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.4.1 Function "nor" (l, r: std_logic) return triple_logic:

  function "nor" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l nor r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.4.2 Function "nor" (l: std_logic; r: triple_logic) return std_logic:

  function "nor" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l nor d;
    return ret;
  end function;

  -- 2.4.3 Function "nor" (l: std_logic; r: triple_logic) return triple_logic:

  function "nor" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a nor r.a;
    ret.b := i.b nor r.b;
    ret.c := i.c nor r.b;
    return ret;
  end function;

  -- 2.4.4 Function "nor" (l: triple_logic; r: std_logic) return std_logic:

  function "nor" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i nor r;
    return ret;
  end function;

  -- 2.4.5 Function "nor" (l: triple_logic; r: std_logic) return triple_logic:

  function "nor" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a nor d.a;
    ret.b := l.b nor d.b;
    ret.c := l.c nor d.b;
    return ret;
  end function;

  -- 2.4.6 Function "nor" (l, r: triple_logic) return std_logic:

  function "nor" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a nor r.a;
    o.b := l.b nor r.b;
    o.c := l.c nor r.b;
    ret := vote(o);
    return ret;
  end function;

  -- 2.4.7 Function "nor" (l, r: triple_logic) return triple_logic:

  function "nor" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a nor r.a;
    ret.b := l.b nor r.b;
    ret.c := l.c nor r.b;
    return ret;
  end function;

  -- NOR gates for vector types:

  --function "nor" (l, r: std_logic_vector) return std_logic_vector;

  function "nor" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nor r);
    return ret;
  end function;

  function "nor" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor vote(r);
    return ret;
  end function;

  function "nor" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor triple(r);
    return ret;
  end function;

  function "nor" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nor r);
    return ret;
  end function;

  function "nor" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nor r(i).a;
      ret(i).b := l(i).b nor r(i).b;
      ret(i).c := l(i).c nor r(i).c;
    end loop;
    return ret;
  end function;

  -- NOR with triple_unsigned

  --function "nor" (l, r: unsigned) return unsigned;

  function "nor" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nor r);
    return ret;
  end function;

  function "nor" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor vote(r);
    return ret;
  end function;

  function "nor" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor triple(r);
    return ret;
  end function;

  function "nor" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nor r);
    return ret;
  end function;

  function "nor" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nor r(i).a;
      ret(i).b := l(i).b nor r(i).b;
      ret(i).c := l(i).c nor r(i).c;
    end loop;
    return ret;
  end function;

  -- NOR with triple_signed

  --function "nor" (l, r: signed) return signed;

  function "nor" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l nor r);
    return ret;
  end function;

  function "nor" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor vote(r);
    return ret;
  end function;

  function "nor" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) nor r;
    return ret;
  end function;

  function "nor" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l nor triple(r);
    return ret;
  end function;

  function "nor" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l nor r);
    return ret;
  end function;

  function "nor" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a nor r(i).a;
      ret(i).b := l(i).b nor r(i).b;
      ret(i).c := l(i).c nor r(i).c;
    end loop;
    return ret;
  end function;


  -- 2.5 XOR GATES:

  -- 2.5.0 Function "xor" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.5.1 Function "xor" (l, r: std_logic) return triple_logic:

  function "xor" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l xor r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.5.2 Function "xor" (l: std_logic; r: triple_logic) return std_logic:

  function "xor" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l xor d;
    return ret;
  end function;

  -- 2.5.3 Function "xor" (l: std_logic; r: triple_logic) return triple_logic:

  function "xor" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a xor r.a;
    ret.b := i.b xor r.b;
    ret.c := i.c xor r.c;
    return ret;
  end function;

  -- 2.5.4 Function "xor" (l: triple_logic; r: std_logic) return std_logic:

  function "xor" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i xor r;
    return ret;
  end function;

  -- 2.5.5 Function "xor" (l: triple_logic; r: std_logic) return triple_logic:

  function "xor" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a xor d.a;
    ret.b := l.b xor d.b;
    ret.c := l.c xor d.c;
    return ret;
  end function;

  -- 2.5.6 Function "xor" (l, r: triple_logic) return std_logic:

  function "xor" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a xor r.a;
    o.b := l.b xor r.b;
    o.c := l.c xor r.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.5.7 Function "xor" (l, r: triple_logic) return triple_logic:

  function "xor" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a xor r.a;
    ret.b := l.b xor r.b;
    ret.c := l.c xor r.c;
    return ret;
  end function;

  -- XOR gates for vector types:

  --function "xor" (l, r: std_logic_vector) return std_logic_vector;
  function "xor" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xor r);
    return ret;
  end function;

  function "xor" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor vote(r);
    return ret;
  end function;

  function "xor" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor triple(r);
    return ret;
  end function;

  function "xor" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xor r);
    return ret;
  end function;

  function "xor" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xor r(i).a;
      ret(i).b := l(i).b xor r(i).b;
      ret(i).c := l(i).c xor r(i).c;
    end loop;
    return ret;
  end function;

  -- XOR with triple_unsigned

  --function "xor" (l, r: unsigned) return unsigned;

  function "xor" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xor r);
    return ret;
  end function;

  function "xor" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor vote(r);
    return ret;
  end function;

  function "xor" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor triple(r);
    return ret;
  end function;

  function "xor" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xor r);
    return ret;
  end function;

  function "xor" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xor r(i).a;
      ret(i).b := l(i).b xor r(i).b;
      ret(i).c := l(i).c xor r(i).c;
    end loop;
    return ret;
  end function;


  -- XOR with triple_signed

  --function "xor" (l, r: signed) return signed;

  function "xor" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xor r);
    return ret;
  end function;

  function "xor" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor vote(r);
    return ret;
  end function;

  function "xor" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xor r;
    return ret;
  end function;

  function "xor" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xor triple(r);
    return ret;
  end function;

  function "xor" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xor r);
    return ret;
  end function;

  function "xor" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xor r(i).a;
      ret(i).b := l(i).b xor r(i).b;
      ret(i).c := l(i).c xor r(i).c;
    end loop;
    return ret;
  end function;
  -- 2.6 XNOR GATES:

  -- 2.6.0 Function "xnor" (l, r: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.6.1 Function "xnor" (l, r: std_logic) return triple_logic:

  function "xnor" (l, r : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := l xnor r;
    ret := triple(o);
    return ret;
  end function;

  -- 2.6.2 Function "xnor" (l: std_logic; r: triple_logic) return std_logic:

  function "xnor" (l : std_logic; r : triple_logic) return std_logic is
    variable d   : std_logic;
    variable ret : std_logic;
  begin
    d   := vote(r);
    ret := l xnor d;
    return ret;
  end function;

  -- 2.6.3 Function "xnor" (l: std_logic; r: triple_logic) return triple_logic:

  function "xnor" (l : std_logic; r : triple_logic) return triple_logic is
    variable i   : triple_logic;
    variable ret : triple_logic;
  begin
    i     := triple(l);
    ret.a := i.a xnor r.a;
    ret.b := i.b xnor r.b;
    ret.c := i.c xnor r.c;
    return ret;
  end function;

  -- 2.6.4 Function "xnor" (l: triple_logic; r: std_logic) return std_logic:

  function "xnor" (l : triple_logic; r : std_logic) return std_logic is
    variable i   : std_logic;
    variable ret : std_logic;
  begin
    i   := vote(l);
    ret := i xnor r;
    return ret;
  end function;

  -- 2.6.5 Function "xnor" (l: triple_logic; r: std_logic) return triple_logic:

  function "xnor" (l : triple_logic; r : std_logic) return triple_logic is
    variable d   : triple_logic;
    variable ret : triple_logic;
  begin
    d     := triple(r);
    ret.a := l.a xnor d.a;
    ret.b := l.b xnor d.b;
    ret.c := l.c xnor d.c;
    return ret;
  end function;

  -- 2.6.6 Function "xnor" (l, r: triple_logic) return std_logic:

  function "xnor" (l, r : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := l.a xnor r.a;
    o.b := l.b xnor r.b;
    o.c := l.c xnor r.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.6.7 Function "xnor" (l, r: triple_logic) return triple_logic:

  function "xnor" (l, r : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := l.a xnor r.a;
    ret.b := l.b xnor r.b;
    ret.c := l.c xnor r.c;
    return ret;
  end function;

  -- AND gates for vector types:

  --function "xnor" (l, r: std_logic_vector) return std_logic_vector;
  function "xnor" (l, r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xnor r);
    return ret;
  end function;

  function "xnor" (l : std_logic_vector; r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor vote(r);
    return ret;
  end function;

  function "xnor" (l : std_logic_vector; r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_logic_vector; r : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_logic_vector; r : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor triple(r);
    return ret;
  end function;

  function "xnor" (l, r : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xnor r);
    return ret;
  end function;

  function "xnor" (l, r : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xnor r(i).a;
      ret(i).b := l(i).b xnor r(i).b;
      ret(i).c := l(i).c xnor r(i).c;
    end loop;
    return ret;
  end function;

  -- XNOR with triple_unsigned

  --function "xnor" (l, r: unsigned) return unsigned;

  function "xnor" (l, r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xnor r);
    return ret;
  end function;

  function "xnor" (l : unsigned; r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor vote(r);
    return ret;
  end function;

  function "xnor" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_unsigned; r : unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor triple(r);
    return ret;
  end function;

  function "xnor" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xnor r);
    return ret;
  end function;

  function "xnor" (l, r : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xnor r(i).a;
      ret(i).b := l(i).b xnor r(i).b;
      ret(i).c := l(i).c xnor r(i).c;
    end loop;
    return ret;
  end function;


  -- XNOR with triple_signed

  --function "xnor" (l, r: signed) return signed;

  function "xnor" (l, r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l xnor r);
    return ret;
  end function;

  function "xnor" (l : signed; r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor vote(r);
    return ret;
  end function;

  function "xnor" (l : signed; r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := triple(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_signed; r : signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l) xnor r;
    return ret;
  end function;

  function "xnor" (l : triple_signed; r : signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := l xnor triple(r);
    return ret;
  end function;

  function "xnor" (l, r : triple_signed) return signed is
    variable ret : signed(MAX(l'length, r'length)-1 downto 0);
  begin
    ret := vote(l xnor r);
    return ret;
  end function;

  function "xnor" (l, r : triple_signed) return triple_signed is
    variable ret : triple_signed(MAX(l'length, r'length)-1 downto 0);
  begin
    for i in l'range loop
      ret(i).a := l(i).a xnor r(i).a;
      ret(i).b := l(i).b xnor r(i).b;
      ret(i).c := l(i).c xnor r(i).c;
    end loop;
    return ret;
  end function;
  -- 2.7 NOT GATES:

  -- 2.7.0 Function "not" (l: std_logic) return std_logic; -- Defined in ieee.std_logic_1164

  -- 2.7.1 Function "not" (l: std_logic) return triple_logic:

  function "not" (l : std_logic) return triple_logic is
    variable o   : std_logic;
    variable ret : triple_logic;
  begin
    o   := not l;
    ret := triple(o);
    return ret;
  end function;

  -- 2.7.2 Function "not" (l: triple_logic) return std_logic:

  function "not" (l : triple_logic) return std_logic is
    variable o   : triple_logic;
    variable ret : std_logic;
  begin
    o.a := not l.a;
    o.b := not l.b;
    o.c := not l.c;
    ret := vote(o);
    return ret;
  end function;

  -- 2.7.3 Function "not" (l: triple_logic) return triple_logic:

  function "not" (l : triple_logic) return triple_logic is
    variable ret : triple_logic;
  begin
    ret.a := not l.a;
    ret.b := not l.b;
    ret.c := not l.c;
    return ret;
  end function;

  -- NOT gates for vector types:

--function "not" (l: std_logic_vector)  return std_logic_vector;  -- Defined in ieee.std_logic_vector_1164

  function "not" (l : std_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(l'range);
  begin
    ret := triple(not l);
    return ret;
  end function;

  function "not" (l : triple_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(l'range);
  begin
    ret := not vote(l);
    return ret;
  end function;

  function "not" (l : triple_logic_vector) return triple_logic_vector is
    variable ret : triple_logic_vector(l'range);
  begin
    for i in l'range loop
      ret(i) := not l(i);
    end loop;
    return ret;
  end function;

  -- NOT with triple_unsigned

  function "not" (l : unsigned) return triple_unsigned is
    variable ret : triple_unsigned(l'range);
  begin
    ret := triple(not l);
    return ret;
  end function;

  function "not" (l : triple_unsigned) return unsigned is
    variable ret : unsigned(l'range);
  begin
    ret := not vote(l);
    return ret;
  end function;

  function "not" (l : triple_unsigned) return triple_unsigned is
    variable ret : triple_unsigned(l'range);
  begin
    for i in l'range loop
      ret(i) := not l(i);
    end loop;
    return ret;
  end function;

  -- NOT with triple_signed

  function "not" (l : signed) return triple_signed is
    variable ret : triple_signed(l'range);
  begin
    ret := triple(not l);
    return ret;
  end function;

  function "not" (l : triple_signed) return signed is
    variable ret : signed(l'range);
  begin
    ret := not vote(l);
    return ret;
  end function;

  function "not" (l : triple_signed) return triple_signed is
    variable ret : triple_signed(l'range);
  begin
    for i in l'range loop
      ret(i) := not l(i);
    end loop;
    return ret;
  end function;

  -- 3. Comparison Operators:

  -- 3.1 "=" Operator:

  -- 3.1.1 "=" Operator (l:triple_logic; r:std_logic)
  function "=" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) = r);
    return ret;
  end function;

  -- 3.1.2 "=" Operator (l:std_logic; r:triple_logic):

  function "=" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l = vote(r));
    return ret;
  end function;

  -- 3.1.3 "=" Operator (l:triple_logic; r:triple_logic):

  function "=" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all bits to be equal:
    -- return true if two values match
    --if ((l.a = r.a) AND (l.b = r.b)) then
    --  ret := true;
    --elsif (l.a = r.a) AND (l.c = r.c) then
    --  ret := true;
    --elsif (l.b = r.b) AND (l.c = r.c) then
    --  ret := true;
    --else
    --  ret := false;
    --end if;
    -- The approach commented above doesn't work because
    -- if l = 001 and r = 110, the three bits are different, but
    -- if l = 001 and r = 011, two bits are equal
    ret := vote (l) = vote (r);
    return ret;
  end function;


  function "=" (l : triple_logic_vector; r : std_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) = r);
    return ret;
  end function;

  function "=" (l : std_logic_vector; r : triple_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := (l = vote(r));
    return ret;
  end function;

  function "=" (l : triple_logic_vector; r : triple_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := true;
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '=': operands of different sizes" severity failure;
    for i in l'range loop
      if((l(i) = r(i)) = false) then
        ret := false;
      end if;
    end loop;
    return ret;
  end function;


  function "=" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) = r);
    return ret;
  end function;

  function "=" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := (l = vote(r));
    return ret;
  end function;

  function "=" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := true;
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '=': operands of different sizes" severity failure;
    for i in l'range loop
      if((l(i) = r(i)) = false) then
        ret := false;
      end if;
    end loop;
    return ret;
  end function;

  function "=" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) = r);
    return ret;
  end function;

  function "=" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := (l = vote(r));
    return ret;
  end function;

  function "=" (l : triple_signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := true;
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '=': operands of different sizes" severity failure;
    for i in l'range loop
      if((l(i) = r(i)) = false) then
        ret := false;
      end if;
    end loop;
    return ret;
  end function;

  function "=" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) = r);
    return ret;
  end function;

  function "=" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l = vote(r));
    return ret;
  end function;

  function "=" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all values to be equal:
    -- return true if two values match
    if ((l.a = r.a) and (l.b = r.b)) then
      ret := true;
    elsif (l.a = r.a) and (l.c = r.c) then
      ret := true;
    elsif (l.b = r.b) and (l.c = r.c) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  -- 3.2 "<" Operator:

  -- 3.2.1 "<" Operator (l:triple_logic; r:std_logic):

  function "<" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) < r);
    return ret;
  end function;

  -- 3.2.2 "<" Operator (l:std_logic; r:triple_logic):

  function "<" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l < vote(r));
    return ret;
  end function;

  -- 3.2.3 "<" Operator (l:triple_logic; r:triple_logic):

  function "<" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all values to be lower:
    -- return true if two values are lower
    --if ((l.a < r.a) AND (l.b < r.b)) then
    --  ret := true;
    --elsif (l.a < r.a) AND (l.c < r.c) then
    --  ret := true;
    --elsif (l.b < r.b) AND (l.c < r.c) then
    --  ret := true;
    --else
    --  ret := false;
    --end if;
    -- As in the = operation, this aproach does not work for triple_logic since
    -- the order of the bits would matter, and it shouldn't
    ret := vote(l) < vote(r);
    return ret;
  end function;


  -- 3.3 ">" Operator:

  -- 3.3.1 ">" Operator (l:triple_logic; r: std_logic):

  function ">" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) > r);
    return ret;
  end function;

  -- 3.3.2 ">" Operator (l:std_logic; r:triple_logic):

  function ">" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l > vote(r));
    return ret;
  end function;

  -- 3.3.3 ">" Operator (l:triple_logic; r:triple_logic):

  function ">" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all values to be greater:
    -- return true if two values are greater
    --if ((l.a > r.a) AND (l.b > r.b)) then
    --  ret := true;
    --elsif (l.a > r.a) AND (l.c > r.c) then
    --  ret := true;
    --elsif (l.b > r.b) AND (l.c > r.c) then
    --  ret := true;
    --else
    --  ret := false;
    --end if;
    -- As in the = operation, this aproach does not work for triple_logic since
    -- the order of the bits would matter, and it shouldn't
    ret := vote(l) > vote(r);
    return ret;
  end function;


  function ">" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) > r;
    return ret;
  end function;

  function ">" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := l > vote(r);
    return ret;
  end function;

  function ">" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable la, lb, lc : unsigned (l'range);
    variable ra, rb, rc : unsigned (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be greater:
    -- return true if two values are greater
    if ((la > ra) and (lb > rb)) then
      ret := true;
    elsif (la > ra) and (lc > rc) then
      ret := true;
    elsif (lb > rb) and (lc > rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;

  end function;


  function ">" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) > r;
    return ret;
  end function;

  function ">" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := l > vote(r);
    return ret;
  end function;

  function ">" (l : triple_signed; r : triple_signed) return boolean is
    variable la, lb, lc : signed (l'range);
    variable ra, rb, rc : signed (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be greater:
    -- return true if two values are greater
    if ((la > ra) and (lb > rb)) then
      ret := true;
    elsif (la > ra) and (lc > rc) then
      ret := true;
    elsif (lb > rb) and (lc > rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;

  function ">" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) > r);
    return ret;
  end function;

  function ">" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l > vote(r));
    return ret;
  end function;

  function ">" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all values to be greater:
    -- return true if two values are greater
    if ((l.a > r.a) and (l.b > r.b)) then
      ret := true;
    elsif (l.a > r.a) and (l.c > r.c) then
      ret := true;
    elsif (l.b > r.b) and (l.c > r.c) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  function "<" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) < r;
    return ret;
  end function;

  function "<" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := l < vote(r);
    return ret;
  end function;

  function "<" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable la, lb, lc : unsigned (l'range);
    variable ra, rb, rc : unsigned (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be lower:
    -- return true if two values are lower
    if ((la < ra) and (lb < rb)) then
      ret := true;
    elsif (la < ra) and (lc < rc) then
      ret := true;
    elsif (lb < rb) and (lc < rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  function "<" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) < r;
    return ret;
  end function;

  function "<" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := l < vote(r);
    return ret;
  end function;

  function "<" (l : triple_signed; r : triple_signed) return boolean is
    variable la, lb, lc : signed (l'range);
    variable ra, rb, rc : signed (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be lower:
    -- return true if two values are lower
    if ((la < ra) and (lb < rb)) then
      ret := true;
    elsif (la < ra) and (lc < rc) then
      ret := true;
    elsif (lb < rb) and (lc < rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
    ret := vote(l) < vote(r);
    return ret;
  end function;


  function "<" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) < r);
    return ret;
  end function;

  function "<" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l < vote(r));
    return ret;
  end function;

  function "<" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    -- Do not require all values to be lower:
    -- return true if two values are lower
    if ((l.a < r.a) and (l.b < r.b)) then
      ret := true;
    elsif (l.a < r.a) and (l.c < r.c) then
      ret := true;
    elsif (l.b < r.b) and (l.c < r.c) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  -- 3.4 "<=" Operator:

  -- 3.4.1 "<=" Operator (l:triple_logic; r: std_logic):

  function "<=" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) <= r);
    return ret;
  end function;

  -- 3.4.2 "<=" Operator (l:std_logic; r:triple_logic):

  function "<=" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l <= vote(r));
    return ret;
  end function;

  -- 3.4.3 "<=" Operator (l:triple_logic; r:triple_logic):

  function "<=" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) <= vote(r));
    return ret;
  end function;


  function "<=" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) <= r;
    return ret;
  end function;

  function "<=" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := l <= vote(r);
    return ret;
  end function;

  function "<=" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable la, lb, lc : unsigned (l'range);
    variable ra, rb, rc : unsigned (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be lower or equal:
    -- return true if two values are lower or equal
    if ((la <= ra) and (lb <= rb)) then
      ret := true;
    elsif (la <= ra) and (lc <= rc) then
      ret := true;
    elsif (lb <= rb) and (lc <= rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  function "<=" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) <= r;
    return ret;
  end function;

  function "<=" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := l <= vote(r);
    return ret;
  end function;

  function "<=" (l : triple_signed; r : triple_signed) return boolean is
    variable la, lb, lc : signed (l'range);
    variable ra, rb, rc : signed (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be lower or equal:
    -- return true if two values are lower or equal
    if ((la <= ra) and (lb <= rb)) then
      ret := true;
    elsif (la <= ra) and (lc <= rc) then
      ret := true;
    elsif (lb <= rb) and (lc <= rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;

  function "<=" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) <= r);
    return ret;
  end function;

  function "<=" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l <= vote(r));
    return ret;
  end function;

  function "<=" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    if ((l.a <= r.a) and (l.b <= r.b)) then
      ret := true;
    elsif (l.a <= r.a) and (l.c <= r.c) then
      ret := true;
    elsif (l.b <= r.b) and (l.c <= r.c) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  -- 3.5 ">=" Operator:

  -- 3.5.1 ">=" Operator (l:triple_logic; r: std_logic):

  function ">=" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) >= r);
    return ret;
  end function;

  -- 3.5.2 ">=" Operator (l:std_logic; r:triple_logic):

  function ">=" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l >= vote(r));
    return ret;
  end function;

  -- 3.5.3 ">=" Operator (l:triple_logic; r:triple_logic):

  function ">=" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) >= vote(r));
    return ret;
  end function;


  function ">=" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) >= r;
    return ret;
  end function;

  function ">=" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := l >= vote(r);
    return ret;
  end function;

  function ">=" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable la, lb, lc : unsigned (l'range);
    variable ra, rb, rc : unsigned (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be greater or equal:
    -- return true if two values are greater or equal
    if ((la >= ra) and (lb >= rb)) then
      ret := true;
    elsif (la >= ra) and (lc >= rc) then
      ret := true;
    elsif (lb >= rb) and (lc >= rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  function ">=" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := vote(l) >= r;
    return ret;
  end function;

  function ">=" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := l >= vote(r);
    return ret;
  end function;

  function ">=" (l : triple_signed; r : triple_signed) return boolean is
    variable la, lb, lc : signed (l'range);
    variable ra, rb, rc : signed (r'range);
    variable ret        : boolean;
  begin

    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    -- Do not require all values to be greater or equal:
    -- return true if two values are greater or equal
    if ((la >= ra) and (lb >= rb)) then
      ret := true;
    elsif (la >= ra) and (lc >= rc) then
      ret := true;
    elsif (lb >= rb) and (lc >= rc) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  function ">=" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) >= r);
    return ret;
  end function;

  function ">=" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l >= vote(r));
    return ret;
  end function;

  function ">=" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    if ((l.a >= r.a) and (l.b >= r.b)) then
      ret := true;
    elsif (l.a >= r.a) and (l.c >= r.c) then
      ret := true;
    elsif (l.b >= r.b) and (l.c >= r.c) then
      ret := true;
    else
      ret := false;
    end if;
    return ret;
  end function;


  -- 3.6 "/=" Operator:

  -- 3.6.1 "/=" Operator (l:triple_logic; r: std_logic):

  function "/=" (l : triple_logic; r : std_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) /= r);
    return ret;
  end function;

  -- 3.6.2 "/=" Operator (l:std_logic; r:triple_logic):

  function "/=" (l : std_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (l /= vote(r));
    return ret;
  end function;


  -- 3.6.3 "/=" Operator (l:triple_logic; r:triple_logic):

  function "/=" (l : triple_logic; r : triple_logic) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) /= vote(r));
    return ret;
  end function;


  function "/=" (l : triple_logic_vector; r : std_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : std_logic_vector; r : triple_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : triple_logic_vector; r : triple_logic_vector) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;



  function "/=" (l : triple_unsigned; r : unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : triple_unsigned; r : triple_unsigned) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : triple_signed; r : signed) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : triple_signed; r : triple_signed) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

  function "/=" (l : triple_integer; r : integer) return boolean is
    variable ret : boolean;
  begin
    ret := (vote(l) /= r);
    return ret;
  end function;

  function "/=" (l : integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := (l /= vote(r));
    return ret;
  end function;

  function "/=" (l : triple_integer; r : triple_integer) return boolean is
    variable ret : boolean;
  begin
    ret := not (l = r);
    return ret;
  end function;

-- 4. Arithmetic Operators:

  -- 4.2 "+" Operator:

  -- 4.2.1 "+" Operator - Signed Data:

  -- 4.2.1.1 "+" Operator (l, r: signed) return triple_signed:

  function "+" (l, r : signed) return triple_signed is
    variable o   : signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    o   := l + r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.2.1.2 "+" Operator (l: signed; r: triple_signed) return signed:

  function "+" (l : signed; r : triple_signed) return signed is
    variable d   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l + d;
    return ret;
  end function;

  -- 4.2.1.3 "+" Operator (l: signed; r: triple_signed) return triple_signed:

  function "+" (l : signed; r : triple_signed) return triple_signed is
    variable i   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i + r;
    return ret;
  end function;

  -- 4.2.1.4 "+" Operator (l: triple_signed; r: signed) return signed:

  function "+" (l : triple_signed; r : signed) return signed is
    variable i   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i + r;
    return ret;
  end function;

  -- 4.2.1.5 "+" Operator (l: triple_signed; r: signed) return triple_signed:

  function "+" (l : triple_signed; r : signed) return triple_signed is
    variable d   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l + d;
    return ret;
  end function;

  -- 4.2.1.6 "+" Operator (l, r: triple_signed) return signed:

  function "+" (l, r : triple_signed) return signed is
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    ret := vote(l + r);
    return ret;
  end function;

  -- 4.2.1.7 "+" Operator (l, r: triple_signed) return triple_signed:

  function "+" (l, r : triple_signed) return triple_signed is
    variable la, lb, lc       : signed (l'range);
    variable ra, rb, rc       : signed (l'range);
    variable reta, retb, retc : signed (l'range);
    variable ret              : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la + ra;
    retb := lb + rb;
    retc := lc + rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.2.2 "+" Operator - Unsigned Data:

  -- 4.2.2.1 "+" Operator (l, r: unsigned) return triple_unsigned:

  function "+" (l, r : unsigned) return triple_unsigned is
    variable o   : unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    o   := l + r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.2.2.2 "+" Operator (l: unsigned; r: triple_unsigned) return unsigned:

  function "+" (l : unsigned; r : triple_unsigned) return unsigned is
    variable d   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l + d;
    return ret;
  end function;

  -- 4.2.2.3 "+" Operator (l: unsigned; r: triple_unsigned) return triple_unsigned:

  function "+" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable i   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i + r;
    return ret;
  end function;

  -- 4.2.2.4 "+" Operator (l: triple_unsigned; r: unsigned) return unsigned:

  function "+" (l : triple_unsigned; r : unsigned) return unsigned is
    variable i   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i + r;
    return ret;
  end function;

  -- 4.2.2.5 "+" Operator (l: triple_unsigned; r: unsigned) return triple_unsigned:

  function "+" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable d   : triple_unsigned (r'range);
    variable ret : triple_unsigned(MAX(l'length, r'length)-1 downto 0);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l + d;
    return ret;
  end function;

  -- 4.2.2.6 "+" Operator (l, r: triple_unsigned) return unsigned:

  function "+" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned (max(l'length, r'length)-1 downto 0);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    ret := vote(l + r);
    return ret;
  end function;

  -- 4.2.2.7 "+" Operator (l, r: triple_unsigned) return triple_unsigned:

  function "+" (l, r : triple_unsigned) return triple_unsigned is
    variable la, lb, lc       : unsigned (l'range);
    variable ra, rb, rc       : unsigned (r'range);
    variable reta, retb, retc : unsigned (max(l'length, r'length)-1 downto 0);
    variable ret              : triple_unsigned (max(l'length, r'length)-1 downto 0);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '+': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
    end loop;

    for i in r'range loop
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la + ra;
    retb := lb + rb;
    retc := lc + rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.2.3 "+" Operator - triple_unsigned and natural:

  -- 4.2.3.1 "+" Operator (l:triple_unsigned; r:natural) return unsigned:

  function "+" (l : triple_unsigned; r : natural) return unsigned is
    variable i : unsigned(l'range);
  begin
    i := vote(l);
    return i + r;
  end function;

  -- 4.2.3.2 "+" Operator (l:triple_unsigned; r:natural) return triple_unsigned:

  function "+" (l : triple_unsigned; r : natural) return triple_unsigned is
    variable d : triple_unsigned(l'range);
  begin
    d := triple(to_unsigned(r, l'length));
    return l + d;
  end function;

  -- 4.2.3.3 "+" Operator (l : natural; r: triple_unsigned) return unsigned:

  function "+" (l : natural; r : triple_unsigned) return unsigned is
    variable d : unsigned(r'range);
  begin
    d := vote(r);
    return l + d;
  end function;

  -- 4.2.3.4 "+" Operator (l : natural; r: triple_unsigned) return triple_unsigned:

  function "+" (l : natural; r : triple_unsigned) return triple_unsigned is
    variable i : triple_unsigned(r'range);
  begin
    i := triple(to_unsigned(l, r'length));
    return i + r;
  end function;

  -- 4.2.4 "+" Operator - Triple signed and natural:

  -- 4.2.4.1 "+" Operator (l : triple_signed; r: natural)return signed:

  function "+" (l : triple_signed; r : natural) return signed is
    variable i : signed(l'range);
  begin
    i := vote(l);
    return i + r;
  end function;

  -- 4.2.4.2 "+" Operator (l : triple_signed; r: natural) return triple_signed:

  function "+" (l : triple_signed; r : natural) return triple_signed is
    variable d : triple_signed(l'range);
  begin
    d := triple(to_signed(r, l'length));
    return l + d;
  end function;

  -- 4.2.4.3 "+" Operator (l : natural; r: triple_signed) return signed:

  function "+" (l : natural; r : triple_signed) return signed is
    variable d : signed(r'range);
  begin
    d := vote(r);
    return l + d;
  end function;

  -- 4.2.4.4 "+" Operator (l : natural; r: triple_signed) return triple_signed:

  function "+" (l : natural; r : triple_signed) return triple_signed is
    variable i : triple_signed(r'range);
  begin
    i := triple(to_signed(l, r'length));
    return i + r;
  end function;

  -- "+" triple_integer

  function "+" (l : integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l + r);
    return ret;
  end function;

  function "+" (l : integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := l + vote(r);
    return ret;
  end function;

  function "+" (l : integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l) + r;
    return ret;
  end function;

  function "+" (l : triple_integer; r : integer) return integer is
    variable ret : integer;
  begin
    ret := vote(l) + r;
    return ret;
  end function;

  function "+" (l : triple_integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := l + triple(r);
    return ret;
  end function;

  function "+" (l : triple_integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := vote (l + r);
    return ret;
  end function;

  function "+" (l : triple_integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret.a := l.a + r.a;
    ret.b := l.b + r.b;
    ret.c := l.c + r.c;
    return ret;
  end function;


  -- 4.3 "-" Operator:

  -- 4.3.1 "-" Operator - Signed Data:

  -- 4.3.1.1 "-" Operator (l, r: signed) return triple_signed:

  function "-" (l, r : signed) return triple_signed is
    variable o   : signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    o   := l - r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.3.1.2 "-" Operator (l: signed; r: triple_signed) return signed:

  function "-" (l : signed; r : triple_signed) return signed is
    variable d   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l - d;
    return ret;
  end function;

  -- 4.3.1.3 "-" Operator (l: signed; r: triple_signed) return triple_signed:

  function "-" (l : signed; r : triple_signed) return triple_signed is
    variable i   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i - r;
    return ret;
  end function;

  -- 4.3.1.4 "-" Operator (l: triple_signed; r: signed) return signed:

  function "-" (l : triple_signed; r : signed) return signed is
    variable i   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i - r;
    return ret;
  end function;

  -- 4.3.1.5 "-" Operator (l: triple_signed; r: signed) return triple_signed:

  function "-" (l : triple_signed; r : signed) return triple_signed is
    variable d   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l - d;
    return ret;
  end function;

  -- 4.3.1.6 "-" Operator (l, r: triple_signed) return signed:

  function "-" (l, r : triple_signed) return signed is
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    ret := vote(l - r);
    return ret;
  end function;

  -- 4.3.1.7 "-" Operator (l, r: triple_signed) return triple_signed:

  function "-" (l, r : triple_signed) return triple_signed is
    variable la, lb, lc       : signed (l'range);
    variable ra, rb, rc       : signed (l'range);
    variable reta, retb, retc : signed (l'range);
    variable ret              : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la - ra;
    retb := lb - rb;
    retc := lc - rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.3.2 "-" Operator - Unsigned Data:

  -- 4.3.2.1 "-" Operator (l, r: unsigned) return triple_unsigned:

  function "-" (l, r : unsigned) return triple_unsigned is
    variable o   : unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    o   := l - r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.3.2.2 "-" Operator (l: unsigned; r: triple_unsigned) return triple_unsigned:

  function "-" (l : unsigned; r : triple_unsigned) return unsigned is
    variable d   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l - d;
    return ret;
  end function;

  -- 4.3.2.3 "-" Operator (l: unsigned; r: triple_unsigned) return triple_unsigned:

  function "-" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable i   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i - r;
    return ret;
  end function;

  -- 4.3.2.4 "-" Operator (l: triple_unsigned; r: unsigned) return unsigned:

  function "-" (l : triple_unsigned; r : unsigned) return unsigned is
    variable i   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i - r;
    return ret;
  end function;

  -- 4.3.2.5 "-" Operator (l: triple_unsigned; r: unsigned) return triple_unsigned:

  function "-" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable d   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l - d;
    return ret;
  end function;

  -- 4.3.2.6 "-" Operator (l, r: triple_unsigned) return unsigned:

  function "-" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    ret := vote(l - r);
    return ret;
  end function;

  -- 4.3.2.7 "-" Operator (l, r: triple_unsigned) return triple_unsigned:

  function "-" (l, r : triple_unsigned) return triple_unsigned is
    variable la, lb, lc       : unsigned (l'range);
    variable ra, rb, rc       : unsigned (l'range);
    variable reta, retb, retc : unsigned (l'range);
    variable ret              : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '-': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la - ra;
    retb := lb - rb;
    retc := lc - rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.3.3 "-" Operator - triple_unsigned and natural:

  -- 4.3.3.1 "-" Operator (l:triple_unsigned; r:natural)return unsigned:

  function "-" (l : triple_unsigned; r : natural) return unsigned is
    variable i : unsigned(l'range);
  begin
    i := vote(l);
    return i - r;
  end function;

  -- 4.3.3.2 "-" Operator (l : triple_unsigned; r: natural) return triple_unsigned:

  function "-" (l : triple_unsigned; r : natural) return triple_unsigned is
    variable d : triple_unsigned(l'range);
  begin
    d := triple(to_unsigned(r, l'length));
    return l - d;
  end function;

  -- 4.3.3.3 "-" Operator (l : natural; r: triple_unsigned) return unsigned:

  function "-" (l : natural; r : triple_unsigned) return unsigned is
    variable d : unsigned(r'range);
  begin
    d := vote(r);
    return l - d;
  end function;

  -- 4.3.3.4 "-" Operator (l : natural; r: triple_unsigned) return triple_unsigned:

  function "-" (l : natural; r : triple_unsigned) return triple_unsigned is
    variable i : triple_unsigned(r'range);
  begin
    i := triple(to_unsigned(l, r'length));
    return i - r;
  end function;

  -- 4.3.4 "-" Operator - Triple signed and natural:

  -- 4.3.4.1 "-" Operator (l : triple_signed; r: natural) return signed:

  function "-" (l : triple_signed; r : natural) return signed is
    variable i : signed(l'range);
  begin
    i := vote(l);
    return i - r;
  end function;

  -- 4.3.4.2 "-" Operator (l : triple_signed; r: natural) return triple_signed:

  function "-" (l : triple_signed; r : natural) return triple_signed is
    variable d : triple_signed(l'range);
  begin
    d := triple(to_signed(r, l'length));
    return l - d;
  end function;

  -- 4.3.4.3 "-" Operator (l : natural; r: triple_signed) return signed:

  function "-" (l : natural; r : triple_signed) return signed is
    variable d : signed(r'range);
  begin
    d := vote(r);
    return l - d;
  end function;

  -- 4.3.4.4 "-" Operator (l : natural; r: triple_signed) return triple_signed:

  function "-" (l : natural; r : triple_signed) return triple_signed is
    variable i : triple_signed(r'range);
  begin
    i := triple(to_signed(l, r'length));
    return i - r;
  end function;

  -- "-" triple_integer

  function "-" (l : integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l - r);
    return ret;
  end function;

  function "-" (l : integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := l - vote(r);
    return ret;
  end function;

  function "-" (l : integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l) - r;
    return ret;
  end function;

  function "-" (l : triple_integer; r : integer) return integer is
    variable ret : integer;
  begin
    ret := vote(l) - r;
    return ret;
  end function;

  function "-" (l : triple_integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := l - triple(r);
    return ret;
  end function;

  function "-" (l : triple_integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := vote (l - r);
    return ret;
  end function;

  function "-" (l : triple_integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret.a := l.a - r.a;
    ret.b := l.b - r.b;
    ret.c := l.c - r.c;
    return ret;
  end function;


  -- 4.4 "*" Operator:

  -- 4.4.1 "*" Operator - Signed Data:

  -- 4.4.1.1 "*" Operator (l, r: signed) return triple_signed:

  function "*" (l, r : signed) return triple_signed is
    variable o   : signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    o   := l * r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.4.1.2 "*" Operator (l: signed; r: triple_signed) return signed:

  function "*" (l : signed; r : triple_signed) return signed is
    variable d   : signed (l'range);
    variable ret : signed (l'range);
  begin
    d   := vote(r);
    ret := l * d;
    return ret;
  end function;

  -- 4.4.1.3 "*" Operator (l: signed; r: triple_signed) return triple_signed:

  function "*" (l : signed; r : triple_signed) return triple_signed is
    variable i   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    i   := triple(l);
    ret := i * r;
    return ret;
  end function;

  -- 4.4.1.4 "*" Operator (l: triple_signed; r: signed) return signed:

  function "*" (l : triple_signed; r : signed) return signed is
    variable i   : signed (l'range);
    variable ret : signed (l'range);
  begin
    i   := vote(l);
    ret := i * r;
    return ret;
  end function;

  -- 4.4.1.5 "*" Operator (l: triple_signed; r: signed) return triple_signed:

  function "*" (l : triple_signed; r : signed) return triple_signed is
    variable d   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    d   := triple(r);
    ret := l * d;
    return ret;
  end function;

  -- 4.4.1.6 "*" Operator (l, r: triple_signed) return signed:

  function "*" (l, r : triple_signed) return signed is
    variable ret : signed (l'range);
  begin
    ret := vote(l * r);
    return ret;
  end function;

  -- 4.4.1.7 "*" Operator (l, r: triple_signed) return triple_signed:

  function "*" (l, r : triple_signed) return triple_signed is
    variable la, lb, lc       : signed (l'range);
    variable ra, rb, rc       : signed (l'range);
    variable reta, retb, retc : signed (l'range);
    variable ret              : triple_signed (l'range);
  begin
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la * ra;
    retb := lb * rb;
    retc := lc * rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.4.2 "*" Operator - Unsigned Data:

  -- 4.4.2.1 "*" Operator (l, r: unsigned) return triple_unsigned:

  function "*" (l, r : unsigned) return triple_unsigned is
    variable o   : unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    o   := l * r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.4.2.2 "*" Operator (l: unsigned; r: triple_unsigned) return unsigned:

  function "*" (l : unsigned; r : triple_unsigned) return unsigned is
    variable d   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    d   := vote(r);
    ret := l * d;
    return ret;
  end function;

  -- 4.4.2.3 "*" Operator (l: unsigned; r: triple_unsigned) return triple_unsigned:

  function "*" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable i   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    i   := triple(l);
    ret := i * r;
    return ret;
  end function;

  -- 4.4.2.4 "*" Operator (l: triple_unsigned; r: unsigned) return unsigned:

  function "*" (l : triple_unsigned; r : unsigned) return unsigned is
    variable i   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    i   := vote(l);
    ret := i * r;
    return ret;
  end function;

  -- 4.4.2.5 "*" Operator (l: triple_unsigned; r: unsigned) return triple_unsigned:

  function "*" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable d   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    d   := triple(r);
    ret := l * d;
    return ret;
  end function;

  -- 4.4.2.6 "*" Operator (l, r: triple_unsigned) return unsigned:

  function "*" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned (l'range);
  begin
    ret := vote(l * r);
    return ret;
  end function;

  -- 4.4.2.7 "*" Operator (l, r: triple_unsigned) return triple_unsigned:

  function "*" (l, r : triple_unsigned) return triple_unsigned is
    variable la, lb, lc       : unsigned (l'range);
    variable ra, rb, rc       : unsigned (l'range);
    variable reta, retb, retc : unsigned (l'range);
    variable ret              : triple_unsigned (l'range);
  begin
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la * ra;
    retb := lb * rb;
    retc := lc * rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.4.3 "*" Operator - triple_unsigned and natural:

  -- 4.4.3.1 "*" Operator (l:triple_unsigned; r:natural)return unsigned:

  function "*" (l : triple_unsigned; r : natural) return unsigned is
    variable i : unsigned(l'range);
  begin
    i := vote(l);
    return i * r;
  end function;

  -- 4.4.3.2 "*" Operator (l : triple_unsigned; r: natural) return triple_unsigned:

  function "*" (l : triple_unsigned; r : natural) return triple_unsigned is
    variable d : triple_unsigned(l'range);
  begin
    d := triple(to_unsigned(r, l'length));
    return l * d;
  end function;

  -- 4.4.3.3 "*" Operator (l : natural; r: triple_unsigned) return unsigned:

  function "*" (l : natural; r : triple_unsigned) return unsigned is
    variable d : unsigned(r'range);
  begin
    d := vote(r);
    return l * d;
  end function;

  -- 4.4.3.4 "*" Operator (l : natural; r: triple_unsigned) return triple_unsigned:

  function "*" (l : natural; r : triple_unsigned) return triple_unsigned is
    variable i : triple_unsigned(r'range);
  begin
    i := triple(to_unsigned(l, r'length));
    return i * r;
  end function;

  -- 4.4.4 "*" Operator - triple_signed and natural:

  -- 4.4.4.1 "*" Operator (l : triple_signed; r: natural) return signed:

  function "*" (l : triple_signed; r : natural) return signed is
    variable i : signed(l'range);
  begin
    i := vote(l);
    return i * r;
  end function;

  -- 4.4.4.2 "*" Operator (l : triple_signed; r: natural) return triple_signed:

  function "*" (l : triple_signed; r : natural) return triple_signed is
    variable d : triple_signed(l'range);
  begin
    d := triple(to_signed(r, l'length));
    return l * d;
  end function;

  -- 4.4.4.3 "*" Operator (l : natural; r: triple_signed) return signed:

  function "*" (l : natural; r : triple_signed) return signed is
    variable d : signed(r'range);
  begin
    d := vote(r);
    return l * d;
  end function;

  -- 4.4.4.4 "*" Operator (l : natural; r: triple_signed) return triple_signed

  function "*" (l : natural; r : triple_signed) return triple_signed is
    variable i : triple_signed(r'range);
  begin
    i := triple(to_signed(l, r'length));
    return i * r;
  end function;

  -- "*" triple_integer

  function "*" (l : integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l * r);
    return ret;
  end function;

  function "*" (l : integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := l * vote(r);
    return ret;
  end function;

  function "*" (l : integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l) * r;
    return ret;
  end function;

  function "*" (l : triple_integer; r : integer) return integer is
    variable ret : integer;
  begin
    ret := vote(l) * r;
    return ret;
  end function;

  function "*" (l : triple_integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := l * triple(r);
    return ret;
  end function;

  function "*" (l : triple_integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := vote (l * r);
    return ret;
  end function;

  function "*" (l : triple_integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret.a := l.a * r.a;
    ret.b := l.b * r.b;
    ret.c := l.c * r.c;
    return ret;
  end function;


  -- 4.5 "/" Operator:

  -- 4.5.1 "/" Operator - Signed Data:

  -- 4.5.1.1 "/" Operator (l, r: signed) return triple_signed:

  function "/" (l, r : signed) return triple_signed is
    variable o   : signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    o   := l / r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.5.1.2 "/" Operator (l: signed; r: triple_signed) return signed:

  function "/" (l : signed; r : triple_signed) return signed is
    variable d   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l / d;
    return ret;
  end function;

  -- 4.5.1.3 "/" Operator (l: signed; r: triple_signed) return triple_signed:

  function "/" (l : signed; r : triple_signed) return triple_signed is
    variable i   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i / r;
    return ret;
  end function;

  -- 4.5.1.4 "/" Operator (l: triple_signed; r: signed) return signed:

  function "/" (l : triple_signed; r : signed) return signed is
    variable i   : signed (l'range);
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i / r;
    return ret;
  end function;

  -- 4.5.1.5 "/" Operator (l: triple_signed; r: signed) return triple_signed:

  function "/" (l : triple_signed; r : signed) return triple_signed is
    variable d   : triple_signed (l'range);
    variable ret : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l / d;
    return ret;
  end function;

  -- 4.5.1.6 "/" Operator (l, r: triple_signed) return signed:

  function "/" (l, r : triple_signed) return signed is
    variable ret : signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    ret := vote(l / r);
    return ret;
  end function;

  -- 4.5.1.7 "/" Operator (l, r: triple_signed) return triple_signed:

  function "/" (l, r : triple_signed) return triple_signed is
    variable la, lb, lc       : signed (l'range);
    variable ra, rb, rc       : signed (l'range);
    variable reta, retb, retc : signed (l'range);
    variable ret              : triple_signed (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la / ra;
    retb := lb / rb;
    retc := lc / rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.5.2 "/" Operator - Unsigned Data:

  -- 4.5.2.1 "/" Operator (l, r: unsigned) return triple_unsigned:

  function "/" (l, r : unsigned) return triple_unsigned is
    variable o   : unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    o   := l / r;
    ret := triple(o);
    return ret;
  end function;

  -- 4.5.2.2 "/" Operator (l: unsigned; r: triple_unsigned) return unsigned:

  function "/" (l : unsigned; r : triple_unsigned) return unsigned is
    variable d   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    d   := vote(r);
    ret := l / d;
    return ret;
  end function;

  -- 4.5.2.3 "/" Operator (l: unsigned; r: triple_unsigned) return triple_unsigned:

  function "/" (l : unsigned; r : triple_unsigned) return triple_unsigned is
    variable i   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    i   := triple(l);
    ret := i / r;
    return ret;
  end function;

  -- 4.5.2.4 "/" Operator (l: triple_unsigned; r: unsigned) return unsigned:

  function "/" (l : triple_unsigned; r : unsigned) return unsigned is
    variable i   : unsigned (l'range);
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    i   := vote(l);
    ret := i / r;
    return ret;
  end function;

  -- 4.5.2.5 "/" Operator (l: triple_unsigned; r: unsigned) return triple_unsigned:

  function "/" (l : triple_unsigned; r : unsigned) return triple_unsigned is
    variable d   : triple_unsigned (l'range);
    variable ret : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    d   := triple(r);
    ret := l / d;
    return ret;
  end function;

  -- 4.5.2.6 "/" Operator (l, r: triple_unsigned) return unsigned:

  function "/" (l, r : triple_unsigned) return unsigned is
    variable ret : unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    ret := vote(l / r);
    return ret;
  end function;

  -- 4.5.2.7 "/" Operator (l, r: triple_unsigned) return triple_unsigned:

  function "/" (l, r : triple_unsigned) return triple_unsigned is
    variable la, lb, lc       : unsigned (l'range);
    variable ra, rb, rc       : unsigned (l'range);
    variable reta, retb, retc : unsigned (l'range);
    variable ret              : triple_unsigned (l'range);
  begin
    --assert (l'LENGTH = r'LENGTH) report "triple_logic '/': operands of different sizes" severity failure;
    for i in l'range loop
      la(i) := l(i).a;
      lb(i) := l(i).b;
      lc(i) := l(i).c;
      ra(i) := r(i).a;
      rb(i) := r(i).b;
      rc(i) := r(i).c;
    end loop;

    reta := la / ra;
    retb := lb / rb;
    retc := lc / rc;

    for i in l'range loop
      ret (i) := (a => reta(i), b => retb(i), c => retc(i));
    end loop;

    return ret;
  end function;

  -- 4.5.3 "/" Operator - triple_unsigned and natural:

  -- 4.5.3.1 "/" Operator (l:triple_unsigned; r:natural)return unsigned:

  function "/" (l : triple_unsigned; r : natural) return unsigned is
    variable i : unsigned(l'range);
  begin
    i := vote(l);
    return i / r;
  end function;

  -- 4.5.3.2 "/" Operator (l : triple_unsigned; r: natural) return triple_unsigned:

  function "/" (l : triple_unsigned; r : natural) return triple_unsigned is
    variable d : triple_unsigned(l'range);
  begin
    d := triple(to_unsigned(r, l'length));
    return l / d;
  end function;

  -- 4.5.3.3 "/" Operator (l : natural; r: triple_unsigned) return unsigned:

  function "/" (l : natural; r : triple_unsigned) return unsigned is
    variable d : unsigned(r'range);
  begin
    d := vote(r);
    return l / d;
  end function;

  -- 4.5.3.4 "/" Operator (l : natural; r: triple_unsigned) return triple_unsigned:

  function "/" (l : natural; r : triple_unsigned) return triple_unsigned is
    variable i : triple_unsigned(r'range);
  begin
    i := triple(to_unsigned(l, r'length));
    return i / r;
  end function;

  -- 4.5.4 "/" Operator - triple_signed and natural:

  -- 4.5.4.1 "/" Operator (l : triple_signed; r: natural) return signed:

  function "/" (l : triple_signed; r : natural) return signed is
    variable i : signed(l'range);
  begin
    i := vote(l);
    return i / r;
  end function;

  -- 4.5.4.2 "/" Operator (l : triple_signed; r: natural) return triple_signed:

  function "/" (l : triple_signed; r : natural) return triple_signed is
    variable d : triple_signed(l'range);
  begin
    d := triple(to_signed(r, l'length));
    return l / d;
  end function;

  -- 4.5.4.3 "/" Operator (l : natural; r: triple_signed) return signed:

  function "/" (l : natural; r : triple_signed) return signed is
    variable d : signed(r'range);
  begin
    d := vote(r);
    return l / d;
  end function;

  -- 4.5.4.4 "/" Operator (l : natural; r: triple_signed) return triple_signed

  function "/" (l : natural; r : triple_signed) return triple_signed is
    variable i : triple_signed(r'range);
  begin
    i := triple(to_signed(l, r'length));
    return i / r;
  end function;

  -- "/" triple_integer

  function "/" (l : integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l / r);
    return ret;
  end function;

  function "/" (l : integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := l / vote(r);
    return ret;
  end function;

  function "/" (l : integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := triple(l) / r;
    return ret;
  end function;

  function "/" (l : triple_integer; r : integer) return integer is
    variable ret : integer;
  begin
    ret := vote(l) / r;
    return ret;
  end function;

  function "/" (l : triple_integer; r : integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret := l / triple(r);
    return ret;
  end function;

  function "/" (l : triple_integer; r : triple_integer) return integer is
    variable ret : integer;
  begin
    ret := vote (l / r);
    return ret;
  end function;

  function "/" (l : triple_integer; r : triple_integer) return triple_integer is
    variable ret : triple_integer;
  begin
    ret.a := l.a / r.a;
    ret.b := l.b / r.b;
    ret.c := l.c / r.c;
    return ret;
  end function;


end triple_logic_pkg;
