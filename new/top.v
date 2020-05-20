`timescale 1ns / 1ps

module top(
input wire clk, //XDC
input wire rst, //XDC
input wire[3:0] in, //XDC
input wire[3:0] out, //XDC
input wire open_door, //XDC
input wire close_door, //XDC
input wire sense_door, //XDC
input wire sos_req, //XDC

output wire an0, 
output wire an1, 
output wire an2, 
output wire an3,
output wire ca,
output wire cb,
output wire cc,
output wire cd,
output wire ce,
output wire cf,
output wire cg,
output wire dp,

output wire sos_led, //XDC
output wire led_floor1, //XDC
output wire led_floor2, //XDC
output wire led_floor3, //XDC
output wire led_floor4, //XDC
output wire sense_led, //XDC

output wire led_current1, //XDC
output wire led_current2, //XDC
output wire led_current3, //XDC
output wire led_current4, //XDC

output wire speaker //XDC
    );
assign led_floor1 = (requested == 1); 
assign led_floor2 = (requested == 2); 
assign led_floor3 = (requested == 3); 
assign led_floor4 = (requested == 4); 

assign led_current1 = (floor == 1);
assign led_current2 = (floor == 2);
assign led_current3 = (floor == 3);
assign led_current4 = (floor == 4);

localparam close = 2;

assign sense_led = sense_door;

wire[3:0] requested;
wire status_door;
wire sos_en; 
wire[3:0] floor;
wire[3:0] state; 
wire[3:0] doorL, doorR, dir;   
wire sos_en;
wire[3:0] floor;
wire[3:0] state;
wire[3:0] requested;

//module elevator(
//input wire clk,
//input wire rst,
//input wire[3:0] in,
//input wire[3:0] out,
//input wire open_door,
//input wire close_door,
//input wire sense_door,
//input wire sos_req,
//output wire status_door,
//output wire sos_en,
//output reg[3:0] floor,
//output reg[3:0] state,
//output reg[3:0] requested
//);

elevator e(clk, rst, in, out, open_door, close_door, sense_door, sos_req,
    status_door, sos_en, floor, state, requested);
    
//module display( 
//    input wire clk,
//    input wire rst,
//    input wire[3:0] doorL,
//    input wire[3:0] doorR,
//    input wire[3:0] dir, 
//    input wire[3:0] floor,
//    //active low 
//    output wire an0, 
//    output wire an1, 
//    output wire an2, 
//    output wire an3,
//    output reg ca,
//    output reg cb,
//    output reg cc,
//    output reg cd,
//    output reg ce,
//    output reg cf,
//    output reg cg,
//    output reg dp
//);

//module display( clk, val0, val1, val2, val3, 
//    an0, an1, an2, an3, ca, cb, cc, cd, ce, cf, cg, dp);
display d(clk, floor, dir, doorR, doorL, an0, an1, an2, an3,
    ca,cb,cc,cd,ce,cf,cg,dp);  
     
//module narrator (
//  input  wire        clk,
//  input wire rst,
//  output wire        speaker,
//  input wire[3:0] state,
//  input wire[3:0] floor
//  );

narrator n(clk, rst, speaker, state, floor);

//module blink(
//input wire clk,
//input wire rst,
//input wire[3:0] state,
//output reg[3:0] dir
//    );

blink b(clk,rst,state,dir);

//module door(
//input wire clk,
//input wire rst,
//input wire[3:0] state,
//output reg[3:0] doorL,
//output reg[3:0] doorR
//    );

door dd(clk,rst,state,doorL,doorR);  

//module sos(
//    input wire clk,
//    input wire rst,
//    input wire sos_en,
//    output wire sos_led
//);

sos s(clk,rst,sos_en,sos_led);

endmodule
