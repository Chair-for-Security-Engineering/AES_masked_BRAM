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

ENTITY KeySchedule is
    GENERIC ( ShareNumber                     : integer );
    PORT ( clk : in  STD_LOGIC;
			  ShowRcon : in  STD_LOGIC;
           Rcon : in  STD_LOGIC_VECTOR (7 downto 0);
           S_key : in  STD_LOGIC_VECTOR (7 downto 0);
           K0 : in  STD_LOGIC_VECTOR (7 downto 0);
			  Key_forCipherText : out  STD_LOGIC_VECTOR (7 downto 0);
           Key_out : out  STD_LOGIC_VECTOR (7 downto 0));
END KeySchedule;

architecture Behavioral of KeySchedule is

begin

	GenShareNumber1: IF ShareNumber = 1 GENERATE
		Key_out 			<= S_key xor K0 xor Rcon;
		Key_forCipherText <= S_key xor K0 xor Rcon;
	END GENERATE;
	
	GenShareNumber2: IF ShareNumber = 2 GENERATE
		Key_out 			<= S_key xor K0;
		Key_forCipherText <= S_key xor K0;
	
	END GENERATE;
	 
end Behavioral;

