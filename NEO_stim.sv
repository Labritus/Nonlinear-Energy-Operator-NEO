// NEO stimulus module

module NEO_stim;

timeunit 1ns; timeprecision 10ps;

logic Clock, nReset;
NEOcalculator #(
    .N(16),
    .M(16)
) NEO1 (
    .Clk(Clock),
    .reset(nReset)
);

initial begin
    Clock = 0;
end

always begin
    # 1000 Clock = ~Clock;
end

initial begin
	nReset = 1;
    @(posedge Clock);
    # 500;
    nReset = 0;
    # 1000;
    nReset =1;
    @(posedge Clock);   
    repeat(50) @(posedge Clock);
    $stop;
    $finish;
end


endmodule