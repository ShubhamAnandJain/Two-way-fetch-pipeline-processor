library ieee;
use ieee.std_logic_1164.all;

entity TopLevel is
   port (r, clk: in std_logic);
end entity;

architecture Project1 of TopLevel is
  
component InstructionFetch is
port( input_pc : in std_logic_vector(15 downto 0); clk, enable, prop : in std_logic;
	out_pc_prev1, out_pc_inc1, out_instruction_1, out_pc_prev2, out_pc_inc2, out_instruction_2 : out std_logic_vector(15 downto 0) );
end component;

component InstructionDecode is
	port(
		pc : in std_logic_vector(15 downto 0);
		pc_inc : in std_logic_vector(15 downto 0);
		ir : in std_logic_vector(15 downto 0);
		prop_bit : in std_logic;
		Enable_bit : in std_logic;
		SM_LM_mux_control : in std_logic;
		clk : in std_logic;	
		out_pc : out std_logic_vector(15 downto 0);
		out_pc_inc : out std_logic_vector(15 downto 0);
		out_ir : out std_logic_vector(15 downto 0);
		control_word : out std_logic_vector(15 downto 0);
		BEQ_jump_address : out std_logic_vector(15 downto 0);
		Normal_jump_address : out std_logic_vector(15 downto 0);
		LsReg_a : out std_logic_vector(2 downto 0);
		IR_ID_enable : out std_logic;
		flag_bit : out std_logic;
		start_bit : out std_logic;
		prop_reg : out std_logic_vector(15 downto 0);
		jump_bit : out std_logic
		);
end component;  

-- Note that to_jump in InstructionDecode will be used by the TopLevel logic

component RegisterRead is
port(pc_1,
	ir_1,
	pc_inc_1,
	jump_addr_in_1,
	wr_reg_data_1,
	pc_2,
	ir_2,
	pc_inc_2,
	jump_addr_in_2,
	wr_reg_data_2,
	pc_3,
	ir_3,
	pc_inc_3,
	jump_addr_in_3,
	wr_reg_data_3,
	wr_pc: in std_logic_vector(15 downto 0);
	lsreg_a_1,
	wr_reg_add_1,
	lsreg_a_2,
	wr_reg_add_2,
	lsreg_a_3,
	wr_reg_add_3: in std_logic_vector(2 downto 0);
	control_word_input_1,
	control_word_input_2,
	control_word_input_3: in std_logic_vector(15 downto 0);
	prop_1,enable_1,prop_wb_1,
	enable_wb_1,write_wb_1,prop_2,
	enable_2,prop_wb_2,enable_wb_2,
	write_wb_2,prop_3,enable_3,
	prop_wb_3,enable_wb_3,write_wb_3,clk,r: in std_logic;
	control_word_output_1,control_word_output_2,control_word_output_3: out std_logic_vector(15 downto 0);
	lsreg_a_out_1,lsreg_a_out_2,lsreg_a_out_3: out std_logic_vector(2 downto 0);
	output_pc_1,output_pc_inc_1,output_ir_1,
	ra_1,rb_1,jump_addr_out_1,output_pc_2,
	output_pc_inc_2,output_ir_2,ra_2,rb_2,
	jump_addr_out_2,output_pc_3,output_pc_inc_3,
	output_ir_3,ra_3,rb_3,jump_addr_out_3: out std_logic_vector(15 downto 0);
	O0, O1, O2, O3, O4, O5, O6, O7 : out std_logic_vector(15 downto 0);
	start_bit_a_1,start_bit_a_2,start_bit_a_3,
	r7_wr_en:in std_logic; start_bit_out_1,start_bit_out_2,start_bit_out_3: out std_logic;
	in_prop_r_1,in_prop_r_2,in_prop_r_3: in std_logic_vector(15 downto 0);
	out_prop_r_1,out_prop_r_2,out_prop_r_3: out std_logic_vector(15 downto 0)
	);

		
end component;

component ExecutionTasks is

	port( 
	pc 		: in std_logic_vector(15 downto 0);
	pc_inc		: in std_logic_vector(15 downto 0);
	operand_1	: in std_logic_vector(15 downto 0);	--ra
	operand_2	: in std_logic_vector(15 downto 0);	--rb
	ir		: in std_logic_vector(15 downto 0);
	control_word	: in std_logic_vector(15 downto 0);
	jump_addr	: in std_logic_vector(15 downto 0);
	prop,enable	: in std_logic;
	zin,cin		: in std_logic;
--	lhi_sel		: in std_logic;
	pc_out 		: out std_logic_vector(15 downto 0);
	pc_inc_out	: out std_logic_vector(15 downto 0);
	alu_out		: out std_logic_vector(15 downto 0);
	ir_out		: out std_logic_vector(15 downto 0);
	jump_addr_out	: out std_logic_vector(15 downto 0);
	cout 		: out std_logic;
	zout		: out std_logic;
	wr_c_bit		: out std_logic;
	beq_condn_bit	: out std_logic;
	control_word_out: out std_logic_vector(15 downto 0); 
   r7_bit      : out std_logic;
	in_prop_e : in std_logic_vector(15 downto 0);
	out_prop_e : out std_logic_vector(15 downto 0)
   );

end component;	

component MemoryAccess is

port( 
	address 	: in std_logic_vector(15 downto 0);	-- lsreg_a in docs
	pc 		: in std_logic_vector(15 downto 0);
	pc_inc		: in std_logic_vector(15 downto 0);
	data_in		: in std_logic_vector(15 downto 0);
	ir		: in std_logic_vector(15 downto 0);
	control_word	: in std_logic_vector(15 downto 0);
	prop,enable	: in std_logic;
	clk : in std_logic;
	pc_out 		: out std_logic_vector(15 downto 0);
	pc_inc_out	: out std_logic_vector(15 downto 0);
	ir_out		: out std_logic_vector(15 downto 0);
	data_out	: out std_logic_vector(15 downto 0);
	control_word_out: out std_logic_vector(15 downto 0);
	zero_bit_out : out std_logic;
	lm_sm_in : in std_logic_vector(2 downto 0);
	lm_sm_out : out std_logic_vector(2 downto 0);
	r7_bit: in std_logic;
	r7_bit_out : out std_logic;
	in_prop_m : in std_logic_vector(15 downto 0);
	out_prop_m : out std_logic_vector(15 downto 0);
	ra_value, rb_value : in std_logic_vector(15 downto 0)
	 );

end component;	

component WriteBack is

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

end component;

