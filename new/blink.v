`timescale 1ns / 1ps

module blink(
input wire clk,
input wire rst,
input wire[3:0] state,
output reg[3:0] dir
    );

integer ctr;
integer delay;
localparam slow = 100000000; //1s
localparam fast = 10000000; //.1s

localparam idle = 0;
localparam open = 1;
localparam close = 2;
localparam service = 3;
localparam accelup = 4;
localparam fastup = 5;
localparam checkup = 6;
localparam flooradd = 7;
localparam decelup = 8;
localparam acceldown = 9;
localparam fastdown = 10;
localparam checkdown = 11;
localparam floorsub = 12;
localparam deceldown = 13;
localparam sos = 14;

localparam C = 10;
localparam rC = 11;
localparam uparrow = 12;
localparam downarrow = 13;
localparam off = 14;

reg en;
wire en2;
assign en2 = (state!=idle)&&(state!=open)&&(state!=close)&&(state!=service)&&(state!=sos);

//only active during certain states with en2, en for flashing from counter
always@(*) begin
    if(en && en2) begin
        if(direction == down) begin
            dir = downarrow;
            end
         else begin
            dir = uparrow;
            end
        end
    else begin
        dir = off;
        end
    end
 //counter to set en enable   
always@(posedge clk or posedge rst) begin
    if(rst) begin
        ctr = 0;
        en = 0;
        end
     else if(ctr >= delay) begin
        ctr = 0;   
        en = ~en;
        end
     else begin
        ctr = ctr + 1;
        end
    end
reg direction;
localparam up = 0;
localparam down = 1;

//Decoder to set direction and delay
always @(*) begin
    case(state) 
        accelup: begin
            delay = slow;
            direction = up;
            end
        fastup: begin
            delay = fast;
            direction = up;
            end       
        checkup: begin
            delay = fast;
            direction = up;
            end
        flooradd: begin
            delay = fast;
            direction = up;
            end
        decelup: begin
            delay = slow;
            direction = up;
            end
        acceldown: begin 
            delay = slow;
            direction = down;
            end
        fastdown: begin
            delay = fast;
            direction = down;
            end
        checkdown: begin
            delay = fast;
            direction = down;
            end
        floorsub: begin
            delay = fast;
            direction = down;
            end
        deceldown: begin
            delay = slow;
            direction = down;
            end
        default: begin
            delay = slow;
            direction = up;
            end
        endcase;
    end    

endmodule
