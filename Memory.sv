// model of Memory
timeunit 1ns; timeprecision 10ps;

module Memory #(
    parameter N = 16,  // N-bits wide
    parameter M = 32  // M locations 111
    )(
    input logic Clk,
    input logic reset,
    input logic signed [N-1:0] wdata,
    input logic [$clog2(M)-1:0] raddr,
    input logic [$clog2(M)-1:0] waddr,
    output logic signed [N-1:0] rdata
);

logic signed [N-1:0] mem [0:M-1];

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        // reset Memory to 0
        $readmemb("memory_data.txt", mem);
        rdata <= '0;

    end else begin
         // Write data to memory only if waddr != 0 or wdata != 0
        if (raddr >= 2 && waddr < M) begin
            mem[waddr] <= wdata;
        end
        if (raddr < M) begin
            rdata <= mem[raddr];
        end
    end
end

endmodule

