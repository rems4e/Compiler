--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:33:10 05/02/2015
-- Design Name:   
-- Module Name:   /home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/pipe_line_test.vhd
-- Project Name:  sysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pipe_line
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
 
ENTITY pipe_line_test IS
END pipe_line_test;
 
ARCHITECTURE behavior OF pipe_line_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pipe_line
    PORT(
         CK : IN  std_logic;
         IN_A : IN  std_logic_vector(7 downto 0);
         IN_B : IN  std_logic_vector(7 downto 0);
         IN_C : IN  std_logic_vector(7 downto 0);
         IN_OP : IN  std_logic_vector(7 downto 0);
         OUT_A : OUT  std_logic_vector(7 downto 0);
         OUT_B : OUT  std_logic_vector(7 downto 0);
         OUT_C : OUT  std_logic_vector(7 downto 0);
         OUT_OP : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal IN_A : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_B : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_C : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_OP : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal OUT_A : std_logic_vector(7 downto 0);
   signal OUT_B : std_logic_vector(7 downto 0);
   signal OUT_C : std_logic_vector(7 downto 0);
   signal OUT_OP : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipe_line PORT MAP (
          CK => CK,
          IN_A => IN_A,
          IN_B => IN_B,
          IN_C => IN_C,
          IN_OP => IN_OP,
          OUT_A => OUT_A,
          OUT_B => OUT_B,
          OUT_C => OUT_C,
          OUT_OP => OUT_OP
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
