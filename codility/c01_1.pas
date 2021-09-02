// binary gap: Find longest sequence of zeros in binary representation of an integer.
program c01_1;
const
  bits = 31; // works for up to 64 bits
  max  = (qword(1) << (bits - 1) - 1) << 1 + 1;

type
  val = 0..max;

  // function name can be used as local variable in expressions if function have arguments
  // otherwise it is treated as recursive call
  function bins (n:val) : string;
  var c : byte;
  begin
    bins := '';
    c := 0;
    while n<>0 do
    begin
      c := c+1;
      bins := chr ( ord('0') + ord(odd(n))) + bins;
      n := n div 2
    end;
    // for loop start and end expressions are computed only once before the loop
    for c := c+1 to bits do bins := '0'+bins; // leading zeroes
    bins := ' ['+bins+']'
  end;

  function solution (n:val) : byte;
  var curr : byte; // current run length
  begin
    solution := 0;
    curr     := 0;

    while not odd(n) and (n<>0) do n := n div 2; // find rightmost 1

    while n<>0 do
    begin
      if not odd(n) // last bit 0
      then curr := curr+1
      else begin
             if curr > solution then solution := curr;
             curr := 0
           end;

      n := n div 2
    end
  end;

  procedure test (n:qword);
  begin
    if (n<1) or (n>max)
    then writeln ('number ',n,' out of range!')
    else writeln (bins(n),' binary gap of ',n,' is ',solution (n))
  end;

begin
  test (1040);
  test (32);
  test (0);
  test (1);
  test (max);
  test (max+1);
  test (max div 2 + 1);
  test (max div 2 + 2)
end.