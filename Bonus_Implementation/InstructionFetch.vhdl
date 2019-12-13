library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity InstructionFetch is
port( input_pc : in std_logic_vector(15 downto 0); clk, enable, prop : in std_logic;
	out_pc_prev1, out_pc_inc1, out_instruction_1, out_pc_prev2, out_pc_inc2, out_instruction_2 : out std_logic_vector(15 downto 0) );

end entity InstructionFetch;

architecture IR of InstructionFetch is


component Bit_adder_8 is
   port( input_vector1: in std_logic_vector(15 downto 0);
	      input_vector2 :in std_logic_vector(15 downto 0);
       	output_vector: out std_logic_vector(16 downto 0));
end component;

component Memory_asyncread_syncwrite is 
	port (address1,address2,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout_1,Mem_dataout_2: out std_logic_vector(15 downto 0));
end component;

signal out_pc_temp, out_pc_temp2: std_logic_vector(16 downto 0);

begin

B1 : Bit_adder_8
	port map(input_vector1 =>  input_pc , input_vector2 => "0000000000000001" , output_vector => out_pc_temp);

B2 : Bit_adder_8
	port map(input_vector1 =>  out_pc_temp(15 downto 0) , input_vector2 => "0000000000000001" , output_vector => out_pc_temp2);

out_pc_prev1 <= input_pc;
out_pc_inc1 <= out_pc_temp(15 downto 0);
out_pc_prev2 <= out_pc_temp(15 downto 0);
out_pc_inc2 <= out_pc_temp2(15 downto 0);


Mem1: Memory_asyncread_syncwrite
	  port map(address1 => input_pc, address2 => out_pc_temp(15 downto 0), Mem_datain => "0000000000000000", 
	  Mem_dataout_1 => out_instruction_1 , Mem_dataout_2 => out_instruction_2, clk => clk, Mem_wrbar => '1'); 


--out_pc <= out_pc_temp(15 downto 0);


end IR;
