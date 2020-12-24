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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SBox IS
	GENERIC ( size  : POSITIVE);
	PORT ( clk 	 	 : in  STD_LOGIC;
           rst 	 : in  STD_LOGIC;
           sel 	 : in  STD_LOGIC;
           EN 		 : in  STD_LOGIC;
           Dec 	 : in  STD_LOGIC;
			  input0  : in  STD_LOGIC_VECTOR (8*size*2-1 downto 0);
           input1  : in  STD_LOGIC_VECTOR (8*size*2-1 downto 0);
           r 		 : in  STD_LOGIC_VECTOR (8*size*2-1 downto 0);
           output0 : out STD_LOGIC_VECTOR (8*size*2-1 downto 0);
           output1 : out STD_LOGIC_VECTOR (8*size*2-1 downto 0));
END SBox;

ARCHITECTURE behavioral OF SBox IS
BEGIN

	GEN :
	FOR i IN 0 TO size-1 GENERATE
		Masked_Sbox_BRAM: ENTITY work.Sbox_BRAM 
		PORT MAP(
			clk 		=> clk,
			rst 		=> rst,
			sel 		=> sel,
			EN 		=> EN,
			EncDec	=> Dec,
			input0 	=> input0((2*i+1)*8-1 downto 2*i*8),
			input1 	=> input1((2*i+1)*8-1 downto 2*i*8),
			input2 	=> input0((2*i+2)*8-1 downto (2*i+1)*8),
			input3 	=> input1((2*i+2)*8-1 downto (2*i+1)*8),
			r 			=> r((i+1)*16-1    downto i*16),
			output0 	=> output0((2*i+1)*8-1 downto 2*i*8),
			output1 	=> output1((2*i+1)*8-1 downto 2*i*8),
			output2 	=> output0((2*i+2)*8-1 downto (2*i+1)*8),
			output3 	=> output1((2*i+2)*8-1 downto (2*i+1)*8));
	END GENERATE;
			
END behavioral;
