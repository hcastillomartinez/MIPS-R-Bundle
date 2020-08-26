library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
           control : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR(31 downto 0));
end mux;

architecture Behavioral of mux is

begin

with control select
    z <= b when '1',
	      a when others;

end Behavioral;