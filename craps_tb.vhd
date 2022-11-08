library ieee;
use ieee.std_logic_1164.all;

entity craps_tb is
end craps_tb;

architecture beh of craps_tb is
	component craps_game
		port(roll_1: in std_logic_vector(2 downto 0);
			roll_2: in std_logic_vector(2 downto 0);
			roll_1_pressed: in std_logic;
			roll_2_pressed: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			sum: out std_logic_vector(3 downto 0);
			win: out std_logic;
			lose: out std_logic;
			roll_1_stored: out std_logic_vector(2 downto 0);
			roll_2_stored: out std_logic_vector(2 downto 0));
	end component;
	
	signal roll_1_s, roll_2_s, roll_1_stored_s, roll_2_stored_s: std_logic_vector(2 downto 0);
	signal clock_s, reset_s, win_s, lose_s, roll_1_pressed_s, roll_2_pressed_s: std_logic;
	signal sum_s: std_logic_vector(3 downto 0);
	
begin
	craps_game_inst: craps_game port map(roll_1 => roll_1_s,
											roll_2 => roll_2_s,
											roll_1_pressed => roll_1_pressed_s,
											roll_2_pressed => roll_2_pressed_s,
											clk => clock_s,
											rst => reset_s,
											sum => sum_s,
											win => win_s,
											lose => lose_s,
											roll_1_stored => roll_1_stored_s,
											roll_2_stored => roll_2_stored_s);
											
	clock:process
	begin
		clock_s <= '0';
		wait for 10 ns;
		clock_s <= '1';
		wait for 10 ns;
	end process;
	
	test:process
	procedure runTestCase1 is
	begin
		-- test case 1
		-- first rolls
		roll_1_s <= "010";
		roll_2_s <= "110";
		wait for 100 ns;
		-- second rolls
		roll_1_s <= "001";
		roll_2_s <= "001";
		wait for 100 ns;
		-- third rolls
		roll_1_s <= "100";
		roll_2_s <= "100";
		wait for 140 ns;
		-- should give win signal
		if(win_s /= '1') then
			assert false
			report "Test case 1 failed"
			severity warning;
		else
			report "Test case 1 success";
		end if;
	end runTestCase1;
	
	procedure runTestCase2 is
	begin
		-- test case 2
		-- first roll
		roll_1_s <= "110";
		roll_2_s <= "001";
		wait for 100 ns;
		-- should give win signal
		if(win_s /= '1') then
			assert false
			report "Test case 2 failed"
			severity warning;
		else
			report "Test case 2 success";
		end if;
	end runTestCase2;
	
	procedure runTestCase3 is
	begin
		-- test case 3
		-- first roll
		roll_1_s <= "110";
		roll_2_s <= "110";
		wait for 100 ns;
		-- should give lose signal
		if(lose_s /= '1') then
			assert false
			report "Test case 3 failed"
			severity warning;
		else
			report "Test case 3 success";
		end if;
	end runTestCase3;
	
	procedure runTestCase4 is
	begin
		-- test case 4
		-- first roll
		roll_1_s <= "110";
		roll_2_s <= "010";
		wait for 100 ns;
		-- second roll
		roll_1_s <= "110";
		roll_2_s <= "010";
		wait for 80 ns;
		-- should give win signal
		if(win_s /= '1') then
			assert false
			report "Test case 4 failed"
			severity warning;
		else
			report "Test case 4 success";
		end if;
	end runTestCase4;
	
	procedure runTestCase5 is
	begin
		-- test case 5
		-- first roll
		roll_1_s <= "110";
		roll_2_s <= "010";
		wait for 100 ns;
		-- second roll
		roll_1_s <= "110";
		roll_2_s <= "001";
		wait for 80 ns;
		-- should give win signal
		if(lose_s /= '1') then
			assert false
			report "Test case 5 failed"
			severity warning;
		else
			report "Test case 5 success";
		end if;
	end runTestCase5;
	
	procedure reset_craps is
	begin
		--reset
		reset_s <= '0';
		roll_1_s <= "000";
		roll_2_s <= "000";
		wait for 20 ns;
		reset_s <= '1';
		wait for 20 ns;
	end reset_craps;
	
	begin
		-- intialize inputs
		roll_1_s <= "000";
		roll_2_s <= "000";
		reset_s <= '0';
		roll_1_pressed_s <= '1';
		roll_2_pressed_s <= '1';
		wait for 20 ns;
		reset_s <= '1';
		wait for 20 ns;
		
		runTestCase1;
		reset_craps;
		runTestCase2;
		reset_craps;
		runTestCase3;
		reset_craps;
		runTestCase4;
		reset_craps;
		runTestCase5;
		
		assert false
		report "End of Testbench"
		severity failure;
	end process;
end beh;