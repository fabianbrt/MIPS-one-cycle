----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2025 08:02:37 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( clk: in STD_LOGIC;
           ALUresIN : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUresOUT : out STD_LOGIC_VECTOR (31 downto 0);
           isPalindrome: out STD_LOGIC_VECTOR(31 downto 0));
end MEM;

architecture Behavioral of MEM is

type ram_type is array(0 to 63) of std_logic_vector(31 downto 0);
signal ram: ram_type := (
    0 => x"00000005", -- no_digits = 5
    1 => x"00000001",
    2 => x"00000002",
    3 => x"00000003",
    4 => x"00000002",
    5 => x"00000001",
    6 => x"00000000", -- PALIDROME CHECK
    others => (others => '0')
);
signal writeEn: std_logic;
begin
writeEn <= en and MemWrite;
--Write
process(clk)
    begin 
        if rising_edge(clk) and writeEn = '1' then
            isPalindrome <= rd2;
            ram(to_integer(unsigned(ALUresIN))) <= rd2;
        end if;
end process;

MemData <= ram(to_integer(unsigned(ALUresIN)));
ALUresOUt <= ALUresIN;

--isPalindrome <= ram(6);
--isPalindrome <= ram(to_integer(unsigned(ram(0) + 1))); -- PALINDROME CHECK -- ram(6)
end Behavioral;
