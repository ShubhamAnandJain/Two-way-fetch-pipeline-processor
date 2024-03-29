library ieee;
use ieee.std_logic_1164.all;
library work;

entity HazardDetectionUnit is
port( 
    
    ir_1    :   in std_logic_vector(15 downto 0);       -- IR_1 is the first instruction
    ir_2    :   in std_logic_vector(15 downto 0);       -- IR_2 is the second, possibly dependent instruction
    ra_bit  :   out std_logic;                          -- RegA of instruction 2 dependent
    rb_bit  :   out std_logic;                           -- RegB of instruction 2 dependent
    fake_rb :   in std_logic_vector(2 downto 0)
    );

end entity HazardDetectionUnit;

architecture SpaghettiCode of HazardDetectionUnit is

signal ra_check : std_logic;
signal rb_check : std_logic;
signal rbf_check : std_logic;

signal ra_bit_c,ra_bit_b,ra_bit_a,ra_bit_lm : std_logic;
signal rb_bit_c,rb_bit_b,rb_bit_a,rb_bit_lm : std_logic;
signal rbf_bit_c,rbf_bit_b,rbf_bit_a,rbf_bit_lm : std_logic;

signal opcode_2 : std_logic_vector(3 downto 0);
signal opcode_1 : std_logic_vector(3 downto 0);

begin

opcode_2 <= ir_2(15 downto 12);
opcode_1 <= ir_1(15 downto 12);

--- Which instructions read from reg A/B so only check for those
ra_check <= '1' when opcode_2="0000" or opcode_2="0001" or opcode_2="0010" or opcode_2="0101" or opcode_2="0111" or opcode_2="1100" else '0';
rb_check <= '1' when opcode_2="0000" or opcode_2="1001" or opcode_2="0010" or opcode_2="0101" or opcode_2="1100" or opcode_2="0100" else '0';
rbf_check <= '1' when opcode_2="0111" else '0';

--- Ra_bit_c means ra of inst2 is written by inst1's rc bits
--- Ra_bit_b means ra of inst2 is written by inst1's rb bits
--- Ra_bit_a means ra of inst2 is written by inst1's ra bits
--- Ra_bit_lm means ra of inst2 is written by inst1's last lm bit

ra_bit_c <= '1' when (opcode_1="0000" or opcode_1="0010") and ra_check='1' and (ir_1(5 downto 3) = ir_2(11 downto 9)) else '0';    -- Inst 1 stores in Reg C
ra_bit_b <= '1' when opcode_1="0001" and ra_check='1' and (ir_1(8 downto 6) = ir_2(11 downto 9)) else '0';    -- Inst 1 stores in Reg B
ra_bit_a <= '1' when (opcode_1="0011" or opcode_1="0100" or opcode_1="1000" or opcode_1="1001") and ra_check='1' and (ir_1(11 downto 9) = ir_2(11 downto 9)) else '0';    -- Inst 1 stores in Reg A
ra_bit_lm <= '1' when opcode_1="0110" and ra_check='1' and ((ir_1(0)='1' and ir_2(11 downto 9)="111") or (ir_1(1 downto 0)="10" and ir_2(11 downto 9)="110") or (ir_1(2 downto 0)="100" and ir_2(11 downto 9)="101") or (ir_1(3 downto 0)="1000" and ir_2(11 downto 9)="100") or (ir_1(4 downto 0)="10000" and ir_2(11 downto 9)="011") or (ir_1(5 downto 0)="100000" and ir_2(11 downto 9)="010")  or (ir_1(6 downto 0)="1000000" and ir_2(11 downto 9)="001") or (ir_1(7 downto 0)="10000000" and ir_2(11 downto 9)="000")) else '0';


rb_bit_c <= '1' when (opcode_1="0000" or opcode_1="0010") and rb_check='1' and (ir_1(5 downto 3) = ir_2(8 downto 6)) else '0';    -- Inst 1 stores in Reg C
rb_bit_b <= '1' when opcode_1="0001" and rb_check='1' and (ir_1(8 downto 6) = ir_2(8 downto 6)) else '0';    -- Inst 1 stores in Reg B
rb_bit_a <= '1' when (opcode_1="0011" or opcode_1="0100" or opcode_1="1000" or opcode_1="1001") and rb_check='1' and (ir_1(11 downto 9) = ir_2(8 downto 6)) else '0';    -- Inst 1 stores in Reg A
rb_bit_lm <= '1' when opcode_1="0110" and rb_check='1' and ((ir_1(0)='1' and ir_2(8 downto 6)="111") or (ir_1(1 downto 0)="10" and ir_2(8 downto 6)="110") or (ir_1(2 downto 0)="100" and ir_2(8 downto 6)="101") or (ir_1(3 downto 0)="1000" and ir_2(8 downto 6)="100") or (ir_1(4 downto 0)="10000" and ir_2(8 downto 6)="011") or (ir_1(5 downto 0)="100000" and ir_2(8 downto 6)="010")  or (ir_1(6 downto 0)="1000000" and ir_2(8 downto 6)="001") or (ir_1(7 downto 0)="10000000" and ir_2(8 downto 6)="000")) else '0';


rbf_bit_c <= '1' when (opcode_1="0000" or opcode_1="0010") and rbf_check='1' and (ir_1(5 downto 3) = fake_rb(2 downto 0)) else '0';    -- Inst 1 stores in Reg C
rbf_bit_b <= '1' when opcode_1="0001" and rbf_check='1' and (ir_1(8 downto 6) = fake_rb(2 downto 0)) else '0';    -- Inst 1 stores in Reg B
rbf_bit_a <= '1' when (opcode_1="0011" or opcode_1="0100" or opcode_1="1000" or opcode_1="1001") and rbf_check='1' and (ir_1(11 downto 9) = fake_rb(2 downto 0)) else '0';    -- Inst 1 stores in Reg A
rbf_bit_lm <= '1' when opcode_1="0110" and rbf_check='1' and ((ir_1(0)='1' and fake_rb(2 downto 0)="111") or (ir_1(1 downto 0)="10" and fake_rb(2 downto 0)="110") or (ir_1(2 downto 0)="100" and fake_rb(2 downto 0)="101") or (ir_1(3 downto 0)="1000" and fake_rb(2 downto 0)="100") or (ir_1(4 downto 0)="10000" and fake_rb(2 downto 0)="011") or (ir_1(5 downto 0)="100000" and fake_rb(2 downto 0)="010")  or (ir_1(6 downto 0)="1000000" and fake_rb(2 downto 0)="001") or (ir_1(7 downto 0)="10000000" and fake_rb(2 downto 0)="000")) else '0';



ra_bit <= ra_bit_a or ra_bit_b or ra_bit_c or ra_bit_lm;
rb_bit <= rb_bit_a or rb_bit_b or rb_bit_c or rb_bit_lm or rbf_bit_a or rbf_bit_b or rbf_bit_c or rbf_bit_lm ;




end SpaghettiCode;