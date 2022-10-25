-- instantiate components and link together
	-- look at shift registers

library ieee;
USE ieee.std_logic_1164.all;

entity toplevel is
port (	key3:			in std_logic;
	key0:			in std_logic;
	clk:			in std_logic;
	lcd_data:		out std_logic_vector(7 downto 0);
	lcd_en:			out std_logic;
	lcd_rw:			out std_logic;
	lcd_rs:			out std_logic;
	lcd_on:			out std_logic
);
end toplevel;

architecture rtl of toplevel is -- taillight state machine
	signal slow_clk: std_logic;
	component keys_lcd
		port (	key3:			in std_logic;
			key0:			in std_logic;
			clk:			in std_logic;
			lcd_data:		out std_logic_vector(7 downto 0);
			lcd_en:			out std_logic;
			lcd_rw:			out std_logic;
			lcd_rs:			out std_logic;
			lcd_on:			out std_logic
);
	end component keys_lcd;

	component counter
		port (	rst : in std_logic;
			clk : in std_logic;
			slow_clk : out std_logic);
	end component counter;
begin
	keys_lcd_instance: keys_lcd
	port map(	key3 => key3,
			key0 => key0,
			clk => slow_clk,
			lcd_data=> lcd_data,
			lcd_en=> lcd_en,
			lcd_rw=> lcd_rw,
			lcd_rs=> lcd_rs,
			lcd_on=> lcd_on
	);

	counter_instance: counter
	port map(
	rst => key0, -- key 0 is the reset key
	clk => clk,
	slow_clk => slow_clk
		);
end rtl;
