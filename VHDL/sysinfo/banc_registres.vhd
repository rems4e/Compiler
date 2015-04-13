----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:51:06 04/13/2015 
-- Design Name: 
-- Module Name:    banc_registres - Behavioral 
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

entity banc_registres is
    Port ( CK : in  STD_LOGIC;
           AA : in  STD_LOGIC_VECTOR (3 downto 0);
           AB : in  STD_LOGIC_VECTOR (3 downto 0);
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0);
           AW : in  STD_LOGIC_VECTOR (3 downto 0);
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           W : in  STD_LOGIC);
end banc_registres;

architecture Behavioral of banc_registres is
	
	type banc is array (15 to 0) of STD_LOGIC_VECTOR (7 downto 0) ;
begin

	QA <= banc(AA) when (AA=AW) and W='1' ; --Aléas de lecture/écriture
	QB <= banc(AB) when (AB=AW) and W='1' ;
	
	banc <= (others =>0) when RST= '0' ; --Reset
	
	QA <= banc(AA) ; --Propagation vers la sortie
	QB <= banc(BB) ;
	
	banc(AW) <= DATA when W='1' ; --Ecriture des données
	
	rising_edge(CK) ; --wait on(CK) ;
	
end Behavioral;

