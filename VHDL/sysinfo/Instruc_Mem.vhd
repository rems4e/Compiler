----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:30 04/14/2015 
-- Design Name: 
-- Module Name:    Instruc_Mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruc_Mem is
    Port ( CK : in  STD_LOGIC;
           AA : in  STD_LOGIC_VECTOR (7 downto 0);
           INS : out  STD_LOGIC_VECTOR (31 downto 0));
end Instruc_Mem;

architecture Behavioral of Instruc_Mem is
	
	type BANC_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (31 downto 0) ;
	subtype BANC_TYPE is BANC_TYPE_1 (1023 downto 0) ;
		
	signal banc_instruc : BANC_TYPE  ;
begin
	mem_instruc : process
		variable AA_intern : NATURAL;
	begin
		AA_intern := TO_INTEGER (UNSIGNED(AA)) ; --function TO_INTEGER (ARG: UNSIGNED) return NATURAL;
		INS <= banc_instruc(AA_intern) ;
	wait on CK ;
	end process ;
end Behavioral;

