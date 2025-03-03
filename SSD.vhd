----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2025 03:29:22 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( digits : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt : std_logic_vector(16 downto 0) := (others => '0');
signal sel : std_logic_vector(2 downto 0) := cnt(16 downto 14);
signal digit: std_logic_vector(3 downto 0) := (others => '0');
signal cat_out: std_logic_vector(6 downto 0);
signal an_out: std_logic_vector(7 downto 0);
begin

process(cnt)
begin
    if(rising_edge(clk)) then
        cnt <= cnt + 1;
    end if;
end process;

muxCat:
    process(sel)
        begin
            case sel is
                when "000" => digit <= digits(3 downto 0);
                when "001" => digit <= digits(7 downto 4);
                when "010" => digit <= digits(11 downto 8);
                when "011" => digit <= digits(15 downto 12);
                when "100" => digit <= digits(19 downto 16);
                when "101" => digit <= digits(23 downto 20);
                when "110" => digit <= digits(27 downto 24);
                when others => digit <= digits(31 downto 28);
            end case;
    end process;
    
process(digit)
    begin
       case digit is
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";
            when "0000" => cat_out <= "0000001";







end Behavioral;
