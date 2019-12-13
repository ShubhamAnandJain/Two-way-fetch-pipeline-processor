library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity RegisterRead is
port(pc_1,ir_1,pc_inc_1,jump_addr_in_1,wr_reg_data_1,pc_2,ir_2,pc_inc_2,jump_addr_in_2,wr_reg_data_2,pc_3,ir_3,pc_inc_3,jump_addr_in_3,wr_reg_data_3,wr_pc: in std_logic_vector(15 downto 0);
		lsreg_a_1,wr_reg_add_1,lsreg_a_2,wr_reg_add_2,lsreg_a_3,wr_reg_add_3: in std_logic_vector(2 downto 0);
		control_word_input_1,control_word_input_2,control_word_input_3: in std_logic_vector(15 downto 0);
		prop_1,enable_1,prop_wb_1,enable_wb_1,write_wb_1,prop_2,enable_2,prop_wb_2,enable_wb_2,write_wb_2,prop_3,enable_3,prop_wb_3,enable_wb_3,write_wb_3,clk,r: in std_logic;
		control_word_output_1,control_word_output_2,control_word_output_3: out std_logic_vector(15 downto 0);
		lsreg_a_out_1,lsreg_a_out_2,lsreg_a_out_3: out std_logic_vector(2 downto 0);
	 output_pc_1,output_pc_inc_1,output_ir_1,ra_1,rb_1,jump_addr_out_1,output_pc_2,output_pc_inc_2,output_ir_2,ra_2,rb_2,jump_addr_out_2,output_pc_3,output_pc_inc_3,output_ir_3,ra_3,rb_3,jump_addr_out_3: out std_logic_vector(15 downto 0);
	 O0, O1, O2, O3, O4, O5, O6, O7 : out std_logic_vector(15 downto 0);
	 start_bit_a_1,start_bit_a_2,start_bit_a_3,r7_wr_en:in std_logic; start_bit_out_1,start_bit_out_2,start_bit_out_3: out std_logic;
	 in_prop_r_1,in_prop_r_2,in_prop_r_3: in std_logic_vector(15 downto 0);
	 out_prop_r_1,out_prop_r_2,out_prop_r_3: out std_logic_vector(15 downto 0)
	 );
		
	
end entity RegisterRead;
	
architecture RR of RegisterRead is

component RF is
port(	clk : in std_logic;
		rst : in std_logic;
		Write_En : in std_logic_vector(3 downto 0);
		Read_En : in std_logic;
		Write_Data_1 : in std_logic_vector(15 downto 0);
		Write_Data_2 : in std_logic_vector(15 downto 0);
		Write_Data_3 : in std_logic_vector(15 downto 0);
		Write_Data_4 : in std_logic_vector(15 downto 0);
		Read_Data_1 : out std_logic_vector(15 downto 0);
		Read_Data_2 : out std_logic_vector(15 downto 0);
		Read_Data_3 : out std_logic_vector(15 downto 0);
		Read_Data_4 : out std_logic_vector(15 downto 0);
		Read_Data_5 : out std_logic_vector(15 downto 0);
		Read_Data_6 : out std_logic_vector(15 downto 0);
		In_select_1 : in std_logic_vector(2 downto 0);
		In_select_2 : in std_logic_vector(2 downto 0);
		In_select_3 : in std_logic_vector(2 downto 0);
		In_select_4 : in std_logic_vector(2 downto 0);
		Out_select_1 : in std_logic_vector(2 downto 0);
		Out_select_2 : in std_logic_vector(2 downto 0);
		Out_select_3 : in std_logic_vector(2 downto 0);
		Out_select_4 : in std_logic_vector(2 downto 0);
		Out_select_5 : in std_logic_vector(2 downto 0);
		Out_select_6 : in std_logic_vector(2 downto 0);
		O0, O1, O2, O3, O4, O5, O6, O7 : out std_logic_vector(15 downto 0));
end component;

component Bit_adder_8 is
   port( input_vector1: in std_logic_vector(15 downto 0);
	      input_vector2 :in std_logic_vector(15 downto 0);
       	output_vector: out std_logic_vector(16 downto 0));
end component;

