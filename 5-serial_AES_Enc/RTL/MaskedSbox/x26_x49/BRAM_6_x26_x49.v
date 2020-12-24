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

module BRAM_6_x26_x49(
    input [9:0] ADDRA,
    input [9:0] ADDRB,
    input clk,
    input rst, input EN,
    output [7:0] DOA,
    output [7:0] DOB
    );



// Spartan-6
// Xilinx HDL Libraries Guide, version 14.7
//////////////////////////////////////////////////////////////////////////
// DATA_WIDTH_A/B | BRAM_SIZE | RAM Depth | ADDRA/B Width | WEA/B Width //
// ===============|===========|===========|===============|=============//
// 19-36 | "18Kb" | 512 | 9-bit | 4-bit //
// 10-18 | "18Kb" | 1024 | 10-bit | 2-bit //
// 10-18 | "9Kb" | 512 | 9-bit | 2-bit //
// 5-9 | "18Kb" | 2048 | 11-bit | 1-bit //
// 5-9 | "9Kb" | 1024 | 10-bit | 1-bit //
// 3-4 | "18Kb" | 4096 | 12-bit | 1-bit //
// 3-4 | "9Kb" | 2048 | 11-bit | 1-bit //
// 2 | "18Kb" | 8192 | 13-bit | 1-bit //
// 2 | "9Kb" | 4096 | 12-bit | 1-bit //
// 1 | "18Kb" | 16384 | 14-bit | 1-bit //
// 1 | "9Kb" | 8192 | 12-bit | 1-bit //
//////////////////////////////////////////////////////////////////////////
BRAM_TDP_MACRO #(
	.BRAM_SIZE("9Kb"), // Target BRAM: "9Kb" or "18Kb"
	.DEVICE("SPARTAN6"), // Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
	.DOA_REG(1), // Optional port A output register (0 or 1)
	.DOB_REG(1), // Optional port B output register (0 or 1)
	.INIT_A(36'h0123), // Initial values on port A output port
	.INIT_B(36'h3210), // Initial values on port B output port
	.INIT_FILE ("NONE"),
	.READ_WIDTH_A (8), // Valid values are 1-36
	.READ_WIDTH_B (8), // Valid values are 1-36
	.SIM_COLLISION_CHECK ("NONE"), // Collision check enable "ALL", "WARNING_ONLY",
	// "GENERATE_X_ONLY" or "NONE"
	.SRVAL_A(36'h00000000), // Set/Reset value for port A output
	.SRVAL_B(36'h00000000), // Set/Reset value for port B output
	.WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
	.WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
	.WRITE_WIDTH_A(8), // Valid values are 1-36
	.WRITE_WIDTH_B(8), // Valid values are 1-36
	
.INIT_00(256'hD161713F550039000E5E9D0050000F00B000EC00D0001E0079001600FC000100),
.INIT_01(256'h2DD6BF88FA00A400698FC8D102006F0030665E66D2002E0062003F000300CC00),
.INIT_02(256'hB21370CD0A3C04BC8D4FFC11B0000D0032DF0C5F7F80D300A7002A0050004F00),
.INIT_03(256'hD6DA26043D4201C272E031BE7A7EF57E54B958399B8005005A00E50049006400),
.INIT_04(256'hCA2E4470579C159C4B8DF6D30C007D001A006800B0005000110050005E008D00),
.INIT_05(256'hE704EBEAC8E00850FDC1C22F6E7C9DCC873777874EB02C001751D4E15DB00C00),
.INIT_06(256'hF01D1CC310A0302091DDCE83F4006700C19ED11E0780850096413541EA00DB00),
.INIT_07(256'h45492B2717A2B592BFEF62010E021FB2BAA928991F301F00761057A00FB0BC00),
.INIT_08(256'h2F9F8FC1ABFEC7FEF0A063FEAEFEF1FE4EFE12FE2EFEE0FE87FEE8FE02FEFFFE),
.INIT_09(256'hD328417604FE5AFE9771362FFCFE91FECE98A0982CFED0FE9CFEC1FEFDFE32FE),
.INIT_0A(256'h4CED8E33F4C2FA4273B102EF4EFEF3FECC21F2A1817E2DFE59FED4FEAEFEB1FE),
.INIT_0B(256'h2824D8FAC3BCFF3C8C1ECF4084800B80AA47A6C7657EFBFEA4FE1BFEB7FE9AFE),
.INIT_0C(256'h34D0BA8EA962EB62B573082DF2FE83FEE4FE96FE4EFEAEFEEFFEAEFEA0FE73FE),
.INIT_0D(256'h19FA1514361EF6AE033F3CD19082633279C98979B04ED2FEE9AF2A1FA34EF2FE),
.INIT_0E(256'h0EE3E23DEE5ECEDE6F23307D0AFE99FE3F602FE0F97E7BFE68BFCBBF14FE25FE),
.INIT_0F(256'hBBB7D5D9E95C4B6C41119CFFF0FCE14C4457D667E1CEE1FE88EEA95EF14E42FE),
.INIT_10(256'h1B324892CD002000E9A00F009B00C30003001F00F600F4006B00C200A8001F00),
.INIT_11(256'h467907D9D9002600B7C34363A400EE00D828D62807001700B30008007200D700),
.INIT_12(256'hA194ABB42A479EC73CCC036C9E001F008F0DCA8D4B8010004F003F0030005E00),
.INIT_13(256'h21F839D8E36045E0BF8892287C27EF27AE25F9A5408009006D000F0010006C00),
.INIT_14(256'h6527D2874B6342634AD64876C0007C003900C1004200A400EF00A200A200F100),
.INIT_15(256'h5C469E8187F5FB92709F07582796EEF177F3FA949A670900A2DB9ABC51677700),
.INIT_16(256'hC74A296A7F242FA487715CD116007300ADC60C462C809300D3CB47CBE9006300),
.INIT_17(256'h230CB84B6E954B72601FCED82CB13CD61935CDD20EE7C40064108577E0671F00),
.INIT_18(256'hE5CCB66C33FEDEFE175EF1FE65FE3DFEFDFEE1FE08FE0AFE95FE3CFE56FEE1FE),
.INIT_19(256'hB887F92727FED8FE493DBD9D5AFE10FE26D628D6F9FEE9FE4DFEF6FE8CFE29FE),
.INIT_1A(256'h5F6A554AD4B96039C232FD9260FEE1FE71F33473B57EEEFEB1FEC1FECEFEA0FE),
.INIT_1B(256'hDF06C7261D9EBB1E41766CD682D911D950DB075BBE7EF7FE93FEF1FEEEFE92FE),
.INIT_1C(256'h9BD92C79B59DBC9DB428B6883EFE82FEC7FE3FFEBCFE5AFE11FE5CFE5CFE0FFE),
.INIT_1D(256'hA2B8607F790B056C8E61F9A6D968100F890D046A6499F7FE5C256442AF9989FE),
.INIT_1E(256'h39B4D79481DAD15A798FA22FE8FE8DFE5338F2B8D27E6DFE2D35B93517FE9DFE),
.INIT_1F(256'hDDF246B5906BB58C9EE13026D24FC228E7CB332CF0193AFE9AEE7B891E99E1FE),


	
	//===============================================================================
	
	.INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),


	// The next set of INITP_xx are for the parity bits
	.INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
	// The next set of INITP_xx are for "18Kb" configuration only
	.INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000)
) BRAM_TDP_MACRO_inst (
	.DOA(DOA), // Output port-A data, width defined by READ_WIDTH_A parameter
	.DOB(DOB), // Output port-B data, width defined by READ_WIDTH_B parameter
	.ADDRA(ADDRA), // Input port-A address, width defined by Port A depth
	.ADDRB(ADDRB), // Input port-B address, width defined by Port B depth
	.CLKA(clk), // 1-bit input port-A clock
	.CLKB(clk), // 1-bit input port-B clock
	.DIA(8'h0), // Input port-A data, width defined by WRITE_WIDTH_A parameter
	.DIB(8'h0), // Input port-B data, width defined by WRITE_WIDTH_B parameter
	.ENA(EN), // 1-bit input port-A enable
	.ENB(EN), // 1-bit input port-B enable
	.REGCEA(EN), // 1-bit input port-A output register enable
	.REGCEB(EN), // 1-bit input port-B output register enable
	.RSTA(rst), // 1-bit input port-A reset
	.RSTB(rst), // 1-bit input port-B reset
	.WEA(1'b0), // Input port-A write enable, width defined by Port A depth
	.WEB(1'b0) // Input port-B write enable, width defined by Port B depth
);
// End of BRAM_TDP_MACRO_inst instantiation
endmodule
