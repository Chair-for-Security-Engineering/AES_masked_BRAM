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

entity Round is
    Port ( clk 					: in  STD_LOGIC;
           rst 					: in  STD_LOGIC;
           InputMuxSel			: in  STD_LOGIC;
           KeyMuxSel				: in  STD_LOGIC;
			  FinalRound			: in  STD_LOGIC;
			  KeyRegEn				: in  STD_LOGIC;
			  StateEN				: in  STD_LOGIC;
			  DoSR					: in  STD_LOGIC;
			  SboxInputSelcetor	: in  STD_LOGIC;
			  LoadKeySchedule		: in  STD_LOGIC;
			  ShowRcon				: in  STD_LOGIC;
			  Rcon					: in  STD_LOGIC_VECTOR ( 7 downto 0);
			InputData 				: in  STD_LOGIC_VECTOR (63 downto 0);
           InputKey 				: in  STD_LOGIC_VECTOR (63 downto 0);
			  SboxInput				: out STD_LOGIC_VECTOR (63 downto 0);
			  SBoxOutput			: in  STD_LOGIC_VECTOR (63 downto 0));
end Round;

architecture Behavioral of Round is
		
	---------------------------------
	---- Encryption Process ---------

	signal AddRoundKeyOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal MuxOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftRowOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal Reg_ShiftRowOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal InputDataStateRegOutput		: STD_LOGIC_VECTOR(63 downto 0);
	signal MixColumnMUXOutput				: STD_LOGIC_VECTOR(63 downto 0);
	
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	Signal s0_in, s1_in, s2_in, s3_in     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal s4_in, s5_in, s6_in, s7_in     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal s8_in, s9_in, s10_in, s11_in   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal s12_in, s13_in, s14_in, s15_in : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	Signal K0, K1, K2, K3     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K4, K5, K6, K7     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K8, K9, K10, K11   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K12, K13, K14, K15 : STD_LOGIC_VECTOR (7 DOWNTO 0);

	Signal K0_in, K1_in, K2_in, K3_in     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K4_in, K5_in, K6_in, K7_in     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K8_in, K9_in, K10_in, K11_in   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	Signal K12_in, K13_in, K14_in, K15_in : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal in0,  in1,  in2,  in3	: STD_LOGIC_VECTOR(7 downto 0);
	signal in4,  in5,  in6,  in7	: STD_LOGIC_VECTOR(7 downto 0);
	signal in8,  in9,  in10, in11 : STD_LOGIC_VECTOR(7 downto 0);
	signal in12, in13, in14, in15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult2in0 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in1 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in2 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in3 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in4 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in5 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in6 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in7 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in8 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in9 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in10	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in11	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in12	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in13	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2in15	: STD_LOGIC_VECTOR(7 downto 0);

	signal Mult3in0 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in1 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in2 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in3 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in4 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in5 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in6 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in7 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in8 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in9 	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in10	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in11	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in12	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in13	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult3in15	: STD_LOGIC_VECTOR(7 downto 0);
	
	--------------------------------- 
	---- Key Schedule ---------------


	signal KeyScheduleRcon					: STD_LOGIC_VECTOR(7 downto 0);
	signal KeySboxInput_internal			: STD_LOGIC_VECTOR(31 downto 0);
	signal Skey_or_w							: STD_LOGIC_VECTOR(31 downto 0);
	signal KeyMUXOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftedSBKey						: STD_LOGIC_VECTOR( 31 downto 0);
	signal w0, w1, w2, w3					: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeyExpansionOutput				: STD_LOGIC_VECTOR(31 downto 0);
	signal KeyStateRegOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal Reg_MixColumnMUXOutput			: STD_LOGIC_VECTOR(63 downto 0);
		
begin
	
	---------------------------------
	---- Encryption Process ---------

	MuxOutput 						<= InputData when InputMuxSel = '1' else Reg_MixColumnMUXOutput;	
	AddRoundKeyOutput				<= MuxOutput XOR KeyMUXOutput;
	SboxInput(31 downto 0)		<= AddRoundKeyOutput(31 downto 0) when SboxInputSelcetor = '0' else KeySboxInput_internal;
	SboxInput(63 downto 32) 	<= AddRoundKeyOutput(63 downto 32);
	---------------------------------
	state_movement: process (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, DoSR, SBoxOutput)
	begin
	
		S0_in 	<= S8;                
		S1_in 	<= S9;                
		S2_in 	<= S10;                
		S3_in 	<= S11;                
		S4_in 	<= S12;                
		S5_in 	<= S13;                
		S6_in 	<= S14;                
		S7_in 	<= S15;                
		
		S15_in 	<= SBoxOutput(63 downto 56);
		S14_in 	<= SBoxOutput(55 downto 48);
		S13_in 	<= SBoxOutput(47 downto 40);
		S12_in 	<= SBoxOutput(39 downto 32); 
		S11_in 	<= SBoxOutput(31 downto 24);                
		S10_in 	<= SBoxOutput(23 downto 16);                
		S9_in 	<= SBoxOutput(15 downto 8);                
		S8_in 	<= SBoxOutput(7 downto 0);                
		               
		                
		                
		
		
		if (DoSR= '1') then
		
		

		S14_in 	<= S10;
		S13_in 	<= S13;
		S12_in 	<= SBoxOutput(7 downto 0); 
            
		S10_in 	<= SBoxOutput(7*8-1 downto 6*8);                
		S9_in 	<= S9;                
		S8_in 	<= S12;  
		
		
		S0_in 	<= SBoxOutput(5*8-1 downto 4*8);                
		S1_in 	<= SBoxOutput(2*8-1 downto 1*8);                
		S2_in 	<= S14;                
               
		S4_in 	<= S8;                
		S5_in 	<= SBoxOutput(6*8-1 downto 5*8);                
		S6_in 	<= SBoxOutput(3*8-1 downto 2*8);                
             
		
		                
			

		end if;
		
	end process state_movement;

	StateReg_gen: PROCESS(StateEN, clk, S0_in, S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in, S9_in, S10_in, S11_in, S12_in, S13_in, S14_in, S15_in)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (StateEN = '1') THEN
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
			end if;
		END IF;
	END PROCESS;
		

	---------------------------------
	Reg_ShiftRowOutput <= S7 & S6 & S5 & S4 & S3 & S2 & S1 & S0;
	in3 		<= S0;
	in2 		<= S1;
	in1 		<= S2;
	in0 		<= S3; 
	
	in7	 	<= S4;
	in6	 	<= S5;
	in5 		<= S6;
	in4 		<= S7;

	---------------------------------

	Mult2in0	<= (in0(6 downto 0)  & "0") XOR ("000" & in0(7) & in0(7) & "0" & in0(7) & in0(7));
	Mult2in1	<= (in1(6 downto 0)  & "0") XOR ("000" & in1(7) & in1(7) & "0" & in1(7) & in1(7));
	Mult2in2	<= (in2(6 downto 0)  & "0") XOR ("000" & in2(7) & in2(7) & "0" & in2(7) & in2(7));
	Mult2in3	<= (in3(6 downto 0)  & "0") XOR ("000" & in3(7) & in3(7) & "0" & in3(7) & in3(7));
	Mult2in4	<= (in4(6 downto 0)  & "0") XOR ("000" & in4(7) & in4(7) & "0" & in4(7) & in4(7));
	Mult2in5	<= (in5(6 downto 0)  & "0") XOR ("000" & in5(7) & in5(7) & "0" & in5(7) & in5(7));
	Mult2in6	<= (in6(6 downto 0)  & "0") XOR ("000" & in6(7) & in6(7) & "0" & in6(7) & in6(7));
	Mult2in7	<= (in7(6 downto 0)  & "0") XOR ("000" & in7(7) & in7(7) & "0" & in7(7) & in7(7));
	

	Mult3in0	<= Mult2in0  XOR in0;
	Mult3in1	<= Mult2in1  XOR in1;
	Mult3in2	<= Mult2in2  XOR in2;
	Mult3in3	<= Mult2in3  XOR in3;
	Mult3in4	<= Mult2in4  XOR in4;
	Mult3in5	<= Mult2in5  XOR in5;
	Mult3in6	<= Mult2in6  XOR in6;
	Mult3in7	<= Mult2in7  XOR in7;
	
	
	---------------------------------
	
	MCOutput( 4*8-1 downto  3*8) <= Mult2in0 XOR Mult3in1 XOR in2      XOR in3;
	MCOutput( 3*8-1 downto  2*8) <= in0      XOR Mult2in1 XOR Mult3in2 XOR in3;
	MCOutput( 2*8-1 downto  1*8) <= in0      XOR in1      XOR Mult2in2 XOR Mult3in3;
	MCOutput( 1*8-1 downto  0*8) <= Mult3in0 XOR in1      XOR in2      XOR Mult2in3;
	
	MCOutput( 8*8-1 downto  7*8) <= Mult2in4 XOR Mult3in5 XOR in6      XOR in7;
	MCOutput( 7*8-1 downto  6*8) <= in4      XOR Mult2in5 XOR Mult3in6 XOR in7;
	MCOutput( 6*8-1 downto  5*8) <= in4      XOR in5      XOR Mult2in6 XOR Mult3in7;
	MCOutput( 5*8-1 downto  4*8) <= Mult3in4 XOR in5      XOR in6      XOR Mult2in7;
				
	---------------------------------

	MixColumnMUXOutput <= MCOutput when	FinalRound = '0' else Reg_ShiftRowOutput;
	
	MCReg_gen: PROCESS(clk, MixColumnMUXOutput)
	BEGIN
		IF RISING_EDGE(clk) THEN

				Reg_MixColumnMUXOutput <= MixColumnMUXOutput;

		END IF;
	END PROCESS;
	
	--------------------------------- 
	---- Key Schedule ---------------

	KeyMUXOutput					<= InputKey when KeyMuxSel = '1' else KeyStateRegOutput;	
	KeySboxInput_internal		<= K15 & K14 & K13 & K12;
	--KeySboxInput					<= KeySboxInput_internal;
	
	
	---------------------------------
	
	ShiftedSBKey 		<= SBoxOutput(23 downto 0) & SBoxOutput(31 downto 24);
	KeyStateRegOutput	<= K7 & K6 & K5 & K4 & K3 & K2 & K1 & K0;
	KeyScheduleRcon 	<= rcon when ShowRcon = '1' else x"00";
	--SecondColOfKeyState <= K7 & K6 & K5 & K4;
	Skey_or_w			<= ShiftedSBKey when ShowRcon = '1' else KeyStateRegOutput(63 downto  32);
	
	w0(31 downto  24)	<= Skey_or_w(31 downto 24)  XOR KeyScheduleRcon XOR K11;
	w0(23 downto  16) <= Skey_or_w(23 downto 16) XOR K10; 
	w0(15 downto  8)  <= Skey_or_w(15 downto 8) XOR K9; 
	w0(7 downto  0) 	<= Skey_or_w(7  downto 0) XOR K8; 
	
	w1(31 downto  24)	<= w0(31 downto 24) XOR K15;
	w1(23 downto  16) <= w0(23 downto 16) XOR K14; 
	w1(15 downto  8)  <= w0(15 downto 8) XOR K13; 
	w1(7 downto  0) 	<= w0(7  downto 0) XOR K12; 

	
	---------------------------------
	K0_in 	<= K8  when LoadKeySchedule = '0' else w0(7 downto  0);                
	K1_in 	<= K9  when LoadKeySchedule = '0' else w0(15 downto 8);                
	K2_in 	<= K10 when LoadKeySchedule = '0' else w0(23 downto 16);                
	K3_in 	<= K11 when LoadKeySchedule = '0' else w0(31 downto 24);  
	K4_in 	<= K12 when LoadKeySchedule = '0' else w1(7 downto  0);                
	K5_in 	<= K13 when LoadKeySchedule = '0' else w1(15 downto 8);                
	K6_in 	<= K14 when LoadKeySchedule = '0' else w1(23 downto 16);                
	K7_in 	<= K15 when LoadKeySchedule = '0' else w1(31 downto 24); 
	
             
	K8_in 	<= KeyMUXOutput(7 downto 0);                  
	K9_in 	<= KeyMUXOutput(15 downto 8);                 
	K10_in 	<= KeyMUXOutput(23 downto 16);                
	K11_in 	<= KeyMUXOutput(31 downto 24);                                
	K12_in 	<= KeyMUXOutput(39 downto 32);                
	K13_in 	<= KeyMUXOutput(47 downto 40);                
	K14_in 	<= KeyMUXOutput(55 downto 48);                
	K15_in 	<= KeyMUXOutput(63 downto 56);
		
		
	KeyReg_gen: PROCESS(KeyRegEn, clk, K0_in, K1_in, K2_in, K3_in, K4_in, K5_in, K6_in, K7_in, K8_in, K9_in, K10_in, K11_in, K12_in, K13_in, K14_in, K15_in)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (KeyRegEn = '1') THEN
				K0 <= K0_in;
				K1 <= K1_in;
				K2 <= K2_in;
				K3 <= K3_in;
				K4 <= K4_in;
				K5 <= K5_in;
				K6 <= K6_in;
				K7 <= K7_in;
				K8 <= K8_in;
				K9 <= K9_in;
				K10 <= K10_in;
				K11 <= K11_in;
				K12 <= K12_in;
				K13 <= K13_in;
				K14 <= K14_in;
				K15 <= K15_in;
			end if;
		END IF;
	END PROCESS;		
		
end Behavioral;