signal Operand_select: std_logic_vector(1 downto 0);
signal temp_var, temp_var_1 : std_logic_vector(3 downto 0);
signal ra_rd_En, rb_rd_En, RF_En_sig : std_logic;
signal ra_temp_1,rb_temp_1,ra_temp_2,rb_temp_2,ra_temp_3,rb_temp_3, wr_pc_1,rb_jump_temp_1,rb_jump_temp_2,rb_jump_temp_3, jump_temp_1, jump_temp_2, jump_temp_3: std_logic_vector(15 downto 0);
signal wr_pc_inc : std_logic_vector(16 downto 0);
signal reg_select_a_1,reg_select_b_1,reg_select_a_temp_1,reg_select_b_temp_1,reg_select_a_2,reg_select_b_2,reg_select_a_temp_2,reg_select_b_temp_2,reg_select_a_3,reg_select_b_3,reg_select_a_temp_3,reg_select_b_temp_3 : std_logic_vector(2 downto 0);


begin

--First of all, let us pass along the operands which are needed for further stages for all three instructions
out_prop_r_1 <= in_prop_r_1;
start_bit_out_1 <= start_bit_a_1;
output_pc_1 <= pc_1;
output_ir_1 <= ir_1;
jump_temp_1 <= rb_jump_temp_1 when (control_word_input_1(13)='1') else jump_addr_in_1;
jump_addr_out_1 <= jump_temp_1;
control_word_output_1 <= control_word_input_1;
lsreg_a_out_1 <= lsreg_a_1;
--temp_var_1 <= ((prop_wb_1 and enable_wb_1 and write_wb_1)&(prop_wb_1 and enable_wb_1));

out_prop_r_2 <= in_prop_r_2;
start_bit_out_2 <= start_bit_a_2;
output_pc_2 <= pc_2;
output_ir_2 <= ir_2;
jump_temp_2 <= rb_jump_temp_2 when (control_word_input_2(13)='1') else jump_addr_in_2;
jump_addr_out_2 <= jump_temp_2;
control_word_output_2 <= control_word_input_2;
lsreg_a_out_2 <= lsreg_a_2;
--temp_var_1 <= ((prop_wb and enable_wb and write_wb)&(prop_wb and enable_wb));

out_prop_r_3 <= in_prop_r_3;
start_bit_out_3 <= start_bit_a_3;
output_pc_3 <= pc_3;
output_ir_3 <= ir_3;
jump_temp_3 <= rb_jump_temp_3 when (control_word_input_3(13)='1') else jump_addr_in_3;
jump_addr_out_3 <= jump_temp_3;
control_word_output_3 <= control_word_input_3;
lsreg_a_out_3 <= lsreg_a_3;
temp_var_1 <= ((prop_wb_1 and enable_wb_1 and write_wb_1)&(prop_wb_2 and enable_wb_2 and write_wb_2)&(prop_wb_3 and enable_wb_3 and write_wb_3)&(r7_wr_en));

--Adding 1 to wr_pc

B1 : Bit_adder_8
	port map(input_vector1 =>  wr_pc , input_vector2 => "0000000000000001" , output_vector => wr_pc_inc);


--Handling the case of R7. Check this very carefully
temp_var(3) <= '0' when wr_reg_add_1="111" else temp_var_1(3);
temp_var(2) <= '0' when wr_reg_add_2="111" else temp_var_1(2);
temp_var(1) <= '0' when wr_reg_add_3="111" else temp_var_1(1);
temp_var(0) <= temp_var_1(0);
wr_pc_1 <= wr_reg_data_1 when wr_reg_add_1="111" else wr_reg_data_2 when wr_reg_add_2="111" else wr_reg_data_3 when wr_reg_add_3="111"  else wr_pc;


--Now let us get the values in registers a and b from the register file for all three cases

reg_select_a_temp_1 <= ir_1(11 downto 9) when control_word_input_1(8)='0' else lsreg_a_1;
reg_select_b_temp_1 <= ir_1(11 downto 9) when control_word_input_1(8)='1' else ir_1(8 downto 6);

reg_select_a_temp_2 <= ir_2(11 downto 9) when control_word_input_2(8)='0' else lsreg_a_2;
reg_select_b_temp_2 <= ir_2(11 downto 9) when control_word_input_2(8)='1' else ir_2(8 downto 6);

reg_select_a_temp_3 <= ir_3(11 downto 9) when control_word_input_3(8)='0' else lsreg_a_3;
reg_select_b_temp_3 <= ir_3(11 downto 9) when control_word_input_3(8)='1' else ir_3(8 downto 6);


