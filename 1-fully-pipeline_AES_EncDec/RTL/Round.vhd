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
			  Dec						: in  STD_LOGIC;
			  FirstKey				: in  STD_LOGIC;
			  FinalRound			: in  STD_LOGIC;
			  KeyRegEn				: in  STD_LOGIC;
			  Rcon					: in  STD_LOGIC_VECTOR ( 7 downto 0);
           InputData 			: in  STD_LOGIC_VECTOR (127 downto 0);
           InputKey 				: in  STD_LOGIC_VECTOR (127 downto 0);
			  AddRoundKeyOutput	: out STD_LOGIC_VECTOR (127 downto 0);
			  SBoxOutput			: in  STD_LOGIC_VECTOR (127 downto 0);
			  KeySboxInput			: out STD_LOGIC_VECTOR ( 31 downto 0);
			  KeySboxOutput 		: in  STD_LOGIC_VECTOR ( 31 downto 0));
end Round;

architecture Behavioral of Round is
		
	---------------------------------
	---- Encryption Process ---------

	signal MuxOutput					: STD_LOGIC_VECTOR(127 downto 0);
	signal Reg_SBoxOutput			: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftRowOutput			: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftRowInvOutput		: STD_LOGIC_VECTOR(127 downto 0);
	signal MCOutput					: STD_LOGIC_VECTOR(127 downto 0);
	signal Selected_SR				: STD_LOGIC_VECTOR(127 downto 0);
	signal FeedBack					: STD_LOGIC_VECTOR(127 downto 0);
	
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	---------------------------------

	signal SR0,  SR1,  SR2,  SR3	: STD_LOGIC_VECTOR(7 downto 0);
	signal SR4,  SR5,  SR6,  SR7	: STD_LOGIC_VECTOR(7 downto 0);
	signal SR8,  SR9,  SR10, SR11 : STD_LOGIC_VECTOR(7 downto 0);
	signal SR12, SR13, SR14, SR15 : STD_LOGIC_VECTOR(7 downto 0);

	signal SR0_2,  SR4_6,  SR8_10, SR12_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal SR1_3,  SR5_7,  SR9_11, SR13_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult20_2,  Mult24_6,  Mult28_10, Mult212_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult21_3,  Mult25_7,  Mult29_11, Mult213_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult40_2,  Mult44_6,  Mult48_10, Mult412_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult41_3,  Mult45_7,  Mult49_11, Mult413_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal PI0,  PI1,  PI2,  PI3	: STD_LOGIC_VECTOR(7 downto 0);
	signal PI4,  PI5,  PI6,  PI7	: STD_LOGIC_VECTOR(7 downto 0);
	signal PI8,  PI9,  PI10, PI11 : STD_LOGIC_VECTOR(7 downto 0);
	signal PI12, PI13, PI14, PI15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult2PI0,  Mult2PI1,  Mult2PI2,  Mult2PI3	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PI4,  Mult2PI5,  Mult2PI6,  Mult2PI7	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PI8,  Mult2PI9,  Mult2PI10, Mult2PI11 : STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PI12, Mult2PI13, Mult2PI14, Mult2PI15 : STD_LOGIC_VECTOR(7 downto 0);

	--------------------------------- 
	---- Key Schedule ---------------

	signal KeyMUXOutput			: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftedSBKey			: STD_LOGIC_VECTOR( 31 downto 0);
	signal w0, w1, w2, w3		: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeyExpansionOutput	: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyStateRegOutput	: STD_LOGIC_VECTOR(127 downto 0);
	signal Selected_Key			: STD_LOGIC_VECTOR(127 downto 0);

	signal w1dec, w2dec, w3dec	: STD_LOGIC_VECTOR( 31 downto 0);
	signal MCInvK					: STD_LOGIC_VECTOR(127 downto 0);

	signal K0,  K1,  K2,  K3	: STD_LOGIC_VECTOR(7 downto 0);
	signal K4,  K5,  K6,  K7	: STD_LOGIC_VECTOR(7 downto 0);
	signal K8,  K9,  K10, K11 : STD_LOGIC_VECTOR(7 downto 0);
	signal K12, K13, K14, K15 : STD_LOGIC_VECTOR(7 downto 0);

	signal K0_2,  K4_6,  K8_10, K12_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal K1_3,  K5_7,  K9_11, K13_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult2K0_2,  Mult2K4_6,  Mult2K8_10, Mult2K12_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2K1_3,  Mult2K5_7,  Mult2K9_11, Mult2K13_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult4K0_2,  Mult4K4_6,  Mult4K8_10, Mult4K12_14	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult4K1_3,  Mult4K5_7,  Mult4K9_11, Mult4K13_15 : STD_LOGIC_VECTOR(7 downto 0);

	signal PIK0,  PIK1,  PIK2,  PIK3	: STD_LOGIC_VECTOR(7 downto 0);
	signal PIK4,  PIK5,  PIK6,  PIK7	: STD_LOGIC_VECTOR(7 downto 0);
	signal PIK8,  PIK9,  PIK10, PIK11 : STD_LOGIC_VECTOR(7 downto 0);
	signal PIK12, PIK13, PIK14, PIK15 : STD_LOGIC_VECTOR(7 downto 0);

	signal Mult2PIK0,  Mult2PIK1,  Mult2PIK2,  Mult2PIK3	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PIK4,  Mult2PIK5,  Mult2PIK6,  Mult2PIK7	: STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PIK8,  Mult2PIK9,  Mult2PIK10, Mult2PIK11 : STD_LOGIC_VECTOR(7 downto 0);
	signal Mult2PIK12, Mult2PIK13, Mult2PIK14, Mult2PIK15 : STD_LOGIC_VECTOR(7 downto 0);
		
