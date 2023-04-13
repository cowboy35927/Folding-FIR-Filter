`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/24 14:39:04
// Design Name: 
// Module Name: FIR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// p
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define width 16
`define tap_nums 28
module FIR(
    input rst,
    input clk,
    input en,
    input signed [`width-1:0] din,
    output  reg signed [`width-1:0] dout
    );
    integer  i;

    
    parameter signed tap0 =16'hFF9F;
    parameter signed tap1 =16'h00A4 ;
    parameter signed tap2 =16'h02A5 ;
    parameter signed tap3 =16'h0338 ;
    parameter signed tap4 =16'h004C ;
    parameter signed tap5 =16'hFCB3 ;
    parameter signed tap6 =16'hFDF5 ;
    parameter signed tap7 =16'h03BD ;
    parameter signed tap8 =16'h056C ;
    parameter signed tap9 =16'hFD6A ;
    parameter signed tap10=16'hF50B ;
    parameter signed tap11=16'hFD47 ;
    parameter signed tap12=16'h188F ;
    parameter signed tap13=16'h3218 ;

    reg enable_id;
    reg [4:0] index ;
    reg signed [`width-1:0]tap_coef[0:`tap_nums-1];
    reg signed [`width-1:0] buffer;    
    reg signed [`width-1:0] d_input[0:`tap_nums-1];
    reg signed [(2*`width)-1:0] temp_output; 
    //reg signed [(2*`width)-1:0] d_output;  
    reg [20:0] counter_r;   
    reg signed  [(2*`width)-1:0] D_in;
    
    always @(posedge clk or posedge rst) begin
       if(rst)begin
             buffer <= 0;
             enable_id<= 0;
       end
       else begin
          if(en)begin
             buffer <= din;
             enable_id<=1'd1;
          end
          else begin
             buffer <= buffer ;
             enable_id<=1'd0;
          end
       end
    end 

    always @(posedge clk or posedge rst ) begin
       if(rst)begin
	        counter_r <= 0;
	  end
	  else begin
            if(en)begin
              counter_r <=  counter_r+1;
	    end
            else begin
		counter_r<=counter_r;
	    end

	  end	
    end
    always @(posedge clk or posedge rst) begin
       if(rst)begin
           /*  tap_coef[0]<=16'h0000_0000;
             tap_coef[1]<=16'h0000_0000;
             tap_coef[2]<=16'h0000_0000;
             tap_coef[3]<=16'h0000_0000;
             tap_coef[4]<=16'h0000_0000;
             tap_coef[5]<=16'h0000_0000;
             tap_coef[6]<=16'h0000_0000;
             tap_coef[7]<=16'h0000_0000;
             tap_coef[8]<=16'h0000_0000;
             tap_coef[9]<=16'h0000_0000;
             tap_coef[10]<=16'h0000_0000;
             tap_coef[11]<=16'h0000_0000;
             tap_coef[12]<=16'h0000_0000;
             tap_coef[13]<=16'h0000_0000;*/
		tap_coef[0]<=tap0;
          tap_coef[1]<=tap1;
          tap_coef[2]<=tap2;
          tap_coef[3]<=tap3;
          tap_coef[4]<=tap4;
          tap_coef[5]<=tap5;
          tap_coef[6]<=tap6;
          tap_coef[7]<=tap7;
          tap_coef[8]<=tap8;
          tap_coef[9]<=tap9;
          tap_coef[10]<=tap10;
          tap_coef[11]<=tap11;
          tap_coef[12]<=tap12;
          tap_coef[13]<=tap13;     
          tap_coef[14]<=tap13;
          tap_coef[15]<=tap12;
          tap_coef[16]<=tap11;
          tap_coef[17]<=tap10;
          tap_coef[18]<=tap9;
          tap_coef[19]<=tap8;
          tap_coef[20]<=tap7;
          tap_coef[21]<=tap6;
          tap_coef[22]<=tap5;
          tap_coef[23]<=tap4;
          tap_coef[24]<=tap3;
          tap_coef[25]<=tap2;
          tap_coef[26]<=tap1;
          tap_coef[27]<=tap0;
       end
       else begin
          tap_coef[0]<=tap_coef[0];
          tap_coef[1]<=tap_coef[1];
          tap_coef[2]<=tap_coef[2];
          tap_coef[3]<=tap_coef[3];
          tap_coef[4]<=tap_coef[4];
          tap_coef[5]<=tap_coef[5];
          tap_coef[6]<=tap_coef[6];
          tap_coef[7]<=tap_coef[7];
          tap_coef[8]<=tap_coef[8];
          tap_coef[9]<=tap_coef[9];
          tap_coef[10]<=tap_coef[10];
          tap_coef[11]<=tap_coef[11];
          tap_coef[12]<=tap_coef[12];
          tap_coef[13]<=tap_coef[13];     
          tap_coef[14]<=tap_coef[14];
          tap_coef[15]<=tap_coef[15];
          tap_coef[16]<=tap_coef[16];
          tap_coef[17]<=tap_coef[17];
          tap_coef[18]<=tap_coef[18];
          tap_coef[19]<=tap_coef[19];
          tap_coef[20]<=tap_coef[20];
          tap_coef[21]<=tap_coef[21];
          tap_coef[22]<=tap_coef[22];
          tap_coef[23]<=tap_coef[23];
          tap_coef[24]<=tap_coef[24];
          tap_coef[25]<=tap_coef[25];
          tap_coef[26]<=tap_coef[26];
          tap_coef[27]<=tap_coef[27];  
       end
    end
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            for(i=0;i<`tap_nums;i=i+1)
            begin
                d_input[i]<=16'h0000;
            end
        end
        else begin
	  if(counter_r==1 || index==5'd28)begin
		    d_input[0]<=buffer;
		    d_input[1]<=d_input[0];
		    d_input[2]<=d_input[1];
		    d_input[3]<=d_input[2];
		    d_input[4]<=d_input[3];
		    d_input[5]<=d_input[4];
		    d_input[6]<=d_input[5];
		    d_input[7]<=d_input[6];
		    d_input[8]<=d_input[7];
		    d_input[9]<=d_input[8];
		    d_input[10]<=d_input[9];
		    d_input[11]<=d_input[10];
		    d_input[12]<=d_input[11];
		    d_input[13]<=d_input[12];
		    d_input[14]<=d_input[13];
		    d_input[15]<=d_input[14];
		    d_input[16]<=d_input[15];
		    d_input[17]<=d_input[16];
		    d_input[18]<=d_input[17];
		    d_input[19]<=d_input[18];
		    d_input[20]<=d_input[19];
		    d_input[21]<=d_input[20];
		    d_input[22]<=d_input[21];
		    d_input[23]<=d_input[22];
		    d_input[24]<=d_input[23];
		    d_input[25]<=d_input[24];
		    d_input[26]<=d_input[25];
		    d_input[27]<=d_input[26];
	   end
	   else begin
		    d_input[0]<=d_input[0];
		    d_input[1]<=d_input[1];
		    d_input[2]<=d_input[2];
		    d_input[3]<=d_input[3];
		    d_input[4]<=d_input[4];
		    d_input[5]<=d_input[5];
		    d_input[6]<=d_input[6];
		    d_input[7]<=d_input[7];
		    d_input[8]<=d_input[8];
		    d_input[9]<=d_input[9];
		    d_input[10]<=d_input[10];
		    d_input[11]<=d_input[11];
		    d_input[12]<=d_input[12];
		    d_input[13]<=d_input[13];
		    d_input[14]<=d_input[14];
		    d_input[15]<=d_input[15];
		    d_input[16]<=d_input[16];
		    d_input[17]<=d_input[17];
		    d_input[18]<=d_input[18];
		    d_input[19]<=d_input[19];
		    d_input[20]<=d_input[20];
		    d_input[21]<=d_input[21];
		    d_input[22]<=d_input[22];
		    d_input[23]<=d_input[23];
		    d_input[24]<=d_input[24];
		    d_input[25]<=d_input[25];
		    d_input[26]<=d_input[26];
		    d_input[27]<=d_input[27];
           end
        end
    end
   
 
   always@(posedge clk or posedge rst)begin
        if(rst)begin
            index<=5'd0;          
        end
        else begin
           if(index==5'd28)begin
               index<=0;
           end
           else if (enable_id)begin
               index<=index+1;
           end
           else begin
               index<=5'd0;
           end
        end
    end
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            temp_output<=32'd0;
		  // D_in<=32'd0;
        end
        else begin
           if(index==5'd0)begin
	          dout<={temp_output[31],temp_output[29:15]};
               temp_output<=32'd0;
           end
           else if (enable_id )begin
			if( index!=32'd28)begin
			//   D_in<=d_input[index]*tap_coef[index];
			   temp_output<=temp_output+ D_in;
			end
			else begin
                  temp_output<=temp_output+ D_in;
              //    D_in<=d_input[0]*tap_coef[0];
			end
           end
           else begin
			 //D_in<=32'd0;
               temp_output<=32'd0;
           end
        end
    end

	always@(posedge clk or posedge rst)begin
        if(rst)begin
	       D_in<=32'd0;
        end
        else begin
            if (enable_id && index!=32'd28 )begin
			
	           D_in<=d_input[index]*tap_coef[index];
               
           end
           else begin
                D_in<=32'd0;
           end
        end
    end
   
   // assign     D_in=d_input[index]*tap_coef[index];
   // assign     dout={d_output[31],d_output[29:15]};
    
    
endmodule



