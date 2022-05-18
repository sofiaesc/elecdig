library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador_tb is
end comparador_tb;

architecture arch_comparador_tb of comparador_tb is

    component comparador
    port(
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        My : out std_logic;
        Eq : out std_logic;
        Mn : out std_logic
    );
    end component;
    
    signal A : std_logic_vector(3 downto 0);
    signal B : std_logic_vector(3 downto 0);
    signal My : std_logic;
    signal Eq : std_logic;
    signal Mn : std_logic;
    
begin
    uut : comparador
    port map(
        A => A,
        B => B,
        My => My,
        Eq => Eq,
        Mn => Mn
    );

    process
    begin
        A <= ('0','0','0','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','0','0','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','0','1','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','0','1','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','1','0','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop; 
        A <= ('0','1','0','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','1','1','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('0','1','1','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','0','0','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
         A <= ('1','0','0','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','0','1','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','0','1','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','1','0','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','1','0','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','1','1','0');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        A <= ('1','1','1','1');
        for i in 0 to 15 loop
            B <= std_logic_vector(to_unsigned(i,B'length));
            wait for 10 ns;
        end loop;
        wait;
    end process;
end arch_comparador_tb; 