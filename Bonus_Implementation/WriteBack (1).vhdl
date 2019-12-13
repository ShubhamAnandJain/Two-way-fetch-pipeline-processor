library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity WriteBack is
port( rf_write_data_1,rf_write_data_2,rf_write_data_3,rf_write_data_1_pc,rf_write_data_2_pc,
		rf_write_data_3_pc,in_control_word_1,in_instruction_1,in_control_word_2,in_instruction_2,
		in_control_word_3,in_instruction_3 : in std_logic_vector(15 downto 0);
		data_add_1,data_add_2,data_add_3,data_add_1_pc,data_add_2_pc,data_add_3_pc : in std_logic_vector(2 downto 0);
		prop_1,enab_1,prop_2,enab_2,prop_3,enab_3 : in std_logic;
		rf_write_data_1_out,rf_write_data_2_out,rf_write_data_3_out,rf_write_pc_out : out std_logic_vector(15 downto 0);
		data_add_1_out,data_add_2_out,data_add_3_out : out std_logic_vector(2 downto 0);
		prop_out_1,enab_out_1,write_out_1,prop_out_2,enab_out_2,write_out_2,prop_out_3,enab_out_3,write_out_3,r7_write : out std_logic;
		in_prop_w_1,in_prop_w_2,in_prop_w_3 : in std_logic_vector(15 downto 0);
		in_jump_bit_1, in_jump_bit_2, in_jump_bit_3 : in std_logic;
		in_jump_add_1, in_jump_add_2, in_jump_add_3 : in std_logic_vector(15 downto 0)
		);

end entity WriteBack;

architecture WB of WriteBack is

signal opcode_1,opcode_2,opcode_3: std_logic_vector(3 downto 0);
signal res: std_logic_vector(16 downto 0);
signal pc1,pc2,pc3 : std_logic_vector(16 downto 0);
signal rf_write_data_1_pc_temp, rf_write_data_2_pc_temp, rf_write_data_3_pc_temp : std_logic_vector(15 downto 0);

begin

opcode_1 <= in_instruction_1(15 downto 12);
rf_write_data_1_out<= rf_write_data_1_pc when (opcode_1 = "1000" or opcode_1 = "1001")  else rf_write_data_1;
data_add_1_out <= data_add_1 when opcode_1 = "0110" else in_instruction_1(11 downto 9) when ((((not opcode_1(3)) and (not opcode_1(2)) and opcode_1(1) and opcode_1(0)) or (opcode_1(3) and (not opcode_1(2)) and (not opcode_1(1))) or ((not opcode_1(3)) and opcode_1(2) and (not opcode_1(0))))='1') else in_instruction_1(5 downto 3);
prop_out_1 <= prop_1;
enab_out_1 <= enab_1;
write_out_1 <= in_control_word_1(7);

opcode_2 <= in_instruction_2(15 downto 12);
rf_write_data_2_out<= rf_write_data_2_pc when (opcode_2 = "1000" or opcode_2 = "1001")  else rf_write_data_2;
data_add_2_out <= data_add_2 when opcode_2 = "0110" else in_instruction_2(11 downto 9) when ((((not opcode_2(3)) and (not opcode_2(2)) and opcode_2(1) and opcode_2(0)) or (opcode_2(3) and (not opcode_2(2)) and (not opcode_2(1))) or ((not opcode_2(3)) and opcode_2(2) and (not opcode_2(0))))='1') else in_instruction_2(5 downto 3);
prop_out_2 <= prop_2;
enab_out_2 <= enab_2;
write_out_2 <= in_control_word_2(7);

opcode_3 <= in_instruction_3(15 downto 12);
rf_write_data_3_out<= rf_write_data_3_pc when (opcode_3 = "1000" or opcode_3 = "1001")  else rf_write_data_3;
data_add_3_out <= data_add_3 when opcode_3 = "0110" else in_instruction_3(11 downto 9) when ((((not opcode_3(3)) and (not opcode_3(2)) and opcode_3(1) and opcode_3(0)) or (opcode_3(3) and (not opcode_3(2)) and (not opcode_3(1))) or ((not opcode_3(3)) and opcode_3(2) and (not opcode_3(0))))='1') else in_instruction_3(5 downto 3);
prop_out_3 <= prop_3;
enab_out_3 <= enab_3;
write_out_3 <= in_control_word_3(7);

--Data logic for R7
r7_write <= (prop_1 and enab_1) or (prop_2 and enab_2) or (prop_3 and enab_3);

rf_write_data_1_pc_temp <= in_jump_add_1 when (in_jump_bit_1 = '1' or in_control_word_1(14) = '1' or in_control_word_1(13) = '1') else rf_write_data_1_pc;
rf_write_data_2_pc_temp <= in_jump_add_2 when (in_jump_bit_2 = '1' or in_control_word_2(14) = '1' or in_control_word_2(13) = '1') else rf_write_data_2_pc;
rf_write_data_3_pc_temp <= in_jump_add_3 when (in_jump_bit_3 = '1' or in_control_word_3(14) = '1' or in_control_word_3(13) = '1') else rf_write_data_3_pc;

pc1 <= (prop_1 and enab_1) & rf_write_data_1_pc_temp;
pc2 <= (prop_2 and enab_2) & rf_write_data_2_pc_temp;
pc3 <= (prop_3 and enab_3) & rf_write_data_3_pc_temp;
res <= pc1 when (pc1 >= pc2 and pc1 >= pc3) else pc2 when (pc2 >= pc3 and pc2 >= pc1) else pc3;
rf_write_pc_out <= res(15 downto 0);


end WB;
