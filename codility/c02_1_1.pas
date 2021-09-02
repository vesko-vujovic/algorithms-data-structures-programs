// rotate an array to the right by a given number of steps
// alternative solution without additional array, result in original array
program c02_1_1;

const
  max = 101;

type
  range  = 0..max-1;
  val    = -1000..1000; // int16

  arr = array [range] of val;

  // rotate k times to the right
  // can be optimized with left (n-k) rotations for k > n div 2
  procedure solution (var a:arr; n,k:range);
  var i,j : integer; temp:val;
  begin
    if n<>0
    then begin
           k := k mod n;
           for j := 1 to k do
           begin
             temp := a[n-1];
             for i := n-1 downto 1 do
               a[i] := a[i-1];
             a[0] := temp
           end
         end
  end;

  procedure test (a:array of val; k:range);
  var n:range;

    procedure print (a:arr; n:range);
    var i:range;
    begin
      write ('[');
      for i := 0 to n-1 do
      begin
        if i>0 then write (',');
        write (a[i])
      end;
      write (']')
    end;

  begin
    n := length(a);
    write ('input:  '); print(a,n); write (', n: ',n,', k: ',k); writeln;
    solution (a,n,k);
    write ('output: '); print (a,n); writeln;
    writeln;
  end;

begin
  test ([3,8,9,7,6],3);
  test ([0,0,0],1);
  test ([1,2,3,4],4)
end.