component HazardDetectionUnit is
port( 
    ir_1    :   in std_logic_vector(15 downto 0);       -- IR_1 is the first instruction
    ir_2    :   in std_logic_vector(15 downto 0);       -- IR_2 is the second, possibly dependent instruction
    ra_bit  :   out std_logic;                          -- RegA of instruction 2 dependent
	 rb_bit  :   out std_logic;                           -- RegB of instruction 2 dependent
	 fake_rb : in std_logic_vector(2 downto 0)
	);
end component;

component Scheduler is
port( 
    
    in_data_1   :   in std_logic_vector(85 downto 0);
    in_data_2   :   in std_logic_vector(85 downto 0);

    clk         :   in std_logic;
    rst         :   in std_logic;
    
    enable      :   in std_logic;

    out_inst_1  :   out std_logic_vector(85 downto 0); --ExMem
    out_inst_2  :   out std_logic_vector(85 downto 0); --Ex1    
    out_inst_3  :   out std_logic_vector(85 downto 0); --Ex2
    
    overflow    :   out std_logic;
    valid_mask  :   out std_logic_vector(2 downto 0)
    );
end component;
		
-- INTERFACE REGISTERS
signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0);


signal IF_ID_1_interface : std_logic_vector(50 downto 0);
signal IF_ID_2_interface : std_logic_vector(50 downto 0);
signal ID_SS_interface : std_logic_vector(173 downto 0);
signal SS_RR_interface : std_logic_vector(386 downto 0);
signal RR_EX_1_interface : std_logic_vector(131 downto 0);
signal RR_EX_2_interface : std_logic_vector(131 downto 0);
signal RR_MEM_interface : std_logic_vector(101 downto 0);
signal WR_interface : std_logic_vector(263 downto 0);

-- INSTRUCTION FETCH : f

signal in_pc_f : std_logic_vector(15 downto 0);
signal out_pc_1_f, out_pc_inc_1_f, out_pc_2_f, out_pc_inc_2_f: std_logic_vector(15 downto 0);
signal out_instruction_1_f, out_instruction_2_f : std_logic_vector(15 downto 0);
signal in_enable_f, in_prop_f : std_logic;
 
-- INSTRUCTION DECODE : d

signal out_pc_1_d, out_pc_inc_1_d, out_instruction_1_d, out_control_word_1_d, out_jump_add_1_d, out_normal_jump_1_d, out_prop_1_d : std_logic_vector(15 downto 0);
signal out_ls_enable_1_d, out_zero_flag_1_d, out_start_bit_1_d : std_logic;
signal out_lsreg_a_1_d : std_logic_vector(2 downto 0);
signal sm_lm_mux_control_1_d : std_logic;
signal jump_bit_1_d : std_logic;

signal out_pc_2_d, out_pc_inc_2_d, out_instruction_2_d, out_control_word_2_d, out_jump_add_2_d, out_normal_jump_2_d, out_prop_2_d : std_logic_vector(15 downto 0);
signal out_ls_enable_2_d, out_zero_flag_2_d, out_start_bit_2_d : std_logic;
signal out_lsreg_a_2_d : std_logic_vector(2 downto 0);
signal sm_lm_mux_control_2_d : std_logic;
signal jump_bit_2_d : std_logic;

-- SCHEDULER : s

signal out_data_1_s, out_data_2_s, out_data_3_s : std_logic_vector(85 downto 0);
signal overflow_s : std_logic;
signal valid_mask_s : std_logic_vector(2 downto 0);

-- REGISTER READ : r

signal out_pc_1_r, out_pc_inc_1_r, out_instruction_1_r, out_control_word_1_r, out_jump_add_1_r, out_ra_1_r, out_rb_1_r : std_logic_vector(15 downto 0);
signal out_lsreg_a_1_r : std_logic_vector(2 downto 0);
signal in_start_bit_1_r, out_start_bit_1_r : std_logic;

signal out_pc_2_r, out_pc_inc_2_r, out_instruction_2_r, out_control_word_2_r, out_jump_add_2_r, out_ra_2_r, out_rb_2_r : std_logic_vector(15 downto 0);
signal out_lsreg_a_2_r : std_logic_vector(2 downto 0);
signal in_start_bit_2_r, out_start_bit_2_r : std_logic;

signal out_pc_3_r, out_pc_inc_3_r, out_instruction_3_r, out_control_word_3_r, out_jump_add_3_r, out_ra_3_r, out_rb_3_r : std_logic_vector(15 downto 0);
signal out_lsreg_a_3_r : std_logic_vector(2 downto 0);
signal in_start_bit_3_r, out_start_bit_3_r : std_logic;

signal in_jump_bit_1_r, in_jump_bit_2_r, in_jump_bit_3_r : std_logic;

-- EXECUTION TASKS : e

signal out_pc_1_e, out_pc_inc_1_e, out_instruction_1_e, out_control_word_1_e, out_jump_add_1_e : std_logic_vector(15 downto 0);
signal alu_out_1_e, out_prop_1_e : std_logic_vector(15 downto 0);
signal out_c_1_e, out_z_1_e, beq_condn_bit_1_e, wr_c_bit_1_e : std_logic;
signal out_r7_bit_1_e : std_logic;

signal out_pc_2_e, out_pc_inc_2_e, out_instruction_2_e, out_control_word_2_e, out_jump_add_2_e : std_logic_vector(15 downto 0);
signal alu_out_2_e, out_prop_2_e : std_logic_vector(15 downto 0);
signal out_c_2_e, out_z_2_e, beq_condn_bit_2_e, wr_c_bit_2_e : std_logic;
signal out_r7_bit_2_e : std_logic;

signal in_jump_bit_1_e, in_jump_bit_2_e : std_logic;
signal in_start_bit_1_e, in_start_bit_2_e : std_logic;

-- MEMORY ACCESS : m

signal out_pc_m, out_pc_inc_m, out_instruction_m, out_data_m, out_control_word_m, in_prop_m, out_prop_m : std_logic_vector(15 downto 0);
signal zero_flag_out_m : std_logic;
signal out_lm_sm_address_m : std_logic_vector(2 downto 0);
signal in_r7_bit_m, out_r7_bit_m : std_logic;
signal in_jump_bit_m, in_start_bit_m : std_logic;
signal ra_in_m, rb_in_m : std_logic_vector(15 downto 0);

-- WRITE BACK : w

