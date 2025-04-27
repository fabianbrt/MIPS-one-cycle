----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 03:20:03 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (5 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           PCnext : in STD_LOGIC_VECTOR (31 downto 0);
           AluSrc : in STD_LOGIC;
           AluOp : in  STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           AluRes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR (31 downto 0));
end EX;

architecture Behavioral of EX is
signal ALUin2: std_logic_vector(31 downto 0) := (others => '0');
signal ALUCtrl: std_logic_vector(2 downto 0) := (others => '0');
signal result: std_logic_vector(31 downto 0) := (others => '0');

begin
--ALUSrc
 with AluSrc select  
    aluin2 <= rd2 when '0',
              ext_imm when '1',
              (others => '0') when others;
--ALU Control
 process(AluOp, func)
    begin
        case AluOP is
            when "000" => 
                case func is
                    -- maybe ADD?
                    when "000010" => ALUCtrl <= "010"; --SRL  
                    when "100010" => ALUCtrl <= "001"; --SUB
                    when others => ALUCtrl <= (others => 'X');
                 end case;
            when "001" => ALUCtrl <= "000";  -- +
            when "010" => ALUCtrl <= "001";  -- -
            when others => ALUCtrl <= (others => 'X');
        end case;
   end process;   
   
--ALU
process(ALUCtrl, RD1, ALUin2, sa)
variable shift_amt: integer;
    begin
        shift_amt := to_integer(unsigned(sa));
        case ALUctrl is
            when "000" => result <= std_logic_vector(unsigned(RD1) + unsigned(ALUin2)); -- ADD
            when "001" => result <= std_logic_vector(unsigned(RD1) - unsigned(ALUin2)); -- SUB
            when "010" => result <= std_logic_vector(shift_right(unsigned(ALUin2), shift_amt)); --SRL
            when others => result <= (others => 'X');
        end case;
end process;

--Branch Address
BranchAddr <= std_logic_vector(unsigned(PCnext) + unsigned(Ext_Imm(29 downto 0) & "00")); -- signed for ext_imm + sll 2?

ALUres <= result;

--Zero flag
Zero <= '1' when result = (others => '0') else '0';

    
end Behavioral;
