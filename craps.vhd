library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity craps_game is
	port(roll_1: in std_logic_vector(2 downto 0);
			roll_2: in std_logic_vector(2 downto 0);
			clock: in std_logic;
			reset: in std_logic;
			sum: out std_logic_vector(3 downto 0);
			win: out std_logic;
			lose: out std_logic);
end craps_game;

architecture rtl of craps_game is
	type state_t is ();
	signal currstate, nextstate: state_t;
	signal currsum, nextsum: std_logic_vector(3 downto 0);
begin
	registers:process(clock, reset)
	begin
		if(reset = '0') then
			currstate <= 
			currsum <= "0000";
		elsif (clock'event and clock = '1') then
			
		end if;
	end process;
end rtl;