begin
	
	---------------------------------
	---- Encryption Process ---------

	MuxOutput 			<= InputData when rst = '1' else FeedBack;	
	AddRoundKeyOutput	<= MuxOutput XOR Selected_Key;

	---------------------------------

	reg_gen: PROCESS(clk, ShiftRowOutput)
	BEGIN
		IF RISING_EDGE(clk) THEN
			Reg_SBoxOutput <= SBoxOutput;
		END IF;
	END PROCESS;		

	---------------------------------

	s15	 	<= Reg_SBoxOutput(8*16-1  downto  8*15);
	s14	 	<= Reg_SBoxOutput(8*15-1  downto  8*14);
	s13	 	<= Reg_SBoxOutput(8*14-1  downto  8*13);
	s12	 	<= Reg_SBoxOutput(8*13-1  downto  8*12);
	s11	 	<= Reg_SBoxOutput(8*12-1  downto  8*11);
	s10	 	<= Reg_SBoxOutput(8*11-1  downto  8*10);
	s9	 		<= Reg_SBoxOutput(8*10-1  downto  8*9);
	s8	 		<= Reg_SBoxOutput(8*9-1   downto  8*8);
	s7	 		<= Reg_SBoxOutput(8*8-1   downto  8*7);
	s6	 		<= Reg_SBoxOutput(8*7-1   downto  8*6);
	s5 		<= Reg_SBoxOutput(8*6-1   downto  8*5);
	s4 		<= Reg_SBoxOutput(8*5-1   downto  8*4);
	s3 		<= Reg_SBoxOutput(8*4-1   downto  8*3);
	s2 		<= Reg_SBoxOutput(8*3-1   downto  8*2);
	s1 		<= Reg_SBoxOutput(8*2-1   downto  8*1);
	s0 		<= Reg_SBoxOutput(8*1-1   downto  8*0); 
	
	ShiftRowOutput 	<= s11 & s6 & s1 & s12 & s7  & s2 & s13 & s8 & s3  & s14 & s9 & s4 & s15 & s10 & s5  & s0; 
	ShiftRowInvOutput <= s3  & s6 & s9 & s12 & s15 & s2 & s5  & s8 & s11 & s14 & s1 & s4 & s7  & s10 & s13 & s0; 

	Selected_SR <= ShiftRowOutput when Dec = '0' else ShiftRowInvOutput;

	---------------------------------

	SR15 	<= Selected_SR(8*16-1  downto  8*15);
	SR14 	<= Selected_SR(8*15-1  downto  8*14);
	SR13 	<= Selected_SR(8*14-1  downto  8*13);
	SR12 	<= Selected_SR(8*13-1  downto  8*12);
	SR11 	<= Selected_SR(8*12-1  downto  8*11);
	SR10 	<= Selected_SR(8*11-1  downto  8*10);
	SR9 	<= Selected_SR(8*10-1  downto  8*9);
	SR8	<= Selected_SR(8*9-1   downto  8*8);
	SR7 	<= Selected_SR(8*8-1   downto  8*7);
	SR6 	<= Selected_SR(8*7-1   downto  8*6);
	SR5 	<= Selected_SR(8*6-1   downto  8*5);
	SR4 	<= Selected_SR(8*5-1   downto  8*4);
	SR3 	<= Selected_SR(8*4-1   downto  8*3);
	SR2 	<= Selected_SR(8*3-1   downto  8*2);
	SR1 	<= Selected_SR(8*2-1   downto  8*1);
	SR0 	<= Selected_SR(8*1-1   downto  8*0); 

	---------------------------------

	SR0_2		<= SR0  XOR SR2;
	SR1_3		<= SR1  XOR SR3;
	SR4_6		<= SR4  XOR SR6;
	SR5_7		<= SR5  XOR SR7;
	SR8_10	<= SR8  XOR SR10;
	SR9_11	<= SR9  XOR SR11;
	SR12_14	<= SR12 XOR SR14;
	SR13_15	<= SR13 XOR SR15;

	Mult20_2		<= (SR0_2(6 downto 0)   & "0") XOR ("000" & SR0_2(7)   & SR0_2(7)   & "0" & SR0_2(7)   & SR0_2(7));
	Mult21_3		<= (SR1_3(6 downto 0)   & "0") XOR ("000" & SR1_3(7)   & SR1_3(7)   & "0" & SR1_3(7)   & SR1_3(7));
	Mult24_6		<= (SR4_6(6 downto 0)   & "0") XOR ("000" & SR4_6(7)   & SR4_6(7)   & "0" & SR4_6(7)   & SR4_6(7));
	Mult25_7		<= (SR5_7(6 downto 0)   & "0") XOR ("000" & SR5_7(7)   & SR5_7(7)   & "0" & SR5_7(7)   & SR5_7(7));
	Mult28_10	<= (SR8_10(6 downto 0)  & "0") XOR ("000" & SR8_10(7)  & SR8_10(7)  & "0" & SR8_10(7)  & SR8_10(7));
	Mult29_11	<= (SR9_11(6 downto 0)  & "0") XOR ("000" & SR9_11(7)  & SR9_11(7)  & "0" & SR9_11(7)  & SR9_11(7));
	Mult212_14	<= (SR12_14(6 downto 0) & "0") XOR ("000" & SR12_14(7) & SR12_14(7) & "0" & SR12_14(7) & SR12_14(7));
	Mult213_15	<= (SR13_15(6 downto 0) & "0") XOR ("000" & SR13_15(7) & SR13_15(7) & "0" & SR13_15(7) & SR13_15(7));
	
	Mult40_2		<= (Mult20_2(6 downto 0)   & "0") XOR ("000" & Mult20_2(7)   & Mult20_2(7)   & "0" & Mult20_2(7)   & Mult20_2(7));
	Mult41_3		<= (Mult21_3(6 downto 0)   & "0") XOR ("000" & Mult21_3(7)   & Mult21_3(7)   & "0" & Mult21_3(7)   & Mult21_3(7));
	Mult44_6		<= (Mult24_6(6 downto 0)   & "0") XOR ("000" & Mult24_6(7)   & Mult24_6(7)   & "0" & Mult24_6(7)   & Mult24_6(7));
	Mult45_7		<= (Mult25_7(6 downto 0)   & "0") XOR ("000" & Mult25_7(7)   & Mult25_7(7)   & "0" & Mult25_7(7)   & Mult25_7(7));
	Mult48_10	<= (Mult28_10(6 downto 0)  & "0") XOR ("000" & Mult28_10(7)  & Mult28_10(7)  & "0" & Mult28_10(7)  & Mult28_10(7));
	Mult49_11	<= (Mult29_11(6 downto 0)  & "0") XOR ("000" & Mult29_11(7)  & Mult29_11(7)  & "0" & Mult29_11(7)  & Mult29_11(7));
	Mult412_14	<= (Mult212_14(6 downto 0) & "0") XOR ("000" & Mult212_14(7) & Mult212_14(7) & "0" & Mult212_14(7) & Mult212_14(7));
	Mult413_15	<= (Mult213_15(6 downto 0) & "0") XOR ("000" & Mult213_15(7) & Mult213_15(7) & "0" & Mult213_15(7) & Mult213_15(7));


	PI0	<= (SR0  XOR Mult40_2)   when Dec = '1' else SR0;
	PI1	<= (SR1  XOR Mult41_3)   when Dec = '1' else SR1;
	PI2	<= (SR2  XOR Mult40_2)   when Dec = '1' else SR2;
	PI3	<= (SR3  XOR Mult41_3)   when Dec = '1' else SR3;
	PI4	<= (SR4  XOR Mult44_6)   when Dec = '1' else SR4;
	PI5	<= (SR5  XOR Mult45_7)   when Dec = '1' else SR5;
	PI6	<= (SR6  XOR Mult44_6)   when Dec = '1' else SR6;
	PI7	<= (SR7  XOR Mult45_7)   when Dec = '1' else SR7;
	PI8	<= (SR8  XOR Mult48_10)  when Dec = '1' else SR8;
	PI9	<= (SR9  XOR Mult49_11)  when Dec = '1' else SR9;
	PI10	<= (SR10 XOR Mult48_10)  when Dec = '1' else SR10;
	PI11	<= (SR11 XOR Mult49_11)  when Dec = '1' else SR11;
	PI12	<= (SR12 XOR Mult412_14) when Dec = '1' else SR12;
	PI13	<= (SR13 XOR Mult413_15) when Dec = '1' else SR13;
	PI14	<= (SR14 XOR Mult412_14) when Dec = '1' else SR14;
	PI15	<= (SR15 XOR Mult413_15) when Dec = '1' else SR15;

	Mult2PI0		<= (PI0(6 downto 0)  & "0") XOR ("000" & PI0(7)  & PI0(7)  & "0" & PI0(7)  & PI0(7));
	Mult2PI1		<= (PI1(6 downto 0)  & "0") XOR ("000" & PI1(7)  & PI1(7)  & "0" & PI1(7)  & PI1(7));
	Mult2PI2		<= (PI2(6 downto 0)  & "0") XOR ("000" & PI2(7)  & PI2(7)  & "0" & PI2(7)  & PI2(7));
	Mult2PI3		<= (PI3(6 downto 0)  & "0") XOR ("000" & PI3(7)  & PI3(7)  & "0" & PI3(7)  & PI3(7));
	Mult2PI4		<= (PI4(6 downto 0)  & "0") XOR ("000" & PI4(7)  & PI4(7)  & "0" & PI4(7)  & PI4(7));
	Mult2PI5		<= (PI5(6 downto 0)  & "0") XOR ("000" & PI5(7)  & PI5(7)  & "0" & PI5(7)  & PI5(7));
	Mult2PI6		<= (PI6(6 downto 0)  & "0") XOR ("000" & PI6(7)  & PI6(7)  & "0" & PI6(7)  & PI6(7));
	Mult2PI7		<= (PI7(6 downto 0)  & "0") XOR ("000" & PI7(7)  & PI7(7)  & "0" & PI7(7)  & PI7(7));
	Mult2PI8		<= (PI8(6 downto 0)  & "0") XOR ("000" & PI8(7)  & PI8(7)  & "0" & PI8(7)  & PI8(7));
	Mult2PI9		<= (PI9(6 downto 0)  & "0") XOR ("000" & PI9(7)  & PI9(7)  & "0" & PI9(7)  & PI9(7));
	Mult2PI10	<= (PI10(6 downto 0) & "0") XOR ("000" & PI10(7) & PI10(7) & "0" & PI10(7) & PI10(7));
	Mult2PI11	<= (PI11(6 downto 0) & "0") XOR ("000" & PI11(7) & PI11(7) & "0" & PI11(7) & PI11(7));
	Mult2PI12	<= (PI12(6 downto 0) & "0") XOR ("000" & PI12(7) & PI12(7) & "0" & PI12(7) & PI12(7));
	Mult2PI13	<= (PI13(6 downto 0) & "0") XOR ("000" & PI13(7) & PI13(7) & "0" & PI13(7) & PI13(7));
	Mult2PI14	<= (PI14(6 downto 0) & "0") XOR ("000" & PI14(7) & PI14(7) & "0" & PI14(7) & PI14(7));
	Mult2PI15	<= (PI15(6 downto 0) & "0") XOR ("000" & PI15(7) & PI15(7) & "0" & PI15(7) & PI15(7));


	MCOutput( 1*8-1 downto  0*8) <= Mult2PI0  XOR  Mult2PI1  XOR PI1  XOR PI2  XOR PI3;
	MCOutput( 2*8-1 downto  1*8) <= Mult2PI1  XOR  Mult2PI2  XOR PI2  XOR PI3  XOR PI0;
	MCOutput( 3*8-1 downto  2*8) <= Mult2PI2  XOR  Mult2PI3  XOR PI3  XOR PI0  XOR PI1;
	MCOutput( 4*8-1 downto  3*8) <= Mult2PI3  XOR  Mult2PI0  XOR PI0  XOR PI1  XOR PI2;

	MCOutput( 5*8-1 downto  4*8) <= Mult2PI4  XOR  Mult2PI5  XOR PI5  XOR PI6  XOR PI7;
	MCOutput( 6*8-1 downto  5*8) <= Mult2PI5  XOR  Mult2PI6  XOR PI6  XOR PI7  XOR PI4;
	MCOutput( 7*8-1 downto  6*8) <= Mult2PI6  XOR  Mult2PI7  XOR PI7  XOR PI4  XOR PI5;
	MCOutput( 8*8-1 downto  7*8) <= Mult2PI7  XOR  Mult2PI4  XOR PI4  XOR PI5  XOR PI6;

	MCOutput( 9*8-1 downto  8*8) <= Mult2PI8  XOR  Mult2PI9  XOR PI9  XOR PI10 XOR PI11;
	MCOutput(10*8-1 downto  9*8) <= Mult2PI9  XOR  Mult2PI10 XOR PI10 XOR PI11 XOR PI8;
	MCOutput(11*8-1 downto 10*8) <= Mult2PI10 XOR  Mult2PI11 XOR PI11 XOR PI8  XOR PI9;
	MCOutput(12*8-1 downto 11*8) <= Mult2PI11 XOR  Mult2PI8  XOR PI8  XOR PI9  XOR PI10;

	MCOutput(13*8-1 downto 12*8) <= Mult2PI12 XOR  Mult2PI13 XOR PI13 XOR PI14 XOR PI15;
	MCOutput(14*8-1 downto 13*8) <= Mult2PI13 XOR  Mult2PI14 XOR PI14 XOR PI15 XOR PI12;
	MCOutput(15*8-1 downto 14*8) <= Mult2PI14 XOR  Mult2PI15 XOR PI15 XOR PI12 XOR PI13;
	MCOutput(16*8-1 downto 15*8) <= Mult2PI15 XOR  Mult2PI12 XOR PI12 XOR PI13 XOR PI14;

	--------------------------------- 
	
	FeedBack 	<= MCOutput when FinalRound = '0' else Selected_SR;
	
	--------------------------------- 
	---- Key Schedule ---------------

	KeyMUXOutput		<= InputKey when rst = '1' else KeyStateRegOutput;	

	w3dec					<= KeyMUXOutput(95 downto 64) XOR KeyMUXOutput(127 downto 96);
	w2dec					<= KeyMUXOutput(63 downto 32) XOR KeyMUXOutput( 95 downto 64);
	w1dec					<= KeyMUXOutput(31 downto  0) XOR KeyMUXOutput( 63 downto 32);
	
	KeySboxInput		<= KeyMUXOutput(127 downto 96) when Dec = '0' else w3dec;
	
	---------------------------------
	
	ShiftedSBKey 		<= KeySboxOutput(7 downto 0) & KeySboxOutput(31 downto 16) & (KeySboxOutput(15 downto 8) XOR Rcon);
	
	w0 	<= ShiftedSBKey XOR KeyMUXOutput(31 downto 0); 
	w1		<= w0 XOR KeyMUXOutput(63 downto 32);
	w2		<= w1 XOR KeyMUXOutput(95 downto 64);
	w3		<= w2 XOR KeyMUXOutput(127 downto 96);
	
	KeyExpansionOutput( 31 downto  0) <= w0;	
	KeyExpansionOutput(127 downto 32) <= (w3 & w2 & w1) when Dec = '0' else (w3dec & w2dec & w1dec);

	---------------------------------
	
	Keyreg_gen: PROCESS(clk, KeyExpansionOutput)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF KeyRegEn = '1' THEN
				KeyStateRegOutput <= KeyExpansionOutput;
			END IF;	
		END IF;
	END PROCESS;		
		
	--------------------------------- 
	---- Key select -----------------
	
	K15 	<= KeyMUXOutput(8*16-1  downto  8*15);
	K14 	<= KeyMUXOutput(8*15-1  downto  8*14);
	K13 	<= KeyMUXOutput(8*14-1  downto  8*13);
	K12 	<= KeyMUXOutput(8*13-1  downto  8*12);
	K11 	<= KeyMUXOutput(8*12-1  downto  8*11);
	K10 	<= KeyMUXOutput(8*11-1  downto  8*10);
	K9 	<= KeyMUXOutput(8*10-1  downto  8*9);
	K8		<= KeyMUXOutput(8*9-1   downto  8*8);
	K7 	<= KeyMUXOutput(8*8-1   downto  8*7);
	K6 	<= KeyMUXOutput(8*7-1   downto  8*6);
	K5 	<= KeyMUXOutput(8*6-1   downto  8*5);
	K4 	<= KeyMUXOutput(8*5-1   downto  8*4);
	K3 	<= KeyMUXOutput(8*4-1   downto  8*3);
	K2 	<= KeyMUXOutput(8*3-1   downto  8*2);
	K1 	<= KeyMUXOutput(8*2-1   downto  8*1);
	K0 	<= KeyMUXOutput(8*1-1   downto  8*0); 

	---------------------------------

	K0_2		<= K0  XOR K2;
	K1_3		<= K1  XOR K3;
	K4_6		<= K4  XOR K6;
	K5_7		<= K5  XOR K7;
	K8_10		<= K8  XOR K10;
	K9_11		<= K9  XOR K11;
	K12_14	<= K12 XOR K14;
	K13_15	<= K13 XOR K15;

	Mult2K0_2	<= (K0_2(6 downto 0)   & "0") XOR ("000" & K0_2(7)   & K0_2(7)   & "0" & K0_2(7)   & K0_2(7));
	Mult2K1_3	<= (K1_3(6 downto 0)   & "0") XOR ("000" & K1_3(7)   & K1_3(7)   & "0" & K1_3(7)   & K1_3(7));
	Mult2K4_6	<= (K4_6(6 downto 0)   & "0") XOR ("000" & K4_6(7)   & K4_6(7)   & "0" & K4_6(7)   & K4_6(7));
	Mult2K5_7	<= (K5_7(6 downto 0)   & "0") XOR ("000" & K5_7(7)   & K5_7(7)   & "0" & K5_7(7)   & K5_7(7));
	Mult2K8_10	<= (K8_10(6 downto 0)  & "0") XOR ("000" & K8_10(7)  & K8_10(7)  & "0" & K8_10(7)  & K8_10(7));
	Mult2K9_11	<= (K9_11(6 downto 0)  & "0") XOR ("000" & K9_11(7)  & K9_11(7)  & "0" & K9_11(7)  & K9_11(7));
	Mult2K12_14	<= (K12_14(6 downto 0) & "0") XOR ("000" & K12_14(7) & K12_14(7) & "0" & K12_14(7) & K12_14(7));
	Mult2K13_15	<= (K13_15(6 downto 0) & "0") XOR ("000" & K13_15(7) & K13_15(7) & "0" & K13_15(7) & K13_15(7));
	
	Mult4K0_2	<= (Mult2K0_2(6 downto 0)   & "0") XOR ("000" & Mult2K0_2(7)   & Mult2K0_2(7) & "0"   & Mult2K0_2(7)   & Mult2K0_2(7));
	Mult4K1_3	<= (Mult2K1_3(6 downto 0)   & "0") XOR ("000" & Mult2K1_3(7)   & Mult2K1_3(7) & "0"   & Mult2K1_3(7)   & Mult2K1_3(7));
	Mult4K4_6	<= (Mult2K4_6(6 downto 0)   & "0") XOR ("000" & Mult2K4_6(7)   & Mult2K4_6(7) & "0"   & Mult2K4_6(7)   & Mult2K4_6(7));
	Mult4K5_7	<= (Mult2K5_7(6 downto 0)   & "0") XOR ("000" & Mult2K5_7(7)   & Mult2K5_7(7) & "0"   & Mult2K5_7(7)   & Mult2K5_7(7));
	Mult4K8_10	<= (Mult2K8_10(6 downto 0)  & "0") XOR ("000" & Mult2K8_10(7)  & Mult2K8_10(7) & "0"  & Mult2K8_10(7)  & Mult2K8_10(7));
	Mult4K9_11	<= (Mult2K9_11(6 downto 0)  & "0") XOR ("000" & Mult2K9_11(7)  & Mult2K9_11(7) & "0"  & Mult2K9_11(7)  & Mult2K9_11(7));
	Mult4K12_14	<= (Mult2K12_14(6 downto 0) & "0") XOR ("000" & Mult2K12_14(7) & Mult2K12_14(7) & "0" & Mult2K12_14(7) & Mult2K12_14(7));
	Mult4K13_15	<= (Mult2K13_15(6 downto 0) & "0") XOR ("000" & Mult2K13_15(7) & Mult2K13_15(7) & "0" & Mult2K13_15(7) & Mult2K13_15(7));

	PIK0	<= K0  XOR Mult4K0_2;
	PIK1	<= K1  XOR Mult4K1_3;
	PIK2	<= K2  XOR Mult4K0_2;
	PIK3	<= K3  XOR Mult4K1_3;
	PIK4	<= K4  XOR Mult4K4_6;
	PIK5	<= K5  XOR Mult4K5_7;
	PIK6	<= K6  XOR Mult4K4_6;
	PIK7	<= K7  XOR Mult4K5_7;
	PIK8	<= K8  XOR Mult4K8_10;
	PIK9	<= K9  XOR Mult4K9_11;
	PIK10	<= K10 XOR Mult4K8_10;
	PIK11	<= K11 XOR Mult4K9_11;
	PIK12	<= K12 XOR Mult4K12_14;
	PIK13	<= K13 XOR Mult4K13_15;
	PIK14	<= K14 XOR Mult4K12_14;
	PIK15	<= K15 XOR Mult4K13_15;

	Mult2PIK0	<= (PIK0(6 downto 0)  & "0") XOR ("000" & PIK0(7)  & PIK0(7)  & "0" & PIK0(7)  & PIK0(7));
	Mult2PIK1	<= (PIK1(6 downto 0)  & "0") XOR ("000" & PIK1(7)  & PIK1(7)  & "0" & PIK1(7)  & PIK1(7));
	Mult2PIK2	<= (PIK2(6 downto 0)  & "0") XOR ("000" & PIK2(7)  & PIK2(7)  & "0" & PIK2(7)  & PIK2(7));
	Mult2PIK3	<= (PIK3(6 downto 0)  & "0") XOR ("000" & PIK3(7)  & PIK3(7)  & "0" & PIK3(7)  & PIK3(7));
	Mult2PIK4	<= (PIK4(6 downto 0)  & "0") XOR ("000" & PIK4(7)  & PIK4(7)  & "0" & PIK4(7)  & PIK4(7));
	Mult2PIK5	<= (PIK5(6 downto 0)  & "0") XOR ("000" & PIK5(7)  & PIK5(7)  & "0" & PIK5(7)  & PIK5(7));
	Mult2PIK6	<= (PIK6(6 downto 0)  & "0") XOR ("000" & PIK6(7)  & PIK6(7)  & "0" & PIK6(7)  & PIK6(7));
	Mult2PIK7	<= (PIK7(6 downto 0)  & "0") XOR ("000" & PIK7(7)  & PIK7(7)  & "0" & PIK7(7)  & PIK7(7));
	Mult2PIK8	<= (PIK8(6 downto 0)  & "0") XOR ("000" & PIK8(7)  & PIK8(7)  & "0" & PIK8(7)  & PIK8(7));
	Mult2PIK9	<= (PIK9(6 downto 0)  & "0") XOR ("000" & PIK9(7)  & PIK9(7)  & "0" & PIK9(7)  & PIK9(7));
	Mult2PIK10	<= (PIK10(6 downto 0) & "0") XOR ("000" & PIK10(7) & PIK10(7) & "0" & PIK10(7) & PIK10(7));
	Mult2PIK11	<= (PIK11(6 downto 0) & "0") XOR ("000" & PIK11(7) & PIK11(7) & "0" & PIK11(7) & PIK11(7));
	Mult2PIK12	<= (PIK12(6 downto 0) & "0") XOR ("000" & PIK12(7) & PIK12(7) & "0" & PIK12(7) & PIK12(7));
	Mult2PIK13	<= (PIK13(6 downto 0) & "0") XOR ("000" & PIK13(7) & PIK13(7) & "0" & PIK13(7) & PIK13(7));
	Mult2PIK14	<= (PIK14(6 downto 0) & "0") XOR ("000" & PIK14(7) & PIK14(7) & "0" & PIK14(7) & PIK14(7));
	Mult2PIK15	<= (PIK15(6 downto 0) & "0") XOR ("000" & PIK15(7) & PIK15(7) & "0" & PIK15(7) & PIK15(7));

	MCInvK( 1*8-1 downto  0*8) <= Mult2PIK0  XOR  Mult2PIK1  XOR PIK1  XOR PIK2  XOR PIK3;
	MCInvK( 2*8-1 downto  1*8) <= Mult2PIK1  XOR  Mult2PIK2  XOR PIK2  XOR PIK3  XOR PIK0;
	MCInvK( 3*8-1 downto  2*8) <= Mult2PIK2  XOR  Mult2PIK3  XOR PIK3  XOR PIK0  XOR PIK1;
	MCInvK( 4*8-1 downto  3*8) <= Mult2PIK3  XOR  Mult2PIK0  XOR PIK0  XOR PIK1  XOR PIK2;

	MCInvK( 5*8-1 downto  4*8) <= Mult2PIK4  XOR  Mult2PIK5  XOR PIK5  XOR PIK6  XOR PIK7;
	MCInvK( 6*8-1 downto  5*8) <= Mult2PIK5  XOR  Mult2PIK6  XOR PIK6  XOR PIK7  XOR PIK4;
	MCInvK( 7*8-1 downto  6*8) <= Mult2PIK6  XOR  Mult2PIK7  XOR PIK7  XOR PIK4  XOR PIK5;
	MCInvK( 8*8-1 downto  7*8) <= Mult2PIK7  XOR  Mult2PIK4  XOR PIK4  XOR PIK5  XOR PIK6;

	MCInvK( 9*8-1 downto  8*8) <= Mult2PIK8  XOR  Mult2PIK9  XOR PIK9  XOR PIK10 XOR PIK11;
	MCInvK(10*8-1 downto  9*8) <= Mult2PIK9  XOR  Mult2PIK10 XOR PIK10 XOR PIK11 XOR PIK8;
	MCInvK(11*8-1 downto 10*8) <= Mult2PIK10 XOR  Mult2PIK11 XOR PIK11 XOR PIK8  XOR PIK9;
	MCInvK(12*8-1 downto 11*8) <= Mult2PIK11 XOR  Mult2PIK8  XOR PIK8  XOR PIK9  XOR PIK10;

	MCInvK(13*8-1 downto 12*8) <= Mult2PIK12 XOR  Mult2PIK13 XOR PIK13 XOR PIK14 XOR PIK15;
	MCInvK(14*8-1 downto 13*8) <= Mult2PIK13 XOR  Mult2PIK14 XOR PIK14 XOR PIK15 XOR PIK12;
	MCInvK(15*8-1 downto 14*8) <= Mult2PIK14 XOR  Mult2PIK15 XOR PIK15 XOR PIK12 XOR PIK13;
	MCInvK(16*8-1 downto 15*8) <= Mult2PIK15 XOR  Mult2PIK12 XOR PIK12 XOR PIK13 XOR PIK14;
	
	---------------------------------
		
	Selected_Key <= KeyMUXOutput when FirstKey = '1' else MCInvK;
		
end Behavioral;

