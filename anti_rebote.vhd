library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Recordando el diseño del registro de desplazamiento, se necesita de entrada una señal de reloj 
-- para hacer el muestreo del pulsador, la señal del pulsador y de salida la señal limpia del pulsador

-- * Construye la entidad con las señales de entrada y salida requeridas.

entity anti_rebote is

	port(
		-- Input ports
		clk: in  std_logic;
		btn: in	std_logic;			-- Señal del pulsador
		
		-- Output ports
		bto: out std_logic);   			-- salida señal limpia del pulsador
		
end anti_rebote;


architecture registro of anti_rebote is

	-- * Declara una señal vector de longitud mayor a 3 bits (este será el registro de desplazamiento).
	--signal registro: std_logic_vector(3 downto 0);
	signal reg: std_logic_vector(3 downto 0);

begin


	process(btn,clk)
	
	begin
	
		if rising_edge(clk) then 
			
			reg <= reg(2 downto 0) & not btn;
			
		end if;
		
		if reg = "1111" then 
			bto <= '1';
		else
			bto <= '0';
		end if;
	
	end process;

end registro;