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
use IEEE.NUMERIC_STD.ALL;

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
		--type BANC_ADD_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (3 downto 0);
		--subtype BANC_ADD_TYPE is BANC_ADD_TYPE_1 (15 downto 0) ;
		--le type banc correspondance addresse Natural / mot 8 bits
		type BANC_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (7 downto 0) ;
		subtype BANC_TYPE is BANC_TYPE_1 (15 downto 0) ;
		
		--constant banc_add : BANC_ADD_TYPE := (15 => MAX, 14 => "1110",13=>"1101",12=>"1100",11=>"1011",
		--													10=>"1010",9=>"1001",8=>"1000",7=>"0111",6=>"0110",
		--													5=>"0101",4=>"0100",3=>"0011",2=>"0010",1=>"0001",0 => MIN) ;
		signal banc : BANC_TYPE ;
begin

		banc <=(others =>MOT_ZERO) when RST='0' ;
		QA <= banc(TO_INTEGER (UNSIGNED(AA))) when W='0'; --Propagation vers la sortie
		QB <= banc(TO_INTEGER (UNSIGNED(AB))) when W='0' ;
		
		label_banc_registres : process

		begin
			--Ecriture
			if W='1' then
				if AA = AW then QA <= DATA ; 
				else QA <= banc(TO_INTEGER (UNSIGNED(AA))); end if ;
				  --when AA=AW else banc(TO_INTEGER (UNSIGNED(AA)));
				if AB = AW then QB<= DATA ; 
				else QB <= banc(TO_INTEGER (UNSIGNED(AB))); end if ;
				--QB <= DATA when AB=AW else banc(TO_INTEGER (UNSIGNED(AB)));	
				banc(TO_INTEGER (UNSIGNED(AW))) <= DATA ;
			end if ;
			wait on CK; --AA,AB,W,RST,
		end process ;
end Behavioral;

