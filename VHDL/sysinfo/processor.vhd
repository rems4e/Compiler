----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:56:44 05/12/2015 
-- Design Name: 
-- Module Name:    processor - Behavioral 
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

entity processor is
    Port ( CK : in  STD_LOGIC;
				RST : in std_logic);
end processor;

architecture Behavioral of processor is

	COMPONENT IP
	Port ( CK : in  STD_LOGIC;
				RST : in std_logic ;
           Add : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT ;
	COMPONENT Instruc_Mem
    PORT(
         CK : IN  std_logic;
         AA : IN  std_logic_vector(7 downto 0);
         INS : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT decod
	 Port ( Instruc : in  STD_LOGIC_VECTOR (31 downto 0);
           OUT_A : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_OP : out  STD_LOGIC_VECTOR (7 downto 0));
	  END COMPONENT ;
	COMPONENT pipe_line
    PORT(
         CK : IN  std_logic;
         IN_A : IN  std_logic_vector(7 downto 0);
         IN_B : IN  std_logic_vector(7 downto 0);
         IN_C : IN  std_logic_vector(7 downto 0);
         IN_OP : IN  std_logic_vector(7 downto 0);
         OUT_A : OUT  std_logic_vector(7 downto 0);
         OUT_B : OUT  std_logic_vector(7 downto 0);
         OUT_C : OUT  std_logic_vector(7 downto 0);
         OUT_OP : OUT  std_logic_vector(7 downto 0)
        );
		  END COMPONENT ;
	 
	 COMPONENT banc_registres
    PORT(
         CK : IN  std_logic;
         AA : IN  std_logic_vector(3 downto 0);
         AB : IN  std_logic_vector(3 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0);
         AW : IN  std_logic_vector(3 downto 0);
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         W : IN  std_logic
        );
	END COMPONENT;
	COMPONENT MUX_BancRegistres
	Port ( CK : in  STD_LOGIC;
	  IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
	  IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
	  sel : in  STD_LOGIC_VECTOR (7 downto 0);
	  S : out  STD_LOGIC_VECTOR (7 downto 0));
	  END COMPONENT ;
	  
	COMPONENT ALU
    PORT(
         op1 : IN  std_logic_vector(7 downto 0);
         op2 : IN  std_logic_vector(7 downto 0);
         ctr_ALU : IN  std_logic_vector(2 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         flag : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
	 COMPONENT MUX_ALU
	     Port ( CK : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
	  END COMPONENT ;
	  COMPONENT LC_ALU
	      Port ( IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_LC : out  STD_LOGIC_VECTOR (2 downto 0));
		END COMPONENT ;
		COMPONENT MUX_Pre_MemData
		    Port ( CK : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
		END COMPONENT ;
		
		COMPONENT LC
		    Port ( IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_LC : out STD_LOGIC );
		END COMPONENT ;
		
	COMPONENT Data_Mem
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic;
         RW : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         Add : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	 COMPONENT MUX_MemData
	     Port ( CK : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT ;
	
	constant CK_period : time := 10 ns;
	signal out_ip : std_logic_vector(7 downto 0) ;
	signal ins : std_logic_vector(31 downto 0) ;
	signal out_a_decod : std_logic_vector(7 downto 0) ;
	signal out_b_decod : std_logic_vector(7 downto 0) ;
	signal out_c_decod : std_logic_vector(7 downto 0) ;
	signal out_op_decod : std_logic_vector(7 downto 0) ;
	signal out_a_li : std_logic_vector(7 downto 0) ;
	signal out_b_li : std_logic_vector(7 downto 0) ;
	signal out_c_li : std_logic_vector(7 downto 0) ;
	signal out_op_li : std_logic_vector(7 downto 0) ;
	signal out_a_br : std_logic_vector(7 downto 0) ;
	signal out_b_br : std_logic_vector(7 downto 0) ;
	signal in_w_br : std_logic ;
	signal in_data_br : std_logic_vector(7 downto 0) ;
	signal in_aw_br : std_logic_vector(7 downto 0) ;
	signal out_mux_alu : std_logic_vector(7 downto 0) ;
	signal out_mux_br : std_logic_vector (7 downto 0) ;
	signal out_a_di : std_logic_vector (7 downto 0) ;
	signal out_b_di : std_logic_vector (7 downto 0) ;
	signal out_c_di : std_logic_vector (7 downto 0) ;
	signal out_op_di : std_logic_vector (7 downto 0) ;
	signal ctr_alu : std_logic_vector (2 downto 0) ;
	signal out_alu : std_logic_vector(7 downto 0) ;
	signal flag : std_logic_vector(3 downto 0) ;
	signal out_a_ex : std_logic_vector(7 downto 0);
	signal out_b_ex : std_logic_vector(7 downto 0);
	signal out_op_ex : std_logic_vector(7 downto 0);
	signal out_mux_pre_data : std_logic_vector (7 downto 0);
	signal out_lc_data : std_logic ;
	signal out_mem_data : std_logic_vector (7 downto 0) ;
	signal out_mux_data : std_logic_vector(7 downto 0) ;
	signal out_op_mem : std_logic_vector(7 downto 0) ;
	signal blank : std_logic_vector(7 downto 0) := (others => '0') ;
begin
	--instanciation
	ipTest : IP port map(
	CK=>CK ,
	RST=>RST,
	ADD=>out_IP) ;
	
	instruct : Instruc_Mem port map(
	CK=>CK ,
	AA=>out_ip,
	INS=>ins
	) ;
	
	decode : decod port map(
		Instruc => ins,
      OUT_A => out_a_decod,
		OUT_B => out_b_decod,
		OUT_C => out_c_decod,
		OUT_OP => out_op_decod
	) ;
	li_di : pipe_line port map(
		CK=>CK,
		IN_A=>out_a_decod,
		IN_B=>out_b_decod,
		IN_C=>out_c_decod,
		IN_OP=>out_op_decod,
		OUT_A=>out_a_li,
		OUT_B=>out_b_li,
		OUT_C=>out_c_li,
		OUT_OP=>out_op_li
		);
	banc_registre : banc_registres port map(
		CK => CK,
		RST=>rst,
		AA => out_b_li(3 downto 0),
		AB => out_c_li(3 downto 0),
		AW =>	in_aw_br(3 downto 0),
		W	=> in_w_br,
		DATA => in_data_br,
		QA => out_a_br,
		QB =>	out_b_br
	) ;
	
	mux_banc_registres : MUX_BancRegistres port map(
		CK => CK,
		IN_1 =>out_b_li,
		IN_2 =>out_a_br,
		sel =>out_op_li,
		S=> out_mux_br
	);
	
	di_ex : pipe_line port map(
		CK=>CK,
		IN_A=>out_a_li,
		IN_B=>out_mux_br,
		IN_C=>out_b_br,
		IN_OP=>out_op_li,
		OUT_A=>out_a_di,
		OUT_B=>out_b_di,
		OUT_C=>out_c_di,
		OUT_OP=>out_op_di
		);
		
		lctr_alu : LC_ALU port map(
			IN_LC =>out_op_di,
			OUT_LC => ctr_alu
		);
		alu_comp :ALU port map(
			op1=>out_b_di,
			op2=>out_c_di,
			ctr_alu => ctr_alu,
			S=> out_alu,
			flag=>flag
		);
		mux_alu_comp : MUX_ALU port map(
			CK=> CK,
			IN_1=>out_b_di,
			IN_2=>out_alu,
			sel => out_op_di,
			S => out_mux_alu
		) ;
		
		ex_Mem : pipe_line port map (
			CK=>CK,
			IN_A=>out_a_di,
			IN_B=>out_mux_alu,
			IN_C=>blank,
			IN_OP=>out_op_di,
			OUT_A=>out_a_ex,
			OUT_B=>out_b_ex,
			OUT_C=>blank,
			OUT_OP=>out_op_ex
		);
			
		mux_pre_data : MUX_Pre_MemData port map (
			CK => CK ,
			IN_1 => out_a_ex,
			IN_2 => out_b_ex,
			sel => out_op_ex,
			S => out_mux_pre_data
		);
		
		lc_data : LC port map (
			IN_LC => out_op_ex,
			OUT_LC => out_lc_data
		);
		
		mem_data : Data_Mem port map (
			 CK => CK,
			 RST => RST,
			 RW => out_lc_data,
			 DATA => out_b_ex,
			 Add => out_mux_pre_data,
			 Q => out_mem_data
		);
		
		mux_mem_data : MUX_MemData port map (
			CK => CK,
			IN_1=>out_mem_data,
			IN_2 =>out_b_ex,
			sel=> out_op_ex,
			S=> out_mux_data
		);
		
		mem_re : pipe_line port map(
			CK => CK,
			IN_A=>out_a_ex,
			IN_B=>out_mux_data,
			IN_C=>blank,
			IN_OP=>out_op_ex,
			OUT_A=>in_aw_br,
			OUT_B=>in_data_br,
			OUT_C=>blank,
			OUT_OP=>out_op_mem
		);
		
		lc_br : LC port map(
			IN_LC => out_op_mem,
			OUT_LC=> in_w_br
		);

end Behavioral;

