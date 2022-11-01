library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd is
port (	
	rst:			in std_logic;
	roll_1:			in std_logic_vector(2 downto 0);
	roll_2:			in std_logic_vector(2 downto 0);
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
	set_space, second_line, write_second);
signal state, next_state: state_t;
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
				lcd_data <= "01010111";-- write a 0
				next_state <= return_home; -- for writing data
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
				lcd_data <= "01000001";-- write a A
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
			count <= "00110000"; -- count set to zero digit on LCD
		elsif(clk = '1' and clk'event) then
			state <= next_state;
			count <= count_d; -- load temporary counter variable to actual counter variable
		end if;
	end process the_registers;

end rtl;
