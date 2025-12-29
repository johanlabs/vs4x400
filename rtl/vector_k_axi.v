module vector_k_axi (
    input s_axi_aclk, input s_axi_aresetn,
    input [31:0] s_axi_awaddr, input s_axi_awvalid, output s_axi_awready,
    input [31:0] s_axi_wdata, input s_axi_wvalid, output s_axi_wready,
    output [1:0] s_axi_bresp, output s_axi_bvalid, input s_axi_bready,
    
    output reg [9:0] write_addr,
    output reg [63:0] write_data_64,
    output reg write_en,
    
    output reg start_search,
    input busy, input [7:0] winner_id, input [31:0] max_score
);
    reg [31:0] data_lo_buffer;

    assign s_axi_awready = 1'b1;
    assign s_axi_wready  = 1'b1;
    assign s_axi_bvalid  = 1'b1;
    assign s_axi_bresp   = 2'b00;

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            start_search <= 0; write_en <= 0; data_lo_buffer <= 0;
            write_data_64 <= 0; write_addr <= 0;
        end else if (s_axi_awvalid && s_axi_wvalid) begin
            case (s_axi_awaddr[7:0])
                8'h00: begin 
                    start_search <= s_axi_wdata[0];
                    write_en <= s_axi_wdata[1]; // V_CTRL_COMMIT
                end
                8'h10: data_lo_buffer <= s_axi_wdata; 
                8'h14: write_data_64 <= {s_axi_wdata, data_lo_buffer}
                8'h18: write_addr <= s_axi_wdata[9:0];
                default: write_en <= 0;
            endcase
        end else begin
            write_en <= 0;
            start_search <= 0;
        end
    end
endmodule