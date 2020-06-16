package barrelNtb;
import barrelN::*;

module mkbarrelNtb(Empty);
Reg#(Bit#(32)) state <- mkReg(0);

Barrel_right#(32) n <- mkBarrel_right(32);
Logicalrightshifter#(32)  m <- mkLogicalrightshifter(32);
Arithmeticrightshifter#(32) p <- mkArithmeticrightshifter(32);
/*
Barrel_left q <- mkBarrel_left();
Logicalleftshifter  r <- mkLogicalleftshifter();
Arithmeticleftshifter s <- mkArithmeticleftshifter();
*/
rule go (state ==0);
let k= m.rightShift(23,2);//input is 23 and shifted by 2
let l= p.rightShift(23,2);
$display("logical barrel right shifter= %d ",k); // expected output is 5

$display("\n Arithmetic barrel right shifter= %d ",l);
/*

let a= r.leftShift(23,2);
let b= s.leftShift(23,2);
$display("logical barrel left shifter= %d ",a);

$display("\n Arithmetic barrel left  shifter= %d ",b);
*/

$finish;
state <= 1;
endrule 

endmodule


endpackage
