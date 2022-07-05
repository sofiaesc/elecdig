library IEEE;
use IEEE.std_logic_1164.all;

-- Máquina de estados finitos que simula la secuencia 0-2-4-6 de forma ascendente o descendente,
-- según el flanco de ascenso (o descenso) de la variable Asc.

entity ej6 is
	port( Re : in std_logic;
		Clk : in std_logic;
		Asc : in std_logic;
		Q : out std_logic_vector(2 downto 0)
		);
end ej6;

architecture arch_ej6 of ej6 is
	constant cero: std_logic_vector(2 downto 0) := "000";
	constant dos: std_logic_vector(2 downto 0) := "010";
	constant cuatro: std_logic_vector(2 downto 0) := "100";
	constant seis: std_logic_vector(2 downto 0) := "110";
	signal estado_actual, estado_siguiente: std_logic_vector(2 downto 0);
	
	begin
	process(Clk, Re)
		begin
			if(Re = '1') then
				estado_actual <= cero;
			elsif rising_edge(Clk) then
				estado_actual <= estado_siguiente;
			end if;
	end process;
	
	process(estado_actual)
		begin
			case estado_actual is
				when cero =>
					if(Asc = '1') then
						estado_siguiente <= dos;
					else
						estado_siguiente <= seis;
					end if;
				when dos =>
					if(Asc = '1') then
						estado_siguiente <= cuatro;
					else
						estado_siguiente <= cero;
					end if;
				when cuatro =>
					if(Asc = '1') then
						estado_siguiente <= seis;
					else
						estado_siguiente <= dos;
					end if;	
				when seis =>
					if(Asc = '1') then
						estado_siguiente <= cero;
					else
						estado_siguiente <= cuatro;
					end if;
				WHEN OTHERS =>
					estado_siguiente <= cero;
			end case;
	end process;
	
	Q <= estado_actual;
end arch_ej6;
	