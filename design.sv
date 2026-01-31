module fifo(input clk,rst,wen,ren,input [7:0] wdata, output reg [7:0] rdata,
            output reg full,empty);
  reg [7:0] mem [0:7];
  reg [3:0] wptr, rptr;
  reg [3:0] count;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
        wptr<=0;
       count<=0;
        end
      else
        begin
          if(wen && !full)
            begin
              mem[wptr]<=wdata;
              wptr<=wptr+1;
              count<=count+1;
            end
        end
    end
  
  always@(posedge clk)
    begin
      if(rst)
        begin
        rptr<=0;
        count<=0;
        end
      else
        begin
          if(ren && !empty)
            begin
              rdata<=mem[rptr];
              rptr<=rptr+1;
              count<=count+1;
            end
        end
    end
  
  assign empty= (count==0)?1'b1:1'b0;
  assign full= (count==8)?1'b1:1'b0;
  
endmodule
