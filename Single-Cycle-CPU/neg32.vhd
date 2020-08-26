library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity neg32 is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0) );
end neg32;

architecture Behavioral of neg32 is
  component adder32
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
         carry_in : in  STD_LOGIC;
         sum : out  STD_LOGIC_VECTOR (31 downto 0);
         carry_out : out  STD_LOGIC);
  end component;
  signal flip_bits : STD_LOGIC_VECTOR (31 downto 0);
begin
  flip_bits <= not a;
  
  ADD:    component adder32    port map(flip_bits,X"00000001",'0',result,open);
  
  
end Behavioral;