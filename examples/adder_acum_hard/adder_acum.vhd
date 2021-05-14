library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.triple_logic_pkg.all;

entity adder_acum is
  generic(TAM1 : integer := 20;
          TAM2 : integer := 8);
  port (clk        : in  std_logic;
        reset      : in  std_logic;
        enable     : in  std_logic;
        dato_in    : in  unsigned(TAM2-1 downto 0);
        valor_acum : out unsigned(TAM1-1 downto 0));
end adder_acum;

architecture Behavioral of adder_acum is
  signal i_valor_acum, p_valor_acum : triple_unsigned(TAM1-1 downto 0);
begin

  asinc : process(enable, i_valor_acum, dato_in)
  begin
      p_valor_acum <= i_valor_acum;
    if (enable = '1') then
      p_valor_acum <= (i_valor_acum + dato_in);
    end if;
  end process;

  sinc : process(clk, reset)
  begin
    if (reset = '0') then
      i_valor_acum <= (others => (others => '0'));
    elsif (clk = '1' and clk'event) then
      i_valor_acum <= p_valor_acum;
    end if;
  end process;

  valor_acum <= vote(i_valor_acum);

end Behavioral;
