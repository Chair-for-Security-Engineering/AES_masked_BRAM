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


entity SharesGen is
    Port ( input0 : in  STD_LOGIC_VECTOR (7 downto 0);
           input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           Share0 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share1 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share2 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share3 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share4 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share5 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share6 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share7 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share8 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share9 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share10 : out  STD_LOGIC_VECTOR (7 downto 0);
           Share11 : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end SharesGen;

architecture Behavioral of SharesGen is

	signal a 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal b 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal c 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal d 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal e 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal f 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal g 							: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal h 							: STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

	a <= input1(0) & input0(0);
	b <= input1(1) & input0(1);
	c <= input1(2) & input0(2);
	d <= input1(3) & input0(3);
	e <= input1(4) & input0(4);
	f <= input1(5) & input0(5);
	g <= input1(6) & input0(6);
	h <= input1(7) & input0(7);
	
	Share0 <= h(0) & g(0) & f(1) & e(1) & d(0) & c(0) & b(0) & a(0);
	Share1 <= h(1) & g(1) & f(0) & e(1) & d(1) & c(0) & b(0) & a(0);
	Share2 <= h(1) & g(0) & f(0) & e(0) & d(0) & c(1) & b(0) & a(0);
	Share3 <= h(0) & g(1) & f(1) & e(0) & d(1) & c(1) & b(0) & a(0);
	Share4 <= h(1) & g(0) & f(1) & e(0) & d(1) & c(0) & b(1) & a(0);
	Share5 <= h(0) & g(1) & f(0) & e(1) & d(0) & c(1) & b(1) & a(0);
	Share6 <= h(0) & g(1) & f(0) & e(0) & d(0) & c(0) & b(0) & a(1);
	Share7 <= h(1) & g(0) & f(1) & e(1) & d(1) & c(1) & b(0) & a(1);
	Share8 <= h(1) & g(1) & f(1) & e(1) & d(0) & c(0) & b(1) & a(1);
	Share9 <= h(0) & g(0) & f(0) & e(1) & d(1) & c(0) & b(1) & a(1);
	Share10<= h(0) & g(0) & f(1) & e(0) & d(0) & c(1) & b(1) & a(1);
	Share11<= h(1) & g(1) & f(0) & e(0) & d(1) & c(1) & b(1) & a(1);

end Behavioral;

