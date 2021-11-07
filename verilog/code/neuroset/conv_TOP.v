
module conv_TOP #(
  parameter num_conv                ,
            SIZE_1             =0   ,
            SIZE_2             =0   ,
            SIZE_3             =0   ,
            SIZE_4             =0   ,
            SIZE_5             =0   ,
            SIZE_6             =0   ,
            SIZE_7             =0   ,
            SIZE_8             =0   ,
            SIZE_9             =0   ,
            SIZE_address_pix   =0   ,
            SIZE_address_pix_t =0   ,
            SIZE_address_wei   =0    
)
(
  input                                       clk             ,
  input                                       conv_en         ,
  input                                       globmaxp_en     ,
  input             [1:0]                     prov            ,
  input             [4:0]                     matrix          ,
  input             [9:0]                     matrix2         ,
  input             [SIZE_address_pix-1:0]    memstartp       , 
  input             [SIZE_address_wei-1:0]    memstartw       ,
  input             [SIZE_address_pix-1:0]    memstartzap     ,
  input             [4:0]                     lvl             ,
  input             [1:0]                     slvl            ,
  output reg        [SIZE_address_pix-1:0]    read_addressp   ,
  output reg        [SIZE_address_pix_t-1:0]  read_addresstp  ,
  output reg        [SIZE_address_wei-1:0]    read_addressw   ,
  output reg        [SIZE_address_pix-1:0]    write_addressp  ,
  output reg        [SIZE_address_pix_t-1:0]  write_addresstp ,
  output reg                                  we              ,
  output reg                                  re              ,
  output reg                                  re_wb           ,
  output reg                                  we_t            ,
  output reg                                  re_t            ,
  input signed      [SIZE_1-1:0]              qp              ,
  input signed      [SIZE_2*1-1:0]            qtp             ,
  input signed      [SIZE_9-1:0]              qw              ,
  output signed     [SIZE_1-1:0]              dp              ,
  output signed     [SIZE_2*1-1:0]            dtp             ,
  output reg                                  STOP            ,
  output [9:0]                                i_2             ,
  input signed      [SIZE_1+SIZE_1-2:0]       Y1              ,
  output reg signed [SIZE_1-1:0]              w15             ,
  output reg signed [SIZE_1-1:0]              w14             ,
  output reg signed [SIZE_1-1:0]              w16             ,
  output reg signed [SIZE_1-1:0]              w13             ,
  output reg signed [SIZE_1-1:0]              w17             ,
  output reg signed [SIZE_1-1:0]              w12             ,
  output reg signed [SIZE_1-1:0]              w18             ,
  output reg signed [SIZE_1-1:0]              w11             ,
  output reg signed [SIZE_1-1:0]              w19             ,
  output reg signed [SIZE_1-1:0]              p1              ,
  output reg signed [SIZE_1-1:0]              p2              ,
  output reg signed [SIZE_1-1:0]              p3              ,
  output reg signed [SIZE_1-1:0]              p4              ,
  output reg signed [SIZE_1-1:0]              p5              ,
  output reg signed [SIZE_1-1:0]              p6              ,
  output reg signed [SIZE_1-1:0]              p7              ,
  output reg signed [SIZE_1-1:0]              p8              ,
  output reg signed [SIZE_1-1:0]              p9              ,
  output reg                                  go              ,
  input [2:0]                                 num             ,
  input [4:0]                                 filt            ,
  input                                       bias              
);

reg signed [SIZE_1-1:0] res_out_1;
reg signed [SIZE_1+SIZE_1-2+1:0] res1;
reg signed [SIZE_1+SIZE_1-2+1:0] res_old_1;
reg signed [SIZE_1-1:0] globmaxp_perem_1;

reg signed [SIZE_1-1:0] buff0 [2:0];
reg signed [SIZE_1-1:0] buff1 [2:0];
reg signed [SIZE_1-1:0] buff2 [2:0];

reg [3:0] marker;
reg zagryzka_weight;
reg [9:0] i;

reg signed [SIZE_1-1+1:0] res_bias_check_1;

initial zagryzka_weight=0;
initial marker=0;

