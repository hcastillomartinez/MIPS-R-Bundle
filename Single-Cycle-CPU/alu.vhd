library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
			  ctrl : in  STD_LOGIC_VECTOR (4 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0);
			  zero : out  STD_LOGIC );
end alu;

architecture Behavioral of alu is
  component adder32
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
         carry_in : in  STD_LOGIC;
         sum : out  STD_LOGIC_VECTOR (31 downto 0);
         carry_out : out  STD_LOGIC);
  end component;
  component neg32
  Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0) );
  end component;
  signal neg_b, temp_result, and_result, or_result, add_result, sub_result, slt_result, nor_result : STD_LOGIC_VECTOR (31 downto 0);
begin
  ADD:       component adder32    port map(a,b,'0',add_result,open);
  
  NEGATIVE:  component neg32      port map(b,neg_b);
  SUB:       component adder32    port map(a,neg_b,'0',sub_result,open);
  
  and_result <= a and b;
  or_result <= a or b;
  nor_result <= a nor b;
  
  -- (a - b) < 0   ==>  a < b
  with sub_result(31) select
  slt_result <= X"00000001" when '1',
                X"00000000" when others;
  
  with ctrl select
  temp_result <=
  and_result when "00000",
  or_result  when "00001",
  add_result when "00010",
  sub_result when "00110",
  slt_result when "00111",
  nor_result when "01100",
  X"00000000" when others;
  
  result <= temp_result;
  
  with temp_result select
  zero <= '1' when X"00000000",
          '0' when others;
end Behavioral;