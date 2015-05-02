----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:13 05/02/2015 
-- Design Name: 
-- Module Name:    decod - Behavioral 
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

entity decod is
    Port ( Instruc : in  STD_LOGIC_VECTOR (31 downto 0);
           OUT_A : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_OP : out  STD_LOGIC_VECTOR (7 downto 0));
end decod;

architecture Behavioral of decod is

begin
	OUT_A <= Instruc(23 downto 16) ; -- transforme l'entrée 32 bit en 4 composantes de 8 bit <=> instructions to pipe_line
	OUT_B <= Instruc(15 downto 8) ;
	OUT_C <= Instruc(7 downto 0) ;
	OUT_OP <= Instruc(31 downto 24) ;
	--peut être inutile : on peut p-e le faire lors du mappage
end Behavioral;

