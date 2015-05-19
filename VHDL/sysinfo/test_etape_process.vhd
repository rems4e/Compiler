--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:52:34 05/19/2015
-- Design Name:   
-- Module Name:   /home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/test_etape_process.vhd
-- Project Name:  sysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: etape_process
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
 
ENTITY test_etape_process IS
END test_etape_process;
 
ARCHITECTURE behavior OF test_etape_process IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT etape_process
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: etape_process PORT MAP (
          CK => CK,
          RST => RST
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
      -- hold reset state for 100 ns.
		RST <= '0' ;
      wait for 100 ns;	
		RST <= '1' ;
      wait for CK_period*50;
      -- insert stimulus here 
      wait;
   end process;

END;
