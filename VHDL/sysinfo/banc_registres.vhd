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

		constant MOT_ZERO : STD_LOGIC_VECTOR (7 downto 0) := (others => '0') ;

		type BANC_TYPE_1 is array (NATURAL range <>) of STD_LOGIC_VECTOR (7 downto 0) ;
		subtype BANC_TYPE is BANC_TYPE_1 (15 downto 0) ;
		
		signal banc : BANC_TYPE ;
begin

		--la lecture est asynchrone
		QA <= banc(TO_INTEGER (UNSIGNED(AA))) when W='0'; --Propagation vers la sortie
		QB <= banc(TO_INTEGER (UNSIGNED(AB))) when W='0' ;
		
		ecriture_sync : process

		begin
			--Ecriture Synchrone
			if W='1' then
				if AA = AW then QA <= DATA ; 
				else QA <= banc(TO_INTEGER (UNSIGNED(AA))); end if ;

				if AB = AW then QB<= DATA ; 
				else QB <= banc(TO_INTEGER (UNSIGNED(AB))); end if ;
					
				banc(TO_INTEGER (UNSIGNED(AW))) <= DATA ;
			end if ;
		wait on CK;
		end process ;
		
		reset_sync : process
		
		begin
			--Reset synchrone
			if (RST='0') then
				banc <=(others =>MOT_ZERO) ;
			end if ;

		wait on CK ;
		end process ;
		
end Behavioral;

