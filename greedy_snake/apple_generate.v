
module  apple_generate(
        input                   clk                     ,
        input                   reset                   ,
        //head
        input         [ 5: 0]   head_x                  ,
        input         [ 4: 0]   head_y                  ,
        //apple
        output  reg   [ 5: 0]   apple_x                 ,
        output  reg   [ 4: 0]   apple_y                 ,
        
        output  reg             body_add_sig 				  
);

parameter   TIME_5MS        =   125_000                         ; 
parameter   APPLE_X_MAX     =   38                              ;
parameter   APPLE_Y_MAX     =   28                              ; 


//利用加法产生随机数，蛇吃苹果的时刻不同，随机数就不一样，所以给人随机的感觉
//cnt0为苹果x的随机数
reg     [ 5: 0]                 cnt0                            ;
wire                            add_cnt0                        ;
wire                            end_cnt0                        ;
//wire                            feedback = cnt0[4]^cnt0[3]^cnt0[2]^cnt0[1]^cnt0[0];

always @(posedge clk or negedge reset)begin
    if(!reset)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 6'd10;
        else begin
		  /*
				cnt0[0] <= cnt0[5];
				cnt0[1] <= cnt0[0];
				cnt0[2] <= cnt0[1];
				cnt0[3] <= cnt0[2]^cnt0[5];
				cnt0[4] <= cnt0[3]^cnt0[5];
				cnt0[5] <= cnt0[4];
			*/
				cnt0 <= cnt0 + 1'b1;
		  end
    end
	 //cnt0 <= cnt0 % 6'd38;
end

assign add_cnt0     =       1'b1;       
assign end_cnt0     =       add_cnt0 && cnt0 >= APPLE_X_MAX-1;

//cnt1为苹果y坐标的随机数
reg     [ 4: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;
always @(posedge clk or negedge reset)begin
    if(!reset)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1'b1;
    end
end

assign add_cnt1     =       1'b1;       
assign end_cnt1     =       add_cnt1 && cnt1== APPLE_Y_MAX-1;

reg     [16: 0]                 cnt2                            ;
wire                            add_cnt2                        ;
wire                            end_cnt2                        ;
always @(posedge clk or negedge reset)begin
    if(!reset)begin
        cnt2 <= 0;
    end
    else if(add_cnt2)begin
        if(end_cnt2)
            cnt2 <= 0;
        else
            cnt2 <= cnt2 + 1'b1;
    end
end

assign add_cnt2     =       1'b1;       
assign end_cnt2     =       add_cnt2 && cnt2== TIME_5MS;

//apple_x,apple_y
always  @(posedge clk or negedge reset)begin
    if(reset==1'b0)begin
        apple_x     <=      6'd10;
        apple_y     <=      5'd13;
    end
    else if(end_cnt2 && apple_x == head_x && apple_y == head_y)begin
        apple_x     <=      cnt0;
        apple_y     <=      cnt1;
    end
end

//body_add_sig
always  @(posedge clk or negedge reset)begin
    if(reset==1'b0)begin
        body_add_sig    <=      1'b0;
    end
    else if(end_cnt2 && apple_x == head_x && apple_y == head_y)begin
        body_add_sig    <=      1'b1;
    end
    else begin
        body_add_sig    <=      1'b0;
    end
end




endmodule
