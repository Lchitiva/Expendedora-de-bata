library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Mov_posicion is
	
	port(
		-- Input ports
		clk: in  std_logic;		--Señal de relog
		ps: in	integer;			-- posicion
		
		-- Output ports
		reg: out std_logic_vector(3 downto 0));
		
end Mov_posicion;

architecture maquina of Mov_posicion is 

	signal r : std_logic_vector(3 downto 0) := "0001";	--alimentacion Bobinas
	signal s : std_logic;									  	--Sentido
	
	signal f,p,d: integer range -4000 to 4000 := 0;		--pos final, actual, diferencia
	
begin 

	f <= 2000/4*ps;
	d <= f-p;
	
	process(clk)
	
	begin 
	
		if rising_edge(clk) then 
		
		--Indicacion de sentido
		
			if d > 0 then 
				s <= '1';
			elsif d < 0 then 
				s <= '0';
			end if;
		
		--Generacion de movimiento
		
			if not(f = p) then 
			
				if s = '0' then 
					r <= r(0) & r(3 downto 1);
				else
					r <= r(2 downto 0) & r(3);
				end if;
		
			end if;
		
		--Conteo
		
			if not(f = p) then
		
				if s = '1' then
					p <= p + 1;
				elsif s = '0' then
					p <= p - 1;
				end if;
		
			end if;
	
		end if;
	
	end process;
	
	reg <= r;

end maquina;
	

			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	