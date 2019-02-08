
module  snakeGame(
        input                   CLOCK_50       ,
        //key
        input         [ 3: 0]   KEY            ,
		  input                   SW0				  ,
		  //VGA  
        output  wire            VGA_CLK        ,
        output  wire            VGA_BLANK_N    ,
        output  wire            VGA_HS         ,
        output  wire            VGA_VS         ,
        output  wire  [ 7: 0]   VGA_R          ,
        output  wire  [ 7: 0]   VGA_G          ,
        output  wire  [ 7: 0]   VGA_B          ,
		  // sevenseg
		  output 		 [ 6: 0]   HEX0			  ,
		  output 		 [ 6: 0]   HEX1 			  ,
		  output 		 [ 6: 0]   HEX4			  ,
		  output 		 [ 6: 0]   HEX5			  
);
// parameter 
        wire                            reset              ; 
        wire                            nouse              ;
		  wire                            locked				  ;
        wire                            clk_25m            ;
        wire                            rom_rd_en          ;
        wire    [ 7: 0]                 rom_data           ;

        wire                            key_left           ;
        wire                            key_right          ;   
        wire                            key_up             ;
        wire                            key_down           ;
                                                                
        wire                            hit_wall           ;
        wire                            hit_body           ;
                                                                
        wire    [ 7: 0]                 play_vga_r         ;
        wire    [ 7: 0]                 play_vga_g         ;
        wire    [ 7: 0]                 play_vga_b         ;
        wire                            play_hs            ;
        wire                            play_vs            ;
              
        wire    [ 1: 0]                 object             ;
        wire    [ 5: 0]                 apple_x            ;
        wire    [ 4: 0]                 apple_y            ;
        wire    [ 9: 0]                 pixel_x            ;
        wire    [ 9: 0]                 pixel_y            ;

        wire    [ 5: 0]                 head_x             ;
        wire    [ 4: 0]                 head_y             ; 
        wire    [ 2: 0]                 game_status        ; 
        wire                            body_add_sig       ;
		  
		  wire    [31: 0]						 score 				  ;
		  reg	 	 [31: 0] 					 current_score		  ;
		  reg	 	 [31: 0] 					 history_score	     ;

// instantiation
mypll mypll_inst(
        .refclk                 (CLOCK_50               ),
        .rst                    (nouse                  ),	// nouse
        .outclk_0               (clk_25m                ),
        .locked                 (locked                 )  // no use
);

assign  VGA_CLK     =       ~clk_25m;
assign  VGA_BLANK_N =       VGA_HS && VGA_VS;
assign  reset       =       SW0;

gameCtrl   game_ctrl_inst(
        .clk                    (clk_25m                ),
        .reset                  (reset                  ),
        //key
        .key_left               (key_left               ),
        .key_right              (key_right              ),
        .key_up                 (key_up                 ),
        .key_down               (key_down               ),
        //
        .hit_wall               (hit_wall               ),
        .hit_body               (hit_body               ),
        .game_status            (game_status            ),
        //play
        .play_vga_r             (play_vga_r             ),
        .play_vga_g             (play_vga_g             ),
        .play_vga_b             (play_vga_b             ),
        .play_hs                (play_hs                ),
        .play_vs                (play_vs                ),
        //vga
        .vga_r                  (VGA_R                  ),
        .vga_g                  (VGA_G                  ),
        .vga_b                  (VGA_B                  ),
        .vga_hs                 (VGA_HS                 ),
        .vga_vs                 (VGA_VS                 )
);

vga_display    vga_play_inst(
        .clk                    (clk_25m                ),
        .reset                  (reset                  ),
        //
        .object                 (object                 ),
        .apple_x                (apple_x                ),
        .apple_y                (apple_y                ),
        .pixel_x                (pixel_x                ),
        .pixel_y                (pixel_y                ),
        
        //vga
        .play_vga_r             (play_vga_r             ),
        .play_vga_g             (play_vga_g             ),
        .play_vga_b             (play_vga_b             ),
        .play_hs                (play_hs                ),
        .play_vs                (play_vs                )
);

key key_inst(
        .clk                    (clk_25m                ),
        .reset                  (reset                  ),
        //key
        .key3                   (KEY[3]                 ),
        .key2                   (KEY[2]                 ),
        .key1                   (KEY[1]                 ),
        .key0                   (KEY[0]                 ),
        //key out
        .key_left               (key_left               ),
        .key_right              (key_right              ),
        .key_up                 (key_up                 ),
        .key_down               (key_down               )
);



snakeCtrl  snake_ctrl_inst(
        .clk                    (clk_25m                ),
        .reset                  (reset                  ),
        //key
        .key_left               (key_left               ),
        .key_right              (key_right              ),
        .key_up                 (key_up                 ),
        .key_down               (key_down               ),
        //pixel
        .pixel_x                (pixel_x                ),
        .pixel_y                (pixel_y                ),
        .game_status            (game_status            ),
        .body_add_sig           (body_add_sig           ),
        //head
        .head_x                 (head_x                 ),
        .head_y                 (head_y                 ),
        //hit
        .hit_body               (hit_body               ),
        .hit_wall               (hit_wall               ),
        .object                 (object                 ),
		  .score						  (score                  )
);

initial
begin 
	history_score <= 0;
	current_score <= 0;
end

always @ (posedge clk_25m)
begin
	if (!reset) begin
		current_score <= 0;
	end
	else begin
		current_score <= score;
		history_score <= score > history_score ? score : history_score;
	end
end

apple_generate  apple_generate_inst(
        .clk                    (clk_25m                ),
        .reset                  (reset                  ),
        //head
        .head_x                 (head_x                 ),
        .head_y                 (head_y                 ),
        //apple
        .apple_x                (apple_x                ),
        .apple_y                (apple_y                ),
        
        .body_add_sig           (body_add_sig           )
);

out_port_seg historyScoreboard(
		  .in							  (history_score			  ),
		  .out1						  (HEX5						  ),
		  .out0						  (HEX4					     )
);
	
out_port_seg scoreboard(
		  .in							  (score						  ),
		  .out1						  (HEX1						  ),
		  .out0						  (HEX0						  )
);

endmodule
