--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:25:59 05/02/2015
-- Design Name:   
-- Module Name:   /home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/mem_data_test.vhd
-- Project Name:  sysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Data_Mem
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
 
ENTITY mem_data_test IS
END mem_data_test;
 
ARCHITECTURE behavior OF mem_data_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Mem
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic;
         RW : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         Add : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
   signal RW : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal Add : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Data_Mem PORT MAP (
          CK => CK,
          RST => RST,
          RW => RW,
          DATA => DATA,
          Add => Add,
          Q => Q
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
      wait for 100 ns;	

      wait for CK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
