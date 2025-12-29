`timescale 1ns / 1ps
module vector_k_bench_tb;
    reg clk, reset, start_search;
    wire busy;
    wire [15:0] mem_addr;
    wire [31:0] max_score;
    wire [7:0] winner_id;
    reg [31:0] sram [0:65535]; // 64K words
    integer start_cycle, end_cycle;

    vector_k_dual_core uut (
        .clk(clk), .reset(reset), .clear(1'b0),
        .start_search(start_search), 
        .vector_count(10'd1024), .dim_size(8'd128),
        .mem_addr(mem_addr), .mem_data(sram[mem_addr]),
        .max_score(max_score), .winner_id(winner_id), .busy(busy)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; start_search = 0;
        $readmemh("sim/bench_db.hex", sram);
        #100 reset = 0;
        #20 start_search = 1; #10 start_search = 0;
        
        wait(busy);
        start_cycle = $time;
        wait(!busy);
        end_cycle = $time;

        $display("--- HARDWARE BENCHMARK RESULT ---");
        $display("Tempo total: %0d ns", end_cycle - start_cycle);
        $display("Ciclos: %0d", (end_cycle - start_cycle) / 10);
        $display("Vencedor ID: %d | Score: %d", winner_id, $signed(max_score));
        $finish;
    end
endmodule