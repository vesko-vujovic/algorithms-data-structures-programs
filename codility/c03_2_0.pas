// tape minimum equilibrium - find minimal difference
{$mode objfpc}
program co3_2_0;

const
  max    = 100000;
  range  = 1000;
  maxsum = max*range;

type
  int = -maxsum..maxsum;

  index = 0..max;
  el = -range..range;

  arr = array [index] of el;


  function solution (var a:arr; n:index) : int;
  var
    ls,rs, ts, diff : int;
    i : index;

    procedure debug;
    begin
      //writeln ('total sum: ',ts,' position: ', i,' left sum: ',ls,' right sum: ',rs, ' diff: ',abs(diff))
    end;

  begin
    ts := 0; for i := 0 to n-1 do ts := ts + a[i];

    ls := a[0]; rs := ts-ls; diff := ls-rs;
    i:=1; debug;

    solution := abs(diff);
    for i := 2 to n-1 do
    begin
      ls := ls+a[i-1]; rs := rs-a[i-1];
      diff := ls-rs;
      debug;
      if abs(diff) < solution then solution := abs(diff)
    end
  end;

  procedure test (a:array of el; n:index = 0);

    procedure print;
    var i:index;
    begin
      if n>20
      then write ('long array, n = ',n)
      else begin
             write ('[');
             for i := 0 to n-1 do
             begin
               if i>0 then write (',');
               write (a[i])
             end;
             write (']')
           end
    end;

  begin
    if n=0
    then n := length(a);
    if (n<2) or (n>max)
    then writeln ('array length must be in [2..',max,']')
    else begin
           write ('array: '); print;
           writeln (' minimum dif: ',solution(a,length(a)))
        end
  end;

var
  a:arr; n,i:index;

begin
  //test ([3,1,2,4,3]);
  //test ([3,4,2,1,3]);
  //test ([2,-1,-2,4,3]);

  randomize;
  n := max;
  for i := 0 to n-1 do
    a[i] := random (2*range+1) - range;
  test (a,n)
end.