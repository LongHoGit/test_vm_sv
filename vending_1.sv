module vending_1(
clk_i,nickle_i,dime_i,quarter_i,
soda_o,change_o);
  ////// input//////////
  input logic clk_i,nickle_i,dime_i,quarter_i;

  ////// output////////
  output logic soda_o;
  output logic [2:0] change_o;


  logic [2:0] ps; /////present state     //      
  logic [2:0] ns; /////next state        //        
  logic c;        /////select ouput state//
  localparam S0 = 3'b000;
  localparam S1 = 3'b001; 
  localparam S2 = 3'b010;
  localparam S3 = 3'b011;
  localparam S4 = 3'b100;
  
 //State machine////
  always_latch begin : proc_main 
  case (ps)
    S0: begin
      soda_o = 1'b0;
      change_o = 3'b000;
      if (nickle_i) 
      begin
        ns = S1 ; 
        c = 1'b0;
      end
      else if (dime_i) 
      begin
        ns = S2 ; 
        c = 1'b0;    
      end
      else if (quarter_i) 
      begin
        ns = S1 ; 
        c = 1'b1;
      end
      else ns = ps;
    //Check//
      if (c) 
      begin 
        change_o = ns;
        ns = S0;
        soda_o = 1'b1;
      end
    end

    S1: begin
    soda_o = 1'b0;
    change_o = 3'b000;
    if (nickle_i) 
      begin
        ns = S2 ; 
        c = 1'b0;
      end
    else if (dime_i) 
      begin
        ns = S3 ; 
        c = 1'b0;    
      end
    else if (quarter_i) 
      begin
        ns = S2 ; 
        c = 1'b1;
      end
    else ns = ps; 
    //Check//   
    if (c) 
      begin 
        change_o = ns; 
        ns = S0;
        soda_o = 1'b1;
      end 
     end

    S2: begin  //
      soda_o = 1'b0;
      change_o = 3'b000;
      if (nickle_i) 
      begin
        ns = S3 ; 
        c = 1'b0;
      end
      else if (dime_i) 
      begin
        ns = S0 ; 
        c = 1'b1;    
      end
      else if (quarter_i)
      begin
        ns = S3 ; 
        c = 1'b1;
      end
      else ns = ps;
    //Check//   
      if (c) 
      begin 
        change_o = ns ; 
        ns = S0;
        soda_o = 1'b1;
      end
    end

    S3: begin ///////state 3////
    soda_o = 1'b0;
    change_o = 3'b000;
    if (nickle_i) 
    begin
      ns = S0 ; 
      c = 1'b1;
    end
    else if (dime_i) 
    begin
      ns = S1 ; 
      c = 1'b1;    
    end
    else if (quarter_i) 
    begin
      ns = S4 ; 
      c = 1'b1;
    end
    else ns = ps;
    //Check//
    if (c) begin 
      change_o = ns ;
      ns = S0;
      soda_o = 1'b1;
    end 
    end

    default : //State 4///
    begin
      ns = S0;
      soda_o = 1'b0;
      change_o = 3'b000;
    end 
  endcase
  end

  ////Flip-Flop/////
  always_ff @(posedge clk_i) begin : proc_FlipFlop 
    ps <= ns; 
  end
  
endmodule : vending_1