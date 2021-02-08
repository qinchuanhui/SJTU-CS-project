`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 15:59:20
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input Clk,
    input reset
    );
    
    wire STALL;
     // IF/ID
    reg  [31:0] IFID_pctmp, IFID_inst;
    wire [4:0]  IFID_rs = IFID_inst[25:21], IFID_rt = IFID_inst[20:16],
    IFID_rd = IFID_inst[15:11];
    

    // ID/EX
    reg [31:0] IDEX_readData1, IDEX_readData2, IDEX_immData;
    reg [31:0] IDEX_pctmp;
    reg [4:0] IDEX_rs, IDEX_rt, IDEX_rd;
    reg [10:0] IDEX_ctrl;
    reg IDEX_JUMP;
    
    wire[3:0] IDEX_ALUOP = IDEX_ctrl[9:6];
    wire IDEX_RegDst = IDEX_ctrl[10], IDEX_ALUSrc= IDEX_ctrl[5], 
    IDEX_Branch = IDEX_ctrl[4], IDEX_MemRead = IDEX_ctrl[3], 
    IDEX_MemWrite = IDEX_ctrl[2], IDEX_RegWrite = IDEX_ctrl[1],
    IDEX_MemtoReg = IDEX_ctrl[0];
    wire PCsrc;
    
    wire [31:0] Finaladdr;
    
    // EX/MEM
    reg [31:0] EXMEM_ALUres, EXMEM_writeData;
    reg [4:0] EXMEM_dstReg;
    reg [4:0] EXMEM_ctrl;
    reg EXMEM_zero;
    wire EXMEM_MemRead = EXMEM_ctrl[3],
    EXMEM_MemWrite = EXMEM_ctrl[2], EXMEM_RegWrite = EXMEM_ctrl[1],
    EXMEM_MemtoReg = EXMEM_ctrl[0];
    
    

    // MEM/WB
    reg [31:0] MEMWB_readData, MEMWB_ALUres;
    reg [4:0] MEMWB_dstReg;
    reg [1:0] MEMWB_ctrl;
    wire MEMWB_RegWrite = MEMWB_ctrl[1], MEMWB_MemtoReg = MEMWB_ctrl[0];
     
   //IF stage
    reg [31:0] PC,PC_PLUS_4;
    wire [31:0] PC_NEXT;
    wire [31:0] IF_INST;
    wire Jr;
    
     InstMemory im0(
    .readaddress(PC),
    .readinst(IF_INST)
    );
    
    
    
     assign PC_NEXT =Jr? IDEX_readData1:  PCsrc?  Finaladdr: PC_PLUS_4;
   
    always @ (reset or posedge Clk)
    begin
         if(reset) 
         begin
         PC=0;
         PC_PLUS_4=0;
         end
        else if(Clk)
        if (!STALL)
        begin    
            PC = PC_NEXT;
            PC_PLUS_4 = PC + 4;
        end
        
        if (PCsrc)
          IFID_inst = 0; // flush
    end
   
   always @ (reset or negedge Clk)
   if (reset)
        begin
        IFID_pctmp <= 0;
        IFID_inst<= 0;
        end
   else 
    begin
    IFID_inst <= IF_INST;
    IFID_pctmp<=PC_PLUS_4;
    end
  // ID
    wire [10:0] IDEX_CTRL;
    wire Jump;
   ctr ctr0(
    .opcode(IFID_inst[31:26]),
    .aluop(IDEX_CTRL[9:6]),
    .branch(IDEX_CTRL[4]),
    .jump(Jump),
    .alusrc(IDEX_CTRL[5]),
    .memwrite(IDEX_CTRL[2]),
    .regwrite(IDEX_CTRL[1]),  
    .memtoreg(IDEX_CTRL[0]),
    .memread(IDEX_CTRL[3]),  
    .regdst(IDEX_CTRL[10])
    );
    
     wire [31:0] WriteDataR;
     wire [4:0] WriteReg;
     wire [31:0] IDEX_READDATA1, IDEX_READDATA2;
     wire RegWrite;
     Reg reg0(
    .Clk(Clk), 
    .readReg1(IFID_rs),
    .readReg2(IFID_rt),
    .writeReg(WriteReg),
    .writeData(WriteDataR),
    .regwrite(RegWrite),
    .readData1(IDEX_READDATA1),
    .readData2(IDEX_READDATA2),
    .reset(reset)
    );
    
    wire [31:0] IDEX_IMMDATA;
    sign sextend0(
    .inst(IFID_inst [15:0]),
    .data(IDEX_IMMDATA)
    );
    
    wire [31:0] Jumpaddr;
    wire [31:0] Branchaddr;
    wire Equal;
    assign Equal=IDEX_READDATA1==IDEX_READDATA2;
    assign PCsrc=(IDEX_Branch && Equal)|| IDEX_JUMP ;
    assign Branchaddr=IDEX_pctmp+(IDEX_immData<<2);
    assign Jumpaddr[31:28]=IDEX_pctmp[31:28];
    assign Jumpaddr[27:23]=IDEX_rs;
    assign Jumpaddr[22:18]=IDEX_rt;
    assign Jumpaddr[17:2]=IDEX_immData;
    assign Jumpaddr[1:0]=0;
    assign Finaladdr=IDEX_JUMP ? Jumpaddr :Branchaddr;
    
    always @ (reset or negedge Clk )
   if (reset)
        begin
        IDEX_rs <= 0;
        IDEX_readData1 <= 0;
        IDEX_readData2 <= 0;
        IDEX_immData <= 0;
        IDEX_rt <= 0;
        IDEX_rd <= 0;
        IDEX_ctrl <= 0;
        IDEX_JUMP<=0;
        end
    else 
    begin
    IDEX_rs<=IFID_rs;
    IDEX_rt<=IFID_rt;
    IDEX_rd<=IFID_rd;
    IDEX_pctmp<=IFID_pctmp;
    IDEX_ctrl<= STALL ? 0:IDEX_CTRL; //SET ONE STALL
    IDEX_readData2<=IDEX_READDATA2;
    IDEX_readData1<=IDEX_READDATA1;
    IDEX_immData<=IDEX_IMMDATA;
    IDEX_JUMP<= Jump;
    end

  // Hazard detection  for lw
    assign STALL = IDEX_MemRead && 
        (IDEX_rt == IFID_rs || IDEX_rt == IFID_rt);
        
  //EX stage 
  
  //forward unit
  wire FWD_EX_1 = EXMEM_RegWrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_rs;
  wire FWD_EX_2 = EXMEM_RegWrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_rt;
  wire FWD_MEM_1 = MEMWB_RegWrite & MEMWB_dstReg != 0 
	& !(EXMEM_RegWrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_rs) 
	& MEMWB_dstReg == IDEX_rs;
  wire FWD_MEM_2 = MEMWB_RegWrite & MEMWB_dstReg != 0 
	& !(EXMEM_RegWrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_rt) //lw在R 之前发生，需要排除。
	& MEMWB_dstReg == IDEX_rt;
 
  wire [3:0] ALUctr;
  wire shiftmux;
  wire Jal;
 
  aluctr aluctr0(
    .ALUOp(IDEX_ALUOP),  
    .Funct(IDEX_immData[5:0]),
    .Oper(ALUctr),   
    .shiftmux(shiftmux),
    .Jal(Jal),
    .Jr(Jr)
    ); 
    
    
    wire[31:0] tmp1,tmp2,input1, input2;
    assign tmp2= IDEX_ALUSrc ? IDEX_immData :IDEX_readData2;
    assign tmp1= shiftmux? IDEX_immData[10:6] : IDEX_readData1;//for sll
    assign input1= FWD_EX_1? EXMEM_ALUres : FWD_MEM_1? WriteDataR: tmp1;
    assign input2= FWD_EX_2? EXMEM_ALUres : FWD_MEM_2? WriteDataR: tmp2;
    
   wire EXMEM_ZERO;
   wire [31:0] EXMEM_ALURES;
    alu alu0(
    .input1(input1),    
    .input2(input2),
    .aluCtr(ALUctr),   
    .zero(EXMEM_ZERO),
    .aluRes(EXMEM_ALURES)
    );   
    
     
    always @ (reset or negedge Clk)
    if (reset)
    begin
        EXMEM_ALUres <= 0;
        EXMEM_writeData <= 0;
        EXMEM_dstReg <= 0;
        EXMEM_ctrl <= 0;
        EXMEM_zero <= 0;
    end
    else
    begin
    EXMEM_writeData<=FWD_EX_2? EXMEM_ALUres : FWD_MEM_2? MEMWB_readData:IDEX_readData2;
    EXMEM_dstReg<= Jal? 31: IDEX_RegDst?  IDEX_rd:IDEX_rt;
    EXMEM_ctrl<=IDEX_ctrl[4:0];
    EXMEM_ALUres<=Jal? IDEX_pctmp: EXMEM_ALURES;
    EXMEM_zero<=EXMEM_ZERO;
    end
    
   //MEM stage
   wire [31:0] MEMWB_READDATA;
    DM dm0(
    .Clk(Clk),  
    .address(EXMEM_ALUres),
    .writeData(EXMEM_writeData),  
    .memwrite(EXMEM_MemWrite),
    .memread(EXMEM_MemRead),  
    .readData(MEMWB_READDATA)
    );
    
    
    
    
    always @ (reset or negedge Clk)
    if(reset)
    begin
        MEMWB_readData <= 0;
        MEMWB_ALUres <= 0;
        MEMWB_dstReg <= 0;
        MEMWB_ctrl <= 0;
    end
    else
    begin
    MEMWB_ALUres<=EXMEM_ALUres;
    MEMWB_dstReg<=EXMEM_dstReg;
    MEMWB_ctrl<=EXMEM_ctrl[1:0];
    MEMWB_readData<=MEMWB_READDATA;
    end
    
    //WB
   assign WriteDataR= MEMWB_MemtoReg ? MEMWB_readData : MEMWB_ALUres;
   assign RegWrite=MEMWB_RegWrite;
   assign WriteReg=MEMWB_dstReg;
   
     
endmodule
