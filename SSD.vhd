library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( digits : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;

architecture Behavioral of SSD is
    signal cnt : std_logic_vector(16 downto 0) := (others => '0');
    signal sel : std_logic_vector(2 downto 0);
    signal digit: std_logic_vector(3 downto 0);
    signal cat_out: std_logic_vector(6 downto 0);
    signal an_out: std_logic_vector(7 downto 0);
begin

  
    process(clk)
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;
    
    sel <= cnt(16 downto 14); 

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
            when "0000" => cat_out <= "0000001"; -- 0
            when "0001" => cat_out <= "1001111"; -- 1
            when "0010" => cat_out <= "0010010"; -- 2
            when "0011" => cat_out <= "0000110"; -- 3
            when "0100" => cat_out <= "1001100"; -- 4
            when "0101" => cat_out <= "0100100"; -- 5
            when "0110" => cat_out <= "0100000"; -- 6
            when "0111" => cat_out <= "0001111"; -- 7
            when "1000" => cat_out <= "0000000"; -- 8
            when "1001" => cat_out <= "0000100"; -- 9
            when "1010" => cat_out <= "0001000"; -- A
            when "1011" => cat_out <= "1100000"; -- B
            when "1100" => cat_out <= "0110001"; -- C
            when "1101" => cat_out <= "1000010"; -- D
            when "1110" => cat_out <= "0110000"; -- E
            when others => cat_out <= "0111000"; -- F
        end case;
    end process;

    process(sel)
    begin
        case sel is
            when "000" => an_out <= "11111110";
            when "001" => an_out <= "11111101";
            when "010" => an_out <= "11111011";
            when "011" => an_out <= "11110111";
            when "100" => an_out <= "11101111";
            when "101" => an_out <= "11011111";
            when "110" => an_out <= "10111111";
            when others => an_out <= "01111111";
        end case;
    end process;
    cat <= cat_out;
    an <= an_out;

end Behavioral;