signal rf_write_data1_out_w, rf_write_data2_out_w , rf_write_data3_out_w, rf_write_pc_out_w: std_logic_vector(15 downto 0);
signal data_add_1_out_w, data_add_2_out_w, data_add_3_out_w : std_logic_vector(2 downto 0);
signal enable_1_w, prop_1_w, write_1_w : std_logic;
signal enable_2_w, prop_2_w, write_2_w : std_logic;
signal enable_3_w, prop_3_w, write_3_w : std_logic;
signal r7_write_w : std_logic;
signal in_jump_bit_1_w, in_jump_bit_2_w, in_jump_bit_3_w : std_logic;
signal in_jump_add_1_w, in_jump_add_2_w, in_jump_add_3_w : std_logic_vector(15 downto 0);

-- HAZARDS

signal bmem_bwb1_ra, bmem_bwb2_ra, bmem_bwb3_ra, bmem_bwb1_rb, bmem_bwb2_rb, bmem_bwb3_rb : std_logic;
signal bex1_bwb1_ra, bex1_bwb2_ra, bex1_bwb3_ra, bex1_bwb1_rb, bex1_bwb2_rb, bex1_bwb3_rb : std_logic;
signal bex2_bwb1_ra, bex2_bwb2_ra, bex2_bwb3_ra, bex2_bwb1_rb, bex2_bwb2_rb, bex2_bwb3_rb : std_logic;

-- General

signal q_var : std_logic_vector(1 downto 0);

-- For queue implementation : std_logic
signal counter : std_logic;

  
begin

-- INSTRUCTION FETCH
	
	IF_instance_1 : InstructionFetch port map(in_pc_f, clk, in_enable_f, in_prop_f, out_pc_1_f, out_pc_inc_1_f,
	out_instruction_1_f, out_pc_2_f, out_pc_inc_2_f, out_instruction_2_f);
	
-- INSTRUCTION DECODE

	ID_instance_1 : InstructionDecode port map(IF_ID_1_interface(50 downto 35), IF_ID_1_interface(34 downto 19), 
	IF_ID_1_interface(18 downto 3), IF_ID_1_interface(2), IF_ID_1_interface(1), IF_ID_1_interface(0),
	clk, out_pc_1_d, out_pc_inc_1_d, out_instruction_1_d, out_control_word_1_d, out_jump_add_1_d, out_normal_jump_1_d,
	out_lsreg_a_1_d, out_ls_enable_1_d, out_zero_flag_1_d, out_start_bit_1_d, out_prop_1_d, jump_bit_1_d);
	
	ID_instance_2 : InstructionDecode port map(IF_ID_2_interface(50 downto 35), IF_ID_2_interface(34 downto 19), 
	IF_ID_2_interface(18 downto 3), IF_ID_2_interface(2), IF_ID_2_interface(1), IF_ID_2_interface(0), 
	clk, out_pc_2_d, out_pc_inc_2_d, out_instruction_2_d, out_control_word_2_d, out_jump_add_2_d, out_normal_jump_2_d,
	out_lsreg_a_2_d, out_ls_enable_2_d, out_zero_flag_2_d, out_start_bit_2_d, out_prop_2_d, jump_bit_2_d);
	
--	SCHEDULER

	SS_instance_1 : Scheduler port map(ID_SS_interface(173 downto 88), ID_SS_interface(87 downto 2), 
	clk, ID_SS_interface(1), ID_SS_interface(0), out_data_1_s, out_data_2_s, out_data_3_s, overflow_s, valid_mask_s	
	);

	
-- REGISTER READ

	RR_instance_1 : RegisterRead port map(SS_RR_interface(386 downto 371), SS_RR_interface(370 downto 355),
	SS_RR_interface(354 downto 339), SS_RR_interface(338 downto 323), SS_RR_interface(322 downto 307), 
	SS_RR_interface(306 downto 291), SS_RR_interface(290 downto 275), SS_RR_interface(274 downto 259),
	SS_RR_interface(258 downto 243), SS_RR_interface(242 downto 227), SS_RR_interface(226 downto 211),
	SS_RR_interface(210 downto 195), SS_RR_interface(194 downto 179), SS_RR_interface(178 downto 163),
	SS_RR_interface(162 downto 147), SS_RR_interface(146 downto 131), SS_RR_interface(130 downto 128),
	SS_RR_interface(127 downto 125), SS_RR_interface(124 downto 122), SS_RR_interface(121 downto 119),
	SS_RR_interface(118 downto 116), SS_RR_interface(115 downto 113), SS_RR_interface(112 downto 97),
	SS_RR_interface(96 downto 81), SS_RR_interface(80 downto 65), SS_RR_interface(64), SS_RR_interface(63),
	SS_RR_interface(62), SS_RR_interface(61), SS_RR_interface(60), SS_RR_interface(59), SS_RR_interface(58),
	SS_RR_interface(57), SS_RR_interface(56), SS_RR_interface(55), SS_RR_interface(54),
	SS_RR_interface(53), SS_RR_interface(52), SS_RR_interface(51), SS_RR_interface(50), clk, SS_RR_interface(49),
	out_control_word_1_r, out_control_word_2_r, out_control_word_3_r, out_lsreg_a_1_r, out_lsreg_a_2_r, out_lsreg_a_3_r, 
	out_pc_1_r, out_pc_inc_1_r, out_instruction_1_r, out_ra_1_r, out_rb_1_r, out_jump_add_1_r,
	out_pc_2_r, out_pc_inc_2_r, out_instruction_2_r, out_ra_2_r, out_rb_2_r, out_jump_add_2_r,
	out_pc_3_r, out_pc_inc_3_r, out_instruction_3_r, out_ra_3_r, out_rb_3_r, out_jump_add_3_r,
	R0, R1, R2, R3, R4, R5, R6, R7, in_start_bit_1_r, in_start_bit_2_r, in_start_bit_3_r, SS_RR_interface(48),
	out_start_bit_1_r, out_start_bit_2_r, out_start_bit_3_r, SS_RR_interface(47 downto 32),
	SS_RR_interface(31 downto 16), SS_RR_interface(15 downto 0)
	);

	
