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

module Controller 
	#(parameter sbox_latency=5)
	(input clk,
    input rst,
    output reg KeyMuxSel,
    output reg InputMuxSel,
    output reg FinalRound,
    output reg StateEN,
    output reg SboxInputSelcetor,
    output reg LoadKeySchedule,
    output reg ShowRcon,
    output reg DoSR,
    output KeyRegEn,
    output reg [7:0] Rcon,
    output reg done
    );

	reg  [4:0] PerRoundCounter;
	reg  [7:0] Rcon_Reg;
	reg        KeyRegEnReg;
	wire [7:0] Rcon_x2;
	
	wire [7:0] conditionalXOR;
	wire [7:0] ShiftedData;
	
	assign conditionalXOR = {3'b000, Rcon[7], Rcon[7], 1'b0, Rcon[7], Rcon[7]};
	assign ShiftedData = {Rcon[6:0], 1'b0};
	assign Rcon_x2 = conditionalXOR ^ ShiftedData;
	

	assign KeyRegEn	  = rst ? 1'b1  : KeyRegEnReg;

	
	always @(posedge clk) begin
		done <= FinalRound;
		
		if (rst) begin
			PerRoundCounter 		<= 0;
			Rcon 						<= 1;

		end
		else  begin
			PerRoundCounter 		<= PerRoundCounter + 1;
			if (PerRoundCounter == 6) begin
				PerRoundCounter 	<= 5'd0;
				Rcon 					<= Rcon_x2;
			end
		end
	end
	
	always @(*) begin
		SboxInputSelcetor  = 0;
		InputMuxSel  		= 0;
		KeyMuxSel    		= 0;
		KeyRegEnReg  		= 1;
		ShowRcon		 		= 0;
		LoadKeySchedule 	= 0;
		StateEN 				= 1;
		DoSR					= 0;
		FinalRound			= 0;
		
		
		if ((PerRoundCounter == 3) || (PerRoundCounter == 1) || (PerRoundCounter == 5)) begin
				DoSR  = 1;
		end
		if ((PerRoundCounter == 6) && (Rcon == 8'h36) || ((PerRoundCounter == 0) && (Rcon == 8'h6c)) || ((PerRoundCounter >= 2) && (PerRoundCounter <= 5) && (Rcon == 8'h6c))) begin
			FinalRound		= 1;
		end	
		
		if ((PerRoundCounter == 6) ) begin
				ShowRcon  = 1;

				LoadKeySchedule  = 1;
		end
		if ((PerRoundCounter == 0)) begin
				LoadKeySchedule  = 1;
		end
		if ((PerRoundCounter < 2) && (Rcon == 1)) begin
				KeyMuxSel  = 1;
		end
		if (PerRoundCounter == 2) begin
				SboxInputSelcetor  = 1;
				KeyRegEnReg			 = 0;
		end

		if (Rcon == 1) begin
				InputMuxSel  = 1;
		end
	end
	
endmodule
