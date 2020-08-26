library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
  Port(opcode : in std_logic_vector(5 downto 0);
       funct : in std_logic_vector(5 downto 0);
		 aluop : out std_logic_vector(4 downto 0);
		 regdst : out std_logic;
		 jump : out std_logic;
		 branch : out std_logic_vector(1 downto 0);
		 memread : out std_logic;
		 memtoreg : out std_logic;
		 memwrite : out std_logic;
		 alusrc : out std_logic;
		 regwrite : out std_logic;
		 mfhi_read:out std_logic;
		 mflo_read: out std_logic;
		 stall: out std_logic
		 );
end control;

architecture Behavioral of control is
  signal funct2 : std_logic_vector(5 downto 0);
  signal tempout : std_logic_vector(16 downto 0);
begin
  mfhi_read <= tempout(16);
  mflo_read <= tempout(15);
  stall <= tempout(14);
  aluop <= tempout(13 downto 9);
  regdst <= tempout(8);
  jump <= tempout(7);
  branch <= tempout(6 downto 5);
  memread <= tempout(4);
  memtoreg <= tempout(3);
  memwrite <= tempout(2);
  alusrc <= tempout(1);
  regwrite <= tempout(0);
  with opcode select
    funct2 <= funct when "000000",
	           "000000" when others;
	-- chose to add the 3 extra bits in the front and made sure that I grab them correctly
	-- later when setting up the outs.
  with opcode & funct2 select
    tempout <=
"00000010" & "100000001" when "000000" & "100000",
"00000010" & "000000011" when "001000" & "000000",
"00000110" & "100000001" when "000000" & "100010",
"00000000" & "100000001" when "000000" & "100100",
"00000001" & "100000001" when "000000" & "100101",
"00001100" & "100000001" when "000000" & "100111",
"00000010" & "000011011" when "100011" & "000000",
"00000010" & "000000110" when "101011" & "000000",
"00000111" & "100000001" when "000000" & "101010",
"00000110" & "001100000" when "000100" & "000000",--beq
"00000111" & "000100000" when "000101" & "000000", --bne
"00000000" & "010000000" when "000010" & "000000",
"00000010" & "100000001" when "000000" & "000000",
"10000000" & "100000000" when "000000" & "010000", -- mfhi
"01000000" & "100000000" when "000000" & "010010", --mflo
"00100000" & "000000000" when "000000" & "011000", --mult
"00000000" & "000000000" when others;

end Behavioral;