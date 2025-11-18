// module of NEO

module NEO #(
    parameter N = 8,  // N-bits wide
    parameter M = 16  // M locations
    )(
    input logic Clk,
    input logic reset,
    input logic [N-1:0] rdata,
    output logic [$clog2(M)-1:0] raddr,
    output logic [$clog2(M)-1:0] waddr,
    output logic [N-1:0] wdata
);

logic [N-1:0] xn_prev, xn_curr, xn_next;
logic [$clog2(M)-1:0] counter;

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        counter <= '0;
        raddr <= '0;
        waddr <= '0;
        wdata <= '0;
        xn_prev <= '0;
        xn_curr <= '0;
        xn_next <= '0;
    end else begin
        // Example 
        // Simple processing: shift data through registers
        xn_next <= rdata; 
        xn_curr <= xn_next;
        xn_prev <= xn_curr; 
        
          

        // Update addresses and data for Memory module
        raddr <= raddr + 1;
        waddr <= waddr + 1;
        wdata <= xn_curr;
    end
end