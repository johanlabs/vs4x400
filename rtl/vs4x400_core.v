module vs4x400_core (
    input clk, input reset,
    input start_search,
    input [9:0] vector_count, 
    input [7:0] dim_size,
    
    output reg [11:0] mem_addr,
    input signed [63:0] mem_data,
    
    output reg signed [31:0] max_score,
    output reg [7:0] winner_id,
    output reg busy
);
    reg signed [31:0] acc [0:7];
    reg [7:0] current_vec_id;
    reg [7:0] dim_cnt;
    integer i;

    localparam IDLE = 1'b0, RUN = 1'b1;
    reg state;

    wire signed [31:0] current_total_score = 
        (acc[0] + acc[1]) + (acc[2] + acc[3]) + 
        (acc[4] + acc[5]) + (acc[6] + acc[7]);

    wire is_last_dim = (dim_cnt >= (dim_size >> 3) - 1);
    wire is_last_vec = (current_vec_id >= vector_count - 1);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; busy <= 0; max_score <= -32'sh7FFFFFFF;
            winner_id <= 8'hFF; mem_addr <= 0;
            current_vec_id <= 0; dim_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start_search) begin
                        state <= RUN; busy <= 1;
                        current_vec_id <= 0; dim_cnt <= 0; mem_addr <= 0;
                        max_score <= -32'sh7FFFFFFF;
                        for (i = 0; i < 8; i = i + 1) acc[i] <= 0;
                    end
                end

                RUN: begin
                    acc[0] <= acc[0] + ($signed(mem_data[7:0])   * $signed(mem_data[15:8]));
                    acc[1] <= acc[1] + ($signed(mem_data[23:16]) * $signed(mem_data[31:24]));
                    acc[2] <= acc[2] + ($signed(mem_data[39:32]) * $signed(mem_data[47:40]));
                    acc[3] <= acc[3] + ($signed(mem_data[55:48]) * $signed(mem_data[63:56]));

                    if (is_last_dim) begin
                        if (current_total_score > max_score) begin
                            max_score <= current_total_score;
                            winner_id <= current_vec_id;
                        end
                        
                        if (is_last_vec) begin
                            state <= IDLE;
                        end else begin
                            current_vec_id <= current_vec_id + 1;
                            dim_cnt <= 0;
                            mem_addr <= mem_addr + 1;
                            for (i = 0; i < 8; i = i + 1) acc[i] <= 0;
                        end
                    end else begin
                        dim_cnt <= dim_cnt + 1;
                        mem_addr <= mem_addr + 1;
                    end
                end
            endcase
        end
    end
endmodule