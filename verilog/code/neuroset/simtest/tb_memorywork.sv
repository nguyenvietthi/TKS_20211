
`timescale 1ns/1ps

module tb_memorywork (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others

	parameter         num_conv = 0;
	parameter     picture_size = 0;
	parameter convolution_size = 0;
	parameter           SIZE_1 = 0;
	parameter           SIZE_2 = 0;
	parameter           SIZE_3 = 0;
	parameter           SIZE_4 = 0;
	parameter           SIZE_5 = 0;
	parameter           SIZE_6 = 0;
	parameter           SIZE_7 = 0;
	parameter           SIZE_8 = 0;
	parameter           SIZE_9 = 0;
	parameter SIZE_address_pix = 0;
	parameter SIZE_address_wei = 0;

	logic    signed [SIZE_1-1:0] data;
	logic                 [12:0] address;
	logic                        we_p;
	logic                        we_w;
	logic                        re_RAM;
	logic    signed [SIZE_1-1:0] dp;
	logic    signed [SIZE_9-1:0] dw;
	logic [SIZE_address_pix-1:0] addrp;
	logic [SIZE_address_wei-1:0] addrw;
	logic                  [4:0] step_out;
	logic                        GO;
	logic                  [4:0] in_dense;

	memorywork #(
			.num_conv(num_conv),
			.picture_size(picture_size),
			.convolution_size(convolution_size),
			.SIZE_1(SIZE_1),
			.SIZE_2(SIZE_2),
			.SIZE_3(SIZE_3),
			.SIZE_4(SIZE_4),
			.SIZE_5(SIZE_5),
			.SIZE_6(SIZE_6),
			.SIZE_7(SIZE_7),
			.SIZE_8(SIZE_8),
			.SIZE_9(SIZE_9),
			.SIZE_address_pix(SIZE_address_pix),
			.SIZE_address_wei(SIZE_address_wei)
		) inst_memorywork (
			.clk      (clk),
			.data     (data),
			.address  (address),
			.we_p     (we_p),
			.we_w     (we_w),
			.re_RAM   (re_RAM),
			.nextstep (clk),
			.dp       (dp),
			.dw       (dw),
			.addrp    (addrp),
			.addrw    (addrw),
			.step_out (step_out),
			.GO       (GO),
			.in_dense (in_dense)
		);

	task init();
		data     <= '0;
		GO       <= '0;
		in_dense <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			data     <= '0;
			GO       <= '0;
			in_dense <= '0;
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(20);

		repeat(10)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_memorywork.fsdb");
			$fsdbDumpvars(0, "tb_memorywork", "+mda", "+functions");
		end
	end

endmodule
