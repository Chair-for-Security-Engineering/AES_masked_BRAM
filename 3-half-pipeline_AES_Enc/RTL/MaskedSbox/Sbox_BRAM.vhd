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

entity Sbox_BRAM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sel : in  STD_LOGIC;
		     EN : in  STD_LOGIC;
		     EncDec : in  STD_LOGIC := '0'; -- Enc:0
           input0 : in  STD_LOGIC_VECTOR (7 downto 0);
           input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           input2 : in  STD_LOGIC_VECTOR (7 downto 0);
           input3 : in  STD_LOGIC_VECTOR (7 downto 0);
           r : in  STD_LOGIC_VECTOR (15 downto 0);
           output0 : out  STD_LOGIC_VECTOR (7 downto 0);
           output1 : out  STD_LOGIC_VECTOR (7 downto 0);
           output2 : out  STD_LOGIC_VECTOR (7 downto 0);
           output3 : out  STD_LOGIC_VECTOR (7 downto 0));
end Sbox_BRAM;

architecture Behavioral of Sbox_BRAM is
	signal r2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal a 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal b 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal c 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal d 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal e 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal f 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal g 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal h 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	
	signal Share0 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share1 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share3 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share4 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share5 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share6 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share7 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share8 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share9 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share10 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share11 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share12 						: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal Share13 						: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	signal Share0_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share1_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share2_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share3_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share4_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share5_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share6_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share7_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share8_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share9_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share10_2 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share11_2 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Share12_2 						: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal Share13_2 						: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	signal Y0		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y1		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y2		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y3		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y4		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y5		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y6		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y7		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y8		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y9		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y10		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y11		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y12		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Y13		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	
	signal Z0		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z1		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z2		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z3		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z4		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z5		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z6		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z7		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z8		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z9		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z10		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z11		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z12		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal Z13		 						: STD_LOGIC_VECTOR (15 DOWNTO 0);
	
	signal ADDRA_0 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_0 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_1 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_1 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_3 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_3 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_4 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_4 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_5 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_5 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_6 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_6 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	signal x49_ADDRA_0 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_0 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_1 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_1 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_3 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_3 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_4 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_4 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_5 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_5 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_6 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_6 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	
	signal ADDRA_0_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_0_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_1_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_1_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_2_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_2_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_3_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_3_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_4_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_4_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_5_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_5_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRA_6_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal ADDRB_6_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	signal x49_ADDRA_0_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_0_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_1_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_1_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_2_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_2_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_3_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_3_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_4_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_4_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_5_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_5_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRA_6_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal x49_ADDRB_6_2 						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	signal ADDR_FullOne						: STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	signal x26_out0 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x26_out1 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x26_out2 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x26_out3 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal S_out0	 						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal S_out1 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal S_out2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal S_out3 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal x49_a 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_b 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_c 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_d 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_e 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_f 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_g 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal x49_h 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	
	signal x49_Share0 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share1 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share3 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share4 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share5 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share6 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share7 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share8 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share9 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share10 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share11 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share12 							: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal x49_Share13 							: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	signal x49_Share0_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share1_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share2_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share3_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share4_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share5_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share6_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share7_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share8_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share9_2 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share10_2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share11_2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal x49_Share12_2							: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal x49_Share13_2							: STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

	r2 <= r(15 downto 8);

	SharesGen_x26_input01: ENTITY work.SharesGen 
	PORT MAP(
		input0 => input0 ,
		input1 => input1 ,
		Share0 => Share0 ,
		Share1 => Share1 ,
		Share2 => Share2 ,
		Share3 => Share3 ,
		Share4 => Share4 ,
		Share5 => Share5 ,
		Share6 => Share6 ,
		Share7 => Share7 ,
		Share8 => Share8 ,
		Share9 => Share9 ,
		Share10 =>Share10 ,
		Share11 =>Share11 );
		
	SharesGen_x49_input01: ENTITY work.SharesGen 
	PORT MAP(
		input0 => x26_out0 ,
		input1 => x26_out1 ,
		Share0 => x49_Share0 ,
		Share1 => x49_Share1 ,
		Share2 => x49_Share2 ,
		Share3 => x49_Share3 ,
		Share4 => x49_Share4 ,
		Share5 => x49_Share5 ,
		Share6 => x49_Share6 ,
		Share7 => x49_Share7 ,
		Share8 => x49_Share8 ,
		Share9 => x49_Share9 ,
		Share10 =>x49_Share10 ,
		Share11 =>x49_Share11  );
		
	SharesGen_x26_input23: ENTITY work.SharesGen 
	PORT MAP(
		input0 => input2 ,
		input1 => input3 ,
		Share0 => Share0_2 ,
		Share1 => Share1_2 ,
		Share2 => Share2_2 ,
		Share3 => Share3_2 ,
		Share4 => Share4_2 ,
		Share5 => Share5_2 ,
		Share6 => Share6_2 ,
		Share7 => Share7_2 ,
		Share8 => Share8_2 ,
		Share9 => Share9_2 ,
		Share10 =>Share10_2 ,
		Share11 =>Share11_2  );
		
	SharesGen_x49_input23: ENTITY work.SharesGen 
	PORT MAP(
		input0 => x26_out2 ,
		input1 => x26_out3 ,
		Share0 => x49_Share0_2 ,
		Share1 => x49_Share1_2 ,
		Share2 => x49_Share2_2,
		Share3 => x49_Share3_2 ,
		Share4 => x49_Share4_2 ,
		Share5 => x49_Share5_2 ,
		Share6 => x49_Share6_2 ,
		Share7 => x49_Share7_2 ,
		Share8 => x49_Share8_2 ,
		Share9 => x49_Share9_2 ,
		Share10 =>x49_Share10_2 ,
		Share11 =>x49_Share11_2 );
	
	
	
	--------------------------------------
	ADDRA_0 					<= EncDec & r(0) & Share0;
	ADDRB_0 					<= EncDec & r(1) & Share1;
	
	x49_ADDRA_0 			<= EncDec & r(0) & x49_Share0;
	x49_ADDRB_0 			<= EncDec & r(1) & x49_Share1;
	----
	ADDRA_0_2 				<= EncDec & r2(0) & Share0_2;
	ADDRB_0_2 				<= EncDec & r2(1) & Share1_2;
	
	x49_ADDRA_0_2 			<= EncDec & r2(0) & x49_Share0_2;
	x49_ADDRB_0_2 			<= EncDec & r2(1) & x49_Share1_2;



	Share_0: ENTITY work.BRAM_0_x26
	PORT MAP(
		ADDRA => ADDRA_0,
		ADDRB => ADDRA_0_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y0(7 DOWNTO 0),
		DOB => Z0(7 DOWNTO 0) );
		
	Share_1: ENTITY work.BRAM_1_x26
	PORT MAP(
		ADDRA => ADDRB_0,
		ADDRB => ADDRB_0_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y1(7 DOWNTO 0),
		DOB => Z1(7 DOWNTO 0));
	
	x49_Share_0: ENTITY work.BRAM_0_x49
	PORT MAP(
		ADDRA => x49_ADDRA_0,
		ADDRB => x49_ADDRA_0_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y0(15 DOWNTO 8),
		DOB => Z0(15 DOWNTO 8) );
		
	x49_Share_1: ENTITY work.BRAM_1_x49
	PORT MAP(
		ADDRA => x49_ADDRB_0,
		ADDRB => x49_ADDRB_0_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y1(15 DOWNTO 8),
		DOB => Z1(15 DOWNTO 8) );
	--------------------------------------
	ADDRA_1 			<= EncDec & r(2) & Share2;
	ADDRB_1 			<= EncDec & r(3) & Share3;
	
	x49_ADDRA_1 		<= EncDec & r(2) & x49_Share2;
	x49_ADDRB_1 		<= EncDec & r(3) & x49_Share3;
	----
	ADDRA_1_2 			<= EncDec & r2(2) & Share2_2;
	ADDRB_1_2 			<= EncDec & r2(3) & Share3_2;
	
	x49_ADDRA_1_2 		<= EncDec & r2(2) & x49_Share2_2;
	x49_ADDRB_1_2 		<= EncDec & r2(3) & x49_Share3_2;

	Share_2: ENTITY work.BRAM_2_x26
	PORT MAP(
		ADDRA => ADDRA_1,
		ADDRB => ADDRA_1_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y2(7 DOWNTO 0),
		DOB => Z2(7 DOWNTO 0) );
		
	Share_3: ENTITY work.BRAM_3_x26
	PORT MAP(
		ADDRA => ADDRB_1,
		ADDRB => ADDRB_1_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y3(7 DOWNTO 0),
		DOB => Z3(7 DOWNTO 0) );
		
	x49_Share_2: ENTITY work.BRAM_2_x49
	PORT MAP(
		ADDRA => x49_ADDRA_1,
		ADDRB => x49_ADDRA_1_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y2(15 DOWNTO 8),
		DOB => Z2(15 DOWNTO 8));
		
	x49_Share_3: ENTITY work.BRAM_3_x49
	PORT MAP(
		ADDRA => x49_ADDRB_1,
		ADDRB => x49_ADDRB_1_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y3(15 DOWNTO 8),
		DOB => Z3(15 DOWNTO 8) );
	--------------------------------------
	ADDRA_2 			<= EncDec & r(4) & Share4;
	ADDRB_2 			<= EncDec & r(5) & Share5;
	
	x49_ADDRA_2 		<= EncDec & r(4) & x49_Share4;
	x49_ADDRB_2 		<= EncDec & r(5) & x49_Share5;
	----
	ADDRA_2_2 			<= EncDec & r2(4) & Share4_2;
	ADDRB_2_2 			<= EncDec & r2(5) & Share5_2;
	
	x49_ADDRA_2_2 		<= EncDec & r2(4) & x49_Share4_2;
	x49_ADDRB_2_2 		<= EncDec & r2(5) & x49_Share5_2;

	Share_4: ENTITY work.BRAM_4_x26
	PORT MAP(
		ADDRA => ADDRA_2,
		ADDRB => ADDRA_2_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y4(7 DOWNTO 0),
		DOB => Z4(7 DOWNTO 0) );
		
	Share_5: ENTITY work.BRAM_5_x26
	PORT MAP(
		ADDRA => ADDRB_2,
		ADDRB => ADDRB_2_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y5(7 DOWNTO 0),
		DOB => Z5(7 DOWNTO 0) );
		
	x49_Share_4: ENTITY work.BRAM_4_x49
	PORT MAP(
		ADDRA => x49_ADDRA_2,
		ADDRB => x49_ADDRA_2_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y4(15 DOWNTO 8),
		DOB => Z4(15 DOWNTO 8) );
		
	x49_Share_5: ENTITY work.BRAM_5_x49
	PORT MAP(
		ADDRA => x49_ADDRB_2,
		ADDRB => x49_ADDRB_2_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y5(15 DOWNTO 8),
		DOB => Z5(15 DOWNTO 8) );
	--------------------------------------
	ADDRA_3 			<= EncDec & r(0) & Share6;
	ADDRB_3			<= EncDec & r(1) & Share7;
	
	x49_ADDRA_3 		<= EncDec & r(0) & x49_Share6;
	x49_ADDRB_3 		<= EncDec & r(1) & x49_Share7;
	----
	ADDRA_3_2 			<= EncDec & r2(0) & Share6_2;
	ADDRB_3_2			<= EncDec & r2(1) & Share7_2;
	
	x49_ADDRA_3_2 		<= EncDec & r2(0) & x49_Share6_2;
	x49_ADDRB_3_2 		<= EncDec & r2(1) & x49_Share7_2;
	
	Share_6: ENTITY work.BRAM_6_x26
	PORT MAP(
		ADDRA => ADDRA_3,
		ADDRB => ADDRA_3_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y6(7 DOWNTO 0),
		DOB => Z6(7 DOWNTO 0) );
		
	Share_7: ENTITY work.BRAM_7_x26
	PORT MAP(
		ADDRA => ADDRB_3,
		ADDRB => ADDRB_3_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y7(7 DOWNTO 0),
		DOB => Z7(7 DOWNTO 0) );
		
	x49_Share_6: ENTITY work.BRAM_6_x49
	PORT MAP(
		ADDRA => x49_ADDRA_3,
		ADDRB => x49_ADDRA_3_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y6(15 DOWNTO 8),
		DOB => Z6(15 DOWNTO 8) );
		
	x49_Share_7: ENTITY work.BRAM_7_x49
	PORT MAP(
		ADDRA => x49_ADDRB_3,
		ADDRB => x49_ADDRB_3_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y7(15 DOWNTO 8),
		DOB => Z7(15 DOWNTO 8) );
	--------------------------------------
	ADDRA_4 			<= EncDec & r(2) & Share8;
	ADDRB_4 			<= EncDec & r(3) & Share9;
	
	x49_ADDRA_4 		<= EncDec & r(2) & x49_Share8;
	x49_ADDRB_4 		<= EncDec & r(3) & x49_Share9;
	----
	ADDRA_4_2 			<= EncDec & r2(2) & Share8_2;
	ADDRB_4_2 			<= EncDec & r2(3) & Share9_2;
	
	x49_ADDRA_4_2 		<= EncDec & r2(2) & x49_Share8_2;
	x49_ADDRB_4_2 		<= EncDec & r2(3) & x49_Share9_2;

	Share_8: ENTITY work.BRAM_8_x26
	PORT MAP(
		ADDRA => ADDRA_4,
		ADDRB => ADDRA_4_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y8(7 DOWNTO 0),
		DOB => Z8(7 DOWNTO 0) );
		
	Share_9: ENTITY work.BRAM_9_x26
	PORT MAP(
		ADDRA => ADDRB_4,
		ADDRB => ADDRB_4_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y9(7 DOWNTO 0),
		DOB => Z9(7 DOWNTO 0) );
		
	x49_Share_8: ENTITY work.BRAM_8_x49
	PORT MAP(
		ADDRA => x49_ADDRA_4,
		ADDRB => x49_ADDRA_4_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y8(15 DOWNTO 8),
		DOB => Z8(15 DOWNTO 8) );
		
	x49_Share_9: ENTITY work.BRAM_9_x49
	PORT MAP(
		ADDRA => x49_ADDRB_4,
		ADDRB => x49_ADDRB_4_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y9(15 DOWNTO 8),
		DOB => Z9(15 DOWNTO 8) );
	--------------------------------------
	ADDRA_5 			<= EncDec & r(4) & Share10;
	ADDRB_5 			<= EncDec & r(5) & Share11;

	x49_ADDRA_5 		<= EncDec & r(4) & x49_Share10;
	x49_ADDRB_5 		<= EncDec & r(5) & x49_Share11;
	----
	ADDRA_5_2 			<= EncDec & r2(4) & Share10_2;
	ADDRB_5_2 			<= EncDec & r2(5) & Share11_2;

	x49_ADDRA_5_2 		<= EncDec & r2(4) & x49_Share10_2;
	x49_ADDRB_5_2 		<= EncDec & r2(5) & x49_Share11_2;
	
	Share_10: ENTITY work.BRAM_10_x26
	PORT MAP(
		ADDRA => ADDRA_5,
		ADDRB => ADDRA_5_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y10(7 DOWNTO 0),
		DOB => Z10(7 DOWNTO 0) );
		
	Share_11: ENTITY work.BRAM_11_x26
	PORT MAP(
		ADDRA => ADDRB_5,
		ADDRB => ADDRB_5_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y11(7 DOWNTO 0),
		DOB => Z11(7 DOWNTO 0) );
		
	x49_Share_10: ENTITY work.BRAM_10_x49
	PORT MAP(
		ADDRA => x49_ADDRA_5,
		ADDRB => x49_ADDRA_5_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y10(15 DOWNTO 8),
		DOB => Z10(15 DOWNTO 8) );
		
	x49_Share_11: ENTITY work.BRAM_11_x49
	PORT MAP(
		ADDRA => x49_ADDRB_5,
		ADDRB => x49_ADDRB_5_2,
		clk => clk,
		rst => rst, EN	=> EN,
		DOA => Y11(15 DOWNTO 8),
		DOB => Z11(15 DOWNTO 8) );
	--------------------------------------
	
	Inst_L_x26: ENTITY work.L
	PORT MAP(
		Remasked_Y0 => Y0(7 downto 0),
		Remasked_Y1 => Y1(7 downto 0),
		Remasked_Y2 => Y2(7 downto 0),
		Remasked_Y3 => Y3(7 downto 0),
		Remasked_Y4 => Y4(7 downto 0),
		Remasked_Y5 => Y5(7 downto 0),
		Remasked_Y6 => Y6(7 downto 0),
		Remasked_Y7 => Y7(7 downto 0),
		Remasked_Y8 => Y8(7 downto 0),
		Remasked_Y9 => Y9(7 downto 0),
		Remasked_Y10 => Y10(7 downto 0),
		Remasked_Y11 => Y11(7 downto 0),
		r				 => r(7 downto 6),
		output0 => x26_out0,
		output1 => x26_out1);
		
	Inst_L_x49: ENTITY work.L
	PORT MAP(
		Remasked_Y0 => Y0(15 downto 8),
		Remasked_Y1 => Y1(15 downto 8),
		Remasked_Y2 => Y2(15 downto 8),
		Remasked_Y3 => Y3(15 downto 8),
		Remasked_Y4 => Y4(15 downto 8),
		Remasked_Y5 => Y5(15 downto 8),
		Remasked_Y6 => Y6(15 downto 8),
		Remasked_Y7 => Y7(15 downto 8),
		Remasked_Y8 => Y8(15 downto 8),
		Remasked_Y9 => Y9(15 downto 8),
		Remasked_Y10 => Y10(15 downto 8),
		Remasked_Y11 => Y11(15 downto 8),
		r				 => r(7 downto 6),
		output0 => S_out0,
		output1 => S_out1);
		
	Inst_L_x26_2: ENTITY work.L
	PORT MAP(
		Remasked_Y0 => Z0(7 downto 0),
		Remasked_Y1 => Z1(7 downto 0),
		Remasked_Y2 => Z2(7 downto 0),
		Remasked_Y3 => Z3(7 downto 0),
		Remasked_Y4 => Z4(7 downto 0),
		Remasked_Y5 => Z5(7 downto 0),
		Remasked_Y6 => Z6(7 downto 0),
		Remasked_Y7 => Z7(7 downto 0),
		Remasked_Y8 => Z8(7 downto 0),
		Remasked_Y9 => Z9(7 downto 0),
		Remasked_Y10 => Z10(7 downto 0),
		Remasked_Y11 => Z11(7 downto 0),
		r				 => r2(7 downto 6),
		output0 => x26_out2,
		output1 => x26_out3);
		
	Inst_L_x49_2: ENTITY work.L
	PORT MAP(
		Remasked_Y0 => Z0(15 downto 8),
		Remasked_Y1 => Z1(15 downto 8),
		Remasked_Y2 => Z2(15 downto 8),
		Remasked_Y3 => Z3(15 downto 8),
		Remasked_Y4 => Z4(15 downto 8),
		Remasked_Y5 => Z5(15 downto 8),
		Remasked_Y6 => Z6(15 downto 8),
		Remasked_Y7 => Z7(15 downto 8),
		Remasked_Y8 => Z8(15 downto 8),
		Remasked_Y9 => Z9(15 downto 8),
		Remasked_Y10 => Z10(15 downto 8),
		Remasked_Y11 => Z11(15 downto 8),
		r				 => r2(7 downto 6),
		output0 => S_out2,
		output1 => S_out3);
		
	output0 <= S_out0;
	output1 <= S_out1;
	output2 <= S_out2;
	output3 <= S_out3;
	
end Behavioral;

