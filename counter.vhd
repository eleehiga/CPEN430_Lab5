library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity counter is
port (rst : in std_logic;
	clk : in std_logic;
	slow_clk : out std_logic);
end counter;

architecture rtl of counter is
signal count: unsigned(18 downto 0); -- may have to slow clock to 2 ms, or 40 ms, 2^18 is around 200000 for the count 
begin 
	count_p: process(rst, clk)
	begin
	if rst = '0' then
		count <= (others => '0');
	elsif(rising_edge(clk)) then
		count <= count + 1;
	end if;
	slow_clk <= count(18);
	end process count_p;
end rtl;	 
