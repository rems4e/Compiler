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
	
	signal instruc_zero : std_logic_vector(31 downto 0) := (others => '0') ;
	type BANC_TYPE is array (255 downto 0) of STD_LOGIC_VECTOR (31 downto 0) ;
	signal banc_instruc : BANC_TYPE :=(	0=> "00000110000000010000100100000000", -- AFC R1 9 -
													1=> "00000110000000100000000100000000", -- AFC R2 1 -
													--2=> "00000001000000000000000100000010", -- ADD R0 R1 R2
													--3=> "00001000000000010000000000000000", -- STORE [@1] R0
													--4=> "00000111000000000000001000000000", -- LOAD R0 [@2]
													others => instruc_zero ) ;
	
	--debug : opération ADD R1 R9 R4
	--signal operation : std_logic_vector(31 downto 0) := "00000001" & "00000001" & "00001001" & "00000100" ;
begin
	lecture_sync : process (CK)

	begin
		--lecture synchrone
		--function TO_INTEGER (ARG: UNSIGNED) return NATURAL;
		if CK'Event and CK='1' then
			INS <= banc_instruc(TO_INTEGER (UNSIGNED(AA))) ;
		end if ;
	end process ;
end Behavioral;

