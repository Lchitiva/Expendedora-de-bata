library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 


entity Flip_FlopD is
  port (
    clk : in std_logic;
    d : in std_logic;
    q : out std_logic
  );
end entity Flip_FlopD;

architecture arc_ff of Flip_FlopD is
  signal q_internal : std_logic;
begin
  process (clk)
  begin
    if rising_edge(clk) then
      q_internal <= d;
    end if;
  end process;

  q <= q_internal;
end architecture arc_ff;