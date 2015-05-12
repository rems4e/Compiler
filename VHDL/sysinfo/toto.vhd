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

entity toto is
    Port ( CK : in  STD_LOGIC;
           AA : in  STD_LOGIC_VECTOR (3 downto 0);
           AB : in  STD_LOGIC_VECTOR (3 downto 0);
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0);
           AW : in  STD_LOGIC_VECTOR (3 downto 0);
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           W : in  STD_LOGIC);
end toto;

architecture Behavioral of toto is

		constant MOT_ZERO : STD_LOGIC_VECTOR (7 downto 0) := (others => '0') ;

		type BANC_TYPE is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0) ;
		
		signal banc : BANC_TYPE :=(others => MOT_ZERO);
begin

		--lecture_async : process
				QA <= DATA when ((W='1') and RST='1' and AA=AW ) else banc(TO_INTEGER (UNSIGNED(AA))); --Propagation vers la sortie
				QB <= DATA when ((W='1') and RST='1' and AB=AW ) else banc(TO_INTEGER (UNSIGNED(AB)));
		
		
		ecriture_sync : process
		begin
		wait on CK'event;
			--Ecriture Synchrone
			if W='1' and CK='1' and RST='1' then
				banc(TO_INTEGER (UNSIGNED(AW))) <= DATA ;
			end if ;
		end process ;
		
		reset_sync : process
		begin
			wait on CK'event;
			--Reset synchrone
			if (RST='0') and CK='1' then
				banc <=(others =>MOT_ZERO) ;
			end if ;
		end process ;
		
end Behavioral;

