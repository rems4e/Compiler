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
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( CK : in  STD_LOGIC;
           op1 : in  STD_LOGIC_VECTOR (7 downto 0);
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
	
	signal make_flags : STD_LOGIC ;							--signaux internes
	signal buff : STD_LOGIC_VECTOR (8 downto 0);
	signal RES : STD_LOGIC_VECTOR (3 downto 0) ;
	
begin
	calcul_sync : process (CK)
		--fait le calcul dans un buffer de taille n+1
		--le n+1 iem bit défini s'il y a overflow / carry etc...
	begin
		if CK='1' then
			case ctr_ALU is
			when ADD => buff <= op1 + op2 ;
			when SUB => buff <= op1 - op2 ;
			when MUL => buff <= op1 * op2 ;
			--when DIV => buff <= op1 / op2 ; --opérateur mod non déclaré ???
			when others => buff<= MOT_ZERO ;
			end case;
			make_flags<='1'; --déclache l'op de flag
			S <= buff(7 downto 0) ;
		end if;
	end process ;
	
	flag_sync : process (make_flags)
	begin
		if make_flags='1' then
			--détermine les flags une fois l'opération effectuée
			--détection par make_flag
			RES <= no_flag ;
			if(TO_INTEGER(SIGNED(buff(7 downto 0))) < TO_INTEGER(SIGNED(MOT_ZERO(7 downto 0 )))) then -- pas sure du fonctionnement : le mot est négatif
				RES <= N ; -- /!\ ce sont des nombre signé, le premier bit a un sens !=
			end if ;
			if(buff=MOT_ZERO(7 downto 0 )) then -- pas sure du fonctionnement : le mot est nul
				RES <= RES + Z ;
			end if ;
			
			if(buff(8)='1') then --G : il y a débordement
				if(ctr_ALU = ADD or ctr_ALU = SUB) then --ce débordement est une retenue (nombre signés)
					flag <= RES + C ;
				else --sinon c'est un overflow
					flag <= RES + O; 
				end if ;
			end if ;
			
			make_flags <= '0';
		end if;
	end process ;

end Behavioral;

