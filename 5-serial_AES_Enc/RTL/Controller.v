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

module Controller(
    input clk,
    input rst,
	 output reg ShowRcon,
	 output reg DoSR,
    output reg DoMC,
	 output reg DoKeySbox,
	 output reg Done,
	 output reg CorrectCiphertext,
	 output reg output_sel,
	 output reg [1:0] KeyIn_sel,
	 output reg [1:0] SboxIn_sel,
	 output reg [7:0] Rcon
    );
		
	reg [3:0] RoundCounter;
	reg [5:0] PerRoundCounter;
	reg [7:0] Rcon_Reg;
	wire [7:0] Rcon_x2;
	
	wire [7:0] conditionalXOR;
	wire [7:0] ShiftedData;
	
	parameter FinalRoundNumber = 9;
	
	assign conditionalXOR = {3'b000, Rcon_Reg[7], Rcon_Reg[7], 1'b0, Rcon_Reg[7], Rcon_Reg[7]};
	assign ShiftedData = {Rcon_Reg[6:0], 1'b0};
	assign Rcon_x2 = conditionalXOR ^ ShiftedData;
	
	always @(posedge clk) begin
		if (rst) begin
			RoundCounter <= 0;
			PerRoundCounter <= 0;
			Rcon_Reg <= 1;
		end
		else begin
			PerRoundCounter <= PerRoundCounter + 1;
			
			if(PerRoundCounter == 19) begin
				RoundCounter <= RoundCounter + 1;
				PerRoundCounter <= 0;
				Rcon_Reg <= Rcon_x2;
			end

		end
	end
	
	always @(*) begin
		Rcon 					= Rcon_Reg;
		DoSR 					= 0;
		DoMC 					= 0;
		DoKeySbox			= 0;
		KeyIn_sel			= 2;
		SboxIn_sel			= 3;
		ShowRcon				= 0;
		output_sel			= 1;
		CorrectCiphertext = 0;
		Done              = 0;
		
		if (rst) begin
			DoKeySbox			= 0;
			KeyIn_sel			= 0;
			SboxIn_sel			= 0;
		end
		else begin				
			case (PerRoundCounter)
				5'd0: begin
							DoKeySbox = 1;
							SboxIn_sel			= 1;
							if(RoundCounter == 0) KeyIn_sel			= 0;
						end
				5'd1: begin
							DoKeySbox = 1;
							SboxIn_sel			= 1;
							if(RoundCounter == 0) KeyIn_sel			= 0;
						end
						
				5'd2: begin
							DoKeySbox = 1;
							SboxIn_sel			= 1;
							
							if(RoundCounter == 0) KeyIn_sel			= 0;
						end
				5'd3: begin
							DoSR = 1;
							
							DoKeySbox = 1;
							SboxIn_sel			= 1;
							if(RoundCounter == 0) KeyIn_sel			= 0;
							
						end
				5'd4: begin
							if(RoundCounter == FinalRoundNumber) Done = 1;
							KeyIn_sel			= 1;
							SboxIn_sel			= 2;
							ShowRcon				= 1;
							if(RoundCounter != FinalRoundNumber) DoMC = 1;
						end
				5'd5: begin
							KeyIn_sel			= 1;
							SboxIn_sel			= 2;
						end
						
				5'd6: begin
							KeyIn_sel			= 1;
							SboxIn_sel			= 2;
						end
				5'd7: begin
							KeyIn_sel			= 1;
							SboxIn_sel			= 2;
							
						end
				5'd8: begin
							if(RoundCounter != FinalRoundNumber) DoMC = 1;
						end
						
				5'd12: begin
							if(RoundCounter != FinalRoundNumber) DoMC = 1;
						end
			

				5'd16: begin
							if(RoundCounter != FinalRoundNumber) DoMC = 1;
						end

				default : begin
								DoSR 					= 0;
								DoMC 					= 0;
								DoKeySbox			= 0;	
								ShowRcon				= 0;	
							 end
			endcase
		end
	end 
	
	
	
endmodule
