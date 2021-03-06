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

module BRAM_10_x26(
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
	
.INIT_00(256'h74246000D87A0000EB5E8500A20000007700E500000000009200000000000000),
.INIT_01(256'hFB06A16C7F70A70A081028000F00AD005F28836600000000DC4E000000000000),
.INIT_02(256'h9F00AF0097FACF0003FAC900EE004C00D02466000380830036A4000000000000),
.INIT_03(256'h10226E6C30F0680AE0B464004300E100F80C00660380830078EA000000000000),
.INIT_04(256'h78E2AA001EBC0000E7984F0064C60000BD002F00000000005800CA0000000000),
.INIT_05(256'h0B70276C4506EB0AF866AE003576E10069980566FCB04C00EAFE8600FCB04C00),
.INIT_06(256'h6B3E9DF8E88576B9F7C4FBF8917FF5B95B65ED4103808300BDE58B4100000000),
.INIT_07(256'h18AC1094B33F9DB3E83A1AF8C0CF14B98FFDC727FF30CF000F1BC741FCB04C00),
.INIT_08(256'h9BCB8FEF3795EFEF04B16AEF4DEFEFEF98EF0AEFEFEFEFEF7DEFEFEFEFEFEFEF),
.INIT_09(256'h14E94E83909F48E5E7FFC7EFE0EF42EFB0C76C89EFEFEFEF33A1EFEFEFEFEFEF),
.INIT_0A(256'h70EF40EF781520EFEC1526EF01EFA3EF3FCB89EFEC6F6CEFD94BEFEFEFEFEFEF),
.INIT_0B(256'hFFCD8183DF1F87E50F5B8BEFACEF0EEF17E3EF89EC6F6CEF9705EFEFEFEFEFEF),
.INIT_0C(256'h970D45EFF153EFEF0877A0EF8B29EFEF52EFC0EFEFEFEFEFB7EF25EFEFEFEFEF),
.INIT_0D(256'hE49FC883AAE904E5178941EFDA990EEF8677EA89135FA3EF051169EF135FA3EF),
.INIT_0E(256'h84D17217076A9956182B14177E901A56B48A02AEEC6F6CEF520A64AEEFEFEFEF),
.INIT_0F(256'hF743FF7B5CD0725C07D5F5172F20FB56601228C810DF20EFE0F428AE135FA3EF),
.INIT_10(256'h2B298600F8370000C01E5A00CF0000009700DC00000000004B00000000000000),
.INIT_11(256'hDA6B65501468EC5F610CE9007C00B3008A1DD30F000000005912000000000000),
.INIT_12(256'h8E2C2600D1BEA0001692000095005A00680526007389FA00C78C000000000000),
.INIT_13(256'h7F6EC5503DE14C5FB780B3002600E9007518290F7389FA00D59E000000000000),
.INIT_14(256'h3AAE10007FB00000D199CC004887000001004A0000000000DD00960000000000),
.INIT_15(256'h92D69050CAD58F5F29B11C00A2BDD0004527260F593A63009628F500593A6300),
.INIT_16(256'h74405BEBF8970EAEECFE7DEBBC29F4AEBB40F5457389FA0014C9D34500000000),
.INIT_17(256'hDC38DBBB4DF281F114D6ADEB561324AEFF67994A2AB399005FE1B045593A6300),
.INIT_18(256'hC4C669EF17D8EFEF2FF1B5EF20EFEFEF78EF33EFEFEFEFEFA4EFEFEFEFEFEFEF),
.INIT_19(256'h35848ABFFB8703B08EE306EF93EF5CEF65F23CE0EFEFEFEFB6FDEFEFEFEFEFEF),
.INIT_1A(256'h61C3C9EF3E514FEFF97DEFEF7AEFB5EF87EAC9EF9C6615EF2863EFEFEFEFEFEF),
.INIT_1B(256'h90812ABFD20EA3B0586F5CEFC9EF06EF9AF7C6E09C6615EF3A71EFEFEFEFEFEF),
.INIT_1C(256'hD541FFEF905FEFEF3E7623EFA768EFEFEEEFA5EFEFEFEFEF32EF79EFEFEFEFEF),
.INIT_1D(256'h7D397FBF253A60B0C65EF3EF4D523FEFAAC8C9E0B6D58CEF79C71AEFB6D58CEF),
.INIT_1E(256'h9BAFB4041778E1410311920453C61B4154AF1AAA9C6615EFFB263CAAEFEFEFEF),
.INIT_1F(256'h33D73454A21D6E1EFB394204B9FCCB41108876A5C55C76EFB00E5FAAB6D58CEF),


	
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
