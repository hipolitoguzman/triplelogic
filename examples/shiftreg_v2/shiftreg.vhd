library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.triple_logic_pkg.all;

entity shiftreg is
  Port (
         clk      : in  STD_LOGIC;
         rst_high : in  STD_LOGIC;
         enable   : in  STD_LOGIC;
         data_in  : in  STD_LOGIC;
         data_out : out STD_LOGIC
       );
end shiftreg;

architecture Behavioral of shiftreg is

  signal reg, p_reg: triple_logic_vector (7 downto 0);
  
attribute syn_preserve: boolean;
attribute syn_preserve of reg: signal is true;
--attribute EQUIVALENT_REGISTER_REMOVAL: string;
--attribute EQUIVALENT_REGISTER_REMOVAL of reg: signal is "NO";
--attribute EQUIVALENT_REGISTER_REMOVAL of p_reg: signal is "NO";

begin

  comb: process (reg, rst_high, data_in)
  begin
   if (rst_high = '1') then
     p_reg <= (others => (others => '0'));
   elsif (enable = '1') then
     p_reg <= reg(6 downto 0) & triple(data_in);
   else
     p_reg <= reg;
   end if;
  end process;

  data_out <= vote(reg(7));

  sinc: process (clk)
  begin
    if (clk='1' and clk'event)then
      reg <= p_reg;
    end if;
  end process;

end Behavioral;
