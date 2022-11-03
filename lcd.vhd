library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd is
port (	
	rst:			in std_logic;
	roll_1_stored:		in std_logic_vector(2 downto 0);
	roll_2_stored:		in std_logic_vector(2 downto 0);
	sum:			in std_logic_vector(3 downto 0);
	clk:			in std_logic;
	lcd_data:		out std_logic_vector(7 downto 0);
	lcd_en:			out std_logic;
	lcd_rw:			out std_logic;
	lcd_rs:			out std_logic;
	lcd_on:			out std_logic
);
end lcd;

-- when keys pushed they go to zero
architecture rtl of lcd is -- call output logic
type state_t is (func_set1, func_set2, func_set3, func_set4, clear_disp,init_ret_home,wait0,wait1,
	disp_control, entry_mode, set_addr, write_roll1, return_home, write_roll2, 
	write_pipe, second_line, write_second);
signal state, next_state: state_t;
signal zero: std_logic_vector(4 downto 0) := "00110";
signal A: std_logic_vector(7 downto 0) := "01000001";
begin 
	lcd_en <= clk; -- enable is set by the clock
	the_machine: process(state)
	begin
		next_state <= state;
		case state is
			when func_set1 => -- function set 1
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00110000"; -- function set
				next_state <= wait0;
			when wait0 =>
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00110000"; -- function set
				next_state <= wait1;
			when wait1 =>
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00110000"; -- function set
				next_state <= func_set2;
			when func_set2 => -- function set 2
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00110000"; -- function set
				next_state <= func_set3;
			when func_set3 => -- function set 3
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00110000"; -- function set
				next_state <= func_set4;
			when func_set4 => -- function set 4
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <='0';
				lcd_rs <= '0';
				lcd_data <= "00111000"; -- number of lines N
				next_state <= clear_disp;
			when clear_disp =>
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00000001"; -- clear display
				next_state <= disp_control;
			when disp_control =>
				lcd_on <= '0'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00001100"; -- execute instruction "Display on/off control"
				next_state <= entry_mode;
			when entry_mode =>
				lcd_on <= '1'; -- keep lcd on for write
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00000110";-- entry mode
				-- turn on increment/decrement
				next_state <= init_ret_home; -- for writing data
			when init_ret_home =>
				lcd_on <= '1';
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "00000010";
				next_state <= set_addr;
			when set_addr =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "10000000";-- to beginning
				next_state <= write_roll1;
			when write_roll1 =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				lcd_data <= zero&roll_1_stored; -- write a roll_1
				next_state <= write_pipe; -- for writing data
			when write_pipe =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				lcd_data <= "01111100"; -- write a '|'
				next_state <= write_roll2; -- for writing data
			when write_roll2 =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				lcd_data <= zero&roll_2_stored; -- write a roll_2
				next_state <= second_line; -- for writing data
			when second_line =>
				lcd_on <= '1'; -- keep lcd off in setup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "11000000";-- to second line
				next_state <= write_second;
			when write_second =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				if(unsigned(sum) < 10) then
					lcd_data <= "0011"&sum;-- write a roll_2
					-- lcd_data <= std_logic_vector(unsigned(zero)+8);-- write a roll_2
				else -- hex A to F
					lcd_data <= "0011"&sum;-- write a roll_2
					--lcd_data <= std_logic_vector(unsigned(A)+unsigned(sum));-- write a roll_2
				end if;
				next_state <= return_home; 
			when return_home =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "10000000";-- return to beginning
				next_state <= set_addr;
			when others =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '0';
				lcd_data <= "10000000";-- return to beginning
				next_state <= set_addr;
				-- do nothing really
			end case;
	end process the_machine;

	the_registers: process(rst, clk) -- need reset
	begin
		if(rst='0') then
			state <= func_set1; -- initialize LCD state
		elsif(clk = '1' and clk'event) then
			state <= next_state;
		end if;
	end process the_registers;

end rtl;
