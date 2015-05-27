----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:12 05/19/2015 
-- Design Name: 
-- Module Name:    etape_process - Behavioral 
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

entity etape_process is
    Port ( clock,RST : in  STD_LOGIC;
			  flag : out std_logic_vector(3 downto 0));
end etape_process;

architecture Behavioral of etape_process is
	COMPONENT IP
	Port ( CK,RST : in std_logic ;
           Add : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT ;
	
	COMPONENT Instruc_Mem
    PORT(CK : IN  std_logic;
         AA : IN  std_logic_vector(7 downto 0);
         INS : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT decod
	 Port ( Instruc : in  STD_LOGIC_VECTOR (31 downto 0);
           OUT_A ,OUT_B,OUT_C,OUT_OP : out  STD_LOGIC_VECTOR (7 downto 0));
	  END COMPONENT ;
	  
	COMPONENT pipe_line
    PORT(
         CK : IN  std_logic;
         IN_A,IN_B,IN_C,IN_OP : IN  std_logic_vector(7 downto 0);
         OUT_A ,OUT_B,OUT_C,OUT_OP : OUT  std_logic_vector(7 downto 0)
        );
		  END COMPONENT ;
	 
	 COMPONENT banc_registres
    PORT(
         CK,RST,W : IN  std_logic;
         AA,AB,AW : IN  std_logic_vector(3 downto 0);
         QA,QB : OUT  std_logic_vector(7 downto 0);
         DATA : IN  std_logic_vector(7 downto 0)
        );
	END COMPONENT;
	
	COMPONENT LC
	 Port ( 
			IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
			OUT_LC : out STD_LOGIC );
	END COMPONENT ;
	
	COMPONENT MUX_BancRegistres
	Port ( 
	  IN_1,IN_2,sel : in  STD_LOGIC_VECTOR (7 downto 0);
	  S : out  STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT ;
  
	COMPONENT ALU
    PORT(
         op1,op2 : IN  std_logic_vector(7 downto 0);
         ctr_ALU : IN  std_logic_vector(2 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         flag : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT MUX_ALU
	     Port ( CK : in  STD_LOGIC;
           IN_1,IN_2,sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
	  END COMPONENT ;
	  
	  COMPONENT LC_ALU
	      Port ( IN_LC : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_LC : out  STD_LOGIC_VECTOR (2 downto 0));
		END COMPONENT ;
		
	COMPONENT Data_Mem
    PORT(
         CK,RST,RW : IN  std_logic;
         DATA,Add : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

	 COMPONENT MUX_MemData
	     Port ( CK : in  STD_LOGIC;
           IN_1,IN_2,sel : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT ;
	
	COMPONENT MUX_Pre_MemData
		 Port ( CK : in  STD_LOGIC;
		  IN_1,IN_2,sel : in  STD_LOGIC_VECTOR (7 downto 0);
		  S : out  STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT ;

	COMPONENT gest_aleas
		    Port ( CK : in  STD_LOGIC;
			  RST : in std_logic ;
           A,OP,B,C : in  STD_LOGIC_VECTOR (7 downto 0);
			  out_OP,out_a,out_b,out_c: out std_logic_vector(7 downto 0);
           clock : out  STD_LOGIC);
	END COMPONENT ;
	
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
	signal in_aw_br : std_logic_vector(7 downto 0);
	signal in_w_br : std_logic ;
	signal in_data_br : std_logic_vector(7 downto 0) ;
	signal out_a_br : std_logic_vector(7 downto 0) ;
	signal out_b_br : std_logic_vector(7 downto 0) ;


	signal out_a_di : std_logic_vector (7 downto 0) ;
	signal out_b_di : std_logic_vector (7 downto 0) ;
	signal out_c_di : std_logic_vector (7 downto 0) ;
	signal out_op_di : std_logic_vector (7 downto 0) ;
	signal out_a_ex : std_logic_vector(7 downto 0);
	signal out_b_ex : std_logic_vector(7 downto 0);
	signal out_op_ex : std_logic_vector(7 downto 0);
	signal out_op_mem : std_logic_vector(7 downto 0) ;
	signal out_mux_br : std_logic_vector(7 downto 0) ;
	signal ctr_alu : std_logic_vector (2 downto 0) ;
	signal out_alu : std_logic_vector(7 downto 0) ;
	--signal flag : std_logic_vector(3 downto 0) ;
	signal out_mux_alu : std_logic_vector(7 downto 0) ;
	signal out_lc_data : std_logic ;
	signal out_mem_data : std_logic_vector (7 downto 0) ;
	signal out_mux_data : std_logic_vector(7 downto 0) ;
	signal out_mux_pre_data : std_logic_vector(7 downto 0) ;
	
	signal out_a_gest_aleas : std_logic_vector( 7 downto 0);
	signal out_b_gest_aleas : std_logic_vector( 7 downto 0);
	signal out_c_gest_aleas : std_logic_vector( 7 downto 0);
	signal out_gest_aleas_op : std_logic_vector(7 downto 0) ;
	signal CK : std_logic ;

begin
	--instanciation
	ipTest : IP port map(CK,RST,out_ip) ;
	
	instruct : Instruc_Mem port map(CK,out_ip,ins) ; ----TODO banc_instruct unco /!\ Normal -- Mais a changer
	
	decode : decod port map(ins,out_a_decod,out_b_decod,out_c_decod,out_op_decod) ;
	----TODO ins unco
	
	li_di : pipe_line port map(CK,out_a_decod,out_b_decod,out_c_decod,out_op_decod,
		out_a_li,out_b_li,out_c_li,out_op_li); ----TODO out_c_li unco
		
	banc_registre : banc_registres port map(
		CK => clock,
		RST=>	RST,
		AA => out_b_gest_aleas(3 downto 0),
		AB => out_c_gest_aleas(3 downto 0), ----TODO out_c_li unco
		AW =>	in_aw_br(3 downto 0),
		W	=> in_w_br,
		DATA => in_data_br,
		QA =>	out_a_br,
		QB =>	out_b_br
	) ;
	
	di_ex : pipe_line port map(clock,out_a_gest_aleas,out_mux_br,out_b_br,out_gest_aleas_op,
		out_a_di,out_b_di,out_c_di,out_op_di);
		
	ex_Mem : pipe_line port map (
		CK=>clock,
		IN_A=>out_a_di,
		IN_B=>out_mux_alu,
		IN_C=>"00000000",
		IN_OP=>out_op_di,
		OUT_A=>out_a_ex,
		OUT_B=>out_b_ex,
		OUT_C=>open,----TODO out_c unco
		OUT_OP=>out_op_ex
	);
			
	mem_re : pipe_line port map(
		CK => clock,
		IN_A=>out_a_ex, ----TODO out_a unco
		IN_B=>out_mux_data,
		IN_C=>"00000000",
		IN_OP=>out_op_ex,
		OUT_A=>in_aw_br,
		OUT_B=>in_data_br,
		OUT_C => open,
		OUT_OP=>out_op_mem
	);
	
	lc_br : LC port map(
		IN_LC => out_op_mem,
		OUT_LC=> in_w_br
	);
	
	mux_banc_registres : MUX_BancRegistres port map(out_b_gest_aleas,out_a_br,out_gest_aleas_op,
		out_mux_br);
	
	lctr_alu : LC_ALU port map(out_op_di,ctr_alu);
		
	mux_alu_comp : MUX_ALU port map(
			CK=> clock,
			IN_1=>out_b_di,
			IN_2=>out_alu,
			sel => out_op_di,
			S => out_mux_alu
		) ;
	alu_comp :ALU port map(
		op1=>out_b_di,
		op2=>out_c_di,
		ctr_alu => ctr_alu,
		S=> out_alu,
		flag=>flag
	);
	
	
	lc_data : LC port map (
		IN_LC => out_op_ex,
		OUT_LC => out_lc_data
	);
	
	mem_data : Data_Mem port map (
		 CK => clock,
		 RST => RST,
		 RW => out_lc_data,
		 DATA => out_b_ex,
		 Add => out_mux_pre_data,
		 Q => out_mem_data
	);
	
	mux_mem_data : MUX_MemData port map (
		CK => clock,
		IN_1=>out_mem_data,
		IN_2 =>out_b_ex,
		sel=> out_op_ex,
		S=> out_mux_data
	);
	
	mux_pre_data : MUX_Pre_MemData port map (
		CK => clock,
		IN_1 => out_a_ex,
		IN_2 => out_b_ex,
		sel => out_op_ex,
		S => out_mux_pre_data
	);

	gestion_aleas : gest_aleas port map (
		clock,RST,out_a_li,out_op_li,out_b_li,out_c_li,
		out_gest_aleas_op,out_a_gest_aleas,out_b_gest_aleas,out_c_gest_aleas,CK
	) ;
end Behavioral;

