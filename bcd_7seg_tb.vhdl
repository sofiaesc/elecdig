library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcd_7seg_tb is
end bcd_7seg_tb;

architecture arch_bcd_7seg_tb of bcd_7seg_tb is
    component bcd_7seg is
        port (
            bcd : in std_logic_vector(3 downto 0);
            LT : in std_logic;
            BI : in std_logic;
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal bcd : std_logic_vector(3 downto 0);
    signal LT : std_logic;
    signal BI : std_logic;
    signal seg : std_logic_vector(6 downto 0);

    begin
        uut : bcd_7seg
        port map (
            bcd => bcd,
            LT => LT,
            BI => BI,
            seg => seg
        );
    process
        begin
        LT <= '0';
        BI <= '0';
        for i in 0 to 15 loop
            bcd <= std_logic_vector(to_unsigned(i,bcd'length));
            wait for 10 ns;
        end loop;
        
        LT <= '0';
        BI <= '1';
        for i in 0 to 15 loop
            bcd <= std_logic_vector(to_unsigned(i,bcd'length));
            wait for 10 ns;
        end loop;

        LT <= '1';
        BI <= '0';
        for i in 0 to 15 loop
            bcd <= std_logic_vector(to_unsigned(i,bcd'length));
            wait for 10 ns;
        end loop;

        LT <= '1';
        BI <= '1';
        for i in 0 to 15 loop
            bcd <= std_logic_vector(to_unsigned(i,bcd'length));
            wait for 10 ns;
        end loop;

        wait;
    end process;
end arch_bcd_7seg_tb; 