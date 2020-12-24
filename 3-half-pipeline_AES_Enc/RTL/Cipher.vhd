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
	 Generic (sbox_latency : integer := 5);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           InputData0 	: in  STD_LOGIC_VECTOR (63 downto 0);
           InputData1 	: in  STD_LOGIC_VECTOR (63 downto 0);
           Key0 			: in  STD_LOGIC_VECTOR (63 downto 0);
           Key1 			: in  STD_LOGIC_VECTOR (63 downto 0);
           r    			: in  STD_LOGIC_VECTOR (63 downto 0);
           OutputData0 	: out  STD_LOGIC_VECTOR (63 downto 0);
           OutputData1 	: out  STD_LOGIC_VECTOR (63 downto 0);
           done 			: out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
		constant SboxTable : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16";
	---------------------------- 
	-- Encryption Process ------
	signal SboxInput0							: STD_LOGIC_VECTOR(63 downto 0);
	signal SBoxOutput0						: STD_LOGIC_VECTOR(63 downto 0);

	signal SboxInput1							: STD_LOGIC_VECTOR(63 downto 0);
	signal SBoxOutput1						: STD_LOGIC_VECTOR(63 downto 0);
	
	---------------------------- 
	-- Key Schedule ------------
	signal KeySboxInput0						: STD_LOGIC_VECTOR(63 downto 0);
	signal KeySboxInput1						: STD_LOGIC_VECTOR(63 downto 0);
	
	
	signal SboxOutputDebug					: STD_LOGIC_VECTOR(63 downto 0);
	signal SboxInputDebug					: STD_LOGIC_VECTOR(63 downto 0);

	---------------------------- 
	-- Control Logic -----------
	signal FinalRound							: STD_LOGIC;
	signal KeyRegEn							: STD_LOGIC;
	signal StateEN								: STD_LOGIC;
	signal DoSR									: STD_LOGIC;
	signal SboxInputSelcetor				: STD_LOGIC;
	signal LoadKeySchedule					: STD_LOGIC;
	signal KeyMuxSel							: STD_LOGIC;
	signal ShowRcon							: STD_LOGIC;
	signal InputMuxSel						: STD_LOGIC;
	signal Rcon									: STD_LOGIC_VECTOR(7 downto 0);
	
begin
	
	OutputData0 		<= SboxInput0;
	OutputData1 		<= SboxInput1;
	
	Round0: ENTITY work.round
	PORT MAP(
		clk 				=> clk,
		rst 				=> rst,
		FinalRound		=> FinalRound,
		KeyRegEn			=> KeyRegEn,
		DoSR				=> DoSR,
		KeyMuxSel		=> KeyMuxSel,
		
		InputMuxSel			=> InputMuxSel,
		StateEN				=> StateEN,
		SboxInputSelcetor	=> SboxInputSelcetor,
		LoadKeySchedule		=> LoadKeySchedule,
		ShowRcon			=> ShowRcon,
		
		Rcon				=> Rcon,
		InputData 			=> InputData0,
		InputKey 			=> Key0,
		SboxInput			=> SboxInput0,
		SBoxOutput			=> SBoxOutput0);
		
	Round1: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		InputMuxSel			=> InputMuxSel,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		KeyMuxSel			=> KeyMuxSel,
		StateEN				=> StateEN,
		SboxInputSelcetor	=> SboxInputSelcetor,
		LoadKeySchedule	=> LoadKeySchedule,
		DoSR					=> DoSR,
		ShowRcon				=> ShowRcon,
		Rcon					=> (others => '0'),
		InputData 			=> InputData1,
		InputKey				=> Key1,
		SboxInput			=> SboxInput1,
		SBoxOutput			=> SBoxOutput1);
	
	Masked_Sbox_BRAM: ENTITY work.Sbox
	GENERIC Map ( size => 4)
	PORT MAP(
		clk 		=> clk,
		rst 		=> '0',
		sel 		=> '0',
		EN	 		=> '1',
		input0 	=> SboxInput0,
		input1 	=> SboxInput1,
		r 			=> r,
		output0 	=> SBoxOutput0,
		output1 	=> SBoxOutput1 );

	---------------------------- 
	------ FSM -----------------
	
	Controller_FSM: ENTITY work.Controller 
	Generic MAP (sbox_latency => sbox_latency)
	PORT MAP(
		clk 				=> clk,
		rst			 	=> rst,
		InputMuxSel			=> InputMuxSel,
		KeyMuxSel		=> KeyMuxSel,
		FinalRound 		=> FinalRound,
		StateEN				=> StateEN,
		SboxInputSelcetor	=> SboxInputSelcetor,
		LoadKeySchedule		=> LoadKeySchedule,
		DoSR				=> DoSR,
		ShowRcon			=> ShowRcon,
		Rcon 				=> Rcon,
		KeyRegEn 		=> KeyRegEn,
		done 				=> done
	);
	
end Behavioral;

