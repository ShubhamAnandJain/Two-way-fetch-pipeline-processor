library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Qu is
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
    underflow_bits  :   out std_logic_vector(2 downto 0);
	 Counter_out : out std_logic_vector(2 downto 0);
	 
	 pop_num_out : out std_logic_vector(1 downto 0)
    );

end entity Qu;

architecture UglyCode of Qu is


    type RegisterSet is  array(0 to 7) of std_logic_vector(85 downto 0);
    signal RegisterNo : RegisterSet:=(others => (others=>'0')) ;
    signal TempNo : RegisterSet:=(others => (others=>'0')) ;
    --type RegisterSet is  array(0 to 7) of std_logic_vector(15 downto 0);
    
    
    signal Counter  : std_logic_vector(2 downto 0):=("000");
    signal empty    : std_logic:=('1');

    signal q_var : std_logic;
    
    begin
	 
	 Counter_out <= Counter;
	 out_data_1 <= RegisterNo(0);
    out_data_2 <= RegisterNo(1);
    out_data_3 <= RegisterNo(2);
	 
	 
	 
        process(clk,rst)
        
        variable nq_var : std_logic;
        variable nUf    : std_logic;
        variable nUf_bits   : std_logic_vector(2 downto 0);
        --variable nR     : std_logic_vector(7 downto 0);
        variable nOverflow  : std_logic;
        variable nCounter   : std_logic_vector(2 downto 0);
        variable nout_data_1   : std_logic_vector(85 downto 0);
        variable nout_data_2   : std_logic_vector(85 downto 0);
        variable nout_data_3   : std_logic_vector(85 downto 0);
        variable nR     : RegisterSet;
        
        begin
            nUf := '0';
            nUf_bits := "000";
            nOverflow := '0';
            nout_data_1 := (others=>'0');
            nout_data_2 := (others=>'0');
            nout_data_3 := (others=>'0');
				nR := RegisterNo;
				
            

            if(clk'event and clk='0' and rst = '0') then
					 
					
					pop_num_out <= pop_num;
					 --PUSHING First
					 
					 if(enable_in_1 = '1' and enable_in_2='1') then
                        nR(to_integer(unsigned(Counter))) := in_data_1;
                        nR(to_integer(unsigned(Counter))+1) := in_data_2;
                        nCounter := std_logic_vector(to_unsigned(to_integer(unsigned(Counter)) + 2,3));
                        if(Counter(2 downto 0)="100" or Counter(2 downto 0)="101") then
									nOverflow := '1';
								else 
									nOverflow := '0';
								end if;
								

                    elsif(enable_in_1 = '1' and enable_in_2='0') then
                        nR(to_integer(unsigned(Counter))) := in_data_1;
                        nCounter := std_logic_vector(to_unsigned(to_integer(unsigned(Counter)) + 1,3));
                        if(Counter(2 downto 0)="101" or Counter(2 downto 0)="110" ) then
									nOverflow := '1';
								else 
									nOverflow := '0';
								end if;
								
						 elsif(enable_in_1 = '0' and enable_in_2='1') then
                        nR(to_integer(unsigned(Counter))) := in_data_2;
                        nCounter := std_logic_vector(to_unsigned(to_integer(unsigned(Counter)) + 1,3));
                        if(Counter(2 downto 0)="101" or Counter(2 downto 0)="110" ) then
									nOverflow := '1';
								else 
									nOverflow := '0';
								end if;
								
                   
                    elsif(enable_in_1 = '0' and enable_in_2='0') then
                        
                        nCounter := Counter;
                        
                    
                    end if;   
					 
					 --POPPING NEXT
					 --First we transfer nR to RegisterNo to avoid problems
					 TempNo <= nR;
					 
					 
					 
					 if (pop_flag='1') then
								Counter <= std_logic_vector(to_unsigned(to_integer(unsigned(nCounter)) - to_integer(unsigned(pop_num)),3));
                        
                        --nCounter := Counter - pop_num;
                        if pop_num = "01" then
                            
									 pop_data_1 <= nR(0);
									 pop_data_2 <= (others=>'0');
									 pop_data_3 <= (others=>'0');
									 RegisterNo(0) <= nR(1);
									 RegisterNo(1) <= nR(2);
									 RegisterNo(2) <= nR(3);
									 RegisterNo(3) <= nR(4);
									 RegisterNo(4) <= nR(5);
									 RegisterNo(5) <= nR(6);
									 RegisterNo(6) <= nR(7);
									 RegisterNo(7) <= (others=>'0');
									 
                        elsif pop_num="10" then
--                            
										pop_data_1 <= nR(0);
										pop_data_2 <= nR(1);
										pop_data_3 <= (others=>'0');
										RegisterNo(0) <= nR(2);
										RegisterNo(1) <= nR(3);
										RegisterNo(2) <= nR(4);
										RegisterNo(3) <= nR(5);
										RegisterNo(4) <= nR(6);
										RegisterNo(5) <= nR(7);
										RegisterNo(6) <= (others=>'0');
										RegisterNo(7) <= (others=>'0');

                        elsif pop_num="11" then
--                            
										pop_data_1 <= nR(0);
										pop_data_2 <= nR(1);
										pop_data_3 <= nR(2);
										RegisterNo(0) <= nR(3);
										RegisterNo(1) <= nR(4);
										RegisterNo(2) <= nR(5);
										RegisterNo(3) <= nR(6);
										RegisterNo(4) <= nR(7);
										RegisterNo(5) <= (others=>'0');
										RegisterNo(6) <= (others=>'0');
										RegisterNo(7) <= (others=>'0');
									

                        end if;
								
						else
						
						pop_data_1 <= nR(0);
						pop_data_2 <= (others=>'0');
						pop_data_3 <= (others=>'0');						
						RegisterNo <= nR;
						Counter <= nCounter;
						
                    end if;
						  
					 --Transferring variables to signals
                
                --q_var <= nq_var;
                
                --RegisterNo <= nR;
                underflow <= nUf;
                underflow_bits <= nUf_bits;
                --out_data_1 <= nout_data_1;
                --out_data_2 <= nout_data_2;
                --out_data_3 <= nout_data_3;
					 


            elsif(clk'event and clk='0' and rst = '1') then
					 pop_num_out <= pop_num;
                q_var <= '0';
                Counter <= "000";
					 nR := RegisterNo;
                RegisterNo(0) <= (others=>'0');
                RegisterNo(1) <= (others=>'0');
                RegisterNo(2) <= (others=>'0');
                RegisterNo(3) <= (others=>'0');
                RegisterNo(4) <= (others=>'0');
                RegisterNo(5) <= (others=>'0');
                RegisterNo(6) <= (others=>'0');
                RegisterNo(7) <= (others=>'0');           
                underflow <= '0';
                underflow_bits <= "000";
                pop_data_1 <= (others=>'0');
                pop_data_2 <= (others=>'0');
                pop_data_3 <= (others=>'0');
            end if;
            
        end process;

end UglyCode;