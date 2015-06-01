----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:09:57 05/12/2015 
-- Design Name: 
-- Module Name:    MUX_ALU - Behavioral 
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

entity MUX_ALU is
    Port ( CK : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  IN_3 : in std_logic_vector (3 downto 0) ;
           sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end MUX_ALU;

architecture Behavioral of MUX_ALU is

--valeur possibles en entrée
	constant Zero : std_logic_vector(7 downto 0) := "00000000";
	constant ADD : STD_LOGIC_VECTOR(7 downto 0) := "00000001" ;
	constant MUL : STD_LOGIC_VECTOR(7 downto 0) := "00000010" ;
	constant SUB : STD_LOGIC_VECTOR(7 downto 0) := "00000011" ;
	constant DIV : STD_LOGIC_VECTOR(7 downto 0) := "00000100" ;
	constant EQU : std_logic_vector(7 downto 0) := "00001001" ;
	constant INF : std_logic_vector(7 downto 0) := "00001010" ;
	constant SUP : std_logic_vector(7 downto 0) := "00001011" ;
	--constant COP : STD_LOGIC_VECTOR(7 downto 0) := "00000101" ;
	--constant AFC : STD_LOGIC_VECTOR(7 downto 0) := "00000110" ;
	--constant LOAD : STD_LOGIC_VECTOR(7 downto 0) := "00000111" ;
	--constant STORE : STD_LOGIC_VECTOR(7 downto 0) := "00001000" ;
	signal out_equ : std_logic_vector(7 downto 0);
	signal out_inf : std_logic_vector(7 downto 0);
	signal out_sup : std_logic_vector(7 downto 0);
	
	
begin

	with IN_3(1) select
	out_equ <= Zero when '1',
			 ADD when others ;
			
	with IN_3(3) select
	out_inf <= "00000000" when '0',
			 "00000001" when others ;
			
	with IN_3(3) select
	out_sup <= "00000000" when '1',
			 "00000001" when others;
			
	with sel select
	S <= 	IN_2 when ADD, 
			IN_2 when MUL,
			IN_2 when SUB,
			IN_2 when DIV,
			out_equ when EQU,
			out_inf when INF,
			out_sup when SUP,
			IN_1 when others;

end Behavioral;
