library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity adder_acum is
  generic(TAM1 : integer := 20;
          TAM2 : integer := 8);
  port (clk        : in  std_logic;
        reset      : in  std_logic;
        enable     : in  std_logic;
        dato_in    : in  std_logic_vector(TAM2-1 downto 0);
        valor_acum : out std_logic_vector(TAM1-1 downto 0));
end adder_acum;

architecture Behavioral of adder_acum is
  signal i_valor_acum, p_valor_acum : std_logic_vector(TAM1-1 downto 0);
begin

  asinc : process(enable, i_valor_acum, dato_in)
  begin
    p_valor_acum <= i_valor_acum;
    if (enable = '1') then
      p_valor_acum <= std_logic_vector(unsigned(i_valor_acum) +
          unsigned(dato_in));
    end if;
  end process;

  sinc : process(clk, reset)
  begin
    if (reset = '0') then
      i_valor_acum <= (others => '0');
    elsif (rising_edge(clk)) then
      i_valor_acum <= p_valor_acum;
    end if;
  end process;

  valor_acum <= i_valor_acum;

end Behavioral;
