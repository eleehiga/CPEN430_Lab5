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
begin
end rtl;
