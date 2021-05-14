library IEEE;
use ieee.std_logic_1164.all;

entity simple_fsm is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        input0  : in  std_logic;
        input1  : in  std_logic;
        output0 : out std_logic;
        output1 : out std_logic
    );
end simple_fsm;

architecture Behavioral of simple_fsm is

    type possible_states is (state0, state1, state2, state3);

    signal state, n_state : possible_states;

begin

    sinc: process (rst, clk)
    begin
        if rst = '1' then
            state <= state0;
        elsif rising_edge(clk) then
            state <= n_state;
        end if;
    end process;

    comb: process (state, input0, input1)
    begin
        n_state <= state;
        case state is
            when state0 =>
                output0 <= '0';
                output1 <= '0';
                if input1 = '1' then
                    n_state <= state1;
                end if;
            when state1 =>
                output0 <= '0';
                output1 <= '1';
                if input0 = '1' then
                    n_state <= state0;
                elsif input1 = '1' then
                    n_state <= state2;
                end if;
            when state2 =>
                output0 <= '1';
                output1 <= '0';
                if input0 = '1' then
                    n_state <= state1;
                elsif input1 = '1' then
                    n_state <= state3;
                end if;
            when state3 =>
                output0 <= '1';
                output1 <= '1';
                if input0 = '1' then
                    n_state <= state2;
                end if;
        end case;
    end process;

end Behavioral;