-- EXECUTION TASKS

	EX_instance_1 : ExecutionTasks port map(RR_EX_1_interface(131 downto 116), RR_EX_1_interface(115 downto 100), 
	RR_EX_1_interface(99 downto 84), RR_EX_1_interface(83 downto 68), RR_EX_1_interface(67 downto 52), 
	RR_EX_1_interface(51 downto 36), RR_EX_1_interface(35 downto 20), RR_EX_1_interface(19), 
	RR_EX_1_interface(18), RR_EX_1_interface(17), RR_EX_1_interface(16),
	out_pc_1_e, out_pc_inc_1_e, alu_out_1_e, out_instruction_1_e, out_jump_add_1_e, out_c_1_e, out_z_1_e,
	wr_c_bit_1_e, beq_condn_bit_1_e, out_control_word_1_e, out_r7_bit_1_e, RR_EX_1_interface(15 downto 0),
	out_prop_1_e);

	EX_instance_2 : ExecutionTasks port map(RR_EX_2_interface(131 downto 116), RR_EX_2_interface(115 downto 100), 
	RR_EX_2_interface(99 downto 84), RR_EX_2_interface(83 downto 68), RR_EX_2_interface(67 downto 52), 
	RR_EX_2_interface(51 downto 36), RR_EX_2_interface(35 downto 20), RR_EX_2_interface(19), 
	RR_EX_2_interface(18), RR_EX_2_interface(17), RR_EX_2_interface(16),
	out_pc_2_e, out_pc_inc_2_e, alu_out_2_e, out_instruction_2_e, out_jump_add_2_e, out_c_2_e, out_z_2_e,
	wr_c_bit_2_e, beq_condn_bit_2_e, out_control_word_2_e, out_r7_bit_2_e, RR_EX_2_interface(15 downto 0),
	out_prop_2_e);

	
-- MEMORY ACCESS

	MEM_instance_1 : MemoryAccess port map(RR_MEM_interface(101 downto 86), RR_MEM_interface(85 downto 70),
	RR_MEM_interface(69 downto 54), RR_MEM_interface(53 downto 38), RR_MEM_interface(37 downto 22), RR_MEM_interface(21 downto 6),
	RR_MEM_interface(5), RR_MEM_interface(4), clk, out_pc_m, out_pc_inc_m, out_instruction_m, out_data_m, out_control_word_m,
	zero_flag_out_m, RR_MEM_interface(3 downto 1), out_lm_sm_address_m, RR_MEM_interface(0), out_r7_bit_m, in_prop_m, out_prop_m,
	ra_in_m, rb_in_m);
	
	
-- WRITE BACK	
	
	WB_instance_1 : WriteBack port map(WR_interface(263 downto 248), WR_interface(247 downto 232), WR_interface(231 downto 216),
	WR_interface(215 downto 200), WR_interface(199 downto 184), WR_interface(183 downto 168), WR_interface(167 downto 152),
	WR_interface(151 downto 136), WR_interface(135 downto 120), WR_interface(119 downto 104), WR_interface(103 downto 88),
	WR_interface(87 downto 72), WR_interface(71 downto 69), WR_interface(68 downto 66), WR_interface(65 downto 63),
	WR_interface(62 downto 60), WR_interface(59 downto 57), WR_interface(56 downto 54), WR_interface(53), WR_interface(52),
	WR_interface(51), WR_interface(50), WR_interface(49), WR_interface(48),
	rf_write_data1_out_w, rf_write_data2_out_w, rf_write_data3_out_w, rf_write_pc_out_w, 
	data_add_1_out_w, data_add_2_out_w, data_add_3_out_w,
	prop_1_w, enable_1_w, write_1_w, prop_2_w, enable_2_w, write_2_w, prop_3_w, enable_3_w, write_3_w, r7_write_w,
	WR_interface(47 downto 32), WR_interface(31 downto 16), WR_interface(15 downto 0),
	in_jump_bit_1_w, in_jump_bit_2_w, in_jump_bit_3_w, in_jump_add_1_w, in_jump_add_2_w, in_jump_add_3_w);

-- HAZARD DETECTION LOGIC

	HD_instance_1 : HazardDetectionUnit port map(out_instruction_m, out_instruction_1_r, bmem_bwb1_ra, bmem_bwb1_rb, out_lsreg_a_1_r);
	HD_instance_2 : HazardDetectionUnit port map(out_instruction_m, out_instruction_2_r, bex1_bwb1_ra, bex1_bwb1_rb, out_lsreg_a_2_r);
	HD_instance_3 : HazardDetectionUnit port map(out_instruction_m, out_instruction_3_r, bex2_bwb1_ra, bex2_bwb1_rb, out_lsreg_a_3_r);
	
	HD_instance_4 : HazardDetectionUnit port map(out_instruction_1_e, out_instruction_1_r, bmem_bwb2_ra, bmem_bwb2_rb, out_lsreg_a_1_r);
	HD_instance_5 : HazardDetectionUnit port map(out_instruction_1_e, out_instruction_2_r, bex1_bwb2_ra, bex1_bwb2_rb, out_lsreg_a_2_r);
	HD_instance_6 : HazardDetectionUnit port map(out_instruction_1_e, out_instruction_3_r, bex2_bwb2_ra, bex2_bwb2_rb, out_lsreg_a_3_r);
	
	HD_instance_7 : HazardDetectionUnit port map(out_instruction_2_e, out_instruction_1_r, bmem_bwb3_ra, bmem_bwb3_rb, out_lsreg_a_1_r);
	HD_instance_8 : HazardDetectionUnit port map(out_instruction_2_e, out_instruction_2_r, bex1_bwb3_ra, bex1_bwb3_rb, out_lsreg_a_2_r);
	HD_instance_9 : HazardDetectionUnit port map(out_instruction_2_e, out_instruction_3_r, bex2_bwb3_ra, bex2_bwb3_rb, out_lsreg_a_3_r);
	
	
-- TRANSFER OF ZERO AND CARRY FLAGS COMBINATIONALLY
	
	RR_EX_2_interface(17) <= out_z_1_e;
	RR_EX_2_interface(16) <= out_c_1_e;
	
