// frog river one
program c04_1;
const
  max = 100000;

type
  index = 0..max;
  val   = 0..max;
  arr   = array [index] of val;

var
  a : arr; n : index;

  function solution (var a:arr; l:index; n:index) : index;
  var
    i,e, count : index;
    f : bitpacked array [index] of boolean;

  begin
    for i := 1 to n do f[i] := false;

    solution := 0; i := 0; count := 0;
    while (solution = 0) and (i<l) do
    begin
      e := a[i];
      if (e<=n) and not f[e]
      then begin
             count := count+1;
             f[e]  := true;
             if count = n then solution := i
           end;
      i := i+1
    end
  end;

  procedure test (a:array of val; n:index);
  var l:index;

    procedure print;
    var i:index;
    begin
      if n>20
      then write ('long array, n = ',n)
      else begin
             write ('[');
             for i := 0 to l-1 do
             begin
               if i>0 then write (',');
               write (a[i])
             end;
             write (']')
           end
    end;

  begin
    l := length(a);
    print;
    writeln (' n: ',n,' solution: ', solution (a,l,n))
  end;

begin
  test ([1,3,1,4,2,3,5,4],4)
end.