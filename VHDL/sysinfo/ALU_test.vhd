--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:20:23 05/02/2015
-- Design Name:   
-- Module Name:   /home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/ALU_test.vhd
-- Project Name:  sysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_test IS
END ALU_test;
 
ARCHITECTURE behavior OF ALU_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         CK : IN  std_logic;
         op1 : IN  std_logic_vector(7 downto 0);
         op2 : IN  std_logic_vector(7 downto 0);
         ctr_ALU : IN  std_logic_vector(2 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         flag : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal op1 : std_logic_vector(7 downto 0) := (others => '0');
   signal op2 : std_logic_vector(7 downto 0) := (others => '0');
   signal ctr_ALU : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   signal flag : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
	
 	constant ADD : STD_LOGIC_VECTOR(2 downto 0) := "001" ; --ctr_ALU 2 bit aurait suffit Cf spec p.36
	constant SUB : STD_LOGIC_VECTOR(2 downto 0) := "010" ;
	constant MUL : STD_LOGIC_VECTOR(2 downto 0) := "011" ;
	constant DIV : STD_LOGIC_VECTOR(2 downto 0) := "100" ;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          CK => CK,
          op1 => op1,
          op2 => op2,
          ctr_ALU => ctr_ALU,
          S => S,
          flag => flag
        );

   -- Clock process definitions
   CK_process :process
   begin
		CK <= '0';
		wait for CK_period/2;
		CK <= '1';
		wait for CK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		--op1 <= "00000000";
      -- hold reset state for 100 ns.
			wait for 100 ns;	
			--op1 <= "00000000";
			op2 <= "00000001";
			ctr_ALU <= ADD;
     wait for 100 ns;	
			op1 <= op2;


      wait for CK_period*10;

      -- insert stimulus here 

      
   end process;

END;