always @(posedge clk)
begin
if (conv_en==1)        //enable convolution
  begin
    if (zagryzka_weight==0)        
    begin
       case (marker)
        0: begin re_wb=1; read_addressw=memstartw+(2'd0*(filt+1)); end
        1: begin end
        2: begin              w11=qw[SIZE_1-1:0]; 
              w12=qw[SIZE_2-1:SIZE_1]; 
              w13=qw[SIZE_3-1:SIZE_2]; 
              w14=qw[SIZE_4-1:SIZE_3]; 
              w15=qw[SIZE_5-1:SIZE_4]; 
              w16=qw[SIZE_6-1:SIZE_5]; 
              w17=qw[SIZE_7-1:SIZE_6]; 
              w18=qw[SIZE_8-1:SIZE_7]; 
              w19=qw[SIZE_9-1:SIZE_8]; 
 end
        3: begin zagryzka_weight=1; re_wb=0; marker=-1; end
        default: $display("Check zagryzka_weight");
    endcase
    marker=marker+1;
    end
    else
    begin
      re=1;
      case (marker)
        0: begin    
                re_t=0;
                read_addressp=i+memstartp; 
                if ((i-1)<matrix2-matrix) 
                begin
                buff2[2]=qp[SIZE_1-1:0];
                end
                else buff2[2]=0;
                
                if (i>=2) go=1;
                
                
                p1=buff1[1];  //center
                p2=buff1[2];  //right
                p3=buff1[0];  //left
                p8=buff2[0];  //downright
                p7=buff0[2];  //up
                p4=buff2[1];  //downleft 
                p5=buff0[1];  //upright
                p9=buff2[2];  //upleft
                p6=buff0[0];  //down 
                
                
          end
        1: begin    if (i>=matrix-1) read_addressp=i-matrix+memstartp;
                res_old_1=qtp[(SIZE_2)*1-1:0];
                
                go=0;
                
                buff2[0]=buff2[1];
                buff1[0]=buff1[1];
                buff0[0]=buff0[1];
                buff2[1]=buff2[2];
                buff1[1]=buff1[2];
                buff0[1]=buff0[2];
          end
        2: begin    if (i<matrix2-matrix) read_addressp=i+matrix+memstartp;
                buff1[2]=qp[SIZE_1-1:0];
                
                if (i>=2) 
                begin
                we_t=1;
                write_addresstp=i-2+matrix2*num+(slvl*((filt+1)*matrix2)>>(num_conv>>1));
                if (globmaxp_en)  write_addressp=memstartzap;
                else  write_addressp=memstartzap+i-2;
                res1=Y1; if (lvl!=0) res1=res1+res_old_1; 
                if (bias==1) 
                  begin  
                    res_bias_check_1=res1[SIZE_1+SIZE_1-2+1:SIZE_1-1];
                    if (res_bias_check_1>(2**(SIZE_1-1))-1) 
                      begin
                        $display("OVERFLOW in conv!");
                        res_out_1=(2**(SIZE_1-1))-1;
                      end
                    else res_out_1=res1[SIZE_1+SIZE_1-2:SIZE_1-1];
                    if (res_out_1<0) res_out_1=0; 
                    
                    if (globmaxp_en)
                      begin
                        if (res_out_1>globmaxp_perem_1) globmaxp_perem_1=res_out_1;
                       end
                    we=1;
                  end
                end
          end
        3: begin    
                re_t=1;
                read_addresstp=i-1+matrix2*num+slvl*(((filt+1)*matrix2>>(num_conv>>1)));
                if (i>=matrix-1)
                begin
                buff0[2]=qp[SIZE_1-1:0];
                end
                else buff0[2]=0;
                
                we_t=0;
                we=0;
          end           
      default: $display("Check case conv_TOP");
      endcase
      
      if (marker!=3) marker=marker+1; 
      else begin 
          marker=0; 
          if (i<matrix2+1) i=i+1; 
          else STOP=1; 
          end
    end
  end
else 
  begin
    i=0;
    zagryzka_weight=0;
    STOP=0;
    re=0;
    re_t=0;
    go=0;
    marker=0;
    globmaxp_perem_1=0;
  end
end
assign i_2=i-2;
assign dp=(globmaxp_en)?{globmaxp_perem_1}:{res_out_1};
assign dtp={res1};
endmodule
