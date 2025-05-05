----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 06:47:31 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    Port(clk: in std_logic;
    Instruction: in std_logic_vector(31 downto 0);
    WD: in std_logic_vector(31 downto 0);
    btn_en: in std_logic;
    rst: in std_logic;
    RegWrite: in std_logic;
    RegDst: in std_logic;
    ExtOp: in std_logic;
    RD1: out std_logic_vector(31 downto 0);
    RD2: out std_logic_vector(31 downto 0);
    Ext_Imm: out std_logic_vector(31 downto 0);
    func: out std_logic_vector(5 downto 0);
    sa: out std_logic_vector(4 downto 0)
    );
end ID;

architecture Behavioral of ID is

type reg_file is array(0 to 31) of std_logic_vector(31 downto 0);
signal rf : reg_file := (others => X"00000000");
signal w_en: std_logic;
signal r_addr1: std_logic_vector(4 downto 0) := (others => '0');
signal r_addr2: std_logic_vector(4 downto 0) := (others => '0');
signal w_addr: std_logic_vector(4 downto 0) := (others => '0');

begin
w_en <= btn_en and RegWrite;
w_addr <= instruction(20 downto 16) when RegDst = '0' else instruction(15 downto 11);
r_addr1 <= instruction(25 downto 21);
r_addr2 <= instruction(20 downto 16);

--WRITE
process(clk)
  begin
    if rising_edge(clk) then
        if w_en = '1' then
            rf(to_integer(unsigned(w_addr))) <= wd;
        end if;
        if rst = '1' then
            rf <= (others => X"00000000");
        end if;
    end if;
end process;

--READ 
rd1 <= rf(to_integer(unsigned(r_addr1)));
rd2 <= rf(to_integer(unsigned(r_addr2)));

ext_imm(15 downto 0) <= instruction(15 downto 0);
ext_imm(31 downto 16) <= (others => instruction(15)) when extop = '1' else (others => '0');

func <= instruction(5 downto 0);
sa <= instruction(10 downto 6);

end Behavioral;
