// model of Memory

module Memory #(
    parameter N = 8,  // N-bits wide
    parameter M = 16  // M locations 111
    )(
    input logic Clk,
    input logic reset,
    input logic signed [N-1:0] wdata,
    input logic [$clog2(M)-1:0] raddr,
    input logic [$clog2(M)-1:0] waddr,
    output logic signed [N-1:0] rdata
);

logic signed [N-1:0] mem [0:M-1];
// logic signed [N-1:0] wdata_buffer; // buffer for write data

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        // reset Memory to 0
        for (int i = 0; i < M; i++) begin
            mem[i] <= '0;
        end
        wdata_buffer = '0;
    end else begin
         // Write data to memory only if waddr != 0 or wdata != 0
        if (!(waddr == 0 && wdata == 0)) begin
            mem[waddr] <= wdata;
        end
    end

always_ff @(posedge Clk) begin
    // read data from memory
    rdata <= mem[raddr];
end

endmodule

