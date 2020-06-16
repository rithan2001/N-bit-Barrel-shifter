package barrelN;

//barrel right  shifter
//inputvalue is input
//shiftAmt is the amt to be shifted by
//shiftValue holds remaining  empty bits remains after shift
//   Integer m = fromInteger( log2 (n) );


interface Barrel_right#(numeric type n);
  method ActionValue#(Bit#(n)) rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt, Bit#(1) shiftValue) provisos(Log#(n,m));
endinterface

module mkBarrel_right#(numeric n)(Barrel_right#(n));

  function Bit#(1) mux1(Bit#(1) sel, Bit#(1) a, Bit#(1) b);  
  return (sel == 0)? a: b;
  endfunction :mux1

function Bit#(n) muxn(Bit#(1) sel, Bit#(n) a, Bit#(n) b);
  Bit#(n) aggregate = 0;
  for (Integer i = 0; i < valueOf(n); i = i+1)
   begin
    aggregate[i] = mux1(sel, a[i], b[i]);
   end
return aggregate;
endfunction


  method ActionValue#(Bit#(n)) rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt, Bit#(1) shiftValue) provisos(Log#(n,m));
   
    Bit#(n) shiftedVal;
    for(Integer i = 0; i < valueOf(m); i = i + 1)
      begin
      for(Integer j = 0; j < valueOf(n) - 2 ** i; j = j + 1)
        begin
        shiftedVal[j] =  inputvalue[j + 2 ** i];
        end
      for(Integer j = 0; j < 2 ** i; j = j + 1)
        begin
        shiftedVal[valueOf(n) -1 - j] = shiftValue;
        end
      inputvalue = muxn(shiftAmt[i], inputvalue, shiftedVal);
      end
    return inputvalue; 

  endmethod
endmodule


//Logical barrel right shifter
// empty bit is 0
interface Logicalrightshifter#(numeric type n);
  method ActionValue#(Bit#(n)) rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt) provisos(Log#(n,m));
endinterface

module mkLogicalrightshifter#(numeric n)(Logicalrightshifter#(n));
  let obj1 <- mkBarrel_right(n);
  
  method ActionValue#(Bit#(n))  rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt) provisos(Log#(n,m));
  
    let outputvalue = obj1.rightShift(inputvalue, shiftAmt, 0);
    let result <- outputvalue;
    return result;
  endmethod
endmodule


//arithmetic barrel right shifter
//empty bit is filled with highest weighted bit
interface Arithmeticrightshifter#(numeric type n);
  method ActionValue#(Bit#(n)) rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt) provisos(Log#(n,m));
endinterface

module mkArithmeticrightshifter#(numeric n)(Arithmeticrightshifter#(n));
  let obj1 <- mkBarrel_right(n);
  method ActionValue#(Bit#(n)) rightShift(Bit#(n) inputvalue, Bit#(m) shiftAmt) provisos(Log#(n,m));
  
    let outputvalue = obj1.rightShift(inputvalue, shiftAmt, inputvalue[valueOf(n) - 1]);

    let result <- outputvalue;
    return result;
  endmethod
endmodule




endpackage

