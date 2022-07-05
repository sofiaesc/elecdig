library IEEE;
use IEEE.std_logic_1164.all;

entity ej6_tb is

end entity;

architecture arch_ej6_tb of ej6_tb is
	
	component ej6
	port( Re : in std_logic;
		Clk : in std_logic;
		Asc : in std_logic;
		Q : out std_logic_vector(2 downto 0)
		);
	end component;
	
	signal Re, Clk, Asc : std_logic;
	signal Q : std_logic_vector(2 downto 0);
	
begin
	uut: ej6
	port map(
		Clk => Clk,
		Re => Re,
		Asc => Asc,
		Q => Q
	);
	
	clock: process
	begin
		Clk <= '1';
		wait for 5 fs;
		Clk <= '0';
		wait for 5 fs;
	end process;
	
	stim: process
	begin
		Re <= '1';
        wait for 10 fs;
        
        Re <= '0';
        Asc <= '1';
        wait for 40 fs;
        Asc <= '0';
        wait for 40 fs;
        
        Re <= '1';
        wait for 10 fs;
	end process;

end arch_ej6_tb;