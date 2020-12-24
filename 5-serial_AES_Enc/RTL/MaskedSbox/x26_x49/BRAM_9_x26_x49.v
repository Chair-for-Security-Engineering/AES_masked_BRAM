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

module BRAM_9_x26_x49(
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
	
.INIT_00(256'hAC7AE500497A00000000000000000000D600E500330000000000000000000000),
.INIT_01(256'h6CD8B500C7965000D14EAD009F00AD00BBA2180010ECFD007C4E000032000000),
.INIT_02(256'hEEA8970079A8000042D2720030D2000046009700D100000090007200E2000000),
.INIT_03(256'h1FDDF9D894C13C8A56BF152C38A3357E640B2AA6EF17EFF45713C652390FE600),
.INIT_04(256'hAC6821F887A6A09C7AAAFE00D000FE00B48E43649F40C20084AA00002E000000),
.INIT_05(256'hAF09B23BCA89335FABE453004F0053001AEF7DA77F6FFCC3F8E400001C000000),
.INIT_06(256'hABE779CAF2298AAE4F17940097BDE60061D31B56381DE83263C56A00BB6F1800),
.INIT_07(256'h8D45C0C5C89761F34F6EE7388BD8C76A940F7127D1DDD011B0C2CA467474EA14),
.INIT_08(256'h5B8D12F7BE8DF7F7F7F7F7F7F7F7F7F721F712F7C4F7F7F7F7F7F7F7F7F7F7F7),
.INIT_09(256'h9B2F42F73061A7F726B95AF768F75AF74C55EFF7E71B0AF78BB9F7F7C5F7F7F7),
.INIT_0A(256'h195F60F78E5FF7F7B52585F7C725F7F7B1F760F726F7F7F767F785F715F7F7F7),
.INIT_0B(256'hE82A0E2F6336CB7DA148E2DBCF54C28993FCDD5118E01803A0E431A5CEF811F7),
.INIT_0C(256'h5B9FD60F7051576B8D5D09F727F709F74379B49368B735F7735DF7F7D9F7F7F7),
.INIT_0D(256'h58FE45CC3D7EC4A85C13A4F7B8F7A4F7ED188A5088980B340F13F7F7EBF7F7F7),
.INIT_0E(256'h5C108E3D05DE7D59B8E063F7604A11F79624ECA1CFEA1FC594329DF74C98EFF7),
.INIT_0F(256'h7AB237323F609604B89910CF7C2F309D63F886D0262A27E647353DB183831DE3),
.INIT_10(256'h0E8D3600388D0000000000000000000083003600B50000000000000000000000),
.INIT_11(256'h3B64F8003B52CE00C136E500F700E50053E91D0053DF2B002436000012000000),
.INIT_12(256'hF7118A007D110000F99CBC00459C0000E6008A006C0000006500BC00D9000000),
.INIT_13(256'h8E4E279902489DA9FA92B417409438275D78E5BED17E5F8EA42976301E2FFA00),
.INIT_14(256'h1E969B42B20C8C630EBB5100B5005100A178A9210DE2BE005FBB0000E4000000),
.INIT_15(256'h30644E59AAC85978CF8DB4004200B4006A8A993AF0268E1B7B8D0000F6000000),
.INIT_16(256'hD0EEAE18C07405399A993E009D228200F39C9C7BE306375A57056F0050BED300),
.INIT_17(256'hE0F84AC8F664D1D9CBC56445CA78E87501ADBA8C1731219DC47EF762C5C37B52),
.INIT_18(256'hF97AC1F7CF7AF7F7F7F7F7F7F7F7F7F774F7C1F742F7F7F7F7F7F7F7F7F7F7F7),
.INIT_19(256'hCC930FF7CCA539F736C112F700F712F7A41EEAF7A428DCF7D3C1F7F7E5F7F7F7),
.INIT_1A(256'h00E67DF78AE6F7F70E6B4BF7B26BF7F711F77DF79BF7F7F792F74BF72EF7F7F7),
.INIT_1B(256'h79B9D06EF5BF6A5E0D6543E0B763CFD0AA8F12492689A87953DE81C7E9D80DF7),
.INIT_1C(256'hE9616CB545FB7B94F94CA6F742F7A6F7568F5ED6FA1549F7A84CF7F713F7F7F7),
.INIT_1D(256'hC793B9AE5D3FAE8F387A43F7B5F743F79D7D6ECD07D179EC8C7AF7F701F7F7F7),
.INIT_1E(256'h271959EF3783F2CE6D6EC9F76AD575F7046B6B8C14F1C0ADA0F298F7A74924F7),
.INIT_1F(256'h170FBD3F0193262E3C3293B23D8F1F82F65A4D7BE0C6D66A3389009532348CA5),


	
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
