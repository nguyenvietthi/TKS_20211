
module conv #(
    parameter SIZE = 23 
)
(
  input                              clk     ,
  input [1:0]                        prov    ,
  input [4:0]                        matrix  ,
  input [9:0]                        matrix2 ,
  input [9:0]                        i       ,
  input signed [SIZE-1:0]            w1      ,
  input signed [SIZE-1:0]            w2      ,
  input signed [SIZE-1:0]            w3      ,
  input signed [SIZE-1:0]            w4      ,
  input signed [SIZE-1:0]            w5      ,
  input signed [SIZE-1:0]            w6      ,
  input signed [SIZE-1:0]            w7      ,
  input signed [SIZE-1:0]            w8      ,
  input signed [SIZE-1:0]            w9      ,
                                              
  input signed [SIZE-1:0]            w11     , 
  input signed [SIZE-1:0]            w12     ,
  input signed [SIZE-1:0]            w13     ,
  input signed [SIZE-1:0]            w14     ,
  input signed [SIZE-1:0]            w15     ,
  input signed [SIZE-1:0]            w16     ,
  input signed [SIZE-1:0]            w17     ,
  input signed [SIZE-1:0]            w18     ,
  input signed [SIZE-1:0]            w19     ,
                                             
  input                              conv_en ,
  input                              dense_en,
  output reg signed [SIZE+SIZE-2:0]  Y1       
);

always @(posedge clk) begin
  if (conv_en == 1) begin
    Y1 = 0;
    Y1 = Y1+Y(w1, w11);
    // $display("center:",w1,w11);
    // right
    if ((prov != 2'b10) || (dense_en == 1)) begin
      Y1 = Y1+Y(w2,w12);
      // $display("right:",w2,w12);
    end
    // left
    if ((prov != 2'b11) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w3, w13);
      // $display("left:",w3,w13);
      end
    // downleft
    if (((i < matrix2 - matrix) && (prov != 2'b11)) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w4, w14);
      // $display("downleft:",w4,w14);
    end
    // upright
    if (((i > matrix-1'b1) && (prov != 2'b10)) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w5, w15);
      // $display("upright:",w5,w15);
    end
    //down
    if ((i < matrix2 - matrix) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w6, w16);
      // $display("down:",w6,w16);
    end
    // up
    if ((i > matrix - 1'b1) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w7, w17);
      // $display("up:",w7,w17);
    end
    // downright
    if (((i < matrix2 - matrix) && (prov != 2'b10)) || (dense_en == 1)) begin
      Y1 = Y1 + Y(w8, w18);
      // $display("downright:",w8,w18);
    end
    // upleft
    if (((i > matrix - 1'b1) && (prov != 2'b11))||(dense_en == 1)) begin
      Y1 = Y1 + Y(w9, w19);
      $display("upleft:",w9,w19);
    end
  end
end


function signed [SIZE+SIZE-2:0] Y;
  input signed [SIZE-1:0] a; 
  input signed            b;
  begin
      Y = a*b;
      //Y = Y>>SIZE-1;
  end
endfunction

endmodule
