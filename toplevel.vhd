-- instantiate components and link together
	-- look at shift registers

library ieee;
USE ieee.std_logic_1164.all;

entity toplevel is
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
end toplevel;

architecture rtl of toplevel is -- taillight state machine
	signal slow_clk: std_logic;
	component keys
		port (	key3:			in std_logic;
			key2:			in std_logic;
			rst:			in std_logic;
			roll_1:			in std_logic_vector(2 downto 0);
			roll_2:			in std_logic_vector(2 downto 0);
	);
	end component keys;

	component craps
		port(	roll_1: in std_logic_vector(2 downto 0);
			roll_2: in std_logic_vector(2 downto 0);
			clk: in std_logic;
			rst: in std_logic;
			sum: out std_logic_vector(3 downto 0);
			win: out std_logic;
			lose: out std_logic);
	end component craps;

	component lcd
		port (
			reset:			in std_logic;
			sum:			in std_logic_vector(3 downto 0);
			clk:			in std_logic;
			lcd_data:		out std_logic_vector(7 downto 0);
			lcd_en:			out std_logic;
			lcd_rw:			out std_logic;
			lcd_rs:			out std_logic;
			lcd_on:			out std_logic;
			led0:			out std_logic;
			led1:			out std_logic
	);
	end component lcd;

	component counter
		port (	rst : in std_logic;
			clk : in std_logic;
			slow_clk : out std_logic);
	end component counter;
begin
	keys_instance: keys
	port map(	key3 => key3,
			key2 => key2,
			rst => rst,
			roll_1 => roll_1,
			roll_2 => roll_2
		);

	craps_instance: craps
	port map(
		roll_1 => roll_1,
		roll_2 => roll_1,
		clk => clk,
		rst => rst,
		sum => sum,
		win => win,
		lose => lose
		);

	lcd_instance: lcd
	port map(
			rst => rst,
			sum => sum;
			clk => slow_clk,
			lcd_data=> lcd_data,
			lcd_en=> lcd_en,
			lcd_rw=> lcd_rw,
			lcd_rs=> lcd_rs,
			lcd_on=> lcd_on,
			led0=> led0,
			led1=> led1
	);

	counter_instance: counter
	port map(
	rst => key0, -- key 0 is the reset key
	clk => clk,
	slow_clk => slow_clk
		);
end rtl;
