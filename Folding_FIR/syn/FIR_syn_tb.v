`timescale 1ns/10ps
`define CYCLE 4.88
`define DELAY 5
`define INPUT "../sim/output8bits_hex.txt"
`define GOLDEN "../sim/quantized_output.txt"
`define width 16
`define size 40027
`define size1 40000

module FIR_syn_tb;
integer i, j, error,id;
integer a;

reg [`width-1:0] input_mem [0:`size1-1];
reg [`width-1:0] golden_mem [0:`size-1];
reg [`width-1:0] output_mem [0:`size-1];
reg [(2*`width)-1:0] counter;
reg clk;
reg rst;
reg en;
reg signed [`width-1:0] din;
wire signed[`width-1:0] dout;

FIR fir(
    .rst(rst),
    .clk(clk),
    .en(en),
    .din(din),
    .dout(dout)
);

always #(`CYCLE/2) clk = ~clk;

initial begin
    $readmemh(`INPUT, input_mem);
    $readmemh(`GOLDEN, golden_mem);
end

initial begin
    clk = 0; rst = 0; i=0; error=0; en = 0;
    #`CYCLE rst = 1;
    #`CYCLE rst = 0; 
    #`CYCLE en = 1;
    #(5*`CYCLE/2) j=0;
    wait(i == `size1);
    //#`CYCLE en = 0;
    wait(j == `size);
    for(j=0; j<`size; j=j+1)begin
        if(golden_mem[j]-output_mem[j]>1'd1)begin
            error = error + 1;
            $display("At index=%d, output=%d, golden=%d,Failed!!", j, output_mem[j], golden_mem[j]);
        end
	   else begin
 
            $display("At index=%d, output=%d, golden=%d,PASS!!", j, output_mem[j], golden_mem[j]);
        end
    end
    if(error == 0)begin

        $display("\nAll pass!!!");
 
    end
    else begin
        $display("\n Failed!!!\n");
        $display("\n numbers of error= %d errors\n", error);

    end
    #10 $finish;
    // #400500 $finish;
end
always @(posedge clk) begin
    if(!rst)begin
        if(en)begin
           counter<=counter+1;
        end
        else begin
            counter<=counter;
        end
     end
     else begin
            counter<=32'd0;
     end
end


always @(negedge clk) begin
    if(!rst)begin
        if(en)begin
	     
	    if(i<`size1 && (counter%29==16'd28 || counter==0))begin
	        din = input_mem[i];
	        i = i+1;
	    end
	    else begin
	        din = 0;
	        i = i;
	    end
        end
        else begin
            din = 0;
            i = i;
        end
    end
end

always @(posedge clk) begin
    if(!rst)begin
        if(i>1 && j<`size && counter%29==2 && counter!=2) begin
		  j = j+1;
            output_mem[j-1] = dout;
            
        end
        else begin
            j = j;
        end
    end
end


initial begin
//    $dumpfile("FIR.vcd");
//    $dumpvars;
//    $dumpvars(0, fir);
//    for(a=0; a<`ORDER; a=a+1)begin
//        $dumpvars(1, fir.din_r[a]);
//    end

      $sdf_annotate("./FIR_syn.sdf", fir);      
      $fsdbDumpfile("../syn/FIR_syn.fsdb");
      $fsdbDumpvars();
end



endmodule

