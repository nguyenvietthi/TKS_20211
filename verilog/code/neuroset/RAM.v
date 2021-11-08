module RAM #(
    parameter   picture_size            =0,
                SIZE_1                  =0,
                SIZE_2                  =0,
                SIZE_4                  =0,
                SIZE_9                  =0,
                SIZE_address_pix        =0,
                SIZE_address_pix_t      =0,
                SIZE_address_wei        =0
)
(
    output reg signed           [SIZE_1-1:0]                qp                   ,      //read data
    output reg signed           [(SIZE_2)*1-1:0]            qtp                  ,      //read data
    output reg signed           [SIZE_9-1:0]                qw                   ,      //read weight
    input signed                [SIZE_1-1:0]                dp                   ,      //write data
    input signed                [(SIZE_2)*1-1:0]            dtp                  ,      //write data
    input signed                [SIZE_9-1:0]                dw                   ,      //write weight
    input                       [SIZE_address_pix-1:0]      write_addressp       ,       
    input                       [SIZE_address_pix-1:0]      read_addressp        ,       
    input                       [SIZE_address_pix_t-1:0]    write_addresstp      ,       
    input                       [SIZE_address_pix_t-1:0]    read_addresstp       ,       
    input                       [SIZE_address_wei-1:0]      write_addressw       ,       
    input                       [SIZE_address_wei-1:0]      read_addressw        ,       
    input                                                   we_p                 ,       
    input                                                   we_tp                ,       
    input                                                   we_w                 ,       
    input                                                   re_p                 ,       
    input                                                   re_tp                ,       
    input                                                   re_w                 ,       
    input                                                   clk                          
);
reg signed [SIZE_1-1:0] mem [0:picture_size*picture_size*8+picture_size*picture_size-1];
reg signed [(SIZE_2)*1-1:0] mem_t [0:picture_size*picture_size*4-1];
reg signed [SIZE_9-1:0] weight [0:256];
always @ (posedge clk)
    begin
        if (we_p) mem[write_addressp] <= dp;
        if (we_tp) mem_t[write_addresstp] <= dtp;
        if (we_w) weight[write_addressw] <= dw;
    end
always @ (posedge clk)
    begin
        if (re_p) qp <= mem[read_addressp];
        if (re_tp) qtp <= mem_t[read_addresstp];
        if (re_w) qw <= weight[read_addressw];
    end
endmodule