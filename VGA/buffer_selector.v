module buffer_selector(
	input wire f0,
	input wire f1,
	input wire rst,
	input wire clk,
 	output reg select
);


always @(posedge clk, negedge rst)
	begin
		if(!rst) 
			select <= 0;
		else
			begin
				if(!f0 && f1) select <= 1;
				if(!f1 && f0) select <= 0;
			end
	end
	
endmodule