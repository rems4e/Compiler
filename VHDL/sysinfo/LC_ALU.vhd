----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:26 05/02/2015 
-- Design Name: 
-- Module Name:    LC - Behavioral 
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

entity LC_ALU is
    Port ( IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_LC : out  STD_LOGIC_VECTOR (2 downto 0));
end LC_ALU;

architecture Behavioral of LC_ALU is
	constant ADD : STD_LOGIC_VECTOR(7 downto 0) := "00000001" ;
	constant MUL : STD_LOGIC_VECTOR(7 downto 0) := "00000010" ;
	constant SUB : STD_LOGIC_VECTOR(7 downto 0) := "00000011" ;
	constant DIV : STD_LOGIC_VECTOR(7 downto 0) := "00000100" ;

	
	constant ADD_ctr : STD_LOGIC_VECTOR(2 downto 0) := "001" ; --ctr_ALU 2 bit aurait suffit Cf spec p.36
	constant SUB_ctr : STD_LOGIC_VECTOR(2 downto 0) := "010" ;
	constant MUL_ctr : STD_LOGIC_VECTOR(2 downto 0) := "011" ;
	constant DIV_ctr : STD_LOGIC_VECTOR(2 downto 0) := "100" ;
	constant DEFAULT : STD_LOGIC_VECTOR(2 downto 0) := "000" ;
	
	
begin
	with IN_LC select
		OUT_LC <= ADD_ctr when ADD, --On charge le controle a une valeur != de ZERO pour les op de calcul CF ALU
					SUB_ctr when SUB,
					MUL_ctr when MUL,
					DIV_ctr when DIV,
				DEFAULT when others ;

end Behavioral;