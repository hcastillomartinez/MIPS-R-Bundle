library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder32 is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           carry_in : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (31 downto 0);
           carry_out : out  STD_LOGIC);
end adder32;

architecture Behavioral of adder32 is
  component full_adder
    port(a,b,carry_in : in STD_LOGIC;
         sum,carry_out : out STD_LOGIC);
  end component;
  signal c : STD_LOGIC_VECTOR (31 downto 0);
begin
  A00: component full_adder port map(a(0),b(0),carry_in,sum(0),c(0));
  A01: component full_adder port map(a(1),b(1),c(0),sum(1),c(1));
  A02: component full_adder port map(a(2),b(2),c(1),sum(2),c(2));
  A03: component full_adder port map(a(3),b(3),c(2),sum(3),c(3));
  A04: component full_adder port map(a(4),b(4),c(3),sum(4),c(4));
  A05: component full_adder port map(a(5),b(5),c(4),sum(5),c(5));
  A06: component full_adder port map(a(6),b(6),c(5),sum(6),c(6));
  A07: component full_adder port map(a(7),b(7),c(6),sum(7),c(7));
  A08: component full_adder port map(a(8),b(8),c(7),sum(8),c(8));
  A09: component full_adder port map(a(9),b(9),c(8),sum(9),c(9));
  A10: component full_adder port map(a(10),b(10),c(9),sum(10),c(10));
  A11: component full_adder port map(a(11),b(11),c(10),sum(11),c(11));
  A12: component full_adder port map(a(12),b(12),c(11),sum(12),c(12));
  A13: component full_adder port map(a(13),b(13),c(12),sum(13),c(13));
  A14: component full_adder port map(a(14),b(14),c(13),sum(14),c(14));
  A15: component full_adder port map(a(15),b(15),c(14),sum(15),c(15));
  A16: component full_adder port map(a(16),b(16),c(15),sum(16),c(16));
  A17: component full_adder port map(a(17),b(17),c(16),sum(17),c(17));
  A18: component full_adder port map(a(18),b(18),c(17),sum(18),c(18));
  A19: component full_adder port map(a(19),b(19),c(18),sum(19),c(19));
  A20: component full_adder port map(a(20),b(20),c(19),sum(20),c(20));
  A21: component full_adder port map(a(21),b(21),c(20),sum(21),c(21));
  A22: component full_adder port map(a(22),b(22),c(21),sum(22),c(22));
  A23: component full_adder port map(a(23),b(23),c(22),sum(23),c(23));
  A24: component full_adder port map(a(24),b(24),c(23),sum(24),c(24));
  A25: component full_adder port map(a(25),b(25),c(24),sum(25),c(25));
  A26: component full_adder port map(a(26),b(26),c(25),sum(26),c(26));
  A27: component full_adder port map(a(27),b(27),c(26),sum(27),c(27));
  A28: component full_adder port map(a(28),b(28),c(27),sum(28),c(28));
  A29: component full_adder port map(a(29),b(29),c(28),sum(29),c(29));
  A30: component full_adder port map(a(30),b(30),c(29),sum(30),c(30));
  A31: component full_adder port map(a(31),b(31),c(30),sum(31),c(31));
  carry_out <= c(31);
end Behavioral;

