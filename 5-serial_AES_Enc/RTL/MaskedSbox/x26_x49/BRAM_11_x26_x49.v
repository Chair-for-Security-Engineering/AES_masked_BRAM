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

module BRAM_11_x26_x49(
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
	
.INIT_00(256'h2C05290029002900000000000000000005050000000000000000000000000000),
.INIT_01(256'hBD70A16C3A13230AFD19E400191900008763826600000000E400E40000000000),
.INIT_02(256'h8F57D800F852AA00A0D27200D2D200007485F100038083007200720000000000),
.INIT_03(256'h1E22506CEB41A00A5DCB9600CBCB0000F6E37366038083009600960000000000),
.INIT_04(256'h78AFD700D700D70054AAFE00FE00FE00AFAF000000000000AAAA000000000000),
.INIT_05(256'h156A136C38A3910A550356001BA9B200D179CE66FCB04C00B21AA800FCB04C00),
.INIT_06(256'h2305DEF8BFEBEDB90C8074F8956B47B99F6EB0410380830099EB334100000000),
.INIT_07(256'h4EC01A945048ABB30D29DCF870C20BB9E1B87E27FF30CF00815B9B41FCB04C00),
.INIT_08(256'hF3DAF6DFF6DFF6DFDFDFDFDFDFDFDFDFDADADFDFDFDFDFDFDFDFDFDFDFDFDFDF),
.INIT_09(256'h62AF7EB3E5CCFCD522C63BDFC6C6DFDF58BC5DB9DFDFDFDF3BDF3BDFDFDFDFDF),
.INIT_0A(256'h508807DF278D75DF7F0DADDF0D0DDFDFAB5A2EDFDC5F5CDFADDFADDFDFDFDFDF),
.INIT_0B(256'hC1FD8FB3349E7FD5821449DF1414DFDF293CACB9DC5F5CDF49DF49DFDFDFDFDF),
.INIT_0C(256'hA77008DF08DF08DF8B7521DF21DF21DF7070DFDFDFDFDFDF7575DFDFDFDFDFDF),
.INIT_0D(256'hCAB5CCB3E77C4ED58ADC89DFC4766DDF0EA611B9236F93DF6DC577DF236F93DF),
.INIT_0E(256'hFCDA012760343266D35FAB274AB4986640B16F9EDC5F5CDF4634EC9EDFDFDFDF),
.INIT_0F(256'h911FC54B8F97746CD2F60327AF1DD4663E67A1F820EF10DF5E84449E236F93DF),
.INIT_10(256'h424A08000800080000000000000000004A4A0000000000000000000000000000),
.INIT_11(256'h0309D0DA636BFAF29B9902009999000060622A28000000000200020000000000),
.INIT_12(256'h47561100B11CAD00209CBC009C9C0000D3CA19002580A500BC00BC0000000000),
.INIT_13(256'h0615C9DADA775FF2BB05BE0005050000F9E233282580A500BE00BE0000000000),
.INIT_14(256'hA8F1590059005900EABB510051005100F1F1000000000000BBBB000000000000),
.INIT_15(256'hC0D5CFDA1B0CE5F258451D00E1FE1F00F2BE642829674E0090DC4C0029674E00),
.INIT_16(256'h5E1EB3F3D824C43839D41EF3F5A46938A3BAD2CB2580A500CC7077CB00000000),
.INIT_17(256'h363A25299A2878CA8B2A52F3455A2738A0F5B6E30CE7EB00E7173BCB29674E00),
.INIT_18(256'h9D95D7DFD7DFD7DFDFDFDFDFDFDFDFDF9595DFDFDFDFDFDFDFDFDFDFDFDFDFDF),
.INIT_19(256'hDCD60F05BCB4252D4446DDDF4646DFDFBFBDF5F7DFDFDFDFDDDFDDDFDFDFDFDF),
.INIT_1A(256'h9889CEDF6EC372DFFF4363DF4343DFDF0C15C6DFFA5F7ADF63DF63DFDFDFDFDF),
.INIT_1B(256'hD9CA160505A8802D64DA61DFDADADFDF263DECF7FA5F7ADF61DF61DFDFDFDFDF),
.INIT_1C(256'h772E86DF86DF86DF35648EDF8EDF8EDF2E2EDFDFDFDFDFDF6464DFDFDFDFDFDF),
.INIT_1D(256'h1F0A1005C4D33A2D879AC2DF3E21C0DF2D61BBF7F6B891DF4F0393DFF6B891DF),
.INIT_1E(256'h81C16C2C07FB1BE7E60BC12C2A7BB6E77C650D14FA5F7ADF13AFA814DFDFDFDF),
.INIT_1F(256'hE9E5FAF645F7A71554F58D2C9A85F8E77F2A693CD33834DF38C8E414F6B891DF),



	
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
