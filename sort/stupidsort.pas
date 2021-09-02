program stupid_sort;
const
  maxlen = 50;
  maxval = 2;

type
  index = 1..maxlen;
  val   = 0..maxval;
  arr   = array [index] of val;

  integer = qword;

var
  a : arr;
  n : index;


  procedure print;
  var i:index;
  begin
    write ('[');
    for i := 1 to n do
    begin
      if i>1 then write (' ');
      write (a[i])
    end;
    writeln (']')
  end;


  procedure stupidsort (var a:arr; n : integer);
  var i,j : index; v : val;
  begin
    for i := 1 to n-1 do
      for j := i+1 to n do
        if a[i]>a[j]
        then begin
               v := a[i];
               a[i] := a[j];
               a[j] := v
             end
  end;

var i : index;
begin
  n := maxlen;

  randomize;
  for i := 1 to n do
    a[i] := random (maxval+1);
  print;

  stupidsort (a,n);
  print
end.