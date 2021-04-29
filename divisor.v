module divisor(SW, clk, init, resultado, done);
input [7:0] SW;
input clk;
input init;
output reg [3:0] resultado;
output reg done = 0;
reg [3:0] A = 0;
reg [3:0] B = 0;
reg resta = 0;
reg condicional = 0;
reg reset = 0;
reg continuar = 0;
reg [2:0] status = 0;
parameter START = 'b00, CONDICIONAL = 'b01, CONDICIONAL2 = 'b10, RESTA = 'b11, END = 'b100;

always @(posedge clk)begin
	if(reset) begin
		A = SW[7:4];
		B = SW[3:0];
	end else if (resta) begin
			A = A - B;
	end
end

always @(posedge clk)begin
	if (reset)begin
		resultado = 0;
	end
	if (condicional) begin
		if (B <= A)begin
			continuar = 1;
			resultado = resultado + 1;
		end else begin
			continuar = 0;
		end
	end
end

always @(posedge clk) begin
	case(status)
		START: begin
			resta = 0;
			condicional = 0;
			if(init == 1) begin
				done = 0;
				reset = 1;
				status = CONDICIONAL;
			end
		end
		CONDICIONAL: begin
			resta = 0;
			condicional = 1;
			done = 0;
			reset = 0;
			status = CONDICIONAL2;
		end
		CONDICIONAL2 : begin
			resta = 0;
			condicional = 0;
			done = 0;
			reset = 0;
			if (continuar == 1)begin
				status = RESTA;
			end else begin
				status = END;
			end
		end
		RESTA: begin
			resta = 1;
			condicional = 0;
			done = 0;
			reset = 0;
			status = CONDICIONAL;
		end
		END: begin
			resta = 0;
			condicional = 0;
			done = 1;
			reset = 0;
			status = START;			
		end
		default: status = START;
	endcase
end

endmodule 