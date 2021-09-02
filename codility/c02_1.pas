// rotate an array to the right by a given number of steps.
program c02_1;

const
  max = 101;

type
  range  = 0..max-1;
  val    = -1000..1000; // int16

  arr = array [range] of val;

  result = record
             a : arr;
             n : integer
           end;

  // since soultion returns new array we can just copy elements in one pass
  function solution (a:arr; n,k:range) : result;
  var i : integer;
  begin
    solution.n := n;
    if n<>0
    then begin
           k := k mod n;
           for i := 0 to n-1 do
             solution.a[(i+k) mod n] := a[i]
         end
  end;

  procedure test (a:array of val; k:range);
  var n:range; s : result;

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
    s := solution (a,n,k);
    write ('output: '); print (s.a,s.n); writeln (', n: ',s.n);
    writeln
  end;

begin
  test ([3,8,9,7,6],3);
  test ([0,0,0],1);
  test ([1,2,3,4],4)
end.