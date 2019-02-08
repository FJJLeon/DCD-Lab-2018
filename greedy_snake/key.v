module  key(
        input                   clk                     ,
        input                   reset                   ,
        //key
        input                   key3                    ,
        input                   key2                    ,
        input                   key1                    ,
        input                   key0                    ,
        //key out
        output  wire            key_left                ,
        output  wire            key_right               ,
        output  wire            key_up                  ,
        output  wire            key_down 
);
// debounce each key
// | 3 | 2 | 1 | 0 |
// | ← | → | ↑ | ↓ |
debounce    debounce_left(
        .clk                    (clk                    ),
        .rst_n                  (reset                  ),
        //key
        .key_in                 (key3                   ),
        .key_out                (key_left               )
);
debounce    debounce_right(
        .clk                    (clk                    ),
        .rst_n                  (reset                  ),
        //key
        .key_in                 (key2                   ),
        .key_out                (key_right              )
);
debounce    debounce_up(
        .clk                    (clk                    ),
        .rst_n                  (reset                  ),
        //key
        .key_in                 (key1                   ),
        .key_out                (key_up                 )
);
debounce    debounce_down(
        .clk                    (clk                    ),
        .rst_n                  (reset                  ),
        //key
        .key_in                 (key0                   ),
        .key_out                (key_down               )
);

endmodule
