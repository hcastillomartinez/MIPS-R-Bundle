----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hector Castillo Martinez 
-- 
-- Create Date:    13:50:19 04/19/2019 
-- Design Name: 
-- Module Name:    Mult - Behavioral 
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

entity Mult is
    Port ( clk, reset : in  STD_LOGIC;
           write_enable : in  STD_LOGIC;
           multiplicand : in  STD_LOGIC_VECTOR (31 downto 0);
           multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           mfhi : out  STD_LOGIC_VECTOR (31 downto 0);
           mflo : out  STD_LOGIC_VECTOR (31 downto 0));
end Mult;



architecture Behavioral of Mult is

component adder32
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
         carry_in : in  STD_LOGIC;
         sum : out  STD_LOGIC_VECTOR (31 downto 0);
         carry_out : out  STD_LOGIC);
  end component;
  
component register64
  port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       data_in : in STD_LOGIC_VECTOR (63 downto 0);
       data_out : out  STD_LOGIC_VECTOR (63 downto 0));
end component;


signal zero: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal full64: std_logic_vector(63 downto 0):= "0000000000000000000000000000000000000000000000000000000000000000";
signal temp_sum: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal first,temp: std_logic:= '0';
begin

FULL_ADDER: component adder32 port map(full64(63 downto 32), multiplicand, '0', temp_sum, open);
--REG: component register64 port map(clk, reset, full64, full64);

process(clk, write_enable, full64(0))
begin
	if(write_enable = '1') then
		full64 <= zero & multiplier;
	-- has the same issue that main memory had where sometimes it would work and sometimes it doesn't.
	elsif(clk'event and clk ='1') then
		temp <= '0';
		first <= full64(0);
		if(full64(0) = '1') then
			temp <= '1';
			full64(63 downto 32) <= temp_sum;
			end if;
			full64<= '0' & full64(63 downto 1);
	end if;
			
end process;
mfhi <= full64(63 downto 32);
mflo <= full64(31 downto 0);
end Behavioral;

