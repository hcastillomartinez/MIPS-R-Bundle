library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu is
    Port ( main_clk : in STD_LOGIC;
           main_reset : in STD_LOGIC );
end cpu;

architecture Behavioral of cpu is
  -- declare the component port maps (each component is defined
  -- elsewhere in its own VHDL file)
  component pc
    port(clk : in STD_LOGIC;
         reset : in STD_LOGIC;
			stall: in std_logic;
         data_in : in STD_LOGIC_VECTOR (31 downto 0);
         data_out : out  STD_LOGIC_VECTOR (31 downto 0));
  end component;
  component adder32
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
         carry_in : in  STD_LOGIC;
         sum : out  STD_LOGIC_VECTOR (31 downto 0);
         carry_out : out  STD_LOGIC);
  end component;
  component alu
    port(a : in  STD_LOGIC_VECTOR (31 downto 0);
         b : in  STD_LOGIC_VECTOR (31 downto 0);
			ctrl : in  STD_LOGIC_VECTOR (4 downto 0);
         result : out  STD_LOGIC_VECTOR (31 downto 0);
			zero : out  STD_LOGIC);
  end component;
  component control
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
		 mfhi_read : out std_logic;
		 mflo_read : out std_logic;
		 stall: out std_logic
		 );
  end component;
  component instr
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
		 stall : in std_logic;
       addr : in  STD_LOGIC_VECTOR (31 downto 0);
       data_out : out  STD_LOGIC_VECTOR (31 downto 0));
  end component;
  component regs
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
  end component;
  component mux
        Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
           control : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component mux5
        Port ( a : in  STD_LOGIC_VECTOR(4 downto 0);
           b : in  STD_LOGIC_VECTOR(4 downto 0);
           control : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR(4 downto 0));
  end component;
  component signextend
  Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
         z : out  STD_LOGIC_VECTOR (31 downto 0));
  end component;
  component mem
  Port(clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       addr : in  STD_LOGIC_VECTOR (31 downto 0);
       data_in : in STD_LOGIC_VECTOR (31 downto 0);
       write_enable : in  STD_LOGIC;
       read_enable : in  STD_LOGIC;
       data_out : out  STD_LOGIC_VECTOR (31 downto 0));
  end component;
  component lshift2
  Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
         z : out  STD_LOGIC_VECTOR (31 downto 0));
  end component;
  
  component dec
  Port( ctrl, clk: in std_logic;
			m_write, stall: out std_logic);
  
  end component;
  
  component Mult
    Port ( clk, reset : in  STD_LOGIC;
           write_enable : in  STD_LOGIC;
           multiplicand : in  STD_LOGIC_VECTOR (31 downto 0);
           multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           mfhi : out  STD_LOGIC_VECTOR (31 downto 0);
           mflo : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

  -- declare temporary signals (use these to wire
  -- component ports together)
  signal branch_addr, mem_out, immediate_sl2, immediate, write_data, reg_read2, instruct, count_in, count_out, count_out_plus4 : STD_LOGIC_VECTOR (31 downto 0);
  signal count_in_temp, alu_a_in, alu_b_in, alu_result_out : STD_LOGIC_VECTOR (31 downto 0);
  signal alu_ctrl_in, write_addr : STD_LOGIC_VECTOR (4 downto 0);
  signal instruct_jump, jump_sl2, jump_addr : std_logic_vector (31 downto 0);
  signal alu_zero_out, branch_ctrl : STD_LOGIC;
  signal regdst, jump, memread, memtoreg, memwrite, alusrc, regwrite : STD_LOGIC;
  signal branch: std_logic_vector(1 downto 0);
  signal m_write, stall, pc_stall, inst_stall, dec_ctrl_in: std_logic;
  signal mflo_read, mfhi_read, begin_stall: std_logic;
  signal mfhi,mflo: std_logic_vector(31 downto 0);
begin
  -- instantiate some components
  -- (notice how the "inst_out" signal is used to connect the
  -- program counter's output to the input of the "plus 4" adder)
  MULT_TIMER:      component dec        port map(begin_stall, main_clk, m_write, stall);
  PROGRAM_COUNTER: component pc         port map(main_clk,main_reset,pc_stall,count_in,count_out);
  PC_PLUS_FOUR:    component adder32    port map(count_out,"00000000000000000000000000000100",'0',count_out_plus4,open);
  
  MAIN_ALU:        component alu        port map(alu_a_in,alu_b_in,alu_ctrl_in,alu_result_out,alu_zero_out);
  CTRL:            component control    port map(instruct(31 downto 26), instruct(5 downto 0), alu_ctrl_in, regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite,
																 mfhi_read, mflo_read, begin_stall);
  INSTRUCT_MEM:    component instr      port map(main_clk,main_reset,inst_stall,count_out,instruct);
  REGISTER_FILE:   component regs       port map(main_clk, main_reset, instruct(25 downto 21), instruct(20 downto 16), write_addr, write_data, mfhi,mflo,
																 m_write, mfhi_read, mflo_read, regwrite, alu_a_in, reg_read2);
  M1:              component mux5       port map(instruct(20 downto 16), instruct(15 downto 11), regdst, write_addr);
  
  SIGN_EXTEND:     component signextend port map(instruct(15 downto 0), immediate); 
  M2:              component mux        port map(reg_read2, immediate, alusrc, alu_b_in);
  
  MAIN_MEMORY:     component mem        port map(main_clk,main_reset,alu_result_out,reg_read2,memwrite,memread,mem_out);
  M3:              component mux        port map(alu_result_out, mem_out, memtoreg, write_data);
  
  LEFT_SHIFT:      component lshift2    port map(immediate, immediate_sl2);
  BRANCH_ADD:      component adder32    port map(count_out_plus4,immediate_sl2,'0',branch_addr,open);
  M4:              component mux        port map(count_out_plus4, branch_addr, branch_ctrl, count_in_temp);
  MUL: 				 component Mult       port map(main_clk, main_reset, begin_stall, alu_a_in, reg_read2,mfhi, mflo);
  
  branch_ctrl <= (branch(0) and branch(1) and alu_zero_out) or
						((not branch(0)) and branch(1) and (not alu_zero_out));
  pc_stall <= not stall;
  inst_stall <= not stall;
 
  instruct_jump <= "000000" & instruct(25 downto 0);
  LEFT_SHIFT2:     component lshift2    port map(instruct_jump, jump_sl2);
  jump_addr <= count_out_plus4(31 downto 28) & jump_sl2(27 downto 0);
  M5:              component mux        port map(count_in_temp, jump_addr, jump, count_in);
end Behavioral;