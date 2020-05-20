`timescale 1ns / 1ps

module door(
input wire clk,
input wire rst,
input wire[3:0] state,
output reg[3:0] doorL,
output reg[3:0] doorR
    );
    
localparam C = 10;
localparam revC = 11;
localparam up = 12;
localparam down = 13;    
localparam off = 14;


localparam idle = 0;
localparam open = 1;
localparam close = 2;
localparam service = 10;
localparam accelup = 3;
localparam fastup = 4;
localparam decelup = 5;
localparam acceldown = 6;
localparam fastdown = 7;
localparam deceldown = 8;
localparam sos = 9;

//Default closed mode, if state is open swaps
always@(posedge clk or posedge rst) begin
    if(rst) begin
        doorL <= revC;
        doorR <= C;
        end
    else begin
        if(state == open) begin
            doorL = C;
            doorR = revC;
            end
        else begin
            doorL = revC;
            doorR = C;
            end
        end
    end                   
endmodule
