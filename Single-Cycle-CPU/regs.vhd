library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regs is
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       addr1 : in  STD_LOGIC_VECTOR (4 downto 0);
		 addr2 : in  STD_LOGIC_VECTOR (4 downto 0);
		 waddr : in  STD_LOGIC_VECTOR (4 downto 0);
       data_in : in STD_LOGIC_VECTOR (31 downto 0);
		 mfhi : in STD_LOGIC_VECTOR (31 downto 0);
		 mflo : in STD_LOGIC_VECTOR (31 downto 0);
		 m_write: in std_logic;
		 mfhi_read: in std_logic;
		 mflo_read: in std_logic;
       write_enable : in  STD_LOGIC;
       data_out1 : out  STD_LOGIC_VECTOR (31 downto 0);
		 data_out2 : out  STD_LOGIC_VECTOR (31 downto 0));
end regs;

architecture Behavioral of regs is
  type t_mem is array (0 to 33) of std_logic_vector(31 downto 0);
  signal array_mem : t_mem;
  signal lo,hi: STD_LOGIC_VECTOR (5 downto 0);
begin
process(clk,reset)
  begin
	lo <= "100000";
	 hi <= "100001";
    if(reset='1') then
      -- NOTE: the following functionality allows you to initialize
      -- the contents of the memory
      array_mem <= (
        "00000000000000000000000000000000", -- 32-bit word at addr 0
        "00000000000000000000000000000000", -- 32-bit word at addr 1
        "00000000000000000000000000000000", -- 32-bit word at addr 2
        -- you can add more 32-bit words here if needed...
        -- the following line sets all other bytes in the memory to 0
        others => "00000000000000000000000000000000" );
    elsif(clk'event and clk='1' and write_enable='1') then
      array_mem(to_integer(signed(waddr))) <= data_in;
    end if;
	 if(m_write = '1') then
		array_mem(to_integer(signed(hi))) <= mfhi;
		array_mem(to_integer(signed(lo))) <= mflo;
	 end if;
    if(reset='0') then
		if(mfhi_read = '1') then
			data_out1 <=array_mem(to_integer(signed(hi)));
			data_out2 <= "00000000000000000000000000000000";
		elsif(mflo_read = '1') then
			data_out1 <=array_mem(to_integer(signed(lo)));
			data_out2 <= "00000000000000000000000000000000";
		else
      data_out1 <= array_mem(to_integer(signed(addr1)));
		data_out2 <= array_mem(to_integer(signed(addr2)));
		end if;
    else
      data_out1 <= "00000000000000000000000000000000";
		data_out2 <= "00000000000000000000000000000000";
    end if;
  end process;
end Behavioral;