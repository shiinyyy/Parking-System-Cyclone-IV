module Ultrasonic_top
(
    input   wire    sys_clk ,
    input   wire    sys_rst ,
    input   wire    echo1    ,
    input   wire    echo2    ,
    
    output  wire    trig1    ,
    output  wire    trig2    ,
    
    output  wire    SPI_CLK  ,
    output  wire    SPI_MOSI ,
    output  wire    SPI_CS   ,
    
    
    output  wire    ds      ,
    output  wire    shcp    ,
    output  wire    stcp    ,
    output  wire    oe      
);


wire    [19:0]  data1    ;
wire    [19:0]  data2    ;
wire    [7:0]   totalpark;


wire            cnt100_flag;

/*data_gen
#(
    .CNT100MAX  (24'd4999999),
    .DATAMAX  (20'd999_999)
)
data_gen_inst
(
    .sys_clk (sys_clk),
    .sys_rst (sys_rst),

    .data    (data ),
    .point   (point),
    .sign    (sign ),
    .EN      (EN   )
    
);*/



Ultrasonic      Ultrasonic_inst
(
    .sys_clk  (sys_clk)       ,//100MHz
    .sys_rst_n(sys_rst)       ,//active low
    .echo     (echo1)       ,//回响信号
        
    .data_bin (data1)       ,//数据
    .trig     (trig1)        //触发信号
);


Ultrasonic      Ultrasonic_inst2
(
    .sys_clk  (sys_clk)       ,//100MHz
    .sys_rst_n(sys_rst)       ,//active low
    .echo     (echo2)       ,//回响信号
        
    .data_bin (data2)       ,//数据
    .trig     (trig2)        //触发信号
);

counter     counter_inst
(
    .sys_clk  (sys_clk)  ,
    .sys_rst  (sys_rst)  ,
    .data1    (data1)  ,
    .data2    (data2)  ,
 
    .cnt100_flag(cnt100_flag)      ,
    .totalpark(totalpark)
);



SPI     SPI_Inst
(
    .sys_clk   (sys_clk)  ,
    .sys_rst   (sys_rst)  ,
    .SPI_start (cnt100_flag)  ,
    .send_data (totalpark)  ,
   
    .SPI_CS    (SPI_CS)  ,
    .SPI_MOSI  (SPI_MOSI)  ,
    .SPI_CLK   (SPI_CLK)  
      
);


seg_dynamic     seg_dynamic_inst
(
    .sys_clk (sys_clk),
    .sys_rst (sys_rst),
    .data    ({12'b0, totalpark}),
    .point   (6'b000_000),
    .sign    (1'b0),
    .EN      (1'b1),


    .ds      (ds  ),
    .shcp    (shcp),
    .stcp    (stcp),
    .oe      (oe  )
);





endmodule