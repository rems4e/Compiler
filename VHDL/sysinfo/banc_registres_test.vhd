--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:35:45 04/14/2015
-- Design Name:   
-- Module Name:   /home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/banc_registres_test.vhd
-- Project Name:  sysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: banc_registres
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
 
ENTITY banc_registres_test IS
END banc_registres_test;
 
ARCHITECTURE behavior OF banc_registres_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT banc_registres
    PORT(
         CK : IN  std_logic;
         AA : IN  std_logic_vector(3 downto 0);
         AB : IN  std_logic_vector(3 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0);
         AW : IN  std_logic_vector(3 downto 0);
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         W : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal AA : std_logic_vector(3 downto 0) := (others => '0');
   signal AB : std_logic_vector(3 downto 0) := (others => '0');
   signal AW : std_logic_vector(3 downto 0) := (others => '0');
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal W : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: banc_registres PORT MAP (
          CK => CK,
          AA => AA,
          AB => AB,
          QA => QA,
          QB => QB,
          AW => AW,
          DATA => DATA,
          RST => RST,
          W => W
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
		RST <= '1' ;
      wait for 100 ns;	
		DATA <= "11001100" ;
		AW <= "0001" ;
		W<='1';
      wait for CK_period*10;
		DATA <= "10101010" ;
		AW <= "0010" ;
		wait for CK_period*10;
      -- insert stimulus here 
		W<='0';
		AA <= "0001";
		AB <= "0010";
      wait;
   end process;

END;
