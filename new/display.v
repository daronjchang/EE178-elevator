`timescale 1ns / 1ps

module display( clk, val0, val1, val2, val3, 
    an0, an1, an2, an3, ca, cb, cc, cd, ce, cf, cg, dp);
    input wire clk;
    input wire[3:0] val0, val1, val2, val3;
    //active low 
    output wire an0, an1, an2, an3;
    output reg ca,cb,cc,cd,ce,cf,cg,dp;
    reg[0:1] state;
    reg[3:0] t_mux_out;
    initial begin
        assign dp = 1'b1; 
        state = 2'b00;
        t_mux_out = 4'b0000;
    end
   
    //FSM counter 00, 01, 10, 11 
    reg[0:9] counter = 10'b0;
    always @(posedge clk) begin
        if(state==2'b11 && counter == 10'b1111111111) begin
            state <= 2'b00;
            counter <=10'b0;
            end
        else if(counter == 10'b1111111111) begin
            state <= state + 2'b01;
            counter <= 10'b0;
            end
        else begin
            counter <= counter + 1'b1;
            end
        end
    //Multiplex based on state        
    assign an0 = ~(state == 2'b00);
    assign an1 = ~(state ==2'b01);
    assign an2 = ~(state ==2'b10);
    assign an3 = ~(state ==2'b11);
    //Datapath multiplex based on state
    always @(*) begin
        case(state)
            2'b00: begin
                t_mux_out = val0;
                end     
            2'b01: begin
                t_mux_out = val1;
                end
            2'b10: begin
                t_mux_out = val2;
                end
            2'b11: begin
                t_mux_out = val3;
                end
            default: t_mux_out = 4'b0000;
        endcase       
    end
    
    always @(*) begin
        case(t_mux_out)
            4'b0000: begin //0
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b0;
                cf = 1'b0;
                cg = 1'b1;
                end
            4'b0001: begin //1
                ca = 1'b1;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b1;
                ce = 1'b1;
                cf = 1'b1;
                cg = 1'b1;
                end
            4'b0010: begin //2
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b1;
                cd = 1'b0;
                ce = 1'b0;
                cf = 1'b1;
                cg = 1'b0;
                end
            4'b0011: begin //3
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b1;
                cf = 1'b1;
                cg = 1'b0;
                end
            4'b0100: begin //4 f,g,c,b illuminate
                ca = 1'b1;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b1;
                ce = 1'b1;
                cf = 1'b0;
                cg = 1'b0;
                end
            4'b0101: begin //5
                ca = 1'b0;
                cb = 1'b1;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b1;
                cf = 1'b0;
                cg = 1'b0;
                end
            4'b0110: begin //6 a,c,d,e,f,g illuminate
                ca = 1'b0;
                cb = 1'b1;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b0;
                cf = 1'b0;
                cg = 1'b0;
                end
            4'b0111: begin //7 f,a,b,c illum
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b1;
                ce = 1'b1;
                cf = 1'b0;
                cg = 1'b1;
                end
            4'b1000: begin //8
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b0;
                cf = 1'b0;
                cg = 1'b0;
                end
            4'b1001: begin //9 e off
                ca = 1'b0;
                cb = 1'b0;
                cc = 1'b0;
                cd = 1'b0;
                ce = 1'b1;
                cf = 1'b0;
                cg = 1'b0;
                end
            4'b1010: begin //C 10
                ca = 0;
                cb = 1;
                cc = 1;
                cd = 0;
                ce = 0;
                cf = 0;
                cg = 1;
                end
            4'b1011: begin //REVERSE C 11
                ca = 0;
                cb = 0;
                cc = 0;
                cd = 0;
                ce = 1;
                cf = 1; 
                cg = 1;  
                end
            4'b1100: begin //UP ARROW 12
                ca = 0;
                cb = 0;
                cc = 1;
                cd = 1;
                ce = 1;
                cf = 0;
                cg = 1; 
                end 
            4'b1101: begin //DOWN ARROW 13
                ca = 1;
                cb = 1;
                cc = 0;
                cd = 0;
                ce = 0;
                cf = 1;
                cg = 1; 
                end  
            4'b1110: begin// OFF
                ca = 1;
                cb = 1;
                cc = 1;
                cd = 1;
                ce = 1;
                cf = 1;
                cg = 1; 
                end
            default: begin
                ca = 1'b1;
                cb = 1'b1;
                cc = 1'b1;
                cd = 1'b1;
                ce = 1'b1;
                cf = 1'b1;
                cg = 1'b0;
                end   
            endcase
        end       
endmodule


