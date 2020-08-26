library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem is
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       addr : in  STD_LOGIC_VECTOR (31 downto 0);
       data_in : in STD_LOGIC_VECTOR (31 downto 0);
       write_enable : in  STD_LOGIC;
       read_enable : in  STD_LOGIC;
       data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end mem;

architecture Behavioral of mem is
  type t_mem is array (0 to 511) of std_logic_vector(7 downto 0);
  type c_mem is array (0 to 7) of std_logic_vector (64 downto 0);
  signal array_mem : t_mem;
  signal cache_mem : c_mem;
  signal c_data: std_logic_vector(64 downto 0);
  signal index: std_logic_vector(2 downto 0);
  signal v,read_already, temp,temp1,temp2: std_logic:= '0';
  signal tag: std_logic_vector(28 downto 0):= "00000000000000000000000000000";
  signal word: std_logic_vector(31 downto 0);
begin
process(clk,reset)
  begin
	 if(reset = '1') then
		cache_mem <= ("00000000000000000000000000000000000000000000000000000000000000000",
				"00100000000000000000000000000000000000000000000000000000000000000",
				"01000000000000000000000000000000000000000000000000000000000000000",
				"01100000000000000000000000000000000000000000000000000000000000000",
				"10000000000000000000000000000000000000000000000000000000000000000",
				"10100000000000000000000000000000000000000000000000000000000000000",
				"11000000000000000000000000000000000000000000000000000000000000000",
				"11100000000000000000000000000000000000000000000000000000000000000");
				c_data <= "00000000000000000000000000000000000000000000000000000000000000000";
		
		elsif(clk'event and clk='1' and write_enable='1') then
			cache_mem(to_integer(unsigned(index)))(31 downto 0) <= array_mem(to_integer(signed(addr))+0) &
																					 array_mem(to_integer(signed(addr))+1) &
																					 array_mem(to_integer(signed(addr))+2) &
																					 array_mem(to_integer(signed(addr))+3);
																					 
			cache_mem(to_integer(unsigned(index)))(60 downto 32) <= addr(31 downto 3);																		 
			cache_mem(to_integer(unsigned(index)))(61) <= '1';		
		end if;
		-- chose to leave the tag bits as 29 because accessing the main memory
		-- with a 32 bit number works as shown by Jed's code.
	 if(read_enable = '1' and reset = '0') then
			index <= addr(2 downto 0);
			c_data <= cache_mem(to_integer(unsigned(index)));
			v <= c_data(61);
			tag <= c_data(60 downto 32);
			word <= c_data(31 downto 0);
			if(v = '1' and tag = addr(31 downto 3)) then
				data_out <= word;
				read_already <= '1';
			else
				cache_mem(to_integer(unsigned(index)))(31 downto 0) <= array_mem(to_integer(signed(addr))+0) &
																						 array_mem(to_integer(signed(addr))+1) &
																						 array_mem(to_integer(signed(addr))+2) &
																						 array_mem(to_integer(signed(addr))+3);
				cache_mem(to_integer(unsigned(index)))(60 downto 32) <= addr(31 downto 3);																		 
				cache_mem(to_integer(unsigned(index)))(61) <= '1';
				data_out <= array_mem(to_integer(signed(addr))+0) & array_mem(to_integer(signed(addr))+1) &
																				    array_mem(to_integer(signed(addr))+2) &
																					 array_mem(to_integer(signed(addr))+3);
				read_already <= '1';
				end if;
	 end if;
	
    if(reset='1') then
      -- NOTE: the following functionality allows you to initialize
      -- the contents of the memory
      array_mem <= (
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 0
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 4
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 8
        -- you can add more 32-bit words here if needed...
        -- the following line sets all other bytes in the memory to 0
        others => "00000000" );
    elsif(clk'event and clk='1' and write_enable='1') then
      array_mem(to_integer(signed(addr))+0) <= data_in(31 downto 24);
      array_mem(to_integer(signed(addr))+1) <= data_in(23 downto 16);
      array_mem(to_integer(signed(addr))+2) <= data_in(15 downto 8);
      array_mem(to_integer(signed(addr))+3) <= data_in(7 downto 0);
    end if;
     
    if(read_enable='1' and reset='0') then
      if(read_already = '0') then
		data_out <= array_mem(to_integer(signed(addr))+0) &
                  array_mem(to_integer(signed(addr))+1) &
                  array_mem(to_integer(signed(addr))+2) &
                  array_mem(to_integer(signed(addr))+3);
		end if;
    else
      data_out <= "00000000000000000000000000000000";
    end if;
	 read_already <= '0';
  end process;
end Behavioral;
