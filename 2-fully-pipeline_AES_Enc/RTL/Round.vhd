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

	signal MuxOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftRowOutput					: STD_LOGIC_VECTOR(127 downto 0);
	signal Reg_ShiftRowOutput				: STD_LOGIC_VECTOR(127 downto 0);
	signal MCOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal InputDataStateRegOutput		: STD_LOGIC_VECTOR(127 downto 0);
	signal MixColumnMUXOutput				: STD_LOGIC_VECTOR(127 downto 0);
	
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
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

	signal KeyMUXOutput			: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftedSBKey			: STD_LOGIC_VECTOR( 31 downto 0);
	signal w0, w1, w2, w3		: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeyExpansionOutput	: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyStateRegOutput	: STD_LOGIC_VECTOR(127 downto 0);
		
begin
	
	---------------------------------
	---- Encryption Process ---------

	MuxOutput 			<= InputData when rst = '1' else MixColumnMUXOutput;	
	AddRoundKeyOutput	<= MuxOutput XOR KeyMUXOutput;

	---------------------------------

	s15	 	<= SBoxOutput(8*16-1  downto  8*15);
	s14	 	<= SBoxOutput(8*15-1  downto  8*14);
	s13	 	<= SBoxOutput(8*14-1  downto  8*13);
	s12	 	<= SBoxOutput(8*13-1  downto  8*12);
	s11	 	<= SBoxOutput(8*12-1  downto  8*11);
	s10	 	<= SBoxOutput(8*11-1  downto  8*10);
	s9	 		<= SBoxOutput(8*10-1  downto  8*9);
	s8	 		<= SBoxOutput(8*9-1   downto  8*8);
	s7	 		<= SBoxOutput(8*8-1   downto  8*7);
	s6	 		<= SBoxOutput(8*7-1   downto  8*6);
	s5 		<= SBoxOutput(8*6-1   downto  8*5);
	s4 		<= SBoxOutput(8*5-1   downto  8*4);
	s3 		<= SBoxOutput(8*4-1   downto  8*3);
	s2 		<= SBoxOutput(8*3-1   downto  8*2);
	s1 		<= SBoxOutput(8*2-1   downto  8*1);
	s0 		<= SBoxOutput(8*1-1   downto  8*0); 
	
	ShiftRowOutput <= s11 & s6 & s1 & s12 & s7 & s2 & s13 & s8 & s3 & s14 & s9 & s4 & s15 & s10 & s5 & s0; 

	---------------------------------
	
	reg_gen: PROCESS(clk, ShiftRowOutput)
	BEGIN
		IF RISING_EDGE(clk) THEN
			Reg_ShiftRowOutput <= ShiftRowOutput;
		END IF;
	END PROCESS;		

	---------------------------------

	in15	 	<= Reg_ShiftRowOutput(8*16-1  downto  8*15);
	in14	 	<= Reg_ShiftRowOutput(8*15-1  downto  8*14);
	in13	 	<= Reg_ShiftRowOutput(8*14-1  downto  8*13);
	in12	 	<= Reg_ShiftRowOutput(8*13-1  downto  8*12);
	in11	 	<= Reg_ShiftRowOutput(8*12-1  downto  8*11);
	in10	 	<= Reg_ShiftRowOutput(8*11-1  downto  8*10);
	in9	 	<= Reg_ShiftRowOutput(8*10-1  downto  8*9);
	in8		<= Reg_ShiftRowOutput(8*9-1   downto  8*8);
	in7	 	<= Reg_ShiftRowOutput(8*8-1   downto  8*7);
	in6	 	<= Reg_ShiftRowOutput(8*7-1   downto  8*6);
	in5 		<= Reg_ShiftRowOutput(8*6-1   downto  8*5);
	in4 		<= Reg_ShiftRowOutput(8*5-1   downto  8*4);
	in3 		<= Reg_ShiftRowOutput(8*4-1   downto  8*3);
	in2 		<= Reg_ShiftRowOutput(8*3-1   downto  8*2);
	in1 		<= Reg_ShiftRowOutput(8*2-1   downto  8*1);
	in0 		<= Reg_ShiftRowOutput(8*1-1   downto  8*0); 

	---------------------------------

	Mult2in0	<= (in0(6 downto 0)  & "0") XOR ("000" & in0(7) & in0(7) & "0" & in0(7) & in0(7));
	Mult2in1	<= (in1(6 downto 0)  & "0") XOR ("000" & in1(7) & in1(7) & "0" & in1(7) & in1(7));
	Mult2in2	<= (in2(6 downto 0)  & "0") XOR ("000" & in2(7) & in2(7) & "0" & in2(7) & in2(7));
	Mult2in3	<= (in3(6 downto 0)  & "0") XOR ("000" & in3(7) & in3(7) & "0" & in3(7) & in3(7));
	Mult2in4	<= (in4(6 downto 0)  & "0") XOR ("000" & in4(7) & in4(7) & "0" & in4(7) & in4(7));
	Mult2in5	<= (in5(6 downto 0)  & "0") XOR ("000" & in5(7) & in5(7) & "0" & in5(7) & in5(7));
	Mult2in6	<= (in6(6 downto 0)  & "0") XOR ("000" & in6(7) & in6(7) & "0" & in6(7) & in6(7));
	Mult2in7	<= (in7(6 downto 0)  & "0") XOR ("000" & in7(7) & in7(7) & "0" & in7(7) & in7(7));
	Mult2in8	<= (in8(6 downto 0)  & "0") XOR ("000" & in8(7) & in8(7) & "0" & in8(7) & in8(7));
	Mult2in9	<= (in9(6 downto 0)  & "0") XOR ("000" & in9(7) & in9(7) & "0" & in9(7) & in9(7));
	Mult2in10<= (in10(6 downto 0) & "0") XOR ("000" & in10(7) & in10(7) & "0" & in10(7) & in10(7));
	Mult2in11<= (in11(6 downto 0) & "0") XOR ("000" & in11(7) & in11(7) & "0" & in11(7) & in11(7));
	Mult2in12<= (in12(6 downto 0) & "0") XOR ("000" & in12(7) & in12(7) & "0" & in12(7) & in12(7));
	Mult2in13<= (in13(6 downto 0) & "0") XOR ("000" & in13(7) & in13(7) & "0" & in13(7) & in13(7));
	Mult2in14<= (in14(6 downto 0) & "0") XOR ("000" & in14(7) & in14(7) & "0" & in14(7) & in14(7));
	Mult2in15<= (in15(6 downto 0) & "0") XOR ("000" & in15(7) & in15(7) & "0" & in15(7) & in15(7));

	Mult3in0	<= Mult2in0  XOR in0;
	Mult3in1	<= Mult2in1  XOR in1;
	Mult3in2	<= Mult2in2  XOR in2;
	Mult3in3	<= Mult2in3  XOR in3;
	Mult3in4	<= Mult2in4  XOR in4;
	Mult3in5	<= Mult2in5  XOR in5;
	Mult3in6	<= Mult2in6  XOR in6;
	Mult3in7	<= Mult2in7  XOR in7;
	Mult3in8	<= Mult2in8  XOR in8;
	Mult3in9	<= Mult2in9  XOR in9;
	Mult3in10<= Mult2in10 XOR in10;
	Mult3in11<= Mult2in11 XOR in11;
	Mult3in12<= Mult2in12 XOR in12;
	Mult3in13<= Mult2in13 XOR in13;
	Mult3in14<= Mult2in14 XOR in14;
	Mult3in15<= Mult2in15 XOR in15;

	---------------------------------

	MCOutput( 1*8-1 downto  0*8) <= Mult2in0 XOR Mult3in1 XOR in2      XOR in3;
	MCOutput( 2*8-1 downto  1*8) <= in0      XOR Mult2in1 XOR Mult3in2 XOR in3;
	MCOutput( 3*8-1 downto  2*8) <= in0      XOR in1      XOR Mult2in2 XOR Mult3in3;
	MCOutput( 4*8-1 downto  3*8) <= Mult3in0 XOR in1      XOR in2      XOR Mult2in3;
	
	MCOutput( 5*8-1 downto  4*8) <= Mult2in4 XOR Mult3in5 XOR in6      XOR in7;
	MCOutput( 6*8-1 downto  5*8) <= in4      XOR Mult2in5 XOR Mult3in6 XOR in7;
	MCOutput( 7*8-1 downto  6*8) <= in4      XOR in5      XOR Mult2in6 XOR Mult3in7;
	MCOutput( 8*8-1 downto  7*8) <= Mult3in4 XOR in5      XOR in6      XOR Mult2in7;
	
	MCOutput( 9*8-1 downto  8*8) <= Mult2in8 XOR Mult3in9 XOR in10      XOR in11;
	MCOutput(10*8-1 downto  9*8) <= in8      XOR Mult2in9 XOR Mult3in10 XOR in11;
	MCOutput(11*8-1 downto 10*8) <= in8      XOR in9      XOR Mult2in10 XOR Mult3in11;
	MCOutput(12*8-1 downto 11*8) <= Mult3in8 XOR in9      XOR in10      XOR Mult2in11;
	
	MCOutput(13*8-1 downto 12*8) <= Mult2in12 XOR Mult3in13  XOR in14      XOR in15;
	MCOutput(14*8-1 downto 13*8) <= in12       XOR Mult2in13 XOR Mult3in14 XOR in15;
	MCOutput(15*8-1 downto 14*8) <= in12      XOR in13       XOR Mult2in14 XOR Mult3in15;
	MCOutput(16*8-1 downto 15*8) <= Mult3in12 XOR in13       XOR in14      XOR Mult2in15;

	---------------------------------

	MixColumnMUXOutput <= MCOutput when	FinalRound = '0' else Reg_ShiftRowOutput;
	
	--------------------------------- 
	---- Key Schedule ---------------

	KeyMUXOutput		<= InputKey when rst = '1' else KeyStateRegOutput;	
	KeySboxInput		<= KeyMUXOutput(16*8-1 downto 12*8);
	
	---------------------------------
	
	ShiftedSBKey 		<= KeySboxOutput(7 downto 0) & KeySboxOutput(31 downto 8);
	
	w0( 7 downto  0)	<= ShiftedSBKey(7 downto 0)  XOR rcon XOR KeyMUXOutput(7 downto 0);
	w0(31 downto  8) 	<= ShiftedSBKey(31 downto 8) XOR KeyMUXOutput(31 downto 8); 

	w1						<= w0 XOR KeyMUXOutput(63 downto 32);
	w2						<= w1 XOR KeyMUXOutput(95 downto 64);
	w3						<= w2 XOR KeyMUXOutput(127 downto 96);
	
	KeyExpansionOutput<= w3 & w2 & w1 & w0;	

	---------------------------------
	
	Keyreg_gen: PROCESS(clk, KeyExpansionOutput)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF KeyRegEn = '1' THEN
				KeyStateRegOutput <= KeyExpansionOutput;
			END IF;	
		END IF;
	END PROCESS;		
		
end Behavioral;

