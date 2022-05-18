library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_7seg is
    port (
        -- bcd(3): A, bcd(2): B, bcd(1): C, bcd(0): D
        bcd : in std_logic_vector(3 downto 0);
        LT : in std_logic;
        BI : in std_logic;
        seg : out std_logic_vector(6 downto 0)
    );
end entity bcd_7seg;

architecture arch_bcd_7seg of bcd_7seg is

begin
    -- segmento a:
    seg(0) <= ((not(bi)) and ((lt) or (not(bcd(3)) and bcd(1)) or (not(bcd(2)) and not(bcd(1)) and not(bcd(0))) or (bcd(3) 
    and not(bcd(2)) and not(bcd(1))) or (not(bcd(3)) and bcd(2) and bcd(0))));
    -- segmento b:
    seg(1) <= ((not(bi)) and ((lt) or (not(bcd(2)) and not(bcd(1))) or (not(bcd(3)) and not(bcd(2))) or (not(bcd(3)) and 
            not(bcd(1)) and not(bcd(0))) or (not(bcd(3)) and bcd(1) and bcd(0))));
    -- segmento c:
    seg(2) <= ((not(bi)) and ((lt) or (not(bcd(2)) and not(bcd(1))) or (not(bcd(3)) and bcd(0)) or (not(bcd(3)) and bcd(2))));
    -- segmento d:
    seg(3) <= ((not(bi)) and ((lt) or (not(bcd(3)) and bcd(2) and not(bcd(1)) and bcd(0)) or (not(bcd(2)) and not(bcd(1))
            and not(bcd(0))) or (not(bcd(3)) and not(bcd(2)) and bcd(1)) or (not(bcd(3)) and bcd(1) and 
            not(bcd(0)))));
    -- segmento e:
    seg(4) <= ((not(bi)) and ((lt) or (not(bcd(2)) and not(bcd(1)) and not(bcd(0))) or (not(bcd(3)) and bcd(1) and not(bcd(0)))));
    -- segmento f:
    seg(5) <= ((not(bi)) and ((lt) or (bcd(3) and not(bcd(2)) and not(bcd(1))) or (not(bcd(3)) and bcd(2) and not(bcd(0))) or
            (not(bcd(3)) and not(bcd(1)) and not(bcd(0))) or (not(bcd(3)) and bcd(2) and not(bcd(1)))));
    -- segmento g:
    seg(6) <= ((not(bi)) and ((lt) or (bcd(3) and not(bcd(2)) and not(bcd(1))) or (not(bcd(3)) and bcd(2) and not(bcd(1))) or
            (not(bcd(3)) and not(bcd(2)) and bcd(1)) or (not(bcd(3)) and bcd(1) and not(bcd(0)))));
end arch_bcd_7seg;