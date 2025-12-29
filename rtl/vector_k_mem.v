module vector_k_mem (
    input clk,
    input we,                  
    input [9:0] addr,          
    input [63:0] din,
    output reg [63:0] dout
);
    reg [63:0] sram [0:1023];

    always @(posedge clk) begin
        if (we) 
            sram[addr] <= din;
        dout <= sram[addr];
    end
endmodule