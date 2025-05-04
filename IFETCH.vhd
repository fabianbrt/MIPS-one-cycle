----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 03:18:59 PM
-- Design Name: 
-- Module Name: IFETCH - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFETCH is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in std_logic;
           jumpAddr : in STD_LOGIC_VECTOR (31 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (31 downto 0);
           Jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCinc : out STD_LOGIC_VECTOR(31 downto 0));
end IFETCH;

architecture Behavioral of IFETCH is
type rom_type is array(0 to 255) of std_logic_vector(31 downto 0);
signal ROM: rom_type := (
    B"100011_00000_00001_0000000000000000",   -- X"8C010000" -- LW $1, 0($0) -$1 - no_digits - 1  
    B"000000_00000_00001_00010_00001_000010", -- X"00011042" -- SRL $2, $1, 1 
    B"001000_00010_00010_0000000000000001",   -- X"20000001" -- ADDI $2, $2, 1                  - 2
    B"001000_00000_00000_0000000000000001",   -- X"20000001" -- ADDI $0, $0, 1               - 3
    
    B"000100_00000_00010_0000000000000110",   -- X"14650007" -- BEQ $0, $2, 6(PALINDROME)  
    
    B"100011_00000_00011_0000000000000000",   -- X"8C030000" -- LW $3, 0($0)                 - 4
    B"000000_00001_00000_00100_00000_100010", -- X"00602022" -- SUB $4, $1, $0               - 5
    B"100011_00100_00101_0000000000000001",   -- X"8C850001" -- LW $5, 1($4)                 - 6
    
    B"000101_00011_00101_0000000000000101",   -- X"14650007" -- BNE $3, $5, 5 (NOT PALINDROME)               - 7
    
    B"001000_00000_00000_0000000000000001",   -- X"20000001" -- ADDI $0, $0, 1               - 8
    B"000010_000000000000000000000100",       -- X"08000010" -- JUMP 4                    - 9
    
    B"001000_00110_00110_0000000000000001",   -- X"20260001" -- ADDI $6, $6, 1               -10 -- PALINDROM
    B"101011_00001_00111_0000000000000000",   -- X"ACC2E001" -- SW $6, 1($1)                 -11
    B"000010_000000000000000000010000",       -- X"08000010" -- J 16  -- END                 -12  
  
    B"001000_00110_00110_0000000000000010",   -- X"20260001" -- ADDI $6, $6, 2               -13 -- NOT PALINDROM
    B"101011_00001_00111_0000000000000001",   -- X"ACC2E001" -- SW $6, 1($1)                 -14
    --END :
    others => X"00000000" -- NoOp(ADD $0, $0, $0)                                            -15
);

signal PC : std_logic_vector(31 downto 0) := (others => '0');
begin

process(clk, rst)
 begin  
    if rst = '1' then
        PC <= (others => '0');
    elsif rising_edge(clk) and en = '1' then
        if Jump = '1' then
            PC <= jumpAddr;
        elsif PCsrc = '1' then
            PC <= branchAddr;
        else
            PC <= PC + 4;
end if;

    end if;
end process;

Instruction <= ROM(to_integer(unsigned(PC(9 downto 2))));
PCinc <= PC + 4;

end Behavioral;
