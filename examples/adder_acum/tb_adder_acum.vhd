library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity tb_adder_acum is
end tb_adder_acum;

architecture behavior of tb_adder_acum is

  component adder_acum
      generic(TAM1 : integer := 20;
          TAM2 : integer := 8);
    port(
      clk        : in  std_logic;
      reset      : in  std_logic;
      enable     : in  std_logic;
      dato_in    : in  std_logic_vector(TAM2-1 downto 0);
      valor_acum : out std_logic_vector(TAM1-1 downto 0)
      );
  end component;

  --Simulation will stop at time = clk_period * num_vectors
  constant clk_period    : time    := 20 ns;
  constant num_vectors   : integer := 100;
  signal ftu_cycle_count : integer := 0;

  --Inputs
  signal clk       : std_logic                    := '0';
  signal reset     : std_logic                    := '0';
  signal enable    : std_logic                    := '0';
  signal dato_in   : std_logic_vector(7 downto 0) := (others => '0');

  --Outputs
  signal valor_acum : std_logic_vector(19 downto 0);

begin

  --Stops simulation at desired time. Compatible with FTU2 and FTU1.
  ftu_endsim : process(clk)
  begin
    if (rising_edge(clk))then
      ftu_cycle_count <= ftu_cycle_count + 1;
      if(ftu_cycle_count = num_vectors)then
        report "Simulation ended succesfully"
          severity failure;
      end if;
    end if;
  end process;

  -- Instantiate the Unit Under Test (UUT)
  uut : adder_acum
    generic map ( TAM1 => 20, TAM2 => 8 )
    port map (
        clk        => clk,
    reset      => reset,
    enable     => enable,
    dato_in    => dato_in,
    valor_acum => valor_acum
    );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
    reset     <= '0';
    wait for 20 ns;
    reset     <= '1';
    wait for 20 ns;
    dato_in   <= "00000100";
    wait for 20 ns;
    enable    <= '1';
    dato_in   <= "00000011";
    wait for 20 ns;
    enable    <= '0';
	 wait for 10ns;
	 enable    <= '1';
    dato_in   <= "00000100";
    wait for 20 ns;
    enable    <= '0';
    wait;
  end process;

end;
