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
    
    reg [31:0] pc;
  
    wire RegDst;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [2:0]ALUOp;
    wire MemWrite;
    wire ALUsrc;
    wire RegWrite;
    wire [31:0] inst;
    wire [3:0] ALUctr;
    wire [31:0] ALUres;
    wire [31:0] memdata;
    wire [4:0] WriteReg;
    wire [31:0] immedata;
    wire [31:0] input1;
    wire [31:0] data1;
    wire [31:0] data2;
    wire [31:0] input2;
    wire [31:0] WriteDataR;
    wire zero;
    wire shiftmux;//for sll srl
    wire [31:0] branchmux;
    wire branchjudge;
    wire [31:0] jumpmux;
    wire [31:0] pctmp;
    wire [31:0] jumptmp;
    wire [31:0] branchtmp;
    wire [27:0] jumpshift;
    wire Jal;
    wire Jr;
    
    always @ (reset or  posedge Clk )
     begin
     if(reset) 
     pc=0;
   
     else if (Clk)pc = jumpmux;
     end 
   
    assign branchjudge= Branch && zero;
    assign pctmp=pc+4;
    assign branchtmp = (immedata<<2)+pctmp;
    assign jumpshift[27:2]= inst[25:0];
    assign jumpshift[1:0]= 2'b00;
    assign branchmux= branchjudge ? branchtmp: pctmp;
    assign jumptmp[31:28] = pctmp[31:28];
    assign jumptmp[27:0]=jumpshift;
    
    assign jumpmux= Jr? data1: Jump? jumptmp: branchmux;
    
    DM dm0(
    .Clk(Clk),  
    .address(ALUres),
    .writeData(data2),  
    .memwrite(MemWrite),
    .memread(MemRead),  
    .readData(memdata)
    );
    
    InstMemory im0(
    .readaddress(pc),
    .readinst(inst)
    );
    
    sign sextend0(
    .inst(inst[15:0]),
    .data(immedata)
    );
    
    assign input2= ALUsrc ? immedata :data2;
    assign input1= shiftmux? inst[10:6] : data1;
    alu alu0(
    .input1(input1),    
    .input2(input2),
    .aluCtr(ALUctr),   
    .zero(zero),
    .aluRes(ALUres)
    );   
    
    aluctr aluctr0(
    .ALUOp(ALUOp),  
    .Funct(inst[5:0]),
    .Oper(ALUctr),   
    .shiftmux(shiftmux),
    .Jal(Jal),
    .Jr(Jr)
    );
    
    ctr ctr0(
    .opcode(inst[31:26]),
    .aluop(ALUOp),
    .branch(Branch),
    .jump(Jump),
    .alusrc(ALUsrc),
    .memwrite(MemWrite),
    .regwrite(RegWrite),  
    .memtoreg(MemtoReg),
    .memread(MemRead),  
    .regdst(RegDst)
    );
    
    
    assign WriteReg = Jal? 31: RegDst? inst[15:11] : inst[20:16];
    assign WriteDataR= Jal? pctmp :MemtoReg ? memdata : ALUres;
    
    Reg reg0(
    .Clk(Clk), 
    .readReg1(inst [25:21]),
    .readReg2(inst [20:16]),
    .writeReg(WriteReg),
    .writeData(WriteDataR),
    .regwrite(RegWrite),
    .readData1(data1),
    .readData2(data2),
    .reset(reset)
    );
    
   
endmodule
