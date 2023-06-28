library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 


entity Principal is
  port (
--  La entrada C representa el sensor del Carnet, la entrada B representa el sensor de
--  la bata.

    C, clk, B : in std_logic; 	
--	 La salida S representa al motor que mueve la puerta, dependiendo de su valor lógico
--	 se moverá hacia una dirección u otra, la salida bata, se usa para mostrar un mensaje 
--	 en la pantalla que indica que no hay bata.
	
    L1,L2,L3: out std_logic;
	 reg: out std_logic_vector(3 downto 0)-- Salida motor
  );
end entity Principal;

architecture dispensador of Principal is

	component anti_rebote

	port(
		-- Input ports
		clk: in  std_logic;
		btn: in	std_logic;			-- Señal del pulsador
		
		-- Output ports
		bto: out std_logic);   			-- salida señal limpia del pulsador
		
	end component;
	
	signal D, Q: std_logic_vector(1 downto 0);
	signal clk_aux: std_logic;
	signal CN, BN, S, bata: std_logic;
	signal Posicion : std_logic_vector(3 downto 0);

begin
	CN <= (C);
	
	--rebote: anti_rebote port map(clk,C,CN);
	
	
	BN <= not (B);
	D(0) <= (Q(1) AND Q(0)) OR (CN AND Q(0)) OR (NOT(BN) AND Q(0)) OR (CN AND NOT(BN) AND Q(1));
	D(1) <= (Q(1) AND NOT(Q(0))) OR  (NOT(CN) AND Q(1) ) OR (NOT(BN) AND Q(1)) OR (CN AND BN AND NOT(Q(0)));
	
	s <= NOT((Q(1) AND NOT(Q(0))) OR  (NOT(CN) AND Q(1) ) OR (NOT(BN) AND Q(1)) OR (CN AND BN AND NOT(Q(0))));

	bata <= NOT((Q(1) AND Q(0)) OR (CN AND Q(0)) OR (NOT(BN) AND Q(0)) OR (CN AND NOT(BN) AND Q(1)));
	
	L1 <= (not(Q(0)) AND NOT(Q(1)));
	
	L2 <= (Q(0) AND Q(1));
	
	L3 <= not(Q(1)) AND Q(0);
	
--	



	df : entity work.divisordefrecuencia	--Divisor de frecuencia para que los FF funcionen
					port map( clk => clk,
						      Nciclos => 5000000,
								f => clk_aux);
	
	d0 : entity work.Flip_FlopD				--Flip flop tipo D
				  port map( clk => clk_aux,
						      d => D(0),
								q => Q(0));
   d1 : entity work.Flip_FlopD				--Flip flop tipo D
				  port map( clk => clk_aux,
						      d => D(1),
								q => Q(1));
	posicion(0) <= s;	--Esta parte confgura en que posiccion inicia el motor  
	Posicion(1)	<= NOT S;
	Posicion(2)	<= '1';
	Posicion(3)	<= '1';
	
   MOTOR : entity work.Motor_paso_a_paso	--Mueve el motor paso a paso 
					port map (clk => clk,
									b => posicion,
									reg => reg);
	 
end architecture dispensador;