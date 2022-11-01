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
begin 

	debouncer_key3: process(key3, clk)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key3 <= key3;
			q2_key3 <= q1_key3;
		end if;
		clean_key3 <= not(not(q1_key3) and q2_key3);
	end process debouncer_key3;

	debouncer_key2: process(key2, clk)
	begin -- edge detector, falling edge and then 'not' that to be zero
		if(clk='1' and clk'event) then
			q1_key2 <= key2;
			q2_key2 <= q1_key2;
		end if;
		clean_key2 <= not(not(q1_key2) and q2_key2);
	end process debouncer_key2;


	up_count: process(clean_key3)
	begin -- if change in sensitivity list and is '0' then increment
		if(clean_key3 = '0') then
			count_d <= std_logic_vector(unsigned(count) + 1);
		else
			count_d <= count;
		end if;
	end process up_count;


end rtl;
