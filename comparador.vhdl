library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador is
  port (
    A : in std_logic_vector(3 downto 0);
    B : in std_logic_vector(3 downto 0);
    My : out std_logic;
    Eq : out std_logic;
    Mn : out std_logic
  );
end comparador;

architecture behavioral of comparador is
begin
    My <= '1' when A > B else '0';
    Eq <= '1' when A = B else '0';
    Mn <= '1' when A < B else '0';
end behavioral; 