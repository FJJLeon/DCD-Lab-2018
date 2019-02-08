module  gameCtrl(
        input                   clk                     ,
        input                   reset                   ,
        //key
        input                   key_left                ,
        input                   key_right               ,
        input                   key_up                  ,
        input                   key_down                ,
        //
        input                   hit_wall                ,
        input                   hit_body                ,
        //play
        input         [ 7: 0]   play_vga_r              ,
        input         [ 7: 0]   play_vga_g              ,
        input         [ 7: 0]   play_vga_b              ,
        input                   play_hs                 ,
        input                   play_vs                 ,
        //
        output  wire  [ 2: 0]   game_status             ,
        //vga
        output  reg   [ 7: 0]   vga_r                   ,
        output  reg   [ 7: 0]   vga_g                   ,
        output  reg   [ 7: 0]   vga_b                   ,
        output  reg             vga_hs                  ,
        output  reg             vga_vs                
);

localparam  START   =           3'b001                          ;
localparam  PLAY    =           3'b010                          ;
localparam  END     =           3'b100                          ;
reg     [ 2: 0]                 status_c                        ;
reg     [ 2: 0]                 status_n                        ; 

wire    [ 7: 0]                 start_vga_r                     ; 
wire    [ 7: 0]                 start_vga_g                     ;
wire    [ 7: 0]                 start_vga_b                     ;
wire                            start_hs                        ;
wire                            start_vs                        ;

wire    [ 7: 0]                 end_vga_r                       ;
wire    [ 7: 0]                 end_vga_g                       ;
wire    [ 7: 0]                 end_vga_b                       ;
wire                            end_hs                          ;
wire                            end_vs                          ;

wire    [ 7: 0]                 start_data                      ;
wire                            start_rd_en                     ;
wire    [ 7: 0]                 end_data                        ;
wire                            end_rd_en                       ; 

assign	game_status		=		status_c;
//status_c
always@(posedge clk or negedge reset)begin
    if(!reset)begin
        status_c <= START;
    end
    else begin
        status_c <= status_n;
    end
end


//status_n
always@(*)begin
    case(status_c)
        START:begin
            if(key_right||key_up||key_down)begin
                status_n = PLAY;
            end
            else begin
                status_n = status_c;
            end
        end
        PLAY:begin
            if(hit_body||hit_wall)begin
                status_n = END;
            end
            else begin
                status_n = status_c;
            end
        end
        END:begin
            if(key_left||key_right||key_up||key_down)begin
                status_n = START;
            end
            else begin
                status_n = status_c;
            end
        end
        default:begin
            status_n = START;
        end
    endcase
end

always  @(posedge clk or negedge reset)begin
    if(!reset)begin
        vga_r        <=     start_vga_r; 
        vga_g        <=     start_vga_g; 
        vga_b        <=     start_vga_b; 
        vga_hs       <=     play_hs; 
        vga_vs       <=     play_vs; 
    end
    else 
        case(status_c)
            START:begin
                vga_r        <=     8'd255; 
                vga_g        <=     8'd128; 
                vga_b        <=     8'd128; 
                vga_hs       <=     play_hs; 
                vga_vs       <=     play_vs; 
            end
            PLAY:begin
                vga_r        <=     play_vga_r; 
                vga_g        <=     play_vga_g; 
                vga_b        <=     play_vga_b; 
                vga_hs       <=     play_hs; 
                vga_vs       <=     play_vs; 
            end
            END:begin
                vga_r        <=     8'd255; 
                vga_g        <=     8'd128; 
                vga_b        <=     8'd128;
                vga_hs       <=     play_hs; 
                vga_vs       <=     play_vs; 
            end
            default:begin
                vga_r        <=     8'd255; 
                vga_g        <=     8'd128; 
                vga_b        <=     8'd128; 
                vga_hs       <=     play_hs; 
                vga_vs       <=     play_vs; 
            end
        endcase
end

endmodule
