//-----------------------------------------------------------------
//-- COMPANY : Ruhr University Bochum
//-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de) and Amir Moradi (amir.moradi@rub.de) 
//-- DOCUMENT: [New First-Order Secure AES Performance Records](IACR Transactions on Cryptographic Hardware and Embeded Systems 2021(2))
//-- -----------------------------------------------------------------
//--
//-- Copyright (c) 2021, Aein Rezaei Shahmirzadi, Amir Moradi, 
//--
//-- All rights reserved.
//--
//-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
//-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//--
//-- Please see LICENSE and README for license and further instructions.
//--

module Cipher_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] r;
	wire [7:0] input1;
	reg  [7:0] input2;
	wire [7:0] key1;
	reg  [7:0] key2;

	// Outputs
	wire [7:0] output1;
	wire [7:0] output2;
	reg  [7:0] Plaintext;
	reg  [7:0] Key;
	wire [7:0] Ciphertext;
	wire Done;
	assign Ciphertext = output1 ^ output2;
	
	assign input1 = Plaintext ^ input2;
	assign key1 =   Key ^ key2;
	
	// Instantiate the Unit Under Test (UUT)
	Cipher uut (
		.clk(clk), 
		.rst(rst), 
		.r(r), 
		.input1(input1), 
		.input2(input2), 
		.key1(key1), 
		.key2(key2), 
		.output1(output1), 
		.output2(output2), 
		.Done(Done)
	);

	initial begin
		// Initialize Inputs
		input2 = 0;
		key2 = 0;
		r = 0;
	
		clk = 0;
		
		rst = 1;
		
		Plaintext = 8'h32;
		Key = 8'h2b;
		#200;
		
		Plaintext = 8'h43;
		Key = 8'h7e;
		#10
		Plaintext = 8'hf6;
		Key = 8'h15;
		#10
		Plaintext = 8'ha8;
		Key = 8'h16;
		#10
		Plaintext = 8'h88;
		Key = 8'h28;
		#10
		Plaintext = 8'h5a;
		Key = 8'hae;
		#10
		Plaintext = 8'h30;
		Key = 8'hd2;
		#10
		Plaintext = 8'h8d;
		Key = 8'ha6;
		#10
		Plaintext = 8'h31;
		Key = 8'hab;
		#10
		Plaintext = 8'h31;
		Key = 8'hf7;
		#10
		Plaintext = 8'h98;
		Key = 8'h15;
		#10
		Plaintext = 8'ha2;
		Key = 8'h88;
		#10
		Plaintext = 8'he0;
		Key = 8'h09;
		#10
		Plaintext = 8'h37;
		Key = 8'hcf;
		#10
		Plaintext = 8'h07;
		Key = 8'h4f;
		#10
		Plaintext = 8'h34;
		Key = 8'h3c;
		//---------------
		#10
		rst = 0;
			
	end

	always #5 clk = ~clk;
  
	always @(negedge clk) begin
		input2 = $random;
		key2 = $random;
		r = $random;
	end
	
endmodule

