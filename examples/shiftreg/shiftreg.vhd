library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

  signal reg, p_reg: std_logic_vector (7 downto 0);

begin

  comb: process (reg, data_in, enable)
  begin
   if (enable = '1') then
     p_reg <= reg(6 downto 0) & data_in;
   else
     p_reg <= reg;
   end if;
  end process;

  data_out <= reg(7);

  sinc: process (clk, rst_high)
  begin
    if (rst_high = '1') then
      reg <= (others => '0');
    elsif (rising_edge(clk)) then
      reg <= p_reg;
    end if;
  end process;

end Behavioral;
