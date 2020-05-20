`timescale 1ns / 1ps

module elevator(
input wire clk,
input wire rst,
input wire[3:0] in,
input wire[3:0] out,
input wire open_door,
input wire close_door,
input wire sense_door,
input wire sos_req,
output wire status_door,
output wire sos_en,
output reg[3:0] floor,
output reg[3:0] state,
output reg[3:0] requested
);

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

integer ctr;
//localparam d1 = 1;
//localparam d3 = 3;
//localparam d5 = 5;

//100,000,000
localparam d1 = 100000000;
localparam d3 = 300000000;
localparam d5 = 500000000;

localparam f1 = 1;
localparam f2 = 2;
localparam f3 = 3;
localparam f4 = 4;

//direction 0 up 1 down
localparam down = 1;
localparam up = 0;

assign status_door = (state==open); 
assign sos_en = (state==sos);
       
always@(posedge clk or posedge rst) begin //Combo + Counter
    if(rst) begin
        state = idle;
        ctr = 0;
        requested = f1;  
        floor = f1;
        end
    else if(sos_req) begin //SOS if triggered
        state = sos;
        end
    else begin
        case(state)
            idle: begin           
                if(open_door) begin
                    state = open;
                    end
                else if(close_door) begin
                    state = close;
                    end
                else if(in != floor && in != 0) begin //Inside Set, Higher Priority
                    requested = in;
                    state = service;
                    end
                else if(out != floor && out != 0) begin //Outside Set, Higher Priority
                    requested = out;
                    state = service;
                    end
                else begin
                    state = idle;
                    end
                end
            open: begin //3 Seconds to Open Before Going To Closing
                if(ctr == d3) begin
                    ctr = 0;
                    state = close;
                    end
                else begin
                    state = open;
                    ctr = ctr + 1;        
                    end
                end
            close: begin //3 Seconds to close before going idle
                if(sense_door) begin //Interrupt, if there is something OPEN DOOR
                    ctr = 0;
                    state = open;
                    end
                else if(ctr == d3) begin
                    ctr = 0;
                    state <= idle;
                    end
                else begin
                    state = close;
                    ctr = ctr + 1;              
                    end
                end
            service: begin //Deciding Direction
                if(floor < requested) begin //Go up
                    state = accelup;
                    end
                else if(floor > requested) begin //Go down
                    state = acceldown;
                    end
                else begin //If not just open door and return idle
                    state = open;                   
                    end
                end
            accelup: begin //Start accelerating up
                if(ctr == d3) begin                    
                    state = fastup;
                    ctr = 0;
                    end
                else begin
                    state <= accelup;
                    ctr = ctr + 1;
                    end
                end
            fastup: begin //Go up fast 
                if(ctr == d5) begin //5s per floor  
                    state = checkup;                                    
                    ctr = 0;
                    end
                else begin                    
                    state = fastup;
                    ctr = ctr + 1;
                    end
                end
            checkup: begin //Check if next floor is desired
                if((floor + 1) == requested) begin
                    state = decelup;
                    floor = floor + 1;
                    end
                else begin
                    state = flooradd; 
                    end
                end
            flooradd: begin
                floor = floor + 1;
                state = fastup;
                end            
            decelup: begin //Slow down going upwards then open door
                if(ctr == d3) begin                    
                    state = open;
                    ctr = 0;
                    end
                else begin                   
                    state = decelup;
                    ctr = ctr + 1;
                    end
                end
            acceldown: begin //Start accelerating down
                if(ctr == d3) begin                   
                    state = fastdown;
                    ctr = 0;
                    end
                else begin                    
                    state = acceldown;
                    ctr = ctr + 1;
                    end
                end
            fastdown: begin //Go fast down
                if(ctr == d5) begin     
                    state = checkdown;                                              
                    ctr = 0;
                    end
                else begin                   
                    state = fastdown;
                    ctr = ctr + 1;
                    end
                end
            checkdown: begin //check if next floor is desired
                if((floor-1) == requested) begin
                    state = deceldown;
                    floor = floor - 1;
                    end
                else begin
                    state = floorsub;
                    end
                end
            floorsub: begin
                floor = floor - 1;
                state = fastdown;
                end
            deceldown: begin //Slow down going down then open door
                if(ctr == d3) begin                   
                    state = open;
                    ctr = 0;
                    end
                 else begin                  
                    state = deceldown;
                    ctr = ctr + 1;
                    end
                 end
             sos: begin //SOS state, stay until global reset, enable SOS fsm to flash
                state = sos;
                end
             default: begin
                state = idle; //Default of idle
                end
             endcase
         end 
     end                                                                          
endmodule
