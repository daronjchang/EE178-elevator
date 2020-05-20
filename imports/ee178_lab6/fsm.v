// File: fsm.v
// This is the FSM module for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator timestep should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module fsm (
  output wire        busy,
  input  wire        period_expired,
  input  wire        data_arrived,
  input  wire        val_match,
  output wire        load_ptrs,
  output wire        increment,
  output wire        sample_capture,
  input  wire        clk
  );
 
 localparam IDLE = 0;
  localparam LOAD =  1;
  localparam WAITSTATE = 2;
  localparam FETCH = 3;
  localparam FETCHPER = 4;
  localparam INCR = 5;

  assign busy = (state != IDLE);
  assign load_ptrs = (state == LOAD);
  assign increment = (state ==INCR);
  assign sample_capture = (state == FETCH); 
    
    initial begin
    state <=IDLE;
    end
  reg[2:0] state;
  reg[2:0] next;
  reg rst;
  always @(posedge clk) begin
//        if(rst) begin
//            state <=IDLE;
//            next <=IDLE;
//            end
//         else begin
        state <= next;
    end
    

  reg[1:0] ctr;
  always @(*) begin
    case(state) 
       IDLE: begin //idle
            if(data_arrived) begin
                next = LOAD;
                end
            else begin
                next = IDLE;
                end
            end
        LOAD: begin //load
            next = WAITSTATE;
            ctr <= 4;
            end
        WAITSTATE: begin //latency from ip module wait
            if(ctr == 0) begin
                next = FETCH;
                end
            else begin 
                ctr <= ctr -1;
                next = WAITSTATE;
            end
            end
        FETCH: begin //fetch check
            if(val_match) begin
                next = IDLE;
                end
            else begin
                next = FETCHPER;
            end
            end
        FETCHPER: begin
            if(period_expired) begin
                next = INCR;
                end
            else begin
                next = FETCHPER;
                end
                end
        INCR: begin //ptr incr
            if(val_match) begin
                next = IDLE;
            end  
            else begin
                next = WAITSTATE;
                end
            end
         default: begin
            next = IDLE;
            end
          endcase  
         
      end
           
endmodule
