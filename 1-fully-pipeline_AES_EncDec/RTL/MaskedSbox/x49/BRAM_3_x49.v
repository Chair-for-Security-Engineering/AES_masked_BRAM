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

module BRAM_3_x49(
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
	
.INIT_00(256'hF4CA330D444CC9C100000000000000002214685E000000000000000000000000),
.INIT_01(256'h19EBAE5CD81E13D503E4AC4B5ABFC326041BA7B8341FEBC03A380C0E00000000),
.INIT_02(256'h405F9F807FEA6EFBFEDFE6C7FC6160FDC14B0F85000000006ED2EA5600000000),
.INIT_03(256'h6841E8C116B76ECFB68A2E12DD5FF775055C0D54E63716C7387CA5E15CA67389),
.INIT_04(256'h431C792613F4D83FF12EEE31306194C5B0B6A3A504BAE658B7390C8200000000),
.INIT_05(256'hF86BB221654CE8C1BF870F379B2FA612311ECBE42BBE168331BDBC3000000000),
.INIT_06(256'h07AA9B3613BAFA53A5881C31ADB22B349BF2B2DB076A5B364BAACA2B598AE734),
.INIT_07(256'h2BB0E873C25F42DFF2C2CBFB2F2F1F1FAA1045FFA81404B8F3EA6B72577EC6EF),
.INIT_08(256'h033DC4FAB3BB3E36F7F7F7F7F7F7F7F7D5E39FA9F7F7F7F7F7F7F7F7F7F7F7F7),
.INIT_09(256'hEE1C59AB2FE9E422F4135BBCAD4834D1F3EC504FC3E81C37CDCFFBF9F7F7F7F7),
.INIT_0A(256'hB7A86877881D990C092811300B96970A36BCF872F7F7F7F799251DA1F7F7F7F7),
.INIT_0B(256'h9FB61F36E1409938417DD9E52AA80082F2ABFAA311C0E130CF8B5216AB51847E),
.INIT_0C(256'hB4EB8ED1E4032FC806D919C6C796633247415452F34D11AF40CEFB75F7F7F7F7),
.INIT_0D(256'h0F9C45D692BB1F364870F8C06CD851E5C6E93C13DC49E174C64A4BC7F7F7F7F7),
.INIT_0E(256'hF05D6CC1E44D0DA4527FEBC65A45DCC36C05452CF09DACC1BC5D3DDCAE7D10C3),
.INIT_0F(256'hDC471F8435A8B52805353C0CD8D8E8E85DE7B2085FE3F34F041D9C85A0893118),
.INIT_10(256'hD21EAD61ECC596BF000000000000000001E404E1000000000000000000000000),
.INIT_11(256'h4E368AF2532ADCA528617F366DC074D92BD78C70D82534C99470DA3E00000000),
.INIT_12(256'h28DA21D392F73A5F19276F51C28E105C940335A200000000CAB86E1C00000000),
.INIT_13(256'hE0405DFD2BF879AA9100BF2E5D5A999E94FC98F0A0BB435880F065158C6A8365),
.INIT_14(256'hB389E0DADBCE273276421A2E44BA827C6B868469EF2DAF6DE12B4B8100000000),
.INIT_15(256'hC14F29A76B2E6227730E4835E5B63A6963972EDAF4CB586794BA705E00000000),
.INIT_16(256'h5D41170BF0B1B1F0495B3C2EE14B9A3053D477F003D92CF6B414D575DEC6B1A9),
.INIT_17(256'h6F2191DF52A5E91EF845D568A647CB2A651DEC9474B5B8790BA92B8946B826D8),
.INIT_18(256'h25E95A961B326148F7F7F7F7F7F7F7F7F613F316F7F7F7F7F7F7F7F7F7F7F7F7),
.INIT_19(256'hB9C17D05A4DD2B52DF9688C19A37832EDC207B872FD2C33E63872DC9F7F7F7F7),
.INIT_1A(256'hDF2DD6246500CDA8EED098A63579E7AB63F4C255F7F7F7F73D4F99EBF7F7F7F7),
.INIT_1B(256'h17B7AA0ADC0F8E5D66F748D9AAAD6E69630B6F07574CB4AF770792E27B9D7492),
.INIT_1C(256'h447E172D2C39D0C581B5EDD9B34D758B9C71739E18DA589A16DCBC76F7F7F7F7),
.INIT_1D(256'h36B8DE509CD995D084F9BFC21241CD9E9460D92D033CAF90634D87A9F7F7F7F7),
.INIT_1E(256'hAAB6E0FC07464607BEACCBD916BC6DC7A4238007F42EDB0143E322822931465E),
.INIT_1F(256'h98D66628A5521EE90FB2229F51B03CDD92EA1B6383424F8EFC5EDC7EB14FD12F),


	
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
