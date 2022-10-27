library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keys_lcd is
port (	key3:			in std_logic;
	key2:			in std_logic;
	key0:			in std_logic;
	clk:			in std_logic;
	lcd_data:		out std_logic_vector(7 downto 0);
	lcd_en:			out std_logic;
	lcd_rw:			out std_logic;
	lcd_rs:			out std_logic;
	lcd_on:			out std_logic;
	led0:			out std_logic;
	led1:			out std_logic
);
end keys_lcd;

-- when keys pushed they go to zero
architecture rtl of keys_lcd is -- call output logic
type state_t is (func_set1, func_set2, func_set3, func_set4, clear_disp,init_ret_home,wait0,wait1,
	disp_control, entry_mode, set_addr, write_data, return_home, write_exceed, 
	debounce, second_line, write_second, waitD);
signal state, next_state: state_t;
signal count, count_d: std_logic_vector(7 downto 0);
signal clean_key0, clean_key3, q1_key0, q2_key0, q1_key3, q2_key3: std_logic;
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
				if(unsigned(count) >= 58) then -- 57 is "9" on LCD
					next_state <= write_exceed;
				else
					next_state <= write_data;
				end if;
			when write_data =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				lcd_data <= count;-- write a 0
				next_state <= return_home; -- for writing data
			when write_exceed =>
				lcd_on <= '1'; -- keep lcd on in writeup
				lcd_rw <= '0';
				lcd_rs <= '1';
				lcd_data <= "01010111";-- write a W
				next_state <= second_line;
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

	debouncer_key3: process(key3, clk)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key3 <= key3;
			q2_key3 <= q1_key3;
		end if;
		clean_key3 <= not(not(q1_key3) and q2_key3);
	end process debouncer_key3;

	debouncer_key0: process(key0, clk)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key0 <= key0;
			q2_key0 <= q1_key0;
		end if;
		clean_key0 <= not(not(q1_key0) and q2_key0);
	end process debouncer_key0;


	up_count: process(clean_key3)
	begin -- if change in sensitivity list and is '0' then increment
		if(clean_key3 = '0') then
			count_d <= std_logic_vector(unsigned(count) + 1);
		else
			count_d <= count;
		end if;
	end process up_count;

	the_registers: process(key0, clk) -- need reset
	begin
		if(key0='0') then
			state <= func_set1; -- initialize LCD state
			count <= "00110000"; -- count set to zero digit on LCD
		elsif(clk = '1' and clk'event) then
			state <= next_state;
			count <= count_d; -- load temporary counter variable to actual counter variable
		end if;
	end process the_registers;

end rtl;
