----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 07:31:29 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port ( op_code : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

begin

process(op_code)
    begin
       RegDst <= '0';
       ExtOp <= '0';
       ALUSrc <= '0';
       Branch <= '0';
       Jump <= '0';
       ALUOp <= (others => '0');
       MemWrite <= '0';
       MemtoReg <= '0';
       RegWrite <= '0';
       case op_code is
        when "100011" => 
            ALUSrc <= '1';
            MemtoReg <= '1';
            RegWrite <= '1';
            ALUOp <= "001";
        when "000000" =>
            RegDst <= '1';
            RegWrite <= '1';
        when "001000" =>
            ExtOp <= '1';
            ALUSrc <= '1';
            RegWrite <= '1';
            ALUOp <= "001";
        when "000101" =>
            ALUSrc <= '1';
            Branch <= '1';
            ALUOp <= "010";
        when "101011" =>
            ALUSrc <= '1';
            MemWrite <= '1';
            ALUOp <= "001";
        when "000010" =>
            Jump <= '1';
        when others => MemWrite <= '0';
   end case;
end process;

end Behavioral;
