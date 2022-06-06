library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_4reg_tb is
end banco_4reg_tb;

architecture Behavioral of banco_4reg_tb is

    component banco_4reg is
        port (
          clk, wr_en : in std_logic;
          w_addr, r_addr0, r_addr1 : in std_logic_vector(1 downto 0);
          w_data : in std_logic_vector(3 downto 0);
          r_data0, r_data1 : out std_logic_vector(3 downto 0)
        );
      end banco_4reg;

    signal clk, wr_en : std_logic;
    signal w_addr, r_addr0, r_addr1 : std_logic_vector(1 downto 0);
    signal w_data : std_logic_vector(3 downto 0);
    signal r_data0, r_data1 : std_logic_vector(3 downto 0);

begin
    uut: banco_4reg PORT MAP (
        clk => clk,
        wr_en => wr_en,
        w_addr => w_addr,
        r_addr0 => r_addr1,
        w_data => w_data,
        r_data0 => r_data0,
        r_data1 => r_data1
    );

    CLK_process : process
    begin
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;
    
    stim_process : process
    begin
        
    end process;

end Behavioral;