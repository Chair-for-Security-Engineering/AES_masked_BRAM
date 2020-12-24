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
	reg [31:0] InputData0;
	reg [31:0] InputData1;
	reg [31:0] Key0;
	reg [31:0] Key1;
	reg [31:0] r;

	// Outputs
	wire [31:0] OutputData0;
	wire [31:0] OutputData1;
	wire [31:0] OutputData;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	Cipher uut (
		.clk(clk), 
		.rst(rst), 
		.InputData0(InputData0), 
		.InputData1(InputData1), 
		.Key0(Key0), 
		.Key1(Key1), 
		.r(r), 
		.OutputData0(OutputData0), 
		.OutputData1(OutputData1), 
		.done(done)
	);
	
	assign OutputData = OutputData0 ^ OutputData1;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		InputData0 = 0;	
		InputData1 = 0;
		Key0 = 0;
		Key1 = 0;
		r = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		InputData0 	= 32'h3243f6a8;
		Key0			= 32'h2b7e1516;
		#10;
		InputData0 	= 32'h885a308d;
		Key0			= 32'h28aed2a6;
		#10;
		InputData0 	= 32'h313198a2;
		Key0			= 32'habf71588;
		#10;
		InputData0 	= 32'he0370734;
		Key0			= 32'h09cf4f3c;
		#10;
		InputData0 	= 32'hFFFFFFFF;
		Key0			= 32'hFFFFFFFF;
		#10;
		InputData0 	= 32'h3243f6a8;

		#10;
		InputData0 	= 32'h885a308d;

		#10;
		InputData0 	= 32'h313198a2;

		#10;
		InputData0 	= 32'he0370734;
		
		@(posedge done) begin
			
			#5;
		
			if(OutputData == 32'h3925841d) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h02dc09fb3925841d);
			end
			#10;
			if(OutputData == 32'h02dc09fb) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h02dc09fb);
			end
			#10;
			if(OutputData == 32'hdc118597) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'hdc118597);
			end
			#10;
			if(OutputData == 32'h196a0b32) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h196a0b32);
			end
			#10;

		end
		
		@(posedge done) begin
			
			#5;
		
			if(OutputData == 32'h3925841d) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h02dc09fb3925841d);
			end
			#10;
			if(OutputData == 32'h02dc09fb) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h02dc09fb);
			end
			#10;
			if(OutputData == 32'hdc118597) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'hdc118597);
			end
			#10;
			if(OutputData == 32'h196a0b32) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,32'h196a0b32);
			end
			#10;

		end

		// Add stimulus here

	end
      always #5 clk = ~clk;
endmodule

