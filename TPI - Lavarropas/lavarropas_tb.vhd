library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity lavarropas_tb is
end lavarropas_tb;

architecture behave of lavarropas_tb is

  component lavarropas
    port( 
		-- ENTRADAS:
        S : out std_logic_vector(4 downto 0); -- sensores del tanque.
        programa : in std_logic_vector(2 downto 0); -- programa a seguir.
        inicio : in std_logic; -- '1' si está en funcionamiento.
        clk : in std_logic; -- señal de reloj.
        rst : in std_logic; -- señal de reset.
		-- SALIDAS:
		    v_l, v_j, v_s, v_v : out std_logic; -- válvulas (llenado, jabón, suavizante, vaciado).
        c_vm : out std_logic_vector(1 downto 0); -- velocidad del motor.
		    c_b : out std_logic; -- control de la bomba.
		    t_t : out std_logic; -- señal de la tapa trabada para LED.
		    -- estado : out std_logic_vector(2 downto 0) -- estado actual.
        LED_lavado, LED_enjuague, LED_centrifugado: out std_logic
    );
  end component;

  -- ENTRADAS:
  signal clk, rst: std_logic;
  signal inicio: std_logic := '0';
  signal programa: std_logic_vector(2 downto 0);
  signal S: std_logic_vector(4 downto 0);
  
  -- SALIDAS:
  signal v_l, v_j, v_s, v_v, c_b, t_t : std_logic;
  signal LED_lavado, LED_enjuague, LED_centrifugado: std_logic;
  signal c_vm : std_logic_vector(1 downto 0);

BEGIN
  uut: lavarropas
  port map(
      clk => clk,
      rst => rst,
      inicio => inicio,
      S => S,
      programa => programa,
      v_l => v_l,
      v_j => v_j,
      v_s => v_s,
      v_v => v_v,
      c_b => c_b,
      t_t => t_t,
      c_vm => c_vm,
      LED_lavado => LED_lavado,
      LED_enjuague => LED_enjuague,
      LED_centrifugado => LED_centrifugado
  );

  clock: process
  begin
      clk <= '0'; wait for 5 ns;
      clk <= '1'; wait for 5 ns;
  end process;

  stim: process
  begin
    rst <= '1'; wait for 10 ns;
    
    rst <= '0'; 
    
    -- Programas:
    -- 000 -> Estado Inicial
    -- 001 -> Lavado
    -- 011 -> Lavado y enjuague
    -- 101 -> Lavado y centrifugado
    -- 111 -> Lavado, enjuague y centrifugado
    -- 010 -> Enjuague
    -- 110 -> Enjuague y centrifugado
    -- 100 -> Centrifugado
    
    programa <= "111";
    inicio <= '1'; -- Boton de iniciar el proceso, si esta activo se traba la tapa.
    

    -- 430 ns para ver el proceso de lavado
    -- 740 ns para ver el proceso de lavado y enjuague
    -- 590 ns para ver el proceso de lavado y centrifugado
    -- 900 ns para ver el proceso de lavado, enjuague y centrifugado
    -- 330 ns para ver el proceso de enjuague
    -- 490 ns para ver el proceso de enjuague y centrifugado
    -- 190 ns para ver el proceso de centrifugado

    wait for 1050 ns; -- Cambiar segun estado si se quiere
    inicio <= '0';
    wait;


  end process;
END behave;
