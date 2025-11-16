// model of Memory

module Memory #(
    parameter N = 8,  // N-bits wide
    parameter M = 16  // M locations
    )(
    input logic Clk,
    input logic reset,
    input logic [N-1:0] wdata,
    input logic [$clog2(M)-1:0] raddr,
    input logic [$clog2(M)-1:0] waddr,
    output logic [N-1:0] rdata
);

logic [N-1:0] mem [0:M-1];

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        // reset Memory to 0
        for (int i = 0; i < M; i++) begin
            mem[i] <= '0;
        end
    end else begin
        // write data to memory
        mem[waddr] <= wdata;
    end
end

always_ff @(posedge Clk) begin
    // read data from memory
    rdata <= mem[raddr];
end

endmodule

