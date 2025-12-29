`timescale 1ns / 1ps
module vector_k_tb;
    reg clk, reset, clear, start_search;
    wire busy;
    wire [11:0] mem_addr;
    wire [31:0] max_score;
    wire [7:0] winner_id;

    // Memória Interna maior para suportar os testes
    reg [31:0] sram [0:1023];

    vector_k_dual_core uut (
        .clk(clk), .reset(reset), .clear(clear), 
        .start_search(start_search), .vector_count(10'd3), .dim_size(8'd8),
        .mem_addr(mem_addr), .mem_data(sram[mem_addr]),
        .max_score(max_score), .winner_id(winner_id), .busy(busy)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; start_search = 0; 
        
        // Limpa a SRAM para evitar lixo
        for (integer k = 0; k < 1024; k = k + 1) sram[k] = 32'h0;

        // Dados de teste manuais para validar a lógica:
        // Vetor 0: Forte positivo
        sram[0] = 32'h0A0A0A0A; // (10*10 + 10*10)
        sram[1] = 32'h0A0A0A0A; // (10*10 + 10*10) -> Total 400
        // Vetor 1: Neutro
        sram[4] = 32'h01010101; // Total 4
        // Vetor 2: Negativo
        sram[8] = 32'hF6F6F6F6; // (-10*-10...) Oposto

        #15 reset = 0;
        #10 start_search = 1; #10 start_search = 0;
        
        wait(!busy);
        $display("--- VDB ON-CHIP RESULT ---");
        $display("Vencedor ID: %d", winner_id);
        $display("Melhor Score: %d", $signed(max_score));
        $finish;
    end
endmodule