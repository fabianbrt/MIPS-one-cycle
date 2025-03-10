library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
  Port (clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (7 downto 0); 
        an : out STD_LOGIC_VECTOR (7 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0);
        led : out STD_LOGIC_VECTOR (7 downto 0)); 
end test_env;

architecture Behavioral of test_env is


signal CNT : std_logic_vector (1 downto 0) := "00";
signal en : STD_LOGIC := '0';


signal A, B : std_logic_vector(31 downto 0); 
signal ALU_OUT : std_logic_vector(31 downto 0);
signal ssd_digits: std_logic_vector(31 downto 0) := (others => '0'); 


signal zero_flag : std_logic;


signal ssd_an : std_logic_vector(7 downto 0);
signal ssd_cat : std_logic_vector(6 downto 0);


component MPG
    port (enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;


component SSD
    Port ( digits : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end component;

begin


e: MPG port map (
    enable => en,
    btn => btn(0),
    clk => clk
);


process(clk)
begin
    if rising_edge(clk) then
        CNT <= CNT + 1; 
    end if;
end process;


A <= (others => '0') & sw(3 downto 0);  
B <= (others => '0') & sw(7 downto 4);  


process(CNT, A, B)
begin
    case CNT is
        when "00" => ALU_OUT <= A + B;         
        when "01" => ALU_OUT <= A - B;         
        when "10" => ALU_OUT <= A sll 2;       
        when others => ALU_OUT <= A srl 2;     
    end case;
end process;


zero_flag <= '1' when ALU_OUT = X"00000000" else '0';
led(7) <= zero_flag; 
led(6 downto 0) <= (others => '0'); 


ssd_digits <= ALU_OUT;

display: SSD port map (
    digits => ssd_digits,
    clk => clk,
    cat => ssd_cat,
    an => ssd_an
);

an <= ssd_an;
cat <= ssd_cat;

end Behavioral;
