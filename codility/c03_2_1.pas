// tape minimum equilibrium - find minimal difference
program co3_2_1;

const
  max    = 100000+1;
  range  = 1000;
  maxsum = max*range;

type
  int = -maxsum..maxsum;

  index = 0..max;
  el = -1000..1000;

  arr = array [index] of el;


  function solution (var a:arr; n:index) : int;
  var diff : int; i : index;
  begin
    diff     := 2*a[0]; for i := 0 to n-1 do diff := diff - a[i];
    solution := abs(diff);

    for i := 2 to n-1 do
    begin
      diff := diff+2*a[i-1];
      if abs(diff) < solution then solution := abs(diff)
    end
  end;

  procedure test (a:array of el);
  var n : index;

    procedure print;
    var i:index;
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
    if (n<2) or (n>(max-1))
    then writeln ('array length must be in [2..',max,']')
    else begin
           write ('array: '); print;
           writeln (' minimum dif: ',solution(a,length(a)))
        end
  end;

begin
  test ([3,1,2,4,3]);
  test ([3,4,2,1,3]);
  test ([2,-1,-2,4,3])
end.