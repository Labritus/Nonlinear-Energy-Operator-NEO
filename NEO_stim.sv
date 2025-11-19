// NEO stimulus module
timeunit 1ns; timeprecision 10ps;

module NEO_stim;



logic Clock, reset;
NEO #(
    .N(16),
    .M(32)
) NEO1 (
    .Clk(Clock),
    .reset(reset)
);

initial begin
    Clock = 0;
end

always begin
    # 1000 Clock = ~Clock;
end

initial begin
	reset = 1;
    @(posedge Clock);
    # 500;
    reset = 0;
    # 1000;
    reset =1;
    @(posedge Clock);   
    repeat(50) @(posedge Clock);
    $stop;
    $finish;
end


endmodule