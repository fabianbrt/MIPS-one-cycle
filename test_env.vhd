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

component IFETCH
 Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in std_logic;
           jumpAddr : in STD_LOGIC_VECTOR (31 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (31 downto 0);
           swJmp : in STD_LOGIC;
           swBr : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCinc : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component UC is
    Port ( op_code : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ID is
   Port(clk: in std_logic;
    Instruction: in std_logic_vector(31 downto 0);
    WD: in std_logic_vector(31 downto 0);
    btn_en: in std_logic;
    RegWrite: in std_logic;
    RegDst: in std_logic;
    ExtOp: in std_logic;
    RD1: out std_logic_vector(31 downto 0);
    RD2: out std_logic_vector(31 downto 0);
    Ext_Imm: out std_logic_vector(31 downto 0);
    func: out std_logic_vector(31 downto 0);
    sa: out std_logic_vector(31 downto 0)
    );
end component;


signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
signal PCinc : std_logic_vector(31 downto 0) := (others => '0');
signal digits: std_logic_vector(31 downto 0) := (others => '0');
signal en, rst: std_logic;
signal sum : std_logic_vector(31 downto 0) := (others => '0');
signal rd1:  std_logic_vector(31 downto 0) := (others => '0');
signal rd2:  std_logic_vector(31 downto 0) := (others => '0');
signal RegDst: STD_LOGIC;
signal ExtOp :  STD_LOGIC;
signal ALUSrc :STD_LOGIC;
signal Branch :  STD_LOGIC;
signal Jump :  STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal MemWrite :  STD_LOGIC;
signal  MemtoReg :  STD_LOGIC;
signal RegWrite :  STD_LOGIC;
signal Ext_Imm: std_logic_vector(31 downto 0) := (others => '0');
signal func: std_logic_vector(31 downto 0) := (others => '0');
signal sa: std_logic_vector(31 downto 0) := (others => '0');
begin

monopulse1: MPG port map(enable => en, btn => btn(0), clk => clk);
monopulse2: MPG port map(enable => rst, btn => btn(1), clk => clk);

instr_fetch: IFETCH port map(clk, rst, en, x"0000FFFB", x"00000010", sw(0), sw(1), Instruction, PCinc);
instr_ID: ID port map(clk, Instruction, sum, en,  RegWrite, RegDst, ExtOp, rd1, rd2, Ext_imm, func, sa);
instr_UC: UC port map(Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);

sum <= rd1 + rd2;

with sw(7 downto 5) select
 digits <= Instruction when "000",
           PCinc when "001",
           rd1 when "010",
           rd2 when "011",
           sum when "100",
           Ext_imm when "101",
           func when "110",
           sa when "111",
           (others => 'X') when others;

display: SSD port map(digits => digits, clk => clk, cat => cat, an => an);
end Behavioral;
