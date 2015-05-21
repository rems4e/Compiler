----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:03:47 04/19/2015 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( op1 : in  STD_LOGIC_VECTOR (7 downto 0);
           op2 : in  STD_LOGIC_VECTOR (7 downto 0);
           ctr_ALU : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           flag : out  STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
	constant MOT_ZERO : STD_LOGIC_VECTOR (8 downto 0) := (others => '0') ;
	
	constant no_flag : STD_LOGIC_VECTOR(3 downto 0) := "0000" ; --Les flags
	constant N : STD_LOGIC_VECTOR(3 downto 0) := "1000" ;
	constant O : STD_LOGIC_VECTOR(3 downto 0) := "0100" ;
	constant Z : STD_LOGIC_VECTOR(3 downto 0) := "0010" ;
	constant C : STD_LOGIC_VECTOR(3 downto 0) := "0001" ;
	
	constant ADD : STD_LOGIC_VECTOR(2 downto 0) := "001" ; --ctr_ALU 2 bit aurait suffit Cf spec p.36
	constant SUB : STD_LOGIC_VECTOR(2 downto 0) := "010" ;
	constant MUL : STD_LOGIC_VECTOR(2 downto 0) := "011" ;
	constant DIV : STD_LOGIC_VECTOR(2 downto 0) := "100" ;
	
	signal buff : STD_LOGIC_VECTOR (8 downto 0);
	signal RES : STD_LOGIC_VECTOR (3 downto 0) ;
	signal modif : STD_LOGIC ;
	
begin
		
		with ctr_ALU select
		buff	<=  std_logic_vector(UNSIGNED("0" & op1) + UNSIGNED("0" & op2)) when ADD, --On charge le controle a une valeur != de ZERO pour les op de calcul CF ALU
				 	 std_logic_vector(UNSIGNED("0" & op1) - UNSIGNED("0" & op2)) when SUB,
					 std_logic_vector(TO_UNSIGNED(TO_INTEGER(UNSIGNED("0" & op1) * UNSIGNED("0" & op2)), 9)) when MUL,
				MOT_ZERO when others ;
		S <= buff(7 downto 0);
		modif <= '1' when modif = '0' else '0';
		
		
	flag_async : process (modif)
	begin

		if modif'Event and modif = '1' then
			--détermine les flags une fois l'opération effectuée
			--détection par écoute du signal buff
			RES <= no_flag ;
			if(buff(8) = '1') then -- pas sure du fonctionnement : le mot est négatif
				RES <= N;
			end if ;
			if(buff= MOT_ZERO) then -- pas sure du fonctionnement : le mot est nul
				RES <= Z ;
			end if ;
			if op1(7)=op2(7) and op1(7)/=buff(7) then --sinon overflow= si signé
				RES <= std_logic_vector(RES + O); 
			end if ;
			if(buff(8)='1') and (ctr_ALU = ADD or ctr_ALU = SUB) then --ce débordement est une retenue (nombre signés)
				RES <= std_logic_vector(RES + C) ;
			end if ;
			flag <= RES ;
		end if;
	end process ;

end Behavioral;

