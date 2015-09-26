LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Transciever IS
PORT 
(
TR, OE, OddEven, clk : in std_logic;
parity : inout std_logic ;
Error : out std_logic;
A : inout std_logic_vector(0 to 7) ;
B : inout std_logic_vector(0 to 7)
);
END Transciever;


ARCHITECTURE TRarch OF Transciever IS

signal TR_save : std_logic;

BEGIN
  
  transcieve: PROCESS(clk,TR)
    
    variable tmp : std_logic ;
    --var tr_check : std_logic;
    --variable var : std_logic_vector(0 to 7);
    --SIGNAL a : STD_LOGIC_VECTOR(2 DOWNTO 0):='00';
    BEGIN
    --IF rising_edge(TR) THEN
        --A <= (7 downto 0 => 'Z');
    --end if;
    --IF falling_edge(TR) THEN
        --B <= (7 downto 0 => 'Z');
        --parity <= 'Z';
     --end if;
     
     if(TR/=TR_save) then
        A <= (7 downto 0 => 'Z');
        B <= (7 downto 0 => 'Z');
        parity <= 'Z';
     end if;
     
     IF clk'event and clk = '1' THEN
       if(OE='0' and TR='1')then
            TR_save<= TR;
	          A <= (7 downto 0 => 'Z');
	           --B <= (7 downto 0 => 'Z');
	          B <= A;
            Error <='Z';
            tmp := '0';
            --loop gives out 0 if even, 1 if odd
            for i in 7 downto 0 loop  
              tmp := tmp xor A(i);
            end loop;
            if(tmp= '0') then
              if(OddEven = '1')then 
                parity <= '1';
              else 
                parity <= '0';  
              end if; 
            else
             if(OddEven = '1')then 
                parity <= '0';
              else 
                parity <= '1';  
              end if;          
            end if;
            --what about case when tmp = 1 ??? when TR = 1
       --elsif(TR='0')then
       elsif(OE='0' and TR='0')then
            TR_save<= TR;
	          B <= (7 downto 0 => 'Z');
	          A <= B;
	          parity <= 'Z'; 	
            tmp := '0';
            --loop gives out 0 if even, 1 if odd
            for i in 7 downto 0 loop  
              tmp := tmp xor B(i);
            end loop;
            if(tmp= '0') then
              if(OddEven = '1')then
                if(parity = '1')then
                  Error <= '1';
                else --if par = 0
                  Error <= '0';
                end if;
              else
                if(parity = '1')then
                  Error <= '0';
                else --if par = 0
                  Error <= '1'; 
                end if;
              end if;
            else -- if tmp = 1 --odd number of inputs 1, in recieving mode
              if(OddEven = '1') then
                if(parity = '1')then
                  Error <= '0';
                else --if par = 0
                  Error <= '1';
                end if;
              else
                if(parity = '1')then
                  Error <= '1';
                else --if par = 0
                  Error <= '0'; 
                end if;
              end if;
            end if;
	      elsif(OE='1')then
          parity <='Z';
          Error <= 'Z';
	        B <= (7 downto 0 => 'Z');
          A <= (7 downto 0 => 'Z');
       end if;
     --elsif((TR = '1' or TR = '0') and not clk'event) then
     end if;     
  END PROCESS transcieve;
                                  
END TRarch ;