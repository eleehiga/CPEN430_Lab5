library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity craps_game is
        port(
                roll_1: in std_logic_vector(2 downto 0);
                roll_2: in std_logic_vector(2 downto 0);
                clk: in std_logic;
                rst: in std_logic;
                sum: out std_logic_vector(3 downto 0);
                win: out std_logic;
                lose: out std_logic);
end craps_game;

architecture rtl of craps_game is
signal roll1_temp: unsigned(2 downto 0);
signal roll2_temp: unsigned(2 downto 0);
signal roll1_four: unsigned(3 downto 0);
signal roll2_four: unsigned(3 downto 0);
signal sum_temp: unsigned(3 downto 0);
begin
	-- roll1_temp <= unsigned(roll_1);
	-- roll1_temp <= unsigned(roll_1);
	-- roll2_temp <= "010";
	-- roll1_temp <= "110";
	-- sum_temp <= ('0'&roll1_temp)+('0'&roll2_temp);
	sum_temp <= ('0'&"010")+('0'&"110");
	-- TODO: fix error with truncated third bit
	sum <= std_logic_vector(sum_temp);
end rtl;
