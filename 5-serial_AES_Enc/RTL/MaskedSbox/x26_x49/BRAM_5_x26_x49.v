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

module BRAM_5_x26_x49(
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
	
.INIT_00(256'hF57394117AEB00006FDAAB2EDA7800009F3E0000DAE9000040D2000000000000),
.INIT_01(256'h1CA84FCA0CAF0A0A60E77AFF4ADA0000B4270000BFBE00008727000089BB0000),
.INIT_02(256'hF91E15139C6CCF4C7324BA3F73330000EC2C2CAF520073F09FEF00007B990000),
.INIT_03(256'hB96C686E11D331B2214439BCEC9E00006E9C8A09CCAC870405475252FD2D0000),
.INIT_04(256'h1FB723A68D320000A13A78FD6DE1000060EF6464EBF600009B270000715F0000),
.INIT_05(256'h6DBBD31A8140C08CF613418844B609451CED83CF385B064AC80A24688DDDC589),
.INIT_06(256'hF73E292F8F5144C76B12D055127CB9B94EA07AF93E4241C22B75000065A90000),
.INIT_07(256'h388F6B216CCC64AB7572AF662030A4E88F1F2FE00200A7683111622E8230D19D),
.INIT_08(256'h2AAC4BCEA534DFDFB00574F105A7DFDF40E1DFDF0536DFDF9F0DDFDFDFDFDFDF),
.INIT_09(256'hC3779015D370D5D5BF38A5209505DFDF6BF8DFDF6061DFDF58F8DFDF5664DFDF),
.INIT_0A(256'h26C1CACC43B31093ACFB65E0ACECDFDF33F3F3708DDFAC2F4030DFDFA446DFDF),
.INIT_0B(256'h66B3B7B1CE0CEE6DFE9BE6633341DFDFB14355D6137358DBDA988D8D22F2DFDF),
.INIT_0C(256'hC068FC7952EDDFDF7EE5A722B23EDFDFBF30BBBB3429DFDF44F8DFDFAE80DFDF),
.INIT_0D(256'hB2640CC55E9F1F5329CC9E579B69D69AC3325C10E784D99517D5FBB752021A56),
.INIT_0E(256'h28E1F6F0508E9B18B4CD0F8ACDA36666917FA526E19D9E1DF4AADFDFBA76DFDF),
.INIT_0F(256'hE750B4FEB313BB74AAAD70B9FFEF7B3750C0F03FDDDF78B7EECEBDF15DEF0E42),
.INIT_10(256'h6035EEFF5A0000006C8C7C6D8E6100002D86000059EC00003E20000000000000),
.INIT_11(256'hA4E37F6ECB83F2F285771F0E32CF0000E1580000A30400002D21000025370000),
.INIT_12(256'h88A12397D7F12C89A59C1001AF990000F22566C38F46EB4E07C00000BD640000),
.INIT_13(256'hDDE60CB8E7D350F5537843523C180000AF6AD87DD40F65C00BDE3030B77C0000),
.INIT_14(256'h7ECFB9A8A8160000B1B50A1B9E950000E1AE21210F5E000031CB0000B4500000),
.INIT_15(256'h779A82DD48AAE4AA8ED6D887481F0D4311027A347578E7A905A3400E0AB2FCB2),
.INIT_16(256'h4A8716A2F93B4EEBFE235E4F39EB3838DAE91DB83D10B114B6950000B78A0000),
.INIT_17(256'h8011C13BEA74769D8C0DEEB1921C6729E986AA41B4C58A61CFB0226C7415AEE0),
.INIT_18(256'hBFEA312085DFDFDFB353A3B251BEDFDFF259DFDF8633DFDFE1FFDFDFDFDFDFDF),
.INIT_19(256'h7B3CA0B1145C2D2D5AA8C0D1ED10DFDF3E87DFDF7CDBDFDFF2FEDFDFFAE8DFDF),
.INIT_1A(256'h577EFC48082EF3567A43CFDE7046DFDF2DFAB91C50993491D81FDFDF62BBDFDF),
.INIT_1B(256'h0239D367380C8F2A8CA79C8DE3C7DFDF70B507A20BD0BA1FD401EFEF68A3DFDF),
.INIT_1C(256'hA110667777C9DFDF6E6AD5C4414ADFDF3E71FEFED081DFDFEE14DFDF6B8FDFDF),
.INIT_1D(256'hA8455D0297753B755109075897C0D29CCEDDA5EBAAA73876DA7C9FD1D56D236D),
.INIT_1E(256'h9558C97D26E4913421FC8190E634E7E70536C267E2CF6ECB694ADFDF6855DFDF),
.INIT_1F(256'h5FCE1EE435ABA94253D2316E4DC3B8F63659759E6B1A55BE106FFDB3ABCA713F),



	
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
