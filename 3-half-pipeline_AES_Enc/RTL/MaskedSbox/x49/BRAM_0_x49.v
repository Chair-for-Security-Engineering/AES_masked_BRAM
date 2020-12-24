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

module BRAM_0_x49(
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
	
.INIT_00(256'h7E57D60C58952404521B646BC45F6CAFEAE9E1FE8274FD09107B08CA5AF27C63),
.INIT_01(256'h4D72B06E1AC305238FFB331340E454BA12E2D52B686FEDFAF447FFF784F68750),
.INIT_02(256'h5C69D1CEF598287151A1C2ADC55B4C539F1D2D6A14DF564683CCA29DA7973C62),
.INIT_03(256'hAA735DBC42C1D376C7F0F14B3A6120E8850ED4882CECBBB20B6616192535B4D8),
.INIT_04(256'h480AA9FC8EA6002122BEBF8175B5CDB1F9C01FDE07452E8A26C93193DB7949B8),
.INIT_05(256'hB6AC657ABDCF375E29C659069B2AF8E73DB9701E6D90D9D0E59C86A09EA84E39),
.INIT_06(256'h9A17E0A3184389028B7D0D8015033241442FA5EF923E38AB273FB73B7F96EE8D),
.INIT_07(256'hF3DC94678C77360F99E6DDCBD24F01EB301C554A789160A4DAAE11E334B3C8D7),
.INIT_08(256'h80A928F2A66BDAFAACE59A953AA1925114171F007C8A03F7EE85F634A40C829D),
.INIT_09(256'hB38C4E90E43DFBDD7105CDEDBE1AAA44EC1C2BD5969113040AB901097A0879AE),
.INIT_0A(256'hA2972F300B66D68FAF5F3C533BA5B2AD61E3D394EA21A8B87D325C635969C29C),
.INIT_0B(256'h548DA342BC3F2D88390E0FB5C49FDE167BF02A76D212454CF598E8E7DBCB4A26),
.INIT_0C(256'hB6F457027058FEDFDC40417F8B4B334F073EE120F9BBD074D837CF6D2587B746),
.INIT_0D(256'h48529B844331C9A0D738A7F865D40619C3478EE0936E272E1B62785E6056B0C7),
.INIT_0E(256'h64E91E5DE6BD77FC7583F37EEBFDCCBFBAD15B116CC0C655D9C149C581681073),
.INIT_0F(256'h0D226A997289C8F1671823352CB1FF15CEE2ABB4866F9E5A2450EF1DCA4D3629),
.INIT_10(256'h8E3EE8A610456D547626B528D6860B0478C8E00C2CFCF1EF532A140206FA0100),
.INIT_11(256'h9368C7F02ED42F8BDF39C2DB3A387718D385605875A7CDE34624C6F9878409C5),
.INIT_12(256'hBA1B51ECA096F44C52909C7129995D5023CEE4B7E21DC417A4033C163B6B4708),
.INIT_13(256'hF3FF250798E7BF7C5BC944CB3733DC57A24F4120C3D88F8A6F353FDA367FCCA8),
.INIT_14(256'h8367B88C4B80C1486CAAB297FEF294E97E647D15AF1F4313DECF42126A341C91),
.INIT_15(256'h05E6BCBD0F2749119DA12DC0ABB9E1B082321AEA40BE79555F19B4819E73D1DD),
.INIT_16(256'hA34E7AA5AE1E62726E22D29F6692CAAD88D7BB748D0AF570B6619AEE8963EB30),
.INIT_17(256'h6569313DF84DF7D02B7BF695D5D956FB4A59ED5C0E21ACB3FD9BA95EE55AB10D),
.INIT_18(256'h70C01658EEBB93AA88D84BD62878F5FA86361EF2D2020F11ADD4EAFCF804FFFE),
.INIT_19(256'h6D96390ED02AD17521C73C25C4C689E62D7B9EA68B59331DB8DA3807797AF73B),
.INIT_1A(256'h44E5AF125E680AB2AC6E628FD767A3AEDD301A491CE33AE95AFDC2E8C595B9F6),
.INIT_1B(256'h0D01DBF966194182A537BA35C9CD22A95CB1BFDE3D26717491CBC124C8813256),
.INIT_1C(256'h7D994672B57E3FB692544C69000C6A17809A83EB51E1BDED2031BCEC94CAE26F),
.INIT_1D(256'hFB184243F1D9B7EF635FD33E55471F4E7CCCE414BE4087ABA1E74A7F608D2F23),
.INIT_1E(256'h5DB0845B50E09C8C90DC2C61986C34537629458A73F40B8E489F6410779D15CE),
.INIT_1F(256'h9B97CFC306B3092ED585086B2B27A805B4A713A2F0DF524D036557A01BA44FF3),


	
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
