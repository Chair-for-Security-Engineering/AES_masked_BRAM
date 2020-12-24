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


ENTITY Key_Registers is
    GENERIC ( ShareNumber                     : integer );
    PORT ( clk 		: in  STD_LOGIC;
           KeyIn 		: in  STD_LOGIC_VECTOR (7 downto 0);
           DoSbox 	: in  STD_LOGIC;
           K0_out 	: out  STD_LOGIC_VECTOR (7 downto 0);
           KeyOut 	: out  STD_LOGIC_VECTOR (7 downto 0);
           KeyToSbox : out  STD_LOGIC_VECTOR (7 downto 0);
           KeyForSchedule : out  STD_LOGIC_VECTOR (7 downto 0));
END Key_Registers;

ARCHITECTURE Behavioral OF Key_Registers IS
	SIGNAL S0, S1, S2, S3 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4, S5, S6, S7 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8, S9, S10, S11 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12, S13, S14, S15 								: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL S0_in, S1_in, S2_in, S3_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4_in, S5_in, S6_in, S7_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8_in, S9_in, S10_in, S11_in 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12_in, S13_in, S14_in, S15_in 				: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL Affined_inv_key					 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Affined_key					 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL SelectedKey					 					: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL latched_EN_first_column,
			 gated_clk_first_column,
			 latched_EN_other_column,
			 gated_clk_other_column			 				: STD_LOGIC;
	
BEGIN
	
	SelectedKey <=  KeyIn;

	key_state_movement: process (SelectedKey, S1, S2, S3, S4, S5, S6, S7, S8,
									S9, S10, S11, S12, S13, S14, S15, DoSbox,  S0) is
	begin 
		K0_out				<= S0;
		KeyOut 				<= S1;
		KeyToSbox 			<= S13;
		KeyForSchedule 	<= S12;
		 
		S0_in <= S1;   
		S1_in <= S2;                
		S2_in <= S3; 
		 
		S4_in <= S5;                
		S5_in <= S6;                
		S6_in <= S7; 
			
		S8_in <= S9;                
		S9_in <= S10;                
		S10_in <= S11;  

		S12_in <= S13;                
		S13_in <= S14;                
		S14_in <= S15; 
			 
		if (DoSbox = '1') then
			S3_in <= S0;
			S7_in <= S4;  
			S11_in <= S8;      
			S15_in <= S12;   
		else  -- Normal register movement  
			S3_in <= S4;
			S7_in <= S8;                
			S11_in <= S12; 
			S15_in <= SelectedKey;
		end if;
	end process key_state_movement;
	
	reg_gen1: PROCESS(clk, S0_in, S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in, S9_in, S10_in, S11_in, S12_in, S13_in, S14_in, S15_in)
	BEGIN
		IF RISING_EDGE(clk) THEN
			S0 <= S0_in;
			S1 <= S1_in;
			S2 <= S2_in;
			S3 <= S3_in;
		END IF;
	END PROCESS;
	
	reg_gen2: PROCESS(clk, S0_in, S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in, S9_in, S10_in, S11_in, S12_in, S13_in, S14_in, S15_in)
	BEGIN
		IF RISING_EDGE(clk) THEN
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
	
end Behavioral;

