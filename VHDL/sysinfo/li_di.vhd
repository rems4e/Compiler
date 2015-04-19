----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:47:59 04/19/2015 
-- Design Name: 
-- Module Name:    li_di - Behavioral 
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

entity li_di is
    Port ( CK : in  STD_LOGIC;
           Instruc : in  STD_LOGIC_VECTOR (31 downto 0);
           Cible : out  STD_LOGIC_VECTOR (7 downto 0);
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
           operande1 : out  STD_LOGIC_VECTOR (7 downto 0);
           operande2 : out  STD_LOGIC_VECTOR (7 downto 0));
end li_di;

architecture Behavioral of li_di is

begin
--décomposition de l'instruction
	Cible <= Instruc(23 downto 16) ;
	OP <= Instruc(31 downto 24 ) ;
	operande1 <= Instruc(15 downto 8) ;
	operande2 <= Instruc(7 downto 0 ) ;

end Behavioral;

