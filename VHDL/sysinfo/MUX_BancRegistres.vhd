----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:30:41 05/12/2015 
-- Design Name: 
-- Module Name:    MUX_BancRegistres - Behavioral 
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

entity MUX_BancRegistres is
    Port ( IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end MUX_BancRegistres;

architecture Behavioral of MUX_BancRegistres is
--valeur possibles en entrée
	--constant ADD : STD_LOGIC_VECTOR(7 downto 0) := "00000001" ;
	--constant MUL : STD_LOGIC_VECTOR(7 downto 0) := "00000010" ;
	--constant SUB : STD_LOGIC_VECTOR(7 downto 0) := "00000011" ;
	--constant DIV : STD_LOGIC_VECTOR(7 downto 0) := "00000100" ;
	constant COP : STD_LOGIC_VECTOR(7 downto 0) := "00000101" ;
	constant AFC : STD_LOGIC_VECTOR(7 downto 0) := "00000110" ;
	constant LOAD : STD_LOGIC_VECTOR(7 downto 0) := "00000111" ;
	constant NOP : STD_LOGIC_VECTOR(7 downto 0) := "00000000" ;
	--constant STORE : STD_LOGIC_VECTOR(7 downto 0) := "00001000" ;
	--constant EQU : std_logic_vector(7 downto 0) :="00001001";
	
	
begin
	with sel select
	S <= 	IN_1 when AFC, 
			IN_1 when LOAD,
			IN_1 when NOP,
			IN_2 when others;

end Behavioral;


