module maxp(clk,maxp_en,memstartp,memstartzap,read_addressp,write_addressp,re,we,qp,dp,STOP,matrix2,matrix);

parameter SIZE_1=0;
parameter SIZE_2=0;
parameter SIZE_3=0;
parameter SIZE_4=0;
parameter SIZE_address_pix=0;

// bước conv và maxpooling sẽ thực hiện ở step sau 

input clk,maxp_en; // maxpooling enable
output reg STOP; // dừng quá trình
input [SIZE_address_pix-1:0] memstartp,memstartzap; // tương tự conv_top, nó sẽ đổi sau khi qua lớp conv
output reg [SIZE_address_pix-1:0] read_addressp,write_addressp;
output reg re,we;
input signed [SIZE_1-1:0] qp; //pixel đọc từ ram
output reg signed [SIZE_1-1:0] dp; // pixel ghi vào ram
input [4:0] matrix; // kích thước input
input [9:0] matrix2;

reg [9:0] i;
reg [9:0] j;
reg [SIZE_1-1:0] buff; // buffer lưu giá trị max
reg [2:0] marker;// đánh dấu

// case 2: kết thúc quá trình duyệt 1 cửa sổ 2x2

wire [9:0] i_wr,i_read;
initial i=0; // thứ tự pixel trong 1 ô 2x2
initial j=0; // thứ tự của ô 2x2 
initial marker=0;

always @(posedge clk)
begin
if (maxp_en==1)
    begin
    case (marker) // case tính toán 2 => 3 => 0 => 1, case 1 sẽ kết thúc duyệt qua 4 phần tử để lấy max
        0: begin read_addressp=memstartp+i_read; re=1;
                if ((i!=0)||(j!=0))
                begin
                    if (qp[SIZE_1-1:0]>buff[SIZE_1-1:0]) buff[SIZE_1-1:0]=qp[SIZE_1-1:0];
                end
           end
        1: begin read_addressp=memstartp+i_read+1; // case ghi giá trị lớn nhất vào mem của RAM 
                if ((i!=0)||(j!=0))
                begin
                   if (qp[SIZE_1-1:0]>buff[SIZE_1-1:0]) dp[SIZE_1-1:0]=qp[SIZE_1-1:0]; else dp[SIZE_1-1:0]=buff[SIZE_1-1:0];
                   write_addressp=memstartzap+i_wr-1;
                   we=1;
                end
           end
        2: begin read_addressp=memstartp+i_read+matrix; buff=qp; we=0; end //ghi giá trị read_addressp=memstartp+i_read vào buff (tại thời điểm này qp mới cập nhật dữ liệu tại địa chỉ read_addressp=memstartp+i_read)
        3: begin read_addressp=memstartp+i_read+matrix+1;
                if (qp[SIZE_1-1:0]>buff[SIZE_1-1:0]) buff[SIZE_1-1:0]=qp[SIZE_1-1:0];
                if (i!=matrix-2) begin 
                    i=i+2; 
                    if (i_read==matrix2) STOP=1; // đuyệt hết tất cả các pixel thì dừng lại quá trình
                end else 
                begin 
                    i=0; j=j+1;  
                end
           end
        default: $display("Check case MaxPooling");
        endcase
        if (marker!=3) marker=marker+1; else marker=0;    end
else
    begin
        STOP=0;
        re=0;
        we=0;
        i=0;
        j=0;
        marker=0;
    end
end
assign i_wr=(i>>1)+j*(matrix>>1);
assign i_read=i+(matrix+matrix)*j;
endmodule