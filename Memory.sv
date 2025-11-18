// model of Memory

module Memory #(
    parameter N = 8,  // N-bits wide
    parameter M = 8  // M locations 111
    )(
    input logic Clk,
    input logic reset,
    input logic signed [N-1:0] wdata,
    input logic [$clog2(M):0] raddr,
    input logic [$clog2(M):0] waddr,
    output logic signed [N-1:0] rdata
);

timeunit 1ns; timeprecision 10ps;

logic signed [N-1:0] mem [0:M-1];

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        // reset Memory to 0
        $readmemb("memory_data.txt", mem);
        rdata <= '0;

    end else begin
         // Write data to memory only if waddr != 0 or wdata != 0
        if (!(waddr == 0 && wdata == 0) && waddr < M) begin
            mem[waddr] <= wdata;
        end
    end
end

always_ff @(posedge Clk) begin
    // read data from memory
    if (raddr < M) begin
        rdata <= mem[raddr];
    end // rdata

end

endmodule

