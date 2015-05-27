----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:44 05/02/2015 
-- Design Name: 
-- Module Name:    pipe_line - Behavioral 
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

entity pipe_line is
    Port ( CK : in  STD_LOGIC;
           IN_A : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_B : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_C : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_OP : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_A : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_OP : out  STD_LOGIC_VECTOR (7 downto 0));
end pipe_line;

architecture Behavioral of pipe_line is
begin
	pipe_line : process(CK)
	begin
	--mémorise ses entrées le temps d'un clock ;
		if CK'event and CK='1' then
				OUT_A <= IN_A ;
				OUT_B <= IN_B ;
				OUT_C <= IN_C ;
				OUT_OP <= IN_OP ;
		end if ;
	end process ;
end Behavioral;

