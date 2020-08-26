library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lshift2 is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end lshift2;

architecture Behavioral of lshift2 is

begin
z <= a(29 downto 0) & "00";
end Behavioral;