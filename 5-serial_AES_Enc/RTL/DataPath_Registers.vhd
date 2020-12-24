-----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de) and Amir Moradi (amir.moradi@rub.de) 
-- DOCUMENT: [New First-Order Secure AES Performance Records](IACR Transactions on Cryptographic Hardware and Embeded Systems 2021(2))
-- -----------------------------------------------------------------
--
-- Copyright (c) 2021, Aein Rezaei Shahmirzadi, Amir Moradi, 
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY DataPath_Registers is
	 generic ( ShareNumber                     : integer );
    PORT ( clk : in  STD_LOGIC;
			  StateIn : in  STD_LOGIC_VECTOR (7 downto 0);
           DoMC : in  STD_LOGIC;
           DoSR : in  STD_LOGIC;
           StateOut : out  STD_LOGIC_VECTOR (7 downto 0));
end DataPath_Registers;

architecture Behavioral of DataPath_Registers is

	SIGNAL S0, S1, S2, S3 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4, S5, S6, S7 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8, S9, S10, S11 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12, S13, S14, S15 								: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL S0_in, S1_in, S2_in, S3_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4_in, S5_in, S6_in, S7_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8_in, S9_in, S10_in, S11_in 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12_in, S13_in, S14_in, S15_in 				: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL in1, in2, in3, in4 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL MC0, MC1, MC2, MC3 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL out1, out2, out3, out4 						: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S0_xor_S1, S2_xor_S3 	 						: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL conditionalXOR1, conditionalXOR2, 
			 conditionalXOR3, conditionalXOR4 			: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL ShiftedData1, ShiftedData2,
			 ShiftedData3, ShiftedData4 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL mult2_in1, mult2_in2,
			 mult2_in3, mult2_in4 							: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL mult3_in1, mult3_in2,
			 mult3_in3, mult3_in4 							: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL latched_EN, gated_clk							: STD_LOGIC;
	SIGNAL MC_gated_clk, latched_MC_hold					: STD_LOGIC;
	
	signal reg_A_output1_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output2_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output3_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output4_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);

	
	signal Affine_out1_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out2_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out3_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out4_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	

begin

	StateOut <= MC0 when (DoMC = '1') else S0;

	state_movement: process (StateIn, S1, S2, S3, S4, S5, S6, S7, S8,
                           S9, S10, S11, S12, S13, S14, S15, DoSR, 
									DoMC, MC0, MC1, MC2, MC3, S0) is
	begin 
		S0_in <= S1;                
		S1_in <= S2;                
		S2_in <= S3; 
		S3_in <= S4;
				
		S4_in <= S5;                
		S5_in <= S6;                
		S6_in <= S7;                
		S7_in <= S8; 

		S8_in <= S9;                
		S9_in <= S10;                
		S10_in <= S11;                
		S11_in <= S12; 

		S12_in <= S13;                
		S13_in <= S14;                
		S14_in <= S15;                
		S15_in <= StateIn;

		if (DoSR = '1') then
			S1_in <= S6;                
			S2_in <= S11;                
			S3_in <= StateIn;
				
			S5_in <= S10;                
			S6_in <= S15;                
			S7_in <= S4;
			
			S9_in <= S14;                
			S10_in <= S3;                
			S11_in <= S8;
						 
			S13_in <= S2;                
			S14_in <= S7;                
			S15_in <= S12;               
		 elsif (DoMC = '1') then -- MixColumns movement
			S0_in <= MC1;                
			S1_in <= MC2;                
			S2_in <= MC3;                
		end if;
	end process state_movement;
    
	reg_gen: PROCESS(clk, S0_in, S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in, S9_in, S10_in, S11_in, S12_in, S13_in, S14_in, S15_in)
	BEGIN
		IF RISING_EDGE(clk) THEN
			S0 <= S0_in;
			S1 <= S1_in;
			S2 <= S2_in;
			S3 <= S3_in;
			S4 <= S4_in;
			S5 <= S5_in;
			S6 <= S6_in;
			S7 <= S7_in;
			S8 <= S8_in;
			S9 <= S9_in;
			S10 <= S10_in;
			S11 <= S11_in;
			S12 <= S12_in;
			S13 <= S13_in;
			S14 <= S14_in;
			S15 <= S15_in;
		END IF;
	END PROCESS;	
	
	------------------------------------- Mix Column -------------------------
		
	--- A
	S0_xor_S1 <= S0 xor S1;
	S2_xor_S3 <= S2 xor S3;
	
	out1 <= S0 xor S2_xor_S3;
	out2 <= S0_xor_S1 xor S3;
	out3 <= S0_xor_S1 xor S2;
	out4 <= S1 xor S2_xor_S3;
		
	in1 <= out1;
	in2 <= out2;
	in3 <= out3;
	in4 <= out4;
	
	conditionalXOR1 <= "000" & in1(7) & in1(7) & "0" & in1(7) & in1(7);
	ShiftedData1 	<= in1(6 downto 0) & "0";
	mult2_in1 <= ShiftedData1 xor conditionalXOR1;
	
	conditionalXOR2 <= "000" & in2(7) & in2(7) & "0" & in2(7) & in2(7);
	ShiftedData2 	<= in2(6 downto 0) & "0";
	mult2_in2 <= ShiftedData2 xor conditionalXOR2;
	
	conditionalXOR3 <= "000" & in3(7) & in3(7) & "0" & in3(7) & in3(7);
	ShiftedData3 	<= in3(6 downto 0) & "0";
	mult2_in3 <= ShiftedData3 xor conditionalXOR3;
	
	conditionalXOR4 <= "000" & in4(7) & in4(7) & "0" & in4(7) & in4(7);
	ShiftedData4 	<= in4(6 downto 0) & "0";
	mult2_in4 <= ShiftedData4 xor conditionalXOR4;

	mult3_in1 <= mult2_in1 xor in1;
	mult3_in2 <= mult2_in2 xor in2;
	mult3_in3 <= mult2_in3 xor in3;
	mult3_in4 <= mult2_in4 xor in4;
	
	MC0 <= mult2_in1 xor mult3_in4;
	MC1 <= mult2_in2 xor mult3_in1;
	MC2 <= mult2_in3 xor mult3_in2;
	MC3 <= mult2_in4 xor mult3_in3;
	
end Behavioral;

