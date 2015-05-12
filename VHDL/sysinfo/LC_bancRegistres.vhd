----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:00 05/12/2015 
-- Design Name: 
-- Module Name:    LC_bancRegistres - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LC_bancRegistres is
    Port ( IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_LC : out  STD_LOGIC);
end LC_bancRegistres;

architecture Behavioral of LC_bancRegistres is
--valeurs possibles en entrée
	--constant ADD : STD_LOGIC_VECTOR(7 downto 0) := "00000001" ;
	--constant MUL : STD_LOGIC_VECTOR(7 downto 0) := "00000010" ;
	--constant SUB : STD_LOGIC_VECTOR(7 downto 0) := "00000011" ;
	--constant DIV : STD_LOGIC_VECTOR(7 downto 0) := "00000100" ;
	--constant COP : STD_LOGIC_VECTOR(7 downto 0) := "00000101" ;
	constant AFC : STD_LOGIC_VECTOR(7 downto 0) := "00000110" ;
	--constant LOAD : STD_LOGIC_VECTOR(7 downto 0) := "00000111" ;
	constant STORE : STD_LOGIC_VECTOR(7 downto 0) := "00001000" ;
	
begin
	with IN_LC select
		OUT_LC <= '0' when LOAD, --On charge le controle a 0 pour les op d'écriture
					 '0' when STORE,
				'1' when others ;

end Behavioral;

