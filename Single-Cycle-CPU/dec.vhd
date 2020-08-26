----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hector Castillo Martinez
-- 
-- Create Date:    15:56:37 04/20/2019 
-- Design Name: 
-- Module Name:    dec - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dec is
    Port ( ctrl : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           m_write : out  STD_LOGIC;
           stall : out  STD_LOGIC);
end dec;

architecture Behavioral of dec is

component adder32
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
         carry_in : in  STD_LOGIC;
         sum : out  STD_LOGIC_VECTOR (31 downto 0);
         carry_out : out  STD_LOGIC);
  end component;
  
signal reg, sum: std_logic_vector(31 downto 0);
signal temp: std_logic;


begin
-- Decrease by 1
DECREMENT: component adder32 port map(reg, "11111111111111111111111111111111", '0', sum,open);

process(clk,ctrl,temp)
begin
	if(ctrl='1') then
		reg <= "00000000000000000000000000100000";
		temp <= '0';
	elsif(clk'event and clk='1' and temp = '0') then
		reg <= sum;
	end if;
	
	--Have at 1 because would only set to correct numbers at the 33 cycle.
	-- This worked like it should after testing.
	if(reg = "00000000000000000000000000000001") then
		stall<= '0';
		temp <= '1';
		m_write <= '1';
		
	else
		temp <= '0';
		stall <= '1';
		m_write <= '0';
	end if;
		
end process;


end Behavioral;

