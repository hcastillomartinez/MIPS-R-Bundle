library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux5 is
    Port ( a : in  STD_LOGIC_VECTOR(4 downto 0);
           b : in  STD_LOGIC_VECTOR(4 downto 0);
           control : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR(4 downto 0));
end mux5;

architecture Behavioral of mux5 is

begin

with control select
    z <= b when '1',
	      a when others;

end Behavioral;