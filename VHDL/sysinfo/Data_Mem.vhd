----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:17 05/02/2015 
-- Design Name: 
-- Module Name:    Data_Mem - Behavioral 
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

entity Data_Mem is
    Port ( CK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           RW : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           Add : in  STD_LOGIC_VECTOR (7 downto 0);
           Q : out  STD_LOGIC_VECTOR (7 downto 0));
end Data_Mem;

architecture Behavioral of Data_Mem is

	constant MOT_ZERO : STD_LOGIC_VECTOR (7 downto 0) := (others => '0') ;
	type BANC_TYPE is array (255 downto 0) of STD_LOGIC_VECTOR (7 downto 0) ;
	signal banc : BANC_TYPE  ;
	
begin

	process (CK)
	begin
		if CK'Event and CK='1' then
			if(RW='1') and RST='1' then
				Q <= banc(TO_INTEGER (UNSIGNED(Add))) ;
			elsif RW='0' and RST='1' then
				banc(TO_INTEGER (UNSIGNED(Add))) <= DATA ;
			else 
				banc<=(others => MOT_ZERO) ;
			end if ;
		end if ;
	end process ;
	
end Behavioral;

