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

		constant MIN : STD_LOGIC_VECTOR (3 downto 0) := (others => '0') ;
		constant MAX : STD_LOGIC_VECTOR (3 downto 0) := (others => '1') ;
		constant MOT_ZERO : STD_LOGIC_VECTOR (7 downto 0) := (others => '0') ;
		constant MOT_FFFF : STD_LOGIC_VECTOR (7 downto 0) := (others => '1') ;
		--le type banc d'addresse / correspondance Integer <=> std_logic_vector
		type BANC_ADD_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (3 downto 0);
		subtype BANC_ADD_TYPE is BANC_ADD_TYPE_1 (15 downto 0) ;
		--le type banc correspondance addresse Natural / mot 8 bits
		type BANC_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (7 downto 0) ;
		subtype BANC_TYPE is BANC_TYPE_1 (15 downto 0) ;
		
		constant banc_add : BANC_ADD_TYPE := (15 => MAX, 14 => "1110",13=>"1101",12=>"1100",11=>"1011",
															10=>"1010",9=>"1001",8=>"1000",7=>"0111",6=>"0110",
															5=>"0101",4=>"0100",3=>"0011",2=>"0010",1=>"0001",0 => MIN) ;
		signal banc : BANC_TYPE ;
begin
		label_banc_registres : process
		variable i : NATURAL ;
		variable j : NATURAL ;
		variable k : NATURAL ;
		begin
		
		--version for
		for ind in BANC_ADD_TYPE'RANGE loop
			if AA = banc_add(ind) then i:=ind ; end if ;
			if AB = banc_add(ind) then j:=ind ; end if ;
			if AW = banc_add(ind) then k:=ind ; end if ;
		end loop ;
		--version assert /!\ ?
			--assert AA=banc_add(i) ;
			--assert AB=banc_add(j) ;
			--assert AW=banc_add(k) ;
			if RST='0' then banc <=(others =>MOT_ZERO) ; end if ; -- reset
			-- banc <=(others =>MOT_ZERO) when RST='0'; --Reset
			
			if W='1' then							--Ecriture
				if AA=AW then QA <= banc(i) ; --gestiond des aléas
				elsif AB=AW then QB <= banc(j) ; 
				else banc(k) <= DATA ;			--ecriture de DATA
				end if ;
			end if ;
			-- QA <= banc(i) when (AA=AW) and W='1' ; --Aléas de lecture/écriture
			-- QB <= banc(j) when (AB=AW) and W='1' ;
			-- banc(k) <= DATA when W='1' ; --Ecriture des données

			QA <= banc(i) ; --Propagation vers la sortie
			QB <= banc(j) ;
			
			
			wait on AA,AB,W,RST,CK;
		end process ;
end Behavioral;

