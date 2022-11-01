library ieee;
use ieee.std_logic_1164.all;

entity craps_tb is
end craps_tb;

architecture beh of craps_tb is
	component craps_game
		port(roll_1: in std_logic_vector(2 downto 0);
			roll_2: in std_logic_vector(2 downto 0);
			clock: in std_logic;
			reset: in std_logic;
			sum: out std_logic_vector(3 downto 0);
			win: out std_logic;
			lose: out std_logic);
	end component;
	
	signal roll_1_s, roll_2_s: std_logic_vector(2 downto 0);
	signal clock_s, reset_s, win_s, lose_s: std_logic;
	signal sum_s: std_logic_vector(3 downto 0);
	
begin
	craps_game_inst: craps_game port map(roll_1 => roll_1_s,
											roll_2 => roll_2_s,
											clock => clock_s,
											reset => reset_s,
											sum => sum_s,
											win => win_s,
											lose => lose_s);
											
	clock:process
	begin
		clock_s <= '0';
		wait for 10 ns;
		clock_s <= '1';
		wait for 10 ns;
	end process;
	
	process
	begin
		-- intialize inputs
		roll_1_s <= "000";
		roll_2_s <= "000";
		reset_s <= '0';
		
		wait for 20 ns;
		reset_s <= '1';
		wait for 20 ns;
		
		-- try first rolls
		roll_1_s <= "001";
		roll_2_s <= "110";
		
		wait for 160 ns;
		
		assert false
		report "End of Testbench"
		severity failure;
	end process;
end beh;