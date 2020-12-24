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


entity Cipher is
    Port ( clk 	: in  STD_LOGIC;
           rst 	: in  STD_LOGIC;
			  r 		: in  STD_LOGIC_VECTOR (7 downto 0);
           input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           input2 : in  STD_LOGIC_VECTOR (7 downto 0);
           key1 	: in  STD_LOGIC_VECTOR (7 downto 0);
           key2 	: in  STD_LOGIC_VECTOR (7 downto 0);
           output1: out STD_LOGIC_VECTOR (7 downto 0);
           output2: out STD_LOGIC_VECTOR (7 downto 0);
           done 	: out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	COMPONENT Controller
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		ShowRcon : OUT std_logic;          
		DoSR : OUT std_logic;
		DoMC : OUT std_logic;
		DoKeySbox : OUT std_logic;
		Done : OUT std_logic;
		CorrectCiphertext : OUT std_logic;
		output_sel : OUT std_logic;
		KeyIn_sel : OUT std_logic_vector(1 downto 0);
		SboxIn_sel : OUT std_logic_vector(1 downto 0);
		Rcon : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	

	signal K_ciphertext1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal K_ciphertext2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal InputXorKey1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal InputXorKey2							: STD_LOGIC_VECTOR (7 DOWNTO 0);

	signal SboxIn1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxIn2									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxOut1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxOut2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	
	signal KeyIn1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyIn2									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal K0_out1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyOut1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyToSbox1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyForSchedule1					   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal K0_out2									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyOut2									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyToSbox2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyForSchedule2					   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal KeySchedule_out1					   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeySchedule_out2					   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	
	signal S0_output1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal S0_output2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal K0_xor_K12_1	                  : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal K0_xor_K12_2                    : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal MCout_xor_SKey_1						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal MCout_xor_SKey_2						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal MCout_xor_K0_xor_K12_1				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal MCout_xor_K0_xor_K12_2				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal StateIn1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal StateIn2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal DoSR										: STD_LOGIC;
	signal DoMC									   : STD_LOGIC;
	signal DoAffineInvOnKey1				   : STD_LOGIC;
	signal DoKeySbox								: STD_LOGIC;

	signal CorrectCiphertext				   : STD_LOGIC;
	signal Output_Sel								: STD_LOGIC;
	signal MC_hold									: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	signal KeyIn_sel								: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal SboxIn_sel								: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal Rcon_internal							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Rcon_1 									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Rcon_2				 					: STD_LOGIC_VECTOR (7 DOWNTO 0);
	-----
	signal ShowRcon								: STD_LOGIC;
	
BEGIN
	
	InputXorKey1 				<= input1 xor key1;
	InputXorKey2 				<= input2 xor key2;
	
	K0_xor_K12_1 				<= K0_out1 xor KeyForSchedule1;
	K0_xor_K12_2 				<= K0_out2 xor KeyForSchedule2;
	
	MCout_xor_SKey_1 			<= S0_output1 xor KeySchedule_out1;
	MCout_xor_SKey_2 			<= S0_output2 xor KeySchedule_out2;
	
	MCout_xor_K0_xor_K12_1 	<= S0_output1 xor K0_xor_K12_1;
	MCout_xor_K0_xor_K12_2 	<= S0_output2 xor K0_xor_K12_2;
		
	output1 <= SboxIn1;
	output2 <= SboxIn2;
	------------------------------- Rcon Condition -------------------------------
	
	Rcon_1 <= Rcon_internal  when (ShowRcon = '1') else x"00";
	Rcon_2 <= "00000000";
	------------------------------- State input Condition -------------------------------

	StateIn1 <= SboxOut1;
	StateIn2 <= SboxOut2;

	------------------------------- Sbox input Condition -------------------------------
	SboxInput_process: process (InputXorKey1, InputXorKey2, KeyToSbox1, KeyToSbox2, MCout_xor_SKey_1,
										 MCout_xor_SKey_2, MCout_xor_K0_xor_K12_1, MCout_xor_K0_xor_K12_2, SboxIn_sel) is
	begin 
		if (SboxIn_sel = "00") then
			SboxIn1 <= InputXorKey1;
			SboxIn2 <= InputXorKey2;
		elsif (SboxIn_sel = "01") then
			SboxIn1 <= KeyToSbox1;
			SboxIn2 <= KeyToSbox2;
		elsif (SboxIn_sel = "10") then
			SboxIn1 <= MCout_xor_SKey_1;
			SboxIn2 <= MCout_xor_SKey_2;
		else
			SboxIn1 <= MCout_xor_K0_xor_K12_1;
			SboxIn2 <= MCout_xor_K0_xor_K12_2;
		end if;
	end process SboxInput_process;
		
	------------------------------- Key input Condition -------------------------------
	KeyInput_process: process (KeyIn_sel, key1, key2, KeySchedule_out1, KeySchedule_out2, K0_xor_K12_1, K0_xor_K12_2  ) is
	begin 
		if (KeyIn_sel = "00") then
			KeyIn1 <= key1;
			KeyIn2 <= key2;
		elsif (KeyIn_sel = "01") then
			KeyIn1 <= KeySchedule_out1;
			KeyIn2 <= KeySchedule_out2;
		else --if (KeyIn_sel = "10") then
			KeyIn1 <= K0_xor_K12_1;
			KeyIn2 <= K0_xor_K12_2;
		end if;
	end process KeyInput_process;

	------------------------------- Key Schedule -------------------------------
	KeySchedule_Inst1: ENTITY work.KeySchedule 
	GENERIC MAP(1)
	PORT MAP(
		clk 		=> clk,
		ShowRcon => ShowRcon,
		Rcon 		=> Rcon_1,
		S_key 	=> SboxOut1,
		K0 		=> K0_out1,
		Key_forCipherText => K_ciphertext1,
		Key_out 	=> KeySchedule_out1 );
		
	KeySchedule_Inst2: ENTITY work.KeySchedule 
	GENERIC MAP(2)
	PORT MAP(
		clk 		=> clk,
		ShowRcon => ShowRcon,
		Rcon 		=> Rcon_2,
		S_key 	=> SboxOut2,
		K0 		=> K0_out2,
		Key_forCipherText => K_ciphertext2,
		Key_out 	=> KeySchedule_out2 );
	
	
	------------------------------- State Regs -------------------------------
	DataPath_Registers_Inst1: ENTITY work.DataPath_Registers 
	GENERIC MAP(0)
	PORT MAP(
		clk => clk,
		StateIn => StateIn1,
		DoMC => DoMC,
		DoSR => DoSR,
		StateOut => S0_output1 );
		
	DataPath_Registers_Inst2: ENTITY work.DataPath_Registers 
	GENERIC MAP(1)
	PORT MAP(
		clk => clk,
		StateIn => StateIn2,
		DoMC => DoMC,
		DoSR => DoSR,
		StateOut => S0_output2 );
		
	------------------------------- Key Regs -------------------------------		
	Key_Registers_INST1: ENTITY work.Key_Registers
	GENERIC MAP(1)	
	PORT MAP(
		clk 				=> clk,
		KeyIn 			=> KeyIn1,
		DoSbox 			=> DoKeySbox,
		K0_out 			=> K0_out1,
		KeyOut 			=> KeyOut1,
		KeyToSbox 		=> KeyToSbox1,
		KeyForSchedule => KeyForSchedule1 );

	Key_Registers_INST2: ENTITY work.Key_Registers
	GENERIC MAP(2)	
	PORT MAP(
		clk 				=> clk,
		KeyIn 			=> KeyIn2,
		DoSbox 			=> DoKeySbox,
		K0_out 			=> K0_out2,
		KeyOut 			=> KeyOut2,
		KeyToSbox 		=> KeyToSbox2,
		KeyForSchedule => KeyForSchedule2 );

	------------------------------- Sbox -------------------------------
	MaskedSbox_Inst: ENTITY work.Sbox_BRAM 
	PORT MAP(
		clk 			=> clk,
		EN				=> '1',
		r 				=> r,
		input0 		=> SboxIn1,
		input1 		=> SboxIn2,
		output0 		=> SboxOut1,
		output1 		=> SboxOut2 );
		
	------------------------------- Controller -------------------------------
	Inst_Controller: Controller PORT MAP(
		clk => clk,
		rst => rst,
		ShowRcon => ShowRcon,
		DoSR => DoSR,
		DoMC => DoMC,
		DoKeySbox => DoKeySbox,
		Done => done_internal,
		CorrectCiphertext => CorrectCiphertext,
		output_sel => Output_Sel,
		KeyIn_sel => KeyIn_sel,
		SboxIn_sel => SboxIn_sel,
		Rcon => Rcon_internal
	);
		
	done <= done_internal;
		
end Behavioral;

