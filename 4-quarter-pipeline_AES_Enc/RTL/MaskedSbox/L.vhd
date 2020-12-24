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

ENTITY L IS

	PORT ( 
			 Remasked_Y0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y5 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y6 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y8 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y9 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y10 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 Remasked_Y11 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 r			 : IN STD_LOGIC_VECTOR (7 DOWNTO 6);
			 output0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			 output1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			 
			 );
END L;

architecture Behavioral of L is

	signal L0 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal L1 							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Modified_Y12 				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Modified_Y13 				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal r6, r7		 				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal r6_xor_r7		 			: STD_LOGIC_VECTOR (7 DOWNTO 0);

begin

	r6 <= r(6) & '0'  & r(6) & r(6) & r(6) & r(6) & r(6) & r(6);
	r7 <= '0'  & r(7) & r(7) & r(7) & r(7) & r(7) & r(7) & r(7);
	r6_xor_r7 <= r6 xor r7;
 
	Compress0: ENTITY work.XOR_7n
	GENERIC Map ( size => 8, count => 1)
	PORT Map ( Remasked_Y0, Remasked_Y1, Remasked_Y2, Remasked_Y3, Remasked_Y4, Remasked_Y5, r6_xor_r7, L0 );
	
	Compress1: ENTITY work.XOR_7n
	GENERIC Map ( size => 8, count => 1)
	PORT Map ( Remasked_Y6, Remasked_Y7, Remasked_Y8, Remasked_Y9, Remasked_Y10, Remasked_Y11, r6_xor_r7, L1 );
	
	output0 <= L0;
	output1 <= L1;
	
	
end Behavioral;

