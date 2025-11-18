// module of NEO

module NEOcalculator #(
    parameter N = 8,  // N-bits wide
    parameter M = 8  // M locations
    )(
    input logic Clk,
    input logic reset,
);

timeunit 1ns; timeprecision 10ps;

logic reset;
logic signed [N-1:0] rdata, wdata;
logic [$clog2(M):0] raddr, waddr;

Memory #(
    .N(N),
    .M(M)
) memory1 (
    .Clk(Clk),
    .reset(reset),
    .wdata(wdata),
    .raddr(raddr),
    .waddr(waddr),
    .rdata(rdata)
);

NEOcalculator #(
    .N(N),
    .M(M)
) calculator1 (
    .Clk(Clk),
    .reset(reset),
    .rdata(rdata),
    .raddr(raddr),
    .waddr(waddr),
    .wdata(wdata)
);

endmodule 