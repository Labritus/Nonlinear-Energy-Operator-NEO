// module of NEO
timeunit 1ns; timeprecision 10ps;

module NEO #(
    parameter N = 16,  // N-bits wide
    parameter M = 32  // M locations
    )(
    input logic Clk,
    input logic reset
);



logic signed [N-1:0] rdata, wdata;
logic [$clog2(M)-1:0] raddr, waddr;

Memory #(
    .N(N),
    .M(M)
) Memory1 (
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
) NEOcalculator1 (
    .Clk(Clk),
    .reset(reset),
    .rdata(rdata),
    .raddr(raddr),
    .waddr(waddr),
    .wdata(wdata)
);

endmodule 