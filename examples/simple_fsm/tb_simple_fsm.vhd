LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_simple_fsm IS
END tb_simple_fsm;

ARCHITECTURE behavior OF tb_simple_fsm IS

  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT simple_fsm
    PORT(
      clk : IN  std_logic;
      rst : IN  std_logic;
      input0 : IN  std_logic;
      input1 : IN  std_logic;
      output0 : OUT  std_logic;
      output1 : OUT  std_logic
      );
  END COMPONENT;

  --Simulation will stop at time = clk_period * num_vectors
  constant clk_period : time := 10 ns;
  constant num_vectors : integer := 16;
  signal ftu_cycle_count : integer := 0;

  --Inputs
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal input0 : std_logic := '0';
  signal input1 : std_logic := '0';

  --Outputs
  signal output0 : std_logic;
  signal output1 : std_logic;

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
  uut: simple_fsm PORT MAP (
    clk => clk,
    rst => rst,
    input0 => input0,
    input1 => input1,
    output0 => output0,
    output1 => output1
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
    -- hold reset state for 20 ns.
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait for 2*clk_period;
    -- up the four states
    input1 <= '1';
    wait for 4*clk_period;
    input1 <= '0';
    wait for 2*clk_period;
    -- down the four states
    input0 <= '1';
    wait for 4*clk_period;
    input0 <= '0';
    wait;

    -- insert stimulus here 

    wait;
  end process;

END;
