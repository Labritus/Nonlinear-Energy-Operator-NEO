// module of NEOcalculator

module NEOcalculator #(
    parameter N = 16,  // N-bits wide
    parameter M = 32  // M locations
    )(
    input logic Clk,
    input logic reset,
    input logic signed [N-1:0] rdata,
    output logic [$clog2(M)-1:0] raddr,
    output logic [$clog2(M)-1:0] waddr,
    output logic signed [N-1:0] wdata
);

timeunit 1ns; timeprecision 10ps;

logic signed [N-1:0] xn_prev, xn_curr;
logic [$clog2(M):0] counter;

always_ff @(posedge Clk, negedge reset) begin
    if (!reset) begin
        counter <= '0;
        xn_prev <= '0;
        xn_curr <= '0;

    end else begin
        // Simple processing: shift data through registers
        

        xn_curr <= rdata;
        xn_prev <= xn_curr;

        if (counter == { $clog2(M){1'b1} }) begin
            counter <= counter;
        end else begin
            counter <= counter + 1;
        end

    end
end

always_comb begin
    if (counter >= 1) begin
        waddr = counter - 1;
    end else begin
        waddr = '0;
    end
    raddr = counter;
    wdata = xn_curr * xn_curr - rdata * xn_prev;
    


end

endmodule