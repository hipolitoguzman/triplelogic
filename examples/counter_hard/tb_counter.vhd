LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY tb_counter IS
END tb_counter;

ARCHITECTURE behavior OF tb_counter IS

  COMPONENT counter
    PORT(
      rst_high : IN  std_logic;
      enable   : IN std_logic;
      clk      : IN  std_logic;
      data_out : OUT  std_logic_vector (7 downto 0)
      );
  END COMPONENT;

  --Simulation will stop at time = clk_period * num_vectors
  constant clk_period : time := 10 ns;
  constant num_vectors : integer := 285;
  signal ftu_cycle_count : integer := 0;

  --Inputs
  signal rst_high : std_logic := '1';
  signal enable   : std_logic := '0';
  signal clk      : std_logic := '1';

  --Outputs
  signal data_out : std_logic_vector (7 downto 0);

BEGIN

  --Stops simulation at desired time. Compatible with FTU2 and FTU1.
  ftu_endsim: process(clk)
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
  uut: counter PORT MAP (
    rst_high => rst_high,
    enable => enable,
    clk => clk,
    data_out => data_out
    );

  -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- 4 cycle rst:
    rst_high <= '1';
    wait for clk_period * 4;
    -- 20 cycles of not reset		
    rst_high <= '0';
    enable <= '1';
    wait for clk_period * 20;
    -- 5 cycles of not enable
    enable <= '0';
    wait for clk_period * 5;
    -- 256 cycles of enable
    enable <= '1';
    wait for clk_period * 256;
    wait;
  end process;

END;
