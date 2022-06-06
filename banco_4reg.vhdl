library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Con el registro paralelo-paralelo del ejercicio 6 construya un banco de 4 registros de 4 bits
-- de ancho. El banco tendrá dos salidas de datos, que podrán elegirse de manera independiente,
-- y una entrada de datos separada de las salidas.

entity banco_4reg is
  port (
    clk, wr_en : in std_logic;
    w_addr, r_addr0, r_addr1 : in std_logic_vector(1 downto 0);
    w_data : in std_logic_vector(3 downto 0);
    r_data0, r_data1 : out std_logic_vector(3 downto 0)
  );
end banco_4reg;

architecture Behavioral of banco_4reg is
  type 4reg_4b is array(3 downto 0) of std_logic_vector(3 downto 0);
  signal array_reg : 4reg_4b;
  begin
    process(clk)
    begin
      if(clk'event and clk='1') then
        if wr_en = '1' then
          array_reg(to_integer(unsigned(w_addr))) <= w_data;
        end if;
      end if;
    end process;

    r_data0 <= array_reg(to_integer(unsigned(r_addr0)));
    r_data1 <= array_reg(to_integer(unsigned(r_addr1)));
end Behavioral ; 