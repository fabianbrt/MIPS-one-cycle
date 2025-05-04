library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
  Port (clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (4 downto 0); 
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

component SSD_pali
    Port ( clk : in STD_LOGIC;
           palindrome : in STD_LOGIC_VECTOR (31 downto 0);
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
           BranchEQ : out STD_LOGIC;
           BranchNEQ : out STD_LOGIC;
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

component EX is
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
end component EX;

component MEM is
    Port ( clk: in STD_LOGIC;
           ALUresIN : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUresOUT : out STD_LOGIC_VECTOR (31 downto 0);
           isPalindrome: out STD_LOGIC_VECTOR(31 downto 0));
end component MEM;



signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
signal PCinc : std_logic_vector(31 downto 0) := (others => '0');
signal digits: std_logic_vector(31 downto 0) := (others => '0');
signal en, rst: std_logic;
signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
signal rd1:  std_logic_vector(31 downto 0) := (others => '0');
signal rd2:  std_logic_vector(31 downto 0) := (others => '0');
signal RegDst: STD_LOGIC;
signal ExtOp :  STD_LOGIC;
signal ALUSrc :STD_LOGIC;
signal BranchEQ :  STD_LOGIC;
signal BranchNEQ :  STD_LOGIC;
signal Jump :  STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal MemWrite :  STD_LOGIC;
signal  MemtoReg :  STD_LOGIC;
signal RegWrite :  STD_LOGIC;
signal Zero :  STD_LOGIC;
signal PCsrc :  STD_LOGIC;
signal Ext_Imm: std_logic_vector(31 downto 0) := (others => '0');
signal func: std_logic_vector(5 downto 0) := (others => '0');
signal sa: std_logic_vector(4 downto 0) := (others => '0');
signal BranchAddr: std_logic_vector(31 downto 0) := (others => '0');
signal JumpAddr: std_logic_vector(31 downto 0) := (others => '0');
signal ALUresIN: std_logic_vector(31 downto 0) := (others => '0');
signal ALUresOUT: std_logic_vector(31 downto 0) := (others => '0');
signal MemData: std_logic_vector(31 downto 0) := (others => '0');
signal isPali: std_logic_vector(31 downto 0) := (others => '0');


begin

monopulse1: MPG port map(enable => en, btn => btn(0), clk => clk);
monopulse2: MPG port map(enable => rst, btn => btn(1), clk => clk);

instr_fetch: IFETCH port map(clk, rst, en, JumpAddr, BranchAddr, Jump, PCsrc, Instruction, PCinc);
instr_ID: ID port map(clk, Instruction, WriteData, en,  RegWrite, RegDst, ExtOp, rd1, rd2, Ext_imm, func, sa);
instr_UC: UC port map(Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, BranchEQ, BranchNEQ, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
instr_EX: EX port map(RD1, RD2, Ext_imm, sa, func, PCinc, ALUsrc, ALUop, Zero, ALUresIN, BranchAddr); 
instr_MEM: MEM port map(clk, ALUresIN, RD2, MemWrite, en, MemData, ALUresOUT, isPali); 

WriteData <= MemData when MemToReg = '1' else ALUresOUT;
PCsrc <= (BranchEQ and Zero) or (BranchNEQ and not Zero);
JumpAddr <= PCinc(31 downto 28) & Instruction(25 downto 0) & "00";

with sw(4 downto 0) select
 digits <= Instruction when "00000",
           PCinc when "00001",
           rd1 when "00010",
           rd2 when "00011",
           WriteData when "00100",
           Ext_imm when "00101",
           ALUresIN when "00110",
           MemData when "00111",
           isPali when "01000",
           (others => 'X') when others;

--display: SSD port map(digits => digits, clk => clk, cat => cat, an => an);
display: SSD_pali port map(clk => clk, palindrome => isPali ,cat => cat, an => an);
end Behavioral;
