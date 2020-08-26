library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signextend is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end signextend;

architecture Behavioral of signextend is

begin
z(15 downto 0) <= a;
G: for i in 16 to 31 generate 
  z(i) <= a(15); 
end generate G;
end Behavioral;