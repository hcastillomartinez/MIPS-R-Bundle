library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           carry_in : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           carry_out : out  STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is

begin

sum <= a xor (b xor carry_in);
carry_out <= (a and b) or (carry_in and (a xor b));

end Behavioral;

