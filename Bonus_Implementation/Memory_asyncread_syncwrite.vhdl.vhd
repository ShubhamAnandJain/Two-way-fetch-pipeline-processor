library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Memory_asyncread_syncwrite is 
	port (address1,address2,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout_1,Mem_dataout_2: out std_logic_vector(15 downto 0));
end entity;

architecture Form of Memory_asyncread_syncwrite is 
type regarray is array(65535 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
    0 => "0011001000000001",   --LHI R1 000000001 
	 1 => "0100101001000111", --LW R5 R1 000111
	 2 => "0010110111100000",   --NDU R6 R7 R4 
	 3 => "0010100100100000",   --NDU R4 R4 R4
	 4 => "0000100111101001",   --ADZ R4 R7 R5
    5 => "0000000001010000",   --ADD R0 R1 R2
    6 => "1100011100110101",   --BEQ R3 R4 110101  
    7 => "0011111001010000",   --LHI R7 001010000 
    8 => "0100101011000111", --LW R5 R3 000111
    9 => "0101100001000101", --SW R4 R1 000101
    10 => "0110000001010001", --LM R0 0 01010001
    11 => "0100101001000111", --LW R5 R1 000111
    12 => "1100111101010101",   --BEQ R7 R5 010101 
    13 => "1000011011010101",   --JAL R3 011010101
    14 => "1001101010000000",   --JALR R5 R2 R2
    15 => "0000000001010000",   --ADD R0 R1 R2  
    16 => "0000001001010010",   --ADC R1 R1 R2
    17 => "0000110111101001",   --ADZ R6 R7 R5 
    18 => "0001100011011000",   --ADI R4 R3 011000 
    19 => "0010100001010000",   --NDU R4 R1 R2 
    20 => "0010010010011010",   --NDC R2 R2 R3
    21 => "0010001011010001",   --NDZ R1 R3 R2
    22 => "0011111001010000",   --LHI R7 001010000 
    23 => "0011111000010010",   --LHI R7 000010010
    24 => "0101110011000111",   --SW R6 R3 000101
    25 => "0110000011010001",   --LM R0 0 11010001 
    26 => "0111001000110001",   --SM R1 0 00110001 
    27 => "1100111101010101",   --BEQ R7 R5 010101 
    28 => "1000011011010101",   --JAL R3 011010101
    29 => "1001101010000000",   --JALR R5 R2 R2
    others => x"0000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
Mem_dataout_1 <= Memory(conv_integer(address1));
Mem_dataout_2 <= Memory(conv_integer(address2));
Mem_write:
process (Mem_wrbar,Mem_datain,address1,clk)
	begin
	if(Mem_wrbar = '0') then
		if(rising_edge(clk)) then
			Memory(conv_integer(address1)) <= Mem_datain;
		end if;
	end if;
	end process;
end Form;
