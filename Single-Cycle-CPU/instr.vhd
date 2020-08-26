library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr is
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
		 stall : in std_logic;
       addr : in  STD_LOGIC_VECTOR (31 downto 0);
       data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end instr;

architecture Behavioral of instr is
  type t_mem is array (0 to 511) of std_logic_vector(7 downto 0);
  signal array_mem : t_mem;
begin
process(clk,reset)
  begin
    if(reset='1') then
      -- NOTE: the following functionality allows you to initialize
      -- the contents of the memory
      array_mem <= (
		  X"00", X"00", X"00", X"00", -- nop
		  X"20", X"09", X"00", X"05", -- addi $t1, $zero, 5
		  X"20", X"0a", X"00", X"04", -- addi $t2, $zero, 4
		  X"20", X"08", X"00", X"00", -- addi $t0, $zero, 0
		  X"11", X"40", X"00", X"03", -- beq $t2, $zero, 0x00000020 <done>
		  X"01", X"09", X"40", X"20", -- add $t0, $t0, $t1
		  X"21", X"4a", X"ff", X"ff", -- addi $t2, $t2, -1
		  X"08", X"00", X"00", X"04", -- j 0x00000010 <loop>
		  X"00", X"00", X"00", X"00", -- nop
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 0
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 4
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 8
        -- you can add more 32-bit words here if needed...
        -- the following line sets all other bytes in the memory to 0
        others => "00000000" );
    end if;
     
    if(reset='0' and stall = '1') then
      data_out <= array_mem(to_integer(signed(addr))+0) &
                  array_mem(to_integer(signed(addr))+1) &
                  array_mem(to_integer(signed(addr))+2) &
                  array_mem(to_integer(signed(addr))+3);
    else
      data_out <= "00000000000000000000000000000000";
    end if;
  end process;
end Behavioral;