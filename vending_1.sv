module vending_1 (
  // input
  input logic clk_i,
  input logic nickle_i,
  input logic dime_i,
  input logic quarter_i,

  // output
  output logic soda_o,
  output logic [2:0] change_o
);

  // local declaration
  logic [2:0] ps_tmp; // temporary for Present State result
  logic [2:0] ns_tmp; // temporary for Next State result
  logic c_tmp; //0 : no change ; 1: change 
  localparam S0 = 3'b000; // 0
  localparam S1 = 3'b001; // 5
  localparam S2 = 3'b010; // 10
  localparam S3 = 3'b011; // 15
  
  always_latch begin : proc_main
  case (ps_tmp)
    S0: begin
      soda_o = 1'b0;
      change_o = 3'b000;
      if (nickle_i) begin
      	ns_tmp = S1 ; c_tmp = 1'b0;
      end
      else if (dime_i) begin
	    ns_tmp = S2 ; c_tmp = 1'b0;    
      end
      else if (quarter_i) begin
      	ns_tmp = S1 ; c_tmp = 1'b1;
      end
      else ns_tmp = ps_tmp;
      if (c_tmp) begin 
      	change_o = ns_tmp;
	ns_tmp = 3'b000;
	soda_o = 1'b1;
      end
    end

    S1: begin
	  soda_o = 1'b0;
          change_o = 3'b000;
	  if (nickle_i) begin
	    ns_tmp = S2 ; c_tmp = 1'b0;
	  end
	  else if (dime_i) begin
	    ns_tmp = S3 ; c_tmp = 1'b0;    
	  end
	  else if (quarter_i) begin
	    ns_tmp = S2 ; c_tmp = 1'b1;
	  end
	  else ns_tmp = ps_tmp;
	  if (c_tmp) begin 
	    change_o = ns_tmp; 
	    ns_tmp = 3'b000;
	    soda_o = 1'b1;
	  end	
    end

    S2: begin
      soda_o = 1'b0;
      change_o = 3'b000;
      if (nickle_i) begin
        ns_tmp = S3 ; c_tmp = 1'b0;
      end
      else if (dime_i) begin
	ns_tmp = S0 ; c_tmp = 1'b1;    
      end
      else if (quarter_i)begin
	ns_tmp = S3 ; c_tmp = 1'b1;
      end
      else ns_tmp = ps_tmp;
      if (c_tmp) begin 
	change_o = ns_tmp ; 
	ns_tmp = S0;
	soda_o = 1'b1;
      end
    end

    S3: begin
    soda_o = 1'b0;
    change_o = 3'b000;
    if (nickle_i) begin
      ns_tmp = S0 ; c_tmp = 1'b1;
    end
    else if (dime_i) begin
      ns_tmp = S1 ; c_tmp = 1'b1;    
    end
    else if (quarter_i) begin
      ns_tmp = 3'b100 ; c_tmp = 1'b1;
    end
    else ns_tmp = ps_tmp;
    if (c_tmp) begin 
      change_o = ns_tmp ;
      ns_tmp = S0;
      soda_o = 1'b1;
    end	
    end

    default : begin
      ns_tmp = S0;
      soda_o = 1'b0;
      change_o = 3'b000;
    end 
  endcase
end

always_ff @(posedge clk_i) begin : proc_state
  ps_tmp <= ns_tmp; 
end
endmodule : vending_1