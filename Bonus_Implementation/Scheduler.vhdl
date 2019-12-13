library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Scheduler is
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

end entity Scheduler;

architecture FML of Scheduler is

component Qu is
port(     
    in_data_1   :   in std_logic_vector(85 downto 0);
    in_data_2   :   in std_logic_vector(85 downto 0);
    enable_in_1 :   in std_logic;
    enable_in_2 :   in std_logic;

    pop_flag    :   in std_logic;
    pop_num     :   in std_logic_vector(1 downto 0);

    clk         :   in std_logic;
    rst         :   in std_logic;
    
    out_data_1  :   out std_logic_vector(85 downto 0);
    out_data_2  :   out std_logic_vector(85 downto 0);    
    out_data_3  :   out std_logic_vector(85 downto 0);
	 
	 pop_data_1  :   out std_logic_vector(85 downto 0);
    pop_data_2  :   out std_logic_vector(85 downto 0);    
    pop_data_3  :   out std_logic_vector(85 downto 0);
    
    overflow    :   out std_logic;
    underflow   :   out std_logic;
    underflow_bits  :   out std_logic_vector(2 downto 0) ;
	 Counter_out : out std_logic_vector(2 downto 0);

	 pop_num_out : out std_logic_vector(1 downto 0));
end component Qu;

component HazardDetectionUnit is
    port( 
        ir_1    :   in std_logic_vector(15 downto 0);       -- IR_1 is the first instruction
        ir_2    :   in std_logic_vector(15 downto 0);       -- IR_2 is the second, possibly dependent instruction
        ra_bit  :   out std_logic;                          -- RegA of instruction 2 dependent
        rb_bit  :   out std_logic;                           -- RegB of instruction 2 dependent
        fake_rb : in std_logic_vector(2 downto 0)
        );
    end component;
    
    signal q_var, pop_flag, underflow, rst1 : std_logic;
    signal pop_num, pop_num_out : std_logic_vector(1 downto 0);
    signal underflow_bits : std_logic_vector(2 downto 0);
    signal out_data_1, out_data_2, out_data_3,pop_data_1,pop_data_2,pop_data_3,hz1,hz2,hz3 : std_logic_vector(85 downto 0);

    signal hz12,hz12_ra,hz12_rb : std_logic;
    signal hz23,hz23_ra,hz23_rb : std_logic;
    signal hz13,hz13_ra,hz13_rb : std_logic;
	 signal mem_pop_1,mem_pop_2,mem_pop_3 : std_logic;
    signal jmp1,jmp2,jmp3,jmp4,jmp5,mem1,mem2,mem3,mem4,mem5,bit_mem_1,bit_mem_2,bit_mem_3,bit_mem_4,bit_mem_5,bit_mem_6 : std_logic;
    signal ex1,ex2,ex3 : std_logic;
	 signal valid_mask_temp,Counter : std_logic_vector(2 downto 0);
    

begin

	rst1 <= rst when enable='1' else '1';

    --- Queue
    Q: Qu Port Map(in_data_1, in_data_2, in_data_1(2),in_data_2(2), pop_flag, pop_num, clk, rst1, 
                        out_data_1, out_data_2, out_data_3, pop_data_1,pop_data_2,pop_data_3, overflow, underflow, underflow_bits,Counter, pop_num_out);

    HD_instance1 : HazardDetectionUnit
	port map( 
    hz1(69 downto 54), hz2(69 downto 54), hz12_ra, hz12_rb, hz2(21 downto 19));

    HD_instance2 : HazardDetectionUnit
	port map( 
        hz1(69 downto 54), hz3(69 downto 54), hz13_ra, hz13_rb, hz3(21 downto 19));

    HD_instance3 : HazardDetectionUnit
	port map( 
        hz2(69 downto 54), hz3(69 downto 54), hz23_ra, hz23_rb, hz3(21 downto 19));

	 --Here the assumption is that they denote which instructions are jump. Will modify logic later.
    jmp1 <= out_data_1(0);
    jmp2 <= out_data_2(0);
    jmp3 <= out_data_3(0);
	 jmp4 <= in_data_1(0);
	 jmp5 <= in_data_2(0);
	 
	 --Here the assumption is that they denote which instructions have to go to memory branch. Will modify logic later.
    mem1 <= not out_data_1(69) and out_data_1(68);
    mem2 <= not out_data_2(69) and out_data_2(68);
    mem3 <= not out_data_3(69) and out_data_3(68);
	 mem4 <= not in_data_1(69) and in_data_1(68);
	 mem5 <= not in_data_2(69) and in_data_2(68);
	 
	 --Here the assumption is that these two variables denote whether in_data_1 and in_data_2 actually get executed or not
    ex1 <=  '1' when in_data_1(2)='1' else '0';
    ex2 <=  '1' when in_data_2(2)='1' else '0';
    --ex3 <=  '1' when q_var='1' and (out_data_3(69 downto 68)="00" or  out_data_3(69)='1') else '0';

    hz12 <= hz12_ra or hz12_rb;
    hz13 <= hz13_ra or hz13_rb;
    hz23 <= hz23_ra or hz23_rb;
	 
	 --Writing logic for hazard detection unit inputs
	 hz1 <= in_data_1 when (to_integer(unsigned(Counter))=0) else out_data_1;
	 hz2 <= in_data_2 when (to_integer(unsigned(Counter))=0) else in_data_1 when (to_integer(unsigned(Counter))=1) else out_data_2;
	 hz3 <= out_data_3 when (to_integer(unsigned(Counter))>=3) else in_data_1 when (to_integer(unsigned(Counter))=2) else in_data_2;
	 
	 --Writing logic for number of pops and pop flag being set
	 
	 pop_flag <= '0' when (to_integer(unsigned(Counter))=0 and ex1='0' and ex2='0') else '1';
	 
	 --These bits are used to give 0 if the number of mem instructions in the set are greater than 1 or equal to 0
	 bit_mem_1 <= (not mem2 and not mem3 and mem1) or ((not mem1) and (mem2 xor mem3)); --out_data_1,2,3
	 bit_mem_2 <= (not mem2 and not mem4 and mem1) or ((not mem1) and (mem2 xor mem4)); --out_data_1,2, in_data_1
	 bit_mem_3 <= (not mem4 and not mem5 and mem1) or ((not mem1) and (mem4 xor mem5)); --out_data_1, in_data_1,2
	 
	 --These bits are used to give 0 if the number of mem instructions in the set are greater than 1
	 bit_mem_4 <= not (mem1 and mem2); --out_data_1,2
	 bit_mem_5 <= not (mem1 and mem4); --out_data_1, in_data_1
	 bit_mem_6 <= not (mem5 and mem4); --in_data_1,2
	 
	 
	 --Setting the number of pops
	 pop_num <= "11" when (((to_integer(unsigned(Counter))>=3) and (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp3='0' and bit_mem_1='1'))
									or ((to_integer(unsigned(Counter))=2) and (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp4='0' and bit_mem_2='1' and (ex1='1' or ex2='1')))
									or ((to_integer(unsigned(Counter))=1) and (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp4='0' and bit_mem_3='1' and ex1='1' and ex2='1')))
									
				else "10" when (((to_integer(unsigned(Counter))>=3) and (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp3='0' and bit_mem_4='1'))
									or ((to_integer(unsigned(Counter))=2) and (hz12='0' and jmp1='0' and jmp2='0' and bit_mem_4='1'))
									or ((to_integer(unsigned(Counter))=1) and (hz12='0' and jmp1='0' and jmp2='0' and bit_mem_5='1' and (ex1='1' or ex2='1')))
									or ((to_integer(unsigned(Counter))=0) and (hz12='0' and jmp4='0' and jmp5='0' and bit_mem_6='1' and ex1='1' and ex2='1')))									
				
				else "01" when (((to_integer(unsigned(Counter))>=3))
									or ((to_integer(unsigned(Counter))=2) )
									or ((to_integer(unsigned(Counter))=1) )
									or ((to_integer(unsigned(Counter))=0) and (ex1='1' or ex2='1')))									
				
				else "00";
	 
	 --First of all we need to determine hz1, hz2 and hz3 and pop_num and pop_flag
