library ieee;
use ieee.std_logic_1164.all;
entity lab4_tb is
end lab4_tb;

architecture beh of lab4_tb is
component toplevel
port (  key3:                   in std_logic;
        key0:                   in std_logic;
        clk:                    in std_logic;
        lcd_data:               out std_logic_vector(7 downto 0);
        lcd_en:                 out std_logic;
        lcd_rw:                 out std_logic;
        lcd_rs:                 out std_logic;
        lcd_on:                 out std_logic
);
end component toplevel;

signal key3 : std_logic := '1';
signal key0 : std_logic := '1';
signal clk : std_logic := '0';
signal lcd_data : std_logic_vector(7 downto 0) := "00000000";
signal lcd_en : std_logic := '0';
signal lcd_rw : std_logic := '0';
signal lcd_rs : std_logic := '0';
signal lcd_on : std_logic := '0';

begin
--instantiate the component
toplevel_inst: toplevel port map(
key3 => key3,
key0 => key0,
clk => clk,
lcd_data => lcd_data,
lcd_en => lcd_en,
lcd_rw => lcd_rw,
lcd_rs => lcd_rs,
lcd_on => lcd_on
);

clk_p : process
  begin
	clk <= '0';
	wait for 5 ns;
	clk <= '1';
	wait for 5 ns;
  end process clk_p;

-- Claudio's testbench process
tb: process
  begin
    key0 <= '0';
    wait for 20 ms;
    key0 <= '1';    
    wait for 20 ms;

    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
    key3 <= '0';
    wait for 20 ms;
    key3 <= '1';    
    wait for 20 ms;
	key0 <= '0';
    wait for 40 ms;

    assert false
    report "End of Testbench"
    severity failure;

end process tb;

end architecture beh;
 
