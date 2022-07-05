library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lavarropas is
	port( 
		-- ENTRADAS:
		programa : in std_logic_vector(2 downto 0); -- programa a seguir.
		inicio : in std_logic; -- '1' si está en funcionamiento.
		clk : in std_logic; -- señal de reloj.
		rst : in std_logic; -- señal de reset.
		-- SALIDAS:
		S : out std_logic_vector(4 downto 0); -- sensores del tanque.
		v_l, v_j, v_s, v_v : out std_logic; -- válvulas (llenado, jabón, suavizante, vaciado).
		c_vm : out std_logic_vector(1 downto 0); -- velocidad del motor.
		c_b : out std_logic; -- control de la bomba.
		t_t : out std_logic; -- señal de la tapa trabada para LED.
		LED_lavado, LED_enjuague, LED_centrifugado: out std_logic
		);
	end lavarropas;
	
	architecture arch_lavarropas of lavarropas is 
		
		-- estados codificados en grey:
		constant Inicial : std_logic_vector (2 downto 0) := "000";
		constant Llenado1 : std_logic_vector(2 downto 0) := "001";
		constant Lavado : std_logic_vector (2 downto 0) := "011";
		constant Vaciado1 : std_logic_vector(2 downto 0) := "010";
		constant Llenado2 : std_logic_vector(2 downto 0) := "110";
		constant Enjuague : std_logic_vector (2 downto 0) := "100";
		constant Vaciado2 : std_logic_vector(2 downto 0) := "101";
		constant Centrifugado : std_logic_vector (2 downto 0) := "111";

		-- máquina funciona con dos estados, actual y siguiente:
		signal estado_actual, estado_siguiente : std_logic_vector(2 downto 0);
		signal llenado_actual: std_logic_vector(4 downto 0); --  Señal referida a los sensores de agua
		signal timer : unsigned(4 downto 0) := "00000";
	begin
		-- proceso del reloj y el reset:
		process(rst, clk)
		begin
			if rst = '1' then -- si hay flanco ascendente de la señal de reset, se vuelve al estado Inicial.
				estado_actual <= Inicial;
				timer <= (others => '0'); -- Se reinicia el timer.
				llenado_actual <= "00000"; -- Se reinician los sensores de nivel de agua.
			elsif rising_edge(clk) then -- si hay flanco ascendente del reloj, pasa al siguiente estado.
				estado_actual <= estado_siguiente;
				-- El timer se activa y comienza a contar solo en los estados Lavado, Enjuague y Centrifugado
				-- Cada uno de estados tiene su duracion predefinida
				if((estado_actual = Lavado and timer /= (30-1)) OR (estado_actual = Enjuague and timer /= (20-1))
				OR (estado_actual = Centrifugado and timer /= (15-1))) then
					timer <= timer + 1; -- El timer aumenta mientras sea necesario
				
				-- Para simular la entrada y salida de agua, los casos correspondientes se modifica 
				-- el nivel detectado por los sensores 
				elsif ((estado_actual = Llenado1 or estado_actual = Llenado2) and llenado_actual /="11110") then
					llenado_actual <= '1' & llenado_actual(4 downto 1); -- 
				elsif ((estado_actual = Vaciado1 or estado_actual = Vaciado2) and llenado_actual /="00000") then
					llenado_actual <= llenado_actual(3 downto 0) & '0';
				else 
					timer <= (others => '0');
				end if;
			end if;
		end process;
		
		-- proceso según el estado actual y el programa:
		process(estado_actual,programa,llenado_actual,timer)
		begin
			case estado_actual is
				when Inicial =>
				LED_lavado <= '0';
				LED_enjuague <= '0';
				LED_centrifugado <= '0';
				v_l <= '0'; -- cuando está sin hacer nada, válvulas cerradas.
				v_j <= '0';
				v_v <= '0';
				v_s <= '0'; 
				c_b <= '0'; -- cuando está sin hacer nada, la bomba está apagada.
				c_vm <= "00"; -- motor en velocidad de apagado (00).
				if(inicio = '1') then
					if (programa(0) = '1') then
						estado_siguiente <= Llenado1; -- llenado antes del lavado.
					elsif (programa(1) = '1') then -- se podría poner sino un vaciado por las dudas antes de llenar para los dos.
						estado_siguiente <= Llenado2; -- llenado antes del enjuagado.
					elsif (programa(2) ='1') then
						estado_siguiente <= Vaciado2; -- vaciado antes del centrifugado.
					else
						estado_siguiente <= Inicial; -- no se seleccionó un programa.
					end if;
				else
					estado_siguiente <= Inicial;
				end if;
				
				when Llenado1 =>
				if (inicio = '1') then
					v_l <= '1'; -- abro válvula de lavado.
					v_j <= '1'; -- abro válvula de jabón.
					v_s <= '0';
					v_v <= '0'; -- otras válvulas están cerradas.
					c_b <= '0'; -- cierro la bomba.
					if llenado_actual="11110" then -- si está lleno hasta el sensor S3, va a lavar.
						estado_siguiente <= Lavado;
					elsif llenado_actual="11111" then -- si se rebalsó, se apaga.
						estado_siguiente <= Inicial; 
					elsif llenado_actual="00000" or llenado_actual="10000" or llenado_actual="11000" or llenado_actual="11100" then -- sino, sigue llenando.
						estado_siguiente <= Llenado1;
					else -- si no se fue por alguna de esas condiciones, hay un sensor roto.
						estado_siguiente <= Inicial;
					end if;
				else
					estado_siguiente <= Inicial;	
				end if;
				
				when Lavado =>
				if(inicio = '1') then
					LED_lavado <= '1';
					LED_enjuague <= '0';
					LED_centrifugado <= '0';
					v_l <= '0'; -- cierro la valvula de llenado.
					v_j <= '0'; -- cierro la valvula de jabon.
					v_v <= '0';
					v_s <= '0'; -- otras válvulas también se cierran.
					c_vm <= "01"; -- velocidad del motor en bajo (01).
					c_b <= '0'; -- cierro la bomba

					if(timer = (30-1)) then -- si terminó el timer, entonces veo a qué estado pasar.
						if(programa(1) = '1') then
							estado_siguiente <= Vaciado1; -- vuelve al vaciado para enjuagar.
						elsif(programa(2) = '1') then
							estado_siguiente <= Vaciado2; -- va al vaciado para centrifugar.
						else
							estado_siguiente <= Vaciado1; -- vuelve al inicio.
						end if; -- no vuelve al Inicio sin antes vaciar.
					else
						estado_siguiente <= Lavado; -- si no terminó de lavar, continúa lavando.	
					end if;
				else
					estado_siguiente <= Inicial; -- si no está en funcionamiento, vuelve a inicio.
				end if;
				
				when Vaciado1 =>
				if (inicio = '1') then
					LED_lavado <= '0';
					LED_enjuague <= '0';
					LED_centrifugado <= '0';
					v_v <= '1'; -- abro válvula de vaciado.
					v_l <= '0';
					v_s <= '0';
					v_j <= '0'; -- otras válvulas se cierran.
					c_b <= '1'; -- abro la bomba.
					c_vm <= "00"; -- velocidad de motor apagado (00).
					if llenado_actual="00000" then -- si está vacío, sigue con lo próximo.
						if programa(1) = '1' then -- si tiene que enjuagar, llena de nuevo.
							estado_siguiente <= Llenado2;
						else -- si ya terminó el programa, vuelve al inicial.
							estado_siguiente <= Inicial;
						end if;
					elsif llenado_actual="10000" or llenado_actual="11000" or llenado_actual="11100" or llenado_actual="11110" or llenado_actual="11111" then
						estado_siguiente <= Vaciado1; -- si tiene agua todavia, sigue vaciando.
					else -- si no se fue por alguna de esas condiciones, hay un sensor roto.
						estado_siguiente <= Inicial;
					end if;
				else
					estado_siguiente <= Inicial;	
				end if;
				
				when Llenado2 =>
				if (inicio = '1') then
					v_v <= '0'; -- cierro válvula de vaciado.
					v_j <= '0'; -- válvula de jabón debe estar cerrada.
					c_b <= '0'; -- cierro la bomba.
					v_l <= '1'; -- abro la válvula de lavado.
					v_s <= '1'; -- abro la válvula de suavizante.
					if llenado_actual="11110" then -- si ya está lleno, continúa con enjuague.
						estado_siguiente <= Enjuague;
					elsif llenado_actual="11111" then -- si se rebalsó, va al inicio.
						estado_siguiente <= Inicial;
					elsif llenado_actual="00000" or llenado_actual="10000" or llenado_actual="11000" or llenado_actual="11100" then -- sino, sigue llenando.
						estado_siguiente <= Llenado2;
					else -- si no se fue por alguna de esas condiciones, hay un sensor roto.
						estado_siguiente <= Inicial;
					end if;
				else
					estado_siguiente <= Inicial;
				end if;
				
				when Enjuague =>
				if(inicio = '1') then
					LED_lavado <= '0';
					LED_enjuague <= '1';
					LED_centrifugado <= '0';
					v_l <= '0'; -- cierro válvula de llenado.
					v_s <= '0'; -- cierro válvula de suavizante.
					v_v <= '0';
					v_j <= '0'; -- otras válvulas deben estar cerradas.
					c_vm <= "01"; -- velocidad de motor baja (0).
					c_b <= '0'; -- cierro la bomba.
					if(timer = (20-1)) then -- terminó el timer.
						estado_siguiente <= Vaciado2; -- sigue con vaciado
					else -- no terminó el timer.
						estado_siguiente <= Enjuague; -- continúa enjuagando. 
					end if;
				else
					estado_siguiente <= Inicial;
				end if;
				
				when Vaciado2 =>
				if (inicio = '1') then
					LED_lavado <= '0';
					LED_enjuague <= '0';
					LED_centrifugado <= '0';
					v_v <= '1'; -- abro válvula de vaciado.
					v_s <= '0';
					v_j <= '0';
					v_l <= '0'; -- cierro otras válvulas.
					c_vm <= "00"; -- velocidad de motor apagado (00).
					c_b <= '1'; -- abro la bomba.
					if llenado_actual="00000" then -- si está vacío, sigue con centrifugado.
						if (programa(2) = '1') then
							estado_siguiente <= Centrifugado;
						else
							estado_siguiente <= Inicial;
						end if;
					elsif llenado_actual="10000" or llenado_actual="11000" or llenado_actual="11100" or llenado_actual="11110" or llenado_actual="11111" then
						estado_siguiente <= Vaciado2; -- si tiene agua todavia, sigue vaciando.
					else -- si no se fue por alguna de esas condiciones, hay un sensor roto.
						estado_siguiente <= Inicial;
					end if;
				else
					estado_siguiente <= Inicial;	
				end if;
				
				when Centrifugado =>
				if(inicio = '1') then
					LED_lavado <= '0';
					LED_enjuague <= '0';
					LED_centrifugado <= '1';
					v_v <= '0'; -- cierro válvula de vaciado.
					v_s <= '0';
					v_j <= '0';
					v_l <= '0'; -- otras válvulas deben estar cerradas.
					c_b <= '0'; -- cierro la bomba.
					c_vm <= "11"; -- velocidad de motor alta (11).
					if(timer = (15-1)) then -- si terminó el timer de centrifugado, terminó el programa.	
						estado_siguiente <= Inicial;
					else
						estado_siguiente <= Centrifugado; -- sigue centrifugando si no terminó el timer.
					end if;
				else
					estado_siguiente <= Inicial;	
				end if;
				when others => 
				estado_siguiente <= Inicial;
			end case;
		end process;
		
		t_t <= inicio; -- se destraba cuando vuelve al estado inactivo.
		S <= llenado_actual;
	end arch_lavarropas;
	