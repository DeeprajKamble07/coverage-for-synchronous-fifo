module tb;
  logic clk,rst,wen,ren;
  logic [7:0] wdata,rdata;
  logic full,empty;
  
  fifo dut(clk,rst,wen,ren,wdata,rdata,full,empty);
  
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    rst=1;
    wen=0;
    ren=0;
    #20; 
    @(posedge clk);
    rst=0;
    repeat(2)
      begin
        write();
        read();
      end
  end
  
  task write();
    for(int i=0;i<=20;i++)
      begin
        wen=1;
        wdata= $urandom_range(0,255);;
        ren=0;
        @(posedge clk)
        $display($time,"wen=%0d wptr=%0d wdata=%0d full=%0d",wen,i,wdata,full);
        wen=0;
        @(posedge clk);
      end
  endtask
  
  task read();
    for(int i=0;i<=20;i++)
      begin
        ren=1;
        wen=0;
        @(posedge clk)
        $display($time,"ren=%0d rptr=%0d rdata=%0d empty=%0d",ren,i,rdata,empty);
        ren=0;
        @(posedge clk);
      end
  endtask
  
  covergroup fifo_cg @(posedge clk);
    option.per_instance=1;
    
    coverpoint rst{bins rst_low={0};
                  bins rst_hign={1};}
    
    coverpoint wen{bins wen_low={0};
                  bins wen_hign={1};}
    
    coverpoint ren{bins ren_low={0};
                  bins ren_hign={1};}
    
    coverpoint full{bins full_low={0};
                  bins full_hign={1};}
    
    coverpoint empty{bins empty_low={0};
                  bins empty_hign={1};}
    
    coverpoint wdata{bins wdata_low={[0:84]};
                  bins wdata_medium={[85:169]};
                  bins wdata_high={[170:255]};}
    
    coverpoint rdata{bins rdata_low={[0:84]};
                  bins rdata_medium={[85:169]};
                  bins rdata_high={[170:255]};}
    
    c1xc2: cross rst,wen{ignore_bins b1=binsof (rst) intersect {1};
                         ignore_bins b2=binsof (wen) intersect {0};}
    
    c1xc3: cross rst,ren{ignore_bins b3=binsof (rst) intersect {1};
                                                                ignore_bins b4=binsof (ren) intersect {0};}
    
    c1xc2xc6: cross rst,wen,wdata{ignore_bins b5=binsof (rst) intersect {1};
                                  ignore_bins b6=binsof (wen) intersect {0};}
    
    c1xc2xc7: cross rst,ren,rdata{ignore_bins b7=binsof (rst) intersect {1};
                                  ignore_bins b8=binsof (ren) intersect {0};}
    
    c1xc2xc4: cross rst,wen,full{ignore_bins b9=binsof (rst) intersect {1};
                                                                        ignore_bins b10=binsof (wen) intersect {0};
                                                                                                                ignore_bins b11=binsof (full) intersect {0};}
    
    c1xc2xc5: cross rst,ren,empty{ignore_bins b12=binsof (rst) intersect {1};
                                                                          ignore_bins b13=binsof (ren) intersect {0};
                                                                                                                  ignore_bins b14=binsof (empty) intersect {0};}
    
  endgroup
  
  fifo_cg c1;
  
  initial begin
    c1=new();
    $dumpfile("dump.vcd");
    $dumpvars();
    #1000;
    $finish;
  end
endmodule
