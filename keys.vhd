library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keys is
port (	key3:			in std_logic;
	key2:			in std_logic;
	rst:			in std_logic;
	clk:			in std_logic;
	roll_1:			out std_logic_vector(2 downto 0);
	roll_2:			out std_logic_vector(2 downto 0)
);
end keys;

-- when keys pushed they go to zero
architecture rtl of keys is -- call output logic
signal count, count_d: std_logic_vector(7 downto 0);
signal clean_key2, clean_key3, q1_key2, q2_key2, q1_key3, q2_key3: std_logic;
signal curr_in_roll1, curr_in_roll2, next_in_roll1, next_in_roll2,
	curr_out_roll1, curr_out_roll2, next_out_roll1, next_out_roll2: std_logic_vector(2 downto 0) := "001";
signal pressed_key3, pressed_key2: std_logic := '0';
begin 

	debouncer_key3: process(key3, clk, q1_key3, q2_key3)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key3 <= key3;
			q2_key3 <= q1_key3;
		end if;
		clean_key3 <= not(not(q1_key3) and q2_key3);
	end process debouncer_key3;

	debouncer_key2: process(key2, clk, q1_key2, q2_key2)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key2 <= key2;
			q2_key2 <= q1_key2;
		end if;
		clean_key2 <= not(not(q1_key2) and q2_key2);
	end process debouncer_key2;

	rst_roll: process(rst,clk)
	begin
		if rst='0' then
			curr_in_roll1 <= "001";
			curr_in_roll2 <= "001";
			curr_out_roll1 <= "001";
			curr_out_roll2 <= "001";
		elsif(clk='1' and clk'event) then
			curr_in_roll1 <= next_in_roll1;
			curr_in_roll2 <= next_in_roll2;
			curr_out_roll1 <= next_out_roll1;
			curr_out_roll2 <= next_out_roll2;
		end if;
	end process rst_roll;

	update_press_key3: process(clean_key3)
	begin
		if(clean_key3 = '0') then
			pressed_key3 <= '0';
		else
			pressed_key3 <= '1';
		end if;
	end process update_press_key3;

	update_press_key2: process(clean_key2)
	begin
		if(clean_key2 = '0') then
			pressed_key2 <= '0';
		else
			pressed_key2 <= '1';
		end if;
	end process update_press_key2;


	rolling1: process(clk,pressed_key3, curr_in_roll1)
	begin
		if(clk='1' and clk'event) then
			if(pressed_key3 = '0') then
				next_in_roll1 <= std_logic_vector(unsigned(curr_in_roll1) + 1);
				if(unsigned(next_in_roll1) > 7) then
					next_in_roll1 <= "001";
				end if;
			else -- '1'
				next_in_roll1 <= curr_in_roll1;
			end if;
		end if;
	end process rolling1;

	rolling2:process(clk,pressed_key2, curr_in_roll2)
	begin
		if(clk='1' and clk'event) then
			if(pressed_key2 = '0') then
				next_in_roll2 <= std_logic_vector(unsigned(curr_in_roll2) + 1);
				if(unsigned(next_in_roll2) > 7) then
					next_in_roll2 <= "001";
				end if;
			else -- '1'
				next_in_roll2 <= curr_in_roll2;
			end if;
		end if;
	end process rolling2;

	update_out_roll1: process(clean_key3, curr_out_roll1, curr_in_roll1)
	begin
		if(clean_key3 = '0') then
			next_out_roll1 <= curr_out_roll1;
		else
			next_out_roll1 <= curr_in_roll1;
		end if;
	end process update_out_roll1;


	update_out_roll2: process(clean_key2, curr_out_roll2, curr_in_roll2)
	begin
		if(clean_key2 = '0') then
			next_out_roll2 <= curr_out_roll2;
		else
			next_out_roll2 <= curr_in_roll2;
		end if;
	end process update_out_roll2;

	roll_1 <= curr_out_roll1;
	roll_2 <= curr_out_roll2;

end rtl;
