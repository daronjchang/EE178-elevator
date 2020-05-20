`timescale 1ns / 1ps

module sos(
    input wire clk,
    input wire rst,
    input wire sos_en,
    output wire sos_led
);

localparam delay = 100000000; // 1s

assign sos_led = en;

//Counter to trigger LED enable while sos_enable is active from elevator fsm
integer ctr;
reg en;
always @(posedge clk or posedge rst) begin
    if(rst || !sos_en) begin
        ctr <= 0;
        en <= 0; 
        end
    else if(ctr == delay) begin
        en <= ~en;  
        ctr <= 0;
        end
    else begin
        ctr <= ctr + 1;
        end
    end
endmodule