--Flipping for SM for all three cases

reg_select_a_1 <= reg_select_a_temp_1 when control_word_input_1(8)='0' else reg_select_b_temp_1;
reg_select_b_1 <= reg_select_b_temp_1 when control_word_input_1(8)='0' else reg_select_a_temp_1;

reg_select_a_2 <= reg_select_a_temp_2 when control_word_input_2(8)='0' else reg_select_b_temp_2;
reg_select_b_2 <= reg_select_b_temp_2 when control_word_input_2(8)='0' else reg_select_a_temp_2;

reg_select_a_3 <= reg_select_a_temp_3 when control_word_input_3(8)='0' else reg_select_b_temp_3;
reg_select_b_3 <= reg_select_b_temp_3 when control_word_input_3(8)='0' else reg_select_a_temp_3;


--Giving input and output to register module

RF1: RF
port map(clk => clk,	rst => r, Write_En=> temp_var, Read_En=>'1',
		Write_Data_1 => wr_reg_data_1, Write_Data_2 => wr_reg_data_2, Write_Data_3 => wr_reg_data_3, Write_Data_4 => wr_pc_1,
		Read_Data_1 => ra_temp_1,
		Read_Data_2 => rb_temp_1,
		Read_Data_3 => ra_temp_2,
		Read_Data_4 => rb_temp_2,
		Read_Data_5 => ra_temp_3,
		Read_Data_6 => rb_temp_3,
		In_select_1 => wr_reg_add_1,
		In_select_2 => wr_reg_add_2,
		In_select_3 => wr_reg_add_3,
		In_select_4 => "111",
		Out_select_1 => reg_select_a_1,
		Out_select_2 => reg_select_b_1,
		Out_select_3 => reg_select_a_2,
		Out_select_4 => reg_select_b_2,
		Out_select_5 => reg_select_a_3,
		Out_select_6 => reg_select_b_3,
		O0 => O0, O1 => O1, O2 => O2, O3 => O3, O4 => O4, O5 => O5, O6 => O6, O7 => O7);

--Checking for dependencies and assigning final values to ra and rb

--ra <= wr_reg_data when ((temp_var(1)='1') and (reg_select_a = wr_reg_add)) else wr_pc when ((temp_var(0)='1') and (reg_select_a = "111")) else ra_temp; 
--rb <= wr_reg_data when ((temp_var(1)='1') and reg_select_b = wr_reg_add) else wr_pc when ((temp_var(0)='1') and reg_select_b = "111") else rb_temp;
ra_1 <= pc_1 when (reg_select_a_1 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_a_1 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_a_1 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_a_1 = wr_reg_add_3) else ra_temp_1;  
ra_2 <= pc_2 when (reg_select_a_2 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_a_2 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_a_2 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_a_2 = wr_reg_add_3) else ra_temp_2;  
ra_3 <= pc_3 when (reg_select_a_3 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_a_3 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_a_3 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_a_3 = wr_reg_add_3) else ra_temp_3;  

rb_jump_temp_1 <= pc_1 when (reg_select_b_1 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_b_1 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_b_1 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_b_1 = wr_reg_add_3) else rb_temp_1;  
rb_1 <= rb_jump_temp_1;
rb_jump_temp_2 <= pc_2 when (reg_select_b_2 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_b_2 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_b_2 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_b_2 = wr_reg_add_3) else rb_temp_2;  
rb_2 <= rb_jump_temp_2;
rb_jump_temp_3 <= pc_3 when (reg_select_b_3 = "111") else wr_reg_data_1 when ((temp_var(1)='1') and reg_select_b_3 = wr_reg_add_1) else wr_reg_data_2 when ((temp_var(2)='1') and reg_select_b_3 = wr_reg_add_2) else wr_reg_data_3 when ((temp_var(3)='1') and reg_select_b_3 = wr_reg_add_3) else rb_temp_3;  
rb_3 <= rb_jump_temp_3;


	
output_pc_inc_1 <= jump_temp_1 when (ir_1(15 downto 12) = "1001") else pc_inc_1;	
output_pc_inc_2 <= jump_temp_2 when (ir_2(15 downto 12) = "1001") else pc_inc_2;	
output_pc_inc_3 <= jump_temp_3 when (ir_3(15 downto 12) = "1001") else pc_inc_3;	

	
end RR;