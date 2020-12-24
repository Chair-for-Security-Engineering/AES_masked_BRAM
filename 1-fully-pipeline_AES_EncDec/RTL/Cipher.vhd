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
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
			  Dec				: in  STD_LOGIC;
           InputData0 	: in  STD_LOGIC_VECTOR (127 downto 0);
           InputData1 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Key0 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Key1 			: in  STD_LOGIC_VECTOR (127 downto 0);
           r    			: in  STD_LOGIC_VECTOR (159 downto 0);
           OutputData0 	: out STD_LOGIC_VECTOR (127 downto 0);
           OutputData1 	: out STD_LOGIC_VECTOR (127 downto 0);
           done 			: out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
		
	---------------------------- 
	-- Encryption Process ------
	signal AddRoundKeyOutput0				: STD_LOGIC_VECTOR(127 downto 0);
	signal AddRoundKeyOutput1				: STD_LOGIC_VECTOR(127 downto 0);

	signal SBoxOutput0						: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput1						: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- 
	-- Key Schedule ------------
	signal KeySboxInput0						: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeySboxInput1						: STD_LOGIC_VECTOR( 31 downto 0);

	signal KeySboxOutput0					: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeySboxOutput1					: STD_LOGIC_VECTOR( 31 downto 0);

	---------------------------- 
	-- Control Logic -----------
	signal FirstKey							: STD_LOGIC;
	signal FinalRound							: STD_LOGIC;
	signal KeyRegEn							: STD_LOGIC;
	signal Rcon									: STD_LOGIC_VECTOR(7 downto 0);
	
begin

	OutputData0 <= AddRoundKeyOutput0;
	OutputData1 <= AddRoundKeyOutput1;
	
	Round0: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		Dec					=> Dec,
		FirstKey				=> FirstKey,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		Rcon					=> Rcon,
		InputData 			=> InputData0,
		InputKey 			=> Key0,
		AddRoundKeyOutput	=> AddRoundKeyOutput0,
		SBoxOutput			=> SBoxOutput0,
		KeySboxInput		=> KeySboxInput0,
		KeySboxOutput		=> KeySboxOutput0);
		
	Round1: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		Dec					=> Dec,
		FirstKey				=> FirstKey,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		Rcon					=> (others => '0'),
		InputData 			=> InputData1,
		InputKey				=> Key1,
		AddRoundKeyOutput	=> AddRoundKeyOutput1,
		SBoxOutput			=> SBoxOutput1,
		KeySboxInput		=> KeySboxInput1,
		KeySboxOutput		=> KeySboxOutput1);
	
	Masked_Sbox_BRAM: ENTITY work.Sbox
	GENERIC Map ( size => 8)
	PORT MAP(
		clk 		=> clk,
		rst 		=> '0',
		sel 		=> '0',
		EN	 		=> '1',
		Dec		=> Dec,
		input0 	=> AddRoundKeyOutput0,
		input1 	=> AddRoundKeyOutput1,
		r 			=> r(127 downto 0),
		output0 	=> SBoxOutput0,
		output1 	=> SBoxOutput1 );

	Masked_KeySbox_BRAM: ENTITY work.Sbox 
	GENERIC Map ( size => 2)
	PORT MAP(
		clk 		=> clk,
		rst 		=> '0',
		sel 		=> '0',
		EN	 		=> '1',
		Dec		=> '0',
		input0 	=> KeySboxInput0,
		input1 	=> KeySboxInput1,
		r 			=> r(159 downto 128),
		output0 	=> KeySboxOutput0,
		output1 	=> KeySboxOutput1);	
	
	---------------------------- 
	------ FSM -----------------
	
	Controller_FSM: ENTITY work.Controller 
	Generic MAP (sbox_latency => 5)
	PORT MAP(
		clk 				=> clk,
		rst			 	=> rst,
		Dec				=> Dec,
		FirstKey			=> FirstKey,
		FinalRound 		=> FinalRound,
		Rcon 				=> Rcon,
		KeyRegEn 		=> KeyRegEn,
		done 				=> done
	);
	
end Behavioral;

