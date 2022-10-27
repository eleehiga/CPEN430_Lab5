library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keys_lcd is
port (	key3:			in std_logic;
	key2:			in std_logic;
	rst:			in std_logic;
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


end rtl;