--	 if (to_integer(unsigned(Counter))>=3) then
--		
--		hz1 <= out_data_1;
--		hz2 <= out_data_2;
--		hz3 <= out_data_3;
--		if (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp3='0') then 
--			pop_num <= "011";
--			pop_flag <= '1';
--		elsif (hz13='1' and hz12='0' and jmp1='0' and jmp2='0') then
--			pop_num <= "010";
--			pop_flag <= '1';
--		else
--			pop_num <= "001";
--			pop_flag <= '1';
--		end if;
--	 
--	 elsif (to_integer(unsigned(Counter))=2) then
--		
--		hz1 <= out_data_1;
--		hz2 <= out_data_2;
--		hz3 <= in_data_1;
--		
--		if (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp2='0' and jmp4='0') then 
--			pop_num <= "011";
--			pop_flag <= '1';
--		elsif (hz13='1' and hz12='0' and jmp1='0' and jmp2='0') then
--			pop_num <= "010";
--			pop_flag <= '1';
--		else
--			pop_num <= "001";
--			pop_flag <= '1';
--		end if;
--	 
--	 elsif (to_integer(unsigned(Counter))=1) then
--	 
--		hz1 <= out_data_1;
--		hz2 <= in_data_1;
--		hz3 <= in_data_2;
--		
--		if (hz12='0' and hz13='0' and hz23='0' and jmp1='0' and jmp4='0' and jmp5='0' and in_data_1(69 downto 68)="00" and in_data_2(69 downto 68)="00") then 
--			pop_num <= "011";
--			pop_flag <= '1';
--		elsif (hz13='1' and hz12='0' and jmp1='0' and jmp4='0') then
--			pop_num <= "010";
--			pop_flag <= '1';
--		else
--			pop_num <= "001";
--			pop_flag <= '1';
--		end if;
--		
--	elsif (to_integer(unsigned(Counter))=0) then
--	 
--		hz1 <= in_data_1;
--		hz2 <= in_data_2;
--		hz3 <= in_data_2;
--		
--	
--		if (hz12='0' and jmp4='0' and jmp5='0') then
--			pop_num <= "010";
--			pop_flag <= '1';
--		else
--			pop_num <= "001";
--			pop_flag <= '1';
--		end if;
--
--    end if;
    
    --Write logic for this later
	 
	 --Here the assumption is again that jump and mem bits are available
	 mem_pop_1 <= not pop_data_1(69) and pop_data_1(68);
	 mem_pop_2 <= not pop_data_2(69) and pop_data_2(68);
	 mem_pop_3 <= not pop_data_3(69) and pop_data_3(68);
	 
	 --Check this very carefully
	 out_inst_1 <= pop_data_1 when (mem_pop_1='1') else pop_data_2 when (mem_pop_2='1') else pop_data_3 when (mem_pop_3='1') else (others=>'0');
	 out_inst_2 <= pop_data_1 when (mem_pop_1='0') else pop_data_2 when (mem_pop_2='0') else pop_data_3 when (mem_pop_3='0') else (others => '0');
	 out_inst_3 <= pop_data_2 when (mem_pop_2='0' and mem_pop_1='0') else pop_data_3;


end FML;