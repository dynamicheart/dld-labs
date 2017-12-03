module stopwatch_01(clk, key_reset, key_start_pause, key_display_stop,
							hex0, hex1, hex2, hex3, hex4, hex5,
							led0, led1, led2, led3);
	input 			clk, key_reset, key_start_pause, key_display_stop;
	output [6:0] 	hex0, hex1, hex2, hex3, hex4, hex5;
	output 			led0, led1, led2, led3;
	reg				led0, led1, led2, led3;

	reg				display_work; // 0 for refresh, 1 for stop
	reg				counter_work; // 0 for refresh, 1 for stop
	parameter		DELAY_TIME = 10000000;

	reg [3:0]		minute_display_high;
	reg [3:0]		minute_display_low;
	reg [3:0]		second_display_high;
	reg [3:0]		second_display_low;
	reg [3:0]		msecond_display_high;
	reg [3:0]		msecond_display_low;

	reg [3:0]		minute_counter_high;
	reg [3:0]		minute_counter_low;
	reg [3:0]		second_counter_high;
	reg [3:0]		second_counter_low;
	reg [3:0]		msecond_counter_high;
	reg [3:0]		msecond_counter_low;

	reg [31:0]		counter_50M; //clock is 50MHz. 500000 x 20ns = 10ms

	reg				reset_1_time; //for reset KEY
	reg [31:0]		counter_reset;

	reg				start_1_time; //for counter/pause KEY
	reg [31:0]		counter_start;

	reg				display_1_time; //for KEY_display_refresh/pause
	reg [31:0]		counter_display;

	//Used for testing long pressing
	reg				start; // 0 means released already
	reg				display; // 0 means released already

	sevenseg	LED8_minute_display_high(minute_display_high, hex5);
	sevenseg LED8_minute_display_low(minute_display_low, hex4);
	
	sevenseg LED8_second_display_high(second_display_high, hex3);
	sevenseg LED8_second_display_low(second_display_low, hex2);
	
	sevenseg LED8_msecond_display_high(msecond_display_high, hex1);
	sevenseg LED8_msecond_display_low(msecond_display_low, hex0);
	
	always @(posedge clk)
		begin
			// check reset KEY
			if(reset_1_time == 0 && key_reset == 0) reset_1_time = 1;
			if(reset_1_time == 1) counter_reset = counter_reset + 1;
			if(reset_1_time == 1 && counter_reset >= DELAY_TIME)
				begin
					if(key_reset == 0)
						begin
							display_work = 0;
							counter_work = 0;
							
							msecond_counter_low = 0;
							msecond_counter_high = 0;
							second_counter_low = 0;
							second_counter_high = 0;
							minute_counter_low = 0;
							minute_counter_high = 0;
							
							msecond_display_low = 0;
							msecond_display_high = 0;
							second_display_low = 0;
							second_display_high = 0;
							minute_display_low = 0;
							minute_display_high = 0;
							
							counter_50M = 0;
							
							reset_1_time = 0;
							counter_reset = 0;
							
							start_1_time = 0;
							counter_start = 0;
							
							display_1_time = 0;
							counter_display = 0;
							
							start = 0;
							display = 0;
						end
					reset_1_time = 0;
					counter_reset = 0;
				end
			
			//check start pause KEY
			if(start_1_time == 0 && key_start_pause == 0) start_1_time = 1;
			if(start_1_time == 1) counter_start = counter_start + 1;
			if(start_1_time == 1 && counter_start >= DELAY_TIME)
				begin
					if(key_start_pause == 0 && start == 0) 
						begin
							counter_work = ~counter_work;
							start = 1;						
						end
					start_1_time = 0;
					counter_start = 0;
				end
			//testing long pressing
			if(start_1_time == 0 && key_start_pause == 1) start_1_time = 1;
			if(start_1_time == 1) counter_start = counter_start + 1;
			if(start_1_time == 1 && counter_start >= DELAY_TIME)
				begin
					if(key_start_pause == 1 && start == 1) start = 0;
					start_1_time = 0;
					counter_start = 0;
				end
				
			//check display stop KEY
			if(display_1_time == 0 && key_display_stop == 0) display_1_time = 1;
			if(display_1_time == 1) counter_display = counter_display + 1;
			if(display_1_time == 1 && counter_display >= DELAY_TIME)
				begin
					if(key_display_stop == 0 && display == 0)
						begin 
							display_work = ~display_work;
							display = 1;
						end
					display_1_time = 0;
					counter_display = 0;
				end
			//testing long pressing
			if(display_1_time == 0 && key_display_stop == 1) display_1_time = 1;
			if(display_1_time == 1) counter_display = counter_display + 1;
			if(display_1_time == 1 && counter_display >= DELAY_TIME)
				begin
					if(key_display_stop == 1 && display == 1) display = 0;
					display_1_time = 0;
					counter_display = 0;
				end
			
			// count
			if(counter_work == 0)	
				begin	
					counter_50M = counter_50M + 1;
					if(counter_50M >= 500000)
						begin
							counter_50M = 0;
							msecond_counter_low = msecond_counter_low + 1;
						
							if(msecond_counter_low >= 10)
								begin
									msecond_counter_low = 0;
									msecond_counter_high = msecond_counter_high + 1;
								end
			
							if(msecond_counter_high >= 10)
								begin
									msecond_counter_high = 0;
									second_counter_low = second_counter_low + 1;
								end
			
							if(second_counter_low >= 10)
								begin
									second_counter_low = 0;
									second_counter_high = second_counter_high + 1;
								end
			
							if(second_counter_high >= 6)
								begin
									second_counter_high = 0;
									minute_counter_low = minute_counter_low + 1;
								end
			
							if(minute_counter_low >= 10)
								begin
									minute_counter_low = 0;
									minute_counter_high = minute_counter_high + 1;
								end
			
							if(minute_counter_high >= 10) minute_counter_high = 0;
						end
				end
			if(display_work == 0)
				begin
					msecond_display_low = msecond_counter_low;
					msecond_display_high = msecond_counter_high;
			
					second_display_low = second_counter_low;
					second_display_high = second_counter_high;
			
					minute_display_low = minute_counter_low;
					minute_display_high = minute_counter_high;
			
				end
			
			//for LEDs
			led0 = ~counter_work;
			led1 = counter_work;
			led2 = ~display_work;
			led3 = display_work;
		end
endmodule
