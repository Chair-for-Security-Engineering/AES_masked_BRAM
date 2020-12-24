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

module AESCipher_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] InputData0;
	reg [127:0] InputData1;
	reg [127:0] Key0;
	reg [127:0] Key1;
	reg [159:0] r;

	// Outputs
	wire [127:0] OutputData0;
	wire [127:0] OutputData1;
	wire [127:0] OutputData;
	reg [127:0] PlainText;
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
		//$stop;

		clk = 0;
		rst = 1;
		PlainText = 128'h340737e0a29831318d305a88a8f64332;
		InputData1 = {$random, $random, $random, $random} & 128'h0;
		InputData0 = PlainText ^ InputData1;

		Key1 = {$random, $random, $random, $random}  & 128'h0;
		Key0 = 128'h3c4fcf098815f7aba6d2ae2816157e2b ^ Key1;
		
		r = 0;

		// Wait 100 ns for global reset to finish
		#200;
		PlainText = 128'h0;
		InputData1 = {$random, $random, $random, $random}  & 128'h0;
		InputData0 = PlainText ^ InputData1;
		#10 
		PlainText = 128'h0123456789abcdef0123456789abcdef;
		InputData1 = {$random, $random, $random, $random}  & 128'h0;
		InputData0 = PlainText ^ InputData1;
		#10 
		PlainText = 128'h00112233445566778899aabbccddeeff;
		InputData1 = {$random, $random, $random, $random}  & 128'h0;
		InputData0 = PlainText ^ InputData1;
		#10 
		PlainText = 128'h340737e0a29831318d305a88a8f64332;
		InputData1 = {$random, $random, $random, $random}  & 128'h0;
		InputData0 = PlainText ^ InputData1;
		#10 
      rst = 0;
		 
		@(posedge done) begin
			
			#5;
		
			if(OutputData == 128'h320b6a19978511dcfb09dc021d842539) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h320b6a19978511dcfb09dc021d842539);
			end
			#10;
			if(OutputData == 128'h6f541bb947f0423eb399b81a0c6bf77d) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h6f541bb947f0423eb399b81a0c6bf77d);
			end
			#10;
			if(OutputData == 128'h67f231d4d67ef497245075cfa63b5ae0) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h67f231d4d67ef497245075cfa63b5ae0);
			end
			#10;
			if(OutputData == 128'hc1b8350e659b5d432f1bb87a1c67492f) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'hc1b8350e659b5d432f1bb87a1c67492f);
			end
			#10;
			if(OutputData == 128'h320b6a19978511dcfb09dc021d842539) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h320b6a19978511dcfb09dc021d842539);
			end
			#10;
			$stop;
		end
		 
		// Add stimulus here

	end
	
	
   always #5 clk = ~clk;
	
//	always @(negedge clk) begin
//		r = {$random, $random, $random, $random, $random};
//	end
endmodule

