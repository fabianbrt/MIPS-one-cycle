library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SSD_palindrome_32bit is
    Port ( clk : in std_logic;
           palindrome : in std_logic_vector(31 downto 0);
           cat : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(7 downto 0));
end SSD_palindrome_32bit;

architecture Behavioral of SSD_palindrome_32bit is

signal cnt : std_logic_vector(17 downto 0) := (others => '0'); -- multiplexare
signal sel : std_logic_vector(2 downto 0);
signal letter : std_logic_vector(3 downto 0);
signal cat_out : std_logic_vector(6 downto 0);
signal an_out : std_logic_vector(7 downto 0);

type msg_array is array (0 to 7) of std_logic_vector(3 downto 0);
signal msg_palindrome : msg_array := ("0000", "0001", "0010", "0011", "1111", "1111", "1111", "1111"); -- P A L I " " " " " " " "
signal msg_not_palindrome : msg_array := ("1000", "1001", "1010", "0000", "0001", "0010", "0011", "1111"); -- N O T P A L I " "

signal current_msg : msg_array;

begin

process(clk)
begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
    end if;
end process;

sel <= cnt(17 downto 15);

process(palindrome)
begin
    if unsigned(palindrome) = 1 then
        current_msg <= msg_palindrome;
    else
        current_msg <= msg_not_palindrome;
    end if;
end process;

process(sel)
begin
    case sel is
        when "000" => letter <= current_msg(0);
        when "001" => letter <= current_msg(1);
        when "010" => letter <= current_msg(2);
        when "011" => letter <= current_msg(3);
        when "100" => letter <= current_msg(4);
        when "101" => letter <= current_msg(5);
        when "110" => letter <= current_msg(6);
        when others => letter <= current_msg(7);
    end case;
end process;

process(letter)
begin
    case letter is
        when "0000" => cat_out <= "0001100"; -- P
        when "0001" => cat_out <= "0001000"; -- A
        when "0010" => cat_out <= "1000111"; -- L
        when "0011" => cat_out <= "1111001"; -- I
        when "1000" => cat_out <= "0010000"; -- N
        when "1001" => cat_out <= "0000110"; -- O
        when "1010" => cat_out <= "0001110"; -- T
        when "1111" => cat_out <= "1111111"; 
        when others => cat_out <= "1111111";
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
