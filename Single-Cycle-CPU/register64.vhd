library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register64 is
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       data_in : in STD_LOGIC_VECTOR (63 downto 0);
       data_out : out  STD_LOGIC_VECTOR (63 downto 0));
end register64;

architecture Behavioral of register64 is
  type t_mem is array (0 to 0) of std_logic_vector(63 downto 0);
  signal array_mem : t_mem;
begin
process(clk,reset)
  begin
    if(reset='1') then
      -- NOTE: the following functionality allows you to initialize
      -- the contents of the memory
      array_mem <= (
        "0000000000000000000000000000000000000000000000000000000000000000", -- 32-bit word at addr 0
        -- you can add more 32-bit words here if needed...
        -- the following line sets all other bytes in the memory to 0
        others => "0000000000000000000000000000000000000000000000000000000000000000" );
    elsif(clk'event and clk='1') then
      array_mem(0) <= data_in;
    end if;
     
    data_out <= array_mem(0);
  end process;
end Behavioral;