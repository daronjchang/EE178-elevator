// File: narrator.v
// This is the top level design for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator timestep should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module narrator (
  input  wire        clk,
  input wire rst,
  output wire        speaker,
  input wire[3:0] state,
  input wire[3:0] floor
  );

  // Create a test circuit to exercise the chatter
  // module, rather than using switches and a
  // button.
  
  reg   [6:0] counter = 0;
  reg   [5:0] data;
  wire        write;
  wire        busy;
reg restart = 0;
always @(posedge clk) begin
     if (!busy) counter <= counter + 1;
     if(rst) counter <=0; 
     end
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

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        data = 6'h04;
        end       
    else if ((state == decelup) || (state == deceldown)) begin
        if (floor == 1) begin //First floor
            case (counter [5:2])
                1: data = 6'h04; //200ms pause
                2: data = 6'h28; //FF
                3: data = 6'h33; //ER
                4: data = 6'h37; //SS
                5: data = 6'h11; //TT
                6: data = 6'h04; //200ms pause
                7: data = 6'h28; //FF
                8: data = 6'h2d; //LL
                9: data = 6'h18; //AA
                10: data = 6'h33; //ER
                11: data = 6'h04; //200ms pause
                default: data = 6'h04; //200ms pause
                endcase
            end     
        else if (floor == 2) begin
            case (counter [5:2])
                1: data = 6'h04; //200ms pause
                2: data = 6'h37; //SS
                3: data = 6'h07; //EH
                4: data = 6'h08; //KK
                5: data = 6'h0b; //NN
                6: data = 6'h15; //DD
                7: data = 6'h04; //200ms pause
                8: data = 6'h28; //FF
                9: data = 6'h2d; //LL
                10: data = 6'h18; //AA
                11: data = 6'h33; //ER
                12: data = 6'h04; //200ms pause
                default: data = 6'h04; //200ms pause
                endcase
            end
        else if (floor == 3) begin
            case (counter [5:2])
                1: data = 6'h04; //200ms pause
                2: data = 6'h1d; //TH
                3: data = 6'h34; //ER
                4: data = 6'h15; //DD
                5: data = 6'h1e; //UH
                6: data = 6'h04; //200ms pause
                7: data = 6'h28; //FF
                8: data = 6'h2d; //LL
                9: data = 6'h18; //AA
                10: data = 6'h33; //ER
                11: data = 6'h04; //200ms pause
                default: data = 6'h04; //200ms pause
                endcase
            end
        else if (floor == 4) begin
            case (counter [5:2])
                1: data = 6'h04; //200ms pause
                2: data = 6'h28; //FF
                3: data = 6'h3a; //OR
                4: data = 6'h1d; //TH
                5: data = 6'h04; //200ms pause
                6: data = 6'h28; //FF
                7: data = 6'h2d; //LL
                8: data = 6'h18; //AA
                9: data = 6'h33; //ER
                10: data = 6'h04; //200ms pause
                default: data = 6'h04; //200ms pause
                endcase                       
            end 
        else begin
            data = 6'h04;
            end
        end
    else if (state == open) begin
        case (counter [5:2])
            1: data = 6'h04; //200ms pause
            2: data = 6'h35; //OW
            3: data = 6'h09; //PP
            4: data = 6'h07; //EH
            5: data = 6'h0b; //NN
            6: data = 6'h04; //200ms pause
            7: data = 6'h15; //DD
            8: data = 6'h1e; //UH
            9: data = 6'h33; //ER
            10: data = 6'h04; //200ms pause
            default: data = 6'h04; //200ms pause
            endcase
        end                                                    
    else if (state == close) begin
        case (counter [5:2])
            1: data = 6'h04; //200ms pause
            2: data = 6'h08; //KK
            3: data = 6'h2d; //LL
            4: data = 6'h35; //OW
            5: data = 6'h37; //SS
            6: data = 6'h04; //200ms pause
            7: data = 6'h15; //DD
            8: data = 6'h1e; //UH
            9: data = 6'h33; //ER
            10: data = 6'h04; //200ms pause
            default: data = 6'h04; //200ms pause
            endcase
        end
    else if (state == sos) begin
        case (counter [5:2])
            1: data = 6'h04; //200ms pause  
            2: data = 6'h07; //EH
            3: data = 6'h37; //SS
            4: data = 6'h04; //200ms pause
            5: data = 6'h35; //OW
            6: data = 6'h04; //200ms pause
            7: data = 6'h07; //EH
            8: data = 6'h37; //SS
            9: data = 6'h04; //200ms pause
            default: data = 6'h04; //200ms pause
            endcase
        end      
    else if (state == accelup) begin
        case (counter [5:2])
            1: data = 6'h04; //200ms pause
            2: data = 6'h24; //GG
            3: data = 6'h35; //OW
            4: data = 6'h13; //IY
            5: data = 6'h2c; //NG
            6: data = 6'h04; //200ms pause
            7: data = 6'h1e; //UH
            8: data = 6'h09; //PP
            9: data = 6'h04; //200ms pause
            default: data = 6'h04; //200ms pause
        endcase
            end
    else if (state == acceldown) begin
        case (counter [5:2])
            1: data = 6'h04; //200ms pause
            2: data = 6'h24; //GG
            3: data = 6'h35; //OW
            4: data = 6'h13; //IY
            5: data = 6'h2c; //NG
            6: data = 6'h04; //200ms pause
            7: data = 6'h21; //DD
            8: data = 6'h20; //AW
            9: data = 6'h0b; //NN
            10: data = 6'h04; //200ms pause
            default: data = 6'h04; //200ms pause
            endcase
        end                 
    else begin           
        data = 6'h04; //200ms pause
        end                                                  
    end

  assign write = (counter[1:0] == 2'b00);
  
  // Instantiate the chatter module, which is
  // driven by the test circuit.

  chatter chatter_inst (
    .data(data),
    .write(write),
    .busy(busy),
    .clk(clk),
    .speaker(speaker)
  );

endmodule
