LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Transciever_tb IS
END Transciever_tb;

ARCHITECTURE behavioral OF Transciever_tb IS
-- Component declaration of the tested unit
COMPONENT Transciever
 PORT 
(
TR, OE, OddEven, clk : in std_logic;
parity : inout std_logic;
Error : out std_logic;
A : inout std_logic_vector(0 to 7) ;
B : inout std_logic_vector(0 to 7)
);
END COMPONENT;

signal clk_test : std_logic := '0';
signal TR_test : std_logic;
signal OE_test : std_logic;
signal OddEvenpar_test : std_logic;
signal par_test : std_logic := 'Z';
signal Error_test : std_logic;
signal A_test : std_logic_vector(0 to 7):=('Z','Z','Z','Z','Z','Z','Z','Z');
signal B_test : std_logic_vector(0 to 7):=('Z','Z','Z','Z','Z','Z','Z','Z');

BEGIN
--UUT1 :entity work.counter(singlepr)
UUT : Transciever
PORT MAP (
  clk =>clk_test,
  TR =>TR_test,
  OE =>OE_test,
  OddEven =>OddEvenpar_test,
  parity =>par_test,
  Error =>Error_test,
  A =>A_test,
  B =>B_test);

clk_test <= not clk_test after 1 ns;

Testing: PROCESS
BEGIN

  OE_test <= '1'; -- transciever is not working
  WAIT FOR 20 ns;

  B_test <= ('Z','Z','Z','Z','Z','Z','Z','Z');
  A_test <= ('0','0','0','0','0','0','0','0');
  par_test <= 'Z'; 
  for i in 8 downto 0 loop 
     if (i/= 8) then 
        A_test(i)<= '1';
        OE_test <= '0'; -- transciever is working
        TR_test <= '1'; -- data on A to B, transmit
        OddEvenpar_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '1'; -- data on A to B, transmit
        OddEvenpar_test <= '0';
        WAIT FOR 8 ns;
     else
        OE_test <= '0'; -- transciever is working
        TR_test <= '1'; -- data on A to B, transmit
        OddEvenpar_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '1'; -- data on A to B, transmit
        OddEvenpar_test <= '0';
        WAIT FOR 8 ns;
     end if;
  end loop;
  
  A_test <= ('Z','Z','Z','Z','Z','Z','Z','Z');
  B_test <= ('0','0','0','0','0','0','0','0');
  for i in 8 downto 0 loop
     if (i/= 8) then   
        B_test(i)<= '1';
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '1';
        par_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '1';
        par_test <= '0';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '0';
        par_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '0';
        par_test <= '0';
        WAIT FOR 8 ns;
     else
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '1';
        par_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '1';
        par_test <= '0';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '0';
        par_test <= '1';
        WAIT FOR 8 ns;
        OE_test <= '0'; -- transciever is working
        TR_test <= '0'; -- data on B to A, recieve mode
        OddEvenpar_test <= '0';
        par_test <= '0';
        WAIT FOR 8 ns;
     end if;
  end loop;
  
  B_test <= ('Z','Z','Z','Z','Z','Z','Z','Z'); --B was driven by the test bench in previos sequences (input port) but on the next steps the driving direction for B changes(B port of transciever will be an output port), so adjust B_test to recieve signal from B by setting it to 'Z'
  OE_test <= '1'; -- transciever is not working
  WAIT FOR 100 ns;
  
END PROCESS;
END behavioral;