-- TRANSFER FROM WB stage to RR stage	
	
	SS_RR_interface(322 downto 307) <= rf_write_data1_out_w;
	SS_RR_interface(242 downto 227) <= rf_write_data2_out_w; 
	SS_RR_interface(162 downto 147) <= rf_write_data3_out_w;
	SS_RR_interface(146 downto 131) <= rf_write_pc_out_w;
	SS_RR_interface(127 downto 125) <= data_add_1_out_w;
	SS_RR_interface(121 downto 119) <= data_add_2_out_w;
	SS_RR_interface(115 downto 113) <= data_add_3_out_w;
	SS_RR_interface(62) <= prop_1_w;
	SS_RR_interface(61) <= enable_1_w;
	SS_RR_interface(60) <= write_1_w;
	SS_RR_interface(57) <= prop_2_w;
	SS_RR_interface(56) <= enable_2_w;
	SS_RR_interface(55) <= write_2_w;
	SS_RR_interface(52) <= prop_3_w;
	SS_RR_interface(51) <= enable_3_w;
	SS_RR_interface(50) <= write_3_w;
	SS_RR_interface(48) <= r7_write_w;
	
	
	process(clk)
	
	variable nq_var : std_logic_vector(1 downto 0);
	variable en_if, en_id, en_rr, en_ex, en_mem, en_wr : std_logic;
	variable prop_if, prop_id_1, prop_id_2, prop_rr, prop_ex_1, prop_ex_2, prop_mem, prop_wr : std_logic;
	variable prop_ss : std_logic_vector(2 downto 0);
	variable out_pc : std_logic_vector(15 downto 0);
	variable next_pc : std_logic_vector(15 downto 0);
	
	variable IF_ID_1 : std_logic_vector(50 downto 0);
	variable IF_ID_2 : std_logic_vector(50 downto 0);
	variable ID_SS : std_logic_vector(173 downto 0);
	variable SS_RR : std_logic_vector(386 downto 0);
	variable RR_EX_1 : std_logic_vector(131 downto 0);
	variable RR_EX_2 : std_logic_vector(131 downto 0);
	variable RR_MEM : std_logic_vector(101 downto 0);
	variable WR : std_logic_vector(263 downto 0);
	variable packed_data_1, packed_data_2 : std_logic_vector(85 downto 0);
	variable in_jump_bit_1_r_var, in_start_bit_1_r_var : std_logic;
	variable in_jump_bit_2_r_var, in_start_bit_2_r_var : std_logic;
	variable in_jump_bit_3_r_var, in_start_bit_3_r_var : std_logic;
	variable in_jump_bit_m_var, in_start_bit_m_var : std_logic;
	variable ra_in_m_var, rb_in_m_var : std_logic_vector(15 downto 0);
	variable in_jump_bit_1_e_var, in_start_bit_1_e_var : std_logic;
	variable in_jump_bit_2_e_var, in_start_bit_2_e_var : std_logic;
	variable in_jump_bit_1_w_var, in_jump_bit_2_w_var, in_jump_bit_3_w_var : std_logic;
	variable in_jump_add_1_w_var, in_jump_add_2_w_var, in_jump_add_3_w_var : std_logic_vector(15 downto 0);
	variable bmem_bwb1_ra_var, bmem_bwb2_ra_var, bmem_bwb3_ra_var, bmem_bwb1_rb_var, bmem_bwb2_rb_var, bmem_bwb3_rb_var : std_logic;
	variable bex1_bwb1_ra_var, bex1_bwb2_ra_var, bex1_bwb3_ra_var, bex1_bwb1_rb_var, bex1_bwb2_rb_var, bex1_bwb3_rb_var : std_logic;
	variable bex2_bwb1_ra_var, bex2_bwb2_ra_var, bex2_bwb3_ra_var, bex2_bwb1_rb_var, bex2_bwb2_rb_var, bex2_bwb3_rb_var : std_logic;
	variable jump_ex1_var, jump_ex2_var, jump_mem_var, jump_r1_var, jump_r2_var, jump_r3_var : std_logic;
	
	begin
	
	bmem_bwb1_ra_var := bmem_bwb1_ra and RR_MEM_interface(5) and out_control_word_m(7);
	bex1_bwb1_ra_var := bex1_bwb1_ra and RR_MEM_interface(5) and out_control_word_m(7);
	bex2_bwb1_ra_var := bex2_bwb1_ra and RR_MEM_interface(5) and out_control_word_m(7);
	
	bmem_bwb1_rb_var := bmem_bwb1_rb and RR_MEM_interface(5) and out_control_word_m(7);
	bex1_bwb1_rb_var := bex1_bwb1_rb and RR_MEM_interface(5) and out_control_word_m(7);
	bex2_bwb1_rb_var := bex2_bwb1_rb and RR_MEM_interface(5) and out_control_word_m(7);
	
	bmem_bwb2_ra_var := bmem_bwb2_ra and RR_EX_1_interface(19) and out_control_word_1_e(7);
	bex1_bwb2_ra_var := bex1_bwb2_ra and RR_EX_1_interface(19) and out_control_word_1_e(7);
	bex2_bwb2_ra_var := bex2_bwb2_ra and RR_EX_1_interface(19) and out_control_word_1_e(7);
	
	bmem_bwb2_rb_var := bmem_bwb2_rb and RR_EX_1_interface(19) and out_control_word_1_e(7);
	bex1_bwb2_rb_var := bex1_bwb2_rb and RR_EX_1_interface(19) and out_control_word_1_e(7);
	bex2_bwb2_rb_var := bex2_bwb2_rb and RR_EX_1_interface(19) and out_control_word_1_e(7);
	
	bmem_bwb3_ra_var := bmem_bwb3_ra and RR_EX_2_interface(19) and out_control_word_2_e(7);
	bex1_bwb3_ra_var := bex1_bwb3_ra and RR_EX_2_interface(19) and out_control_word_2_e(7);
	bex2_bwb3_ra_var := bex2_bwb3_ra and RR_EX_2_interface(19) and out_control_word_2_e(7);
	
	bmem_bwb3_rb_var := bmem_bwb3_rb and RR_EX_2_interface(19) and out_control_word_2_e(7);
	bex1_bwb3_rb_var := bex1_bwb3_rb and RR_EX_2_interface(19) and out_control_word_2_e(7);
	bex2_bwb3_rb_var := bex2_bwb3_rb and RR_EX_2_interface(19) and out_control_word_2_e(7);

	--bmem_bwb1_ra_var := bmem_bwb1_ra and RR_MEM_interface(5);
	--bex1_bwb1_ra_var := bex1_bwb1_ra and RR_MEM_interface(5);
	--bex2_bwb1_ra_var := bex2_bwb1_ra and RR_MEM_interface(5);
	
	--bmem_bwb1_rb_var := bmem_bwb1_rb and RR_MEM_interface(5);
	--bex1_bwb1_rb_var := bex1_bwb1_rb and RR_MEM_interface(5);
	--bex2_bwb1_rb_var := bex2_bwb1_rb and RR_MEM_interface(5);
	
	--bmem_bwb2_ra_var := bmem_bwb2_ra and RR_EX_1_interface(19); 
	--bex1_bwb2_ra_var := bex1_bwb2_ra and RR_EX_1_interface(19); 
	--bex2_bwb2_ra_var := bex2_bwb2_ra and RR_EX_1_interface(19); 
	
	--bmem_bwb2_rb_var := bmem_bwb2_rb and RR_EX_1_interface(19); 
	--bex1_bwb2_rb_var := bex1_bwb2_rb and RR_EX_1_interface(19); 
	--bex2_bwb2_rb_var := bex2_bwb2_rb and RR_EX_1_interface(19);
	
	--bmem_bwb2_ra_var := bmem_bwb2_ra and RR_EX_1_interface(19); 
	--bex1_bwb2_ra_var := bex1_bwb2_ra and RR_EX_1_interface(19); 
	--bex2_bwb2_ra_var := bex2_bwb2_ra and RR_EX_1_interface(19); 
	
	--bmem_bwb3_rb_var := bmem_bwb3_rb and RR_EX_2_interface(19); 
	--bex1_bwb3_rb_var := bex1_bwb3_rb and RR_EX_2_interface(19); 
	--bex2_bwb3_rb_var := bex2_bwb3_rb and RR_EX_2_interface(19);
	
	
	next_pc := out_pc_inc_2_f;
	prop_if := in_prop_f;
	prop_id_1 := IF_ID_1_interface(2);
	prop_id_2 := IF_ID_2_interface(2);
	prop_ss := valid_mask_s;
	prop_ex_1 := RR_EX_1_interface(19);
	prop_ex_2 := RR_EX_2_interface(19);
	prop_mem := RR_MEM_interface(5);
	
	IF_ID_1(50 downto 35) := out_pc_1_f;
	IF_ID_1(34 downto 19) := out_pc_inc_1_f;
	IF_ID_1(18 downto 3) := out_instruction_1_f;
	IF_ID_1(2) := in_prop_f;
	IF_ID_1(1) := in_enable_f;
	IF_ID_1(0) := sm_lm_mux_control_1_d;
	
	IF_ID_2(50 downto 35) := out_pc_2_f;
	IF_ID_2(34 downto 19) := out_pc_inc_2_f;
	IF_ID_2(18 downto 3) := out_instruction_2_f;
	IF_ID_2(2) := in_prop_f;
	IF_ID_2(1) := in_enable_f;
	IF_ID_2(0) := sm_lm_mux_control_2_d;
	
	packed_data_1(85 downto 70) := out_pc_1_d;
	packed_data_1(69 downto 54) := out_instruction_1_d;
	packed_data_1(53 downto 38) := out_pc_inc_1_d;
	packed_data_1(37 downto 22) := out_jump_add_1_d;
	packed_data_1(21 downto 19) := out_lsreg_a_1_d;
	packed_data_1(18 downto 3) := out_control_word_1_d;
	packed_data_1(2) := prop_id_1;
	packed_data_1(1) := out_start_bit_1_d;
	packed_data_1(0) := jump_bit_1_d;
	
	packed_data_2(85 downto 70) := out_pc_2_d;
	packed_data_2(69 downto 54) := out_instruction_2_d;
	packed_data_2(53 downto 38) := out_pc_inc_2_d;
	packed_data_2(37 downto 22) := out_jump_add_2_d;
	packed_data_2(21 downto 19) := out_lsreg_a_2_d;
	packed_data_2(18 downto 3) := out_control_word_2_d;
	packed_data_2(2) := prop_id_2;
	packed_data_2(1) := out_start_bit_2_d;
	packed_data_2(0) := jump_bit_2_d;
	
	ID_SS(173 downto 88) := packed_data_1;
	ID_SS(87 downto 2) := packed_data_2;
	ID_SS(1) := r;
	ID_SS(0) := '1';
	
	in_start_bit_1_r_var := out_data_1_s(1);
	in_jump_bit_1_r_var := out_data_1_s(0);
	in_start_bit_2_r_var := out_data_2_s(1);
	in_jump_bit_2_r_var := out_data_2_s(0);
	in_start_bit_3_r_var := out_data_3_s(1);
	in_jump_bit_3_r_var := out_data_3_s(0);
	
	SS_RR(386 downto 371) := out_data_1_s(85 downto 70);
	SS_RR(370 downto 355) := out_data_1_s(69 downto 54);
	SS_RR(354 downto 339) := out_data_1_s(53 downto 38);
	SS_RR(338 downto 323) := out_data_1_s(37 downto 22);
	SS_RR(306 downto 291) := out_data_2_s(85 downto 70);
	SS_RR(290 downto 275) := out_data_2_s(69 downto 54);
	SS_RR(274 downto 259) := out_data_2_s(53 downto 38);
	SS_RR(258 downto 243) := out_data_2_s(37 downto 22);
	SS_RR(226 downto 211) := out_data_3_s(85 downto 70);
	SS_RR(210 downto 195) := out_data_3_s(69 downto 54);
	SS_RR(194 downto 179) := out_data_3_s(53 downto 38);
	SS_RR(178 downto 163) := out_data_3_s(37 downto 22);
	SS_RR(130 downto 128) := out_data_1_s(21 downto 19);
	SS_RR(124 downto 122) := out_data_2_s(21 downto 19);
	SS_RR(118 downto 116) := out_data_3_s(21 downto 19);
	SS_RR(112 downto 97) := out_data_1_s(18 downto 3);
	SS_RR(96 downto 81) := out_data_2_s(18 downto 3);
	SS_RR(80 downto 65) := out_data_3_s(18 downto 3);
	SS_RR(64) := out_data_1_s(2);
	SS_RR(63) := out_data_1_s(2);
	SS_RR(59) := out_data_2_s(2);
	SS_RR(58) := out_data_2_s(2);
	SS_RR(54) := out_data_3_s(2);
	SS_RR(53) := out_data_3_s(2);
	SS_RR(49) := r;
	SS_RR(47 downto 32) := out_data_1_s(37 downto 22);
	SS_RR(31 downto 16) := out_data_2_s(37 downto 22);
	SS_RR(15 downto 0) := out_data_3_s(37 downto 22);
	
	in_jump_bit_1_e_var := out_start_bit_2_r;
	in_start_bit_1_e_var := in_jump_bit_2_r;
	
	RR_EX_1(131 downto 116) := out_pc_2_r;
	RR_EX_1(115 downto 100) := out_pc_inc_2_r;
	RR_EX_1(99 downto 84) := out_ra_2_r;
	RR_EX_1(83 downto 68) := out_rb_2_r;
	RR_EX_1(67 downto 52) := out_instruction_2_r;
	RR_EX_1(51 downto 36) := out_control_word_2_r;
	RR_EX_1(35 downto 20) := out_jump_add_2_r;
	RR_EX_1(19) := SS_RR_interface(59);
	RR_EX_1(18) := SS_RR_interface(58);
	RR_EX_1(17) := out_z_2_e;
	RR_EX_1(16) := out_c_2_e;
	RR_EX_1(15 downto 0) := out_jump_add_2_r;
	
	in_jump_bit_2_e_var := out_start_bit_3_r;
	in_start_bit_2_e_var := in_jump_bit_3_r;
	
	RR_EX_2(131 downto 116) := out_pc_3_r;
	RR_EX_2(115 downto 100) := out_pc_inc_3_r;
	RR_EX_2(99 downto 84) := out_ra_3_r;
	RR_EX_2(83 downto 68) := out_rb_3_r;
	RR_EX_2(67 downto 52) := out_instruction_3_r;
	RR_EX_2(51 downto 36) := out_control_word_3_r;
	RR_EX_2(35 downto 20) := out_jump_add_3_r;
	RR_EX_2(19) := SS_RR_interface(54);
	RR_EX_2(18) := SS_RR_interface(53);
	RR_EX_2(15 downto 0) := out_jump_add_3_r;
	
	
	in_jump_bit_m_var := in_jump_bit_1_r;
	in_start_bit_m_var := out_start_bit_1_r;
	
	ra_in_m_var := out_ra_1_r;
	rb_in_m_var := out_rb_1_r;
	
	RR_MEM(101 downto 86) := out_jump_add_1_r; --USELESS RN - RECALCULATED WITHIN. USED AS TEMP FOR JUMP
	RR_MEM(85 downto 70) := out_pc_1_r;
	RR_MEM(69 downto 54) := out_pc_inc_1_r;
	RR_MEM(53 downto 38) := "0000000000000000"; -- USELESS RN - RECALCULATED WITHIN.
	RR_MEM(37 downto 22) := out_instruction_1_r;
	RR_MEM(21 downto 6) := out_control_word_1_r;
	RR_MEM(5) := SS_RR_interface(64);
	RR_MEM(4) := SS_RR_interface(63);
	RR_MEM(3 downto 1) := out_lsreg_a_1_r;
	RR_MEM(0) := in_jump_bit_1_r; -- OK NOW
	
	in_jump_bit_1_w_var := in_jump_bit_m;
	in_jump_add_1_w_var := RR_MEM_interface(101 downto 86);
	in_jump_bit_2_w_var := in_jump_bit_1_e;
	in_jump_add_2_w_var := RR_EX_1_interface(35 downto 20);
	in_jump_bit_3_w_var := in_jump_bit_2_e;
	in_jump_add_3_w_var := RR_EX_2_interface(35 downto 20);
	
	
	WR(263 downto 248) := out_data_m;
	WR(247 downto 232) := alu_out_1_e;
	WR(231 downto 216) := alu_out_2_e;
	WR(215 downto 200) := out_pc_inc_m;
	WR(199 downto 184) := out_pc_inc_1_e;
	WR(183 downto 168) := out_pc_inc_2_e;
	WR(167 downto 152) := out_control_word_m;
	WR(151 downto 136) := out_instruction_m;
	WR(135 downto 120) := out_control_word_1_e;
	WR(119 downto 104) := out_instruction_1_e;
	WR(103 downto 88) := out_control_word_2_e;
	WR(87 downto 72) := out_instruction_2_e;
	WR(71 downto 69) := out_lm_sm_address_m;
	WR(68 downto 66) := "000"; -- DUMMY VARIABLE
	WR(65 downto 63) := "000"; -- DUMMY VARIABLE
	WR(62 downto 60) := "111";
	WR(59 downto 57) := "111";
	WR(56 downto 54) := "111";
	WR(53) := RR_MEM_interface(5);
	WR(52) := RR_MEM_interface(5);
	WR(51) := RR_EX_1_interface(19); 
	WR(50) := RR_EX_1_interface(18);
	WR(49) := RR_EX_2_interface(19);
	WR(48) := RR_EX_2_interface(18);
	WR(47 downto 32) := out_prop_m;
	WR(31 downto 16) := out_prop_1_e;
	WR(15 downto 0) := out_prop_2_e;
	
	if(bmem_bwb1_ra_var = '1') then
		ra_in_m_var := out_data_m;
	end if;
	if(bex1_bwb1_ra_var = '1') then
		RR_EX_1(99 downto 84) := out_data_m;
	end if;
	if(bex2_bwb1_ra_var = '1') then
		RR_EX_2(99 downto 84) := out_data_m;
	end if;
	
	if(bmem_bwb1_rb_var = '1') then
		rb_in_m_var := out_data_m;
	end if;
	if(bex1_bwb1_rb_var = '1') then
		RR_EX_1(83 downto 68) := out_data_m;
	end if;
	if(bex2_bwb1_rb_var = '1') then
		RR_EX_2(83 downto 68) := out_data_m;
	end if;
	
	if(bmem_bwb2_ra_var = '1') then
		ra_in_m_var := alu_out_1_e;
	end if;
	if(bex1_bwb2_ra_var = '1') then
		RR_EX_1(99 downto 84) := alu_out_1_e;
	end if;
	if(bex2_bwb2_ra_var = '1') then
		RR_EX_2(99 downto 84) := alu_out_1_e;
	end if;
	
	if(bmem_bwb2_rb_var = '1') then
		rb_in_m_var := alu_out_1_e;
	end if;
	if(bex1_bwb2_rb_var = '1') then
		RR_EX_1(83 downto 68) := alu_out_1_e;
	end if;
	if(bex2_bwb2_rb_var = '1') then
		RR_EX_2(83 downto 68) := alu_out_1_e;
	end if;
	
	if(bmem_bwb3_ra_var = '1') then
		ra_in_m_var := alu_out_2_e;
	end if;
	if(bex1_bwb3_ra_var = '1') then
		RR_EX_1(99 downto 84) := alu_out_2_e;
	end if;
	if(bex2_bwb3_ra_var = '1') then
		RR_EX_2(99 downto 84) := alu_out_2_e;
	end if;
	
	if(bmem_bwb3_rb_var = '1') then
		rb_in_m_var := alu_out_2_e;
	end if;
	if(bex1_bwb3_rb_var = '1') then
		RR_EX_1(83 downto 68) := alu_out_2_e;
	end if;
	if(bex2_bwb3_rb_var = '1') then
		RR_EX_2(83 downto 68) := alu_out_2_e;
	end if;
	
	jump_mem_var := in_jump_bit_m and RR_MEM_interface(5);
	jump_ex1_var := out_r7_bit_1_e and RR_EX_1_interface(19);
	jump_ex2_var := out_r7_bit_2_e and RR_EX_2_interface(19);
	
	jump_r1_var := in_jump_bit_1_r and SS_RR_interface(64) and (SS_RR_interface(111) or SS_RR_interface(110));
	jump_r2_var := in_jump_bit_2_r and SS_RR_interface(59) and (SS_RR_interface(95) or SS_RR_interface(94));
	jump_r3_var := in_jump_bit_3_r and SS_RR_interface(54) and (SS_RR_interface(79) or SS_RR_interface(78));	
	
	if(jump_r1_var = '1' or jump_r2_var = '1' or jump_r3_var = '1') then
		RR_EX_1(17 downto 16) := "00";
		IF_ID_1(2) := '0';
		IF_ID_2(2) := '0';
		ID_SS(1) := '0';
		ID_SS(0) := '0';
		SS_RR(64 downto 63) := "00";
		SS_RR(59 downto 58) := "00";
		SS_RR(54 downto 53) := "00";
	end if;
	
	if(jump_mem_var = '1' or jump_ex1_var = '1' or jump_ex2_var = '1') then
		RR_EX_1(17 downto 16) := "00";
		IF_ID_1(2) := '0';
		IF_ID_2(2) := '0';
		ID_SS(1) := '0';
		ID_SS(0) := '0';
		SS_RR(64 downto 63) := "00";
		SS_RR(59 downto 58) := "00";
		SS_RR(54 downto 53) := "00";
		RR_EX_1(19) := '0';
		RR_EX_1(18) := '0';
		RR_EX_2(19) := '0';
		RR_EX_2(18) := '0';
		RR_MEM(5) := '0';
		RR_MEM(4) := '0';
	end if;
	
	if(jump_mem_var = '1') then
		next_pc := out_data_m;
	
	elsif(jump_ex1_var = '1') then --Change here
		--next_pc := alu_out_1_e;
		next_pc := out_jump_add_1_e;
	
	elsif(jump_ex2_var = '1') then
		--next_pc := alu_out_2_e;
		next_pc := out_jump_add_2_e;
		
	elsif(jump_r1_var = '1') then
		next_pc := out_jump_add_1_r;
		
	elsif(jump_r2_var = '1') then
		next_pc := out_jump_add_2_r;
		
	elsif(jump_r3_var = '1') then
		next_pc := out_jump_add_3_r;
		
	end if;
	
	
	if(clk'event and clk = '1') then
		
			 
          if(r = '1') then
            
				 in_enable_f <= '1';
				 in_prop_f <= '1';
				 next_pc := "0000000000000000";
				 in_pc_f <= next_pc;
				 RR_EX_1_interface(17 downto 16) <= "00";
				 IF_ID_1_interface(2) <= '0';
				 IF_ID_2_interface(2) <= '0';
				 ID_SS_interface(0) <= '0';
				 SS_RR_interface(64 downto 63) <= "00";
				 SS_RR_interface(59 downto 58) <= "00";
				 SS_RR_interface(54 downto 53) <= "00";
				 RR_EX_1_interface(19) <= '0';
				 RR_EX_1_interface(18) <= '0';
				 RR_EX_2_interface(19) <= '0';
				 RR_EX_2_interface(18) <= '0';
				 RR_MEM_interface(5) <= '0';
				 RR_MEM_interface(4) <= '0';
				 WR_interface(53) <= '0';
				 WR_interface(52) <= '0';
				 WR_interface(51) <= '0';
				 WR_interface(50) <= '0';
				 WR_interface(49) <= '0';
				 WR_interface(48) <= '0';
				 
--				 IF_ID_interface(2) <= '0';
--				 ID_RR_interface(6) <= '0';
--				 RR_EX_interface(3) <= '0';
--				 EX_MEM_interface(2) <= '0';
--				 MEM_WR_interface(1) <= '0';
--				 beq_happens := '0';
--				 jlr_happens := '0';
--				 jal_happens := '0';
--				 q_var <= "00";
--			    RR_EX_interface(1) <= '0';
--				 RR_EX_interface(0) <= '0';
			
			 else

				 in_enable_f <= '1';
				 in_prop_f <= '1';
				 in_pc_f <= next_pc;
				 
				 ra_in_m <= ra_in_m_var;
				 rb_in_m <= rb_in_m_var;
			 
				 in_start_bit_1_r <= in_start_bit_1_r_var;
				 in_jump_bit_1_r <= in_jump_bit_1_r_var;
				 in_start_bit_2_r <= in_start_bit_2_r_var;
				 in_jump_bit_2_r <= in_jump_bit_2_r_var;
				 in_start_bit_3_r <= in_start_bit_3_r_var;
				 in_jump_bit_3_r <= in_jump_bit_3_r_var;
			 
				 in_jump_bit_1_e <= in_jump_bit_1_e_var;
				 in_jump_bit_2_e <= in_jump_bit_2_e_var;
				 in_start_bit_1_e <= in_start_bit_1_e_var;
				 in_start_bit_2_e <= in_start_bit_2_e_var;
				 
				 in_jump_bit_m <= in_jump_bit_m_var;
				 in_start_bit_m <= in_start_bit_m_var;
				 
				 in_jump_bit_1_w <= in_jump_bit_1_w_var;
				 in_jump_bit_2_w <= in_jump_bit_2_w_var;
				 in_jump_bit_3_w <= in_jump_bit_3_w_var;
				 in_jump_add_1_w <= in_jump_add_1_w_var;
				 in_jump_add_2_w <= in_jump_add_2_w_var;
				 in_jump_add_3_w <= in_jump_add_3_w_var;
			 
			 
				 IF_ID_1_interface <= IF_ID_1;
				 IF_ID_2_interface <= IF_ID_2;
				 ID_SS_interface <= ID_SS;	 
				 SS_RR_interface(386 downto 323) <= SS_RR(386 downto 323);
				 SS_RR_interface(306 downto 243) <= SS_RR(306 downto 243);
				 SS_RR_interface(226 downto 163) <= SS_RR(226 downto 163);
				 SS_RR_interface(130 downto 128) <= SS_RR(130 downto 128);
				 SS_RR_interface(124 downto 122) <= SS_RR(124 downto 122);
				 SS_RR_interface(118 downto 116) <= SS_RR(118 downto 116);
				 SS_RR_interface(112 downto 65) <= SS_RR(112 downto 65);
				 SS_RR_interface(64 downto 63) <= SS_RR(64 downto 63);
				 SS_RR_interface(59 downto 58) <= SS_RR(59 downto 58);
				 SS_RR_interface(54 downto 53) <= SS_RR(54 downto 53);
				 SS_RR_interface(49) <= SS_RR(49);
				 SS_RR_interface(47 downto 0) <= SS_RR(47 downto 0);
				 
				 RR_EX_1_interface <= RR_EX_1;
				 RR_EX_2_interface(131 downto 18) <= RR_EX_2(131 downto 18);
				 RR_EX_2_interface(15 downto 0) <= RR_EX_2(15 downto 0);
				 RR_MEM_interface <= RR_MEM; 
				 WR_interface <= WR;
			 
			end if;
	end if;
	
	end process;


end Project1;