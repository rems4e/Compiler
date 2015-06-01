----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:36:50 05/21/2015 
-- Design Name: 
-- Module Name:    gest_aleas - Behavioral 
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

entity gest_aleas is
    Port ( CK : in  STD_LOGIC;
			  RST : in std_logic ;
           A : in  STD_LOGIC_VECTOR (7 downto 0);
			  OP : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           C : in  STD_LOGIC_VECTOR (7 downto 0);
			  out_OP,out_a,out_b,out_c: out std_logic_vector(7 downto 0);
           clock : out  STD_LOGIC);
end gest_aleas;

architecture Behavioral of gest_aleas is
	constant NOP : std_logic_vector(7 downto 0) := (others => '0') ;
	constant COP : STD_LOGIC_VECTOR(7 downto 0) := "00000101" ;
	constant AFC : STD_LOGIC_VECTOR(7 downto 0) := "00000110" ;
	constant LOAD : std_logic_vector(7 downto 0):= "00000111" ;
	
	type BANC_TYPE is array (15 downto 0) of STD_LOGIC_VECTOR (1 downto 0) ;
	signal banc : BANC_TYPE ;
	signal Inhib : std_logic ;
begin
	
	remplissage : process(CK)
		variable indice : integer := 0 ;
	begin
		if rising_edge(CK) then
			if RST='0' then
				banc <= (others => "00") ;
			elsif (OP = COP or  OP = AFC or OP = LOAD) and RST = '1' then
				banc(to_integer(unsigned(A))) <= "11" ;
				for indice in banc'RANGE loop
					if banc(indice) /= "00" and indice /= to_integer(unsigned(A)) then
						banc(indice) <= std_logic_vector(to_unsigned(to_integer(unsigned(banc(indice))) - 1, 2)) ;
					end if ;
				end loop ;				
			else
				for indice in banc'RANGE loop
					if banc(indice) /= "00" then
						banc(indice) <= std_logic_vector(to_unsigned(to_integer(unsigned(banc(indice))) - 1, 2)) ;
					end if ;
				end loop ;
			end if ;
		end if ;
	end process ;
	
	lecture : process(CK)
	begin
		if rising_edge(CK) then
			if RST='1' and Inhib='0' and(banc(to_integer(unsigned(B(3 downto 0)))) /= "00" or banc(to_integer(unsigned(C(3 downto 0)))) /= "00") then
				out_OP <= OP ;
				out_a <=A;
				out_b <=B;
				out_c <=C;
				Inhib <='1' ;
			elsif RST='1' and (banc(to_integer(unsigned(B(3 downto 0)))) = "00" and banc(to_integer(unsigned(C(3 downto 0)))) = "00") then
				Inhib <='0' ;
				out_OP <= OP ;
				out_a <=A;
				out_b <=B;
				out_c <=C;
			else 
				Inhib <='1' ;
				out_OP <= NOP ;
				out_a <=NOP;
				out_b <=NOP;
				out_c <=NOP;
			end if ;	
		end if ;
	end process ;
	
	
	clock <= CK when Inhib = '0' else '0' when Inhib='1';
	
	
end Behavioral;

