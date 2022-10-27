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
	type state_t_game is (firstroll, morerolls, gameover);
	signal currstate_game, nextstate_game: state_t_game;
	type state_t_rolls is (nochange, changed);
	signal currstate_rolls, nextstate_rolls: state_t_rolls;
	signal currsum, nextsum, sum: std_logic_vector(3 downto 0);
	signal currrole_1, currrole_2, nextrole_1, nextrole_2: std_logic_vector(2 downto 0);
	signal currchanged_1, currchanged_2, nextchanged_1, nextchanged_2: std_logic;
begin
	registers:process(clock, reset)
	begin
		if(reset = '0') then
			currstate <= firstroll;
			currsum <= "0000";
			currrole_1 <= "000";
			currrole_2 <= "000";
			currchanged_1 <= '0';
			currchanged_2 <= '0';
		elsif (clock'event and clock = '1') then
			currstate <= nextstate;
			currsum <= nextsum;
			currrole_1 <= nextrole_1;
			currrole_2 <= nextrole_2;
			currchanged_1 <= nextchanged_1;
			currchanged_2 <= nextchanged_2;
		end if;
	end process;
	
	state_machine_rolls: process(currstate_rolls, roll_1, roll_2, currrole_1, currrol_2)
	begin
		
		-- default roll over
		nextstate_rolls <= currstate_rolls;
		-- this detects when dice have been rolled and prevents rerolling
		case currstate_rolls is
			when nochange =>
				-- continue taking in rolls waiting for change
				nextroll_1 <= roll_1;
				nextroll_2 <= roll_2;
				if(currchanged_1 = '1') then
					nextstate_rolls <= changed_roll_1;
				elsif(currchanged_2 = '1') then
					nextstate_rolls <= changed_roll_2;
				end if;
			when changed_roll_1 =>
				-- stop taking in roll 1, continue waiting for roll 2
				nextroll_1 <= currrole_1;
				nextroll_2 <= roll_2;
				if(currchanged_2 = '1') then
					nextstate_rolls <= both_rolls_changed;
				end if;
			when changed_roll_2 =>
				-- stop taking in roll 2, continue waiting for roll 1
				nextroll_1 <= roll_1;
				nextroll_2 <= currchanged_2;
				if(currchanged_1 = '1') then
					nextsate_rolls <= both_rolls_changed;
				end if;
			when both_rolls_changed =>
				if(nextstate_game = currstate_game) then
					-- stop taking in both rolls
					nextroll_1 <= currrole_1;
					nextroll_2 <= currrole_2;
				else
					-- continue taking in both rolls and go back to no change state
					nextrole_1 <= roll_1;
					nextrole_2 <= roll_2;
					nextstate_rolls <= nochange;
				end if;
		end case;
		-- set flags if change is detected, otherwise roll over values
		if(nextrole_1 != currrole_1) then
			nextchanged_1 <= '1';
		else
			nextchanged_1 <= currchanged_1;
		end if;
		if(nextrole_2 != currrole_2) then
			nextchanged_2 <= '1';
		else
			nextchanged_2 <= currchanged_2;
		end if;
	end process;
	
	state_machine_game: process(currstate, currchanged_1, currchanged_2)
	begin
		case currstate is
			when firstroll =>
				if(currstate_rolls = both_rolls_changed) then
					nextstate_rolls <= morerolls;
				else
					nextstate_rolls <= firstroll;
				end if;
			when morerolls =>
			when gameover =>
		end case;
	end process;
end rtl;