library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--Declaración de la entidad
entity Motor_paso_a_paso is

	port(
		-- Input ports
		clk: in  std_logic;
		b: in std_logic_vector(3 downto 0);--Pulsadores de posicion 

		-- Output ports		
		--led: out std_logic_vector(1 downto 0);-- Visualizar posiciones 
		reg: out std_logic_vector(3 downto 0));-- Salida motor 
		
end Motor_paso_a_paso;

architecture maquina of Motor_paso_a_paso is

signal f : std_logic;							--Frecuencia dividida
signal bcl : std_logic_vector(3 downto 0);--Pulsos limpios
signal pul : std_logic;						--Indica presion del pulsador 
signal ps,pa: integer range 0 to 3;			--Valor de pos. siguiente

component anti_rebote

	port(
		-- Input ports
		clk: in  std_logic;
		btn: in	std_logic;			-- Señal del pulsador
		
		-- Output ports
		bto: out std_logic);   			-- salida señal limpia del pulsador
		
	end component;

	component div_frec
	
	port(
		-- Input ports
		clk: in  std_logic;
		Nciclos: in	integer;			-- número de ciclos para la frecuencia deseada
		
		-- Output ports
		f: out std_logic);
		
	end component;
	
	component Mov_posicion
	
	port(
		-- Input ports
		clk: in  std_logic;
		ps: in	integer;			-- número de ciclos para la frecuencia deseada
		
		-- Output ports
		reg: out std_logic_vector(3 downto 0));
		
	end component;
	
begin 
	--Preprocesamiento
	
	frec: div_frec port map(clk,50000,f);
	
	ar: for i in 0 to 3 generate
		antr: anti_rebote port map(f,b(i),bcl(i));
	end generate;
	
	--Funcionamiento
	
	mp: mov_posicion port map(f,ps,reg);
	
	--Asignacion de posicion
	
	pul <= bcl(3) or bcl(2) or bcl(1) or bcl(0);
	
	process(pul) begin 
	
		if rising_edge(pul) then 
			ps <= pa;
		end if;
		
	end process;
	
	with not(b) select
		pa <= 0 when "0001",		--b(0) = '1' = pos 0
				1 when "0010",		--b(1) = '1' = pos 1
				2 when "0100",
				3 when others;

--Visualizacion	
	
--	with ps select
--		led <= "00" when 0,
--				 "01" when 1,
--				 "10" when 2,
--				 "11" when others;


end maquina;