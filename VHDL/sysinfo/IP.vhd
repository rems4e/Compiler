----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:32 05/12/2015 
-- Design Name: 
-- Module Name:    IP - Behavioral 
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

entity IP is
    Port ( CK : in  STD_LOGIC;
				RST : in std_logic ;
           Add : out  STD_LOGIC_VECTOR (7 downto 0));
end IP;

architecture Behavioral of IP is
		signal temp : std_logic_vector (7 downto 0) := (others => '0') ;
begin
	process (CK)
	begin
		if CK'event and CK='1' then
			if RST = '1' then
			Add <= temp  ;
			temp <= std_logic_vector(to_unsigned(to_integer(unsigned( temp )) + 1, 8));
			end if ;
		end if ;
	end process ;
	
end Behavioral;

