module RAM(qp,qtp,qw,dp,dtp,dw,write_addressp,read_addressp,write_addresstp,read_addresstp,write_addressw,read_addressw,we_p,we_tp,we_w,re_p,re_tp,re_w,clk);
parameter picture_size=0;
parameter SIZE_1=0;
parameter SIZE_2=0;
parameter SIZE_4=0;
parameter SIZE_9=0;
parameter SIZE_address_pix=0;
parameter SIZE_address_pix_t=0;
parameter SIZE_address_wei=0;

output reg signed [SIZE_1-1:0] qp; 
output reg signed [(SIZE_2)*1-1:0] qtp; 
output reg signed [SIZE_9-1:0] qw; 
input signed [SIZE_1-1:0] dp; 
input signed [(SIZE_2)*1-1:0] dtp; 
input signed [SIZE_9-1:0] dw;  
input [SIZE_address_pix-1:0] write_addressp, read_addressp;
input [SIZE_address_pix_t-1:0] write_addresstp, read_addresstp;
input [SIZE_address_wei-1:0] write_addressw, read_addressw;
input we_p,we_tp,we_w,    re_p,re_tp,re_w,clk;


// lưu giá trị input và sau đó là output của các layer. Tương tự mem_t => nhưng chỉ cắt 11 bít đầu tiên còn men_t sẽ giữ đủ gia trị trong các lần chập và nhân =>(làm tròn cuối của các phép tính) và chỉ sau khi chập xong 1 lớp của input mới nạp vào mem
reg signed [SIZE_1-1:0] mem [0:picture_size*picture_size*8+picture_size*picture_size-1];

//lưu giá trị  sau khi ảnh chập với 1 kernel, ở các bước chập với các kernel tiếp theo thì nó sẽ lấy ra và cộng giá trị chập với kernel hiện tại
reg signed [(SIZE_2)*1-1:0] mem_t [0:picture_size*picture_size*4-1];

// lưu các giá trị của các kernel trong layer, các giá trị sẽ được ghép lại với nhau
reg signed [SIZE_9-1:0] weight [0:256]; // 
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