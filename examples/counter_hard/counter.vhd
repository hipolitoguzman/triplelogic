library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.triple_logic_pkg.all;

entity counter is
  port ( rst_high : in  std_logic;
         clk : in  std_logic;
         enable : in  std_logic;
         data_out : out  std_logic_vector (7 downto 0));
end counter;

architecture Behavioral of counter is

  signal reg_i, p_reg_i: triple_unsigned (7 downto 0);

attribute syn_preserve: boolean;
attribute syn_preserve of reg_i: signal is true;

begin

  comb: process (reg_i, rst_high, enable)
  begin
   if (rst_high = '1') then
     p_reg_i <= (others => (others => '0'));
   elsif (enable = '1') then
     p_reg_i <= reg_i + 1;
   else
     p_reg_i <= reg_i;
   end if;
  end process;

  data_out <= std_logic_vector(vote(reg_i));

  sinc: process (clk)
  begin
    if (clk='1' and clk'event)then
      reg_i <= p_reg_i;
    end if;
  end process;

end Behavioral;
