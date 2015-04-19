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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

begin
	alu_process : process
		constant MOT_ZERO : STD_LOGIC_VECTOR (7 downto 0) := (others => '0') ;
		variable RES : STD_LOGIC_VECTOR (7 downto 0) ;
	begin
		case ctr_ALU is
		when "001" => S <= op1 + op2 ;
		when "010" => S <= op1 * op2 ;
		when "011" => S <= op1 - op2 ;
		--when "100" => S <= op1 / op2 ; -- operateur non reconnu 
		when others => S<= MOT_ZERO ;
		end case;
		S <= RES ;
	wait on CK ;
	end process ;

end Behavioral;

