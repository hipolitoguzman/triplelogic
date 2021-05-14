library IEEE;
use ieee.std_logic_1164.all;
--use work.triple_logic_package.all;

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
    constant enum_t_elems:  natural:= possible_states'POS(possible_states'RIGHT) + 1;
    type tmr_states is
        record
            a: possible_states;
            b: possible_states;
            c: possible_states;
        end record;

    -- This function could be made of a generic type in VHDL-2008, and thus
    -- written into the package, if Vendors' synthesis tools supported
    -- VHDL-2008, which is not the case :( -- maybe with Synplify?
    --
    -- Assuming only one SEU:
    --   If a == b, SEU is in c -> return either a or b
    --   If a == c, SEU is in b -> return either a or c
    --   Else, b == c, SEU is in a, or no SEU -> return either b or c
    function decode (value: tmr_states) return possible_states is
        variable ret: possible_states;
    begin
        if (value.a = value.b) then
            ret := value.a;
        elsif value.a = value.c then
            ret := value.c;
        else
            ret := value.b;
        end if;
        return ret;
    end function;

    -- This function could also be made generic and included in the
    -- triple_logic package, if using VHDL-2008
    --
    -- Just triple the value. Overloads the already existing triple() functions
    -- in the triple_logic package
    function triple (value: possible_states) return tmr_states is
    begin
        return (a => value, b => value, c=> value);
    end function;

    signal state, n_state : tmr_states;
    attribute syn_preserve: boolean;
    attribute syn_preserve of state: signal is true;
    attribute syn_preserve of n_state: signal is true;

begin

    assert FALSE
      report "possible_states number of elements = " & natural'IMAGE(enum_t_elems)
      severity note;

    sinc: process (rst, clk)
    begin
        if rst = '1' then
            state <= triple(state0);
        elsif rising_edge(clk) then
            state <= n_state;
        end if;
    end process;

    comb: process (state, input0, input1)
    begin
        n_state <= state;
        case decode(state) is
            when state0 =>
                output0 <= '0';
                output1 <= '0';
                if input1 = '1' then
                    n_state <= triple(state1);
                end if;
            when state1 =>
                output0 <= '0';
                output1 <= '1';
                if input0 = '1' then
                    n_state <= triple(state0);
                elsif input1 = '1' then
                    n_state <= triple(state2);
                end if;
            when state2 =>
                output0 <= '1';
                output1 <= '0';
                if input0 = '1' then
                    n_state <= triple(state1);
                elsif input1 = '1' then
                    n_state <= triple(state3);
                end if;
            when state3 =>
                output0 <= '1';
                output1 <= '1';
                if input0 = '1' then
                    n_state <= triple(state2);
                end if;
        end case;
    end process;

end Behavioral;
