program quicksort;
const
  maxlen = 1000000;
  maxval = 65535;

type
  index = 10..100;
  val   = 0..maxval;
  arr   = array [index] of val;

  integer = int64;

var
  a : arr;
  n : integer;


  procedure print;
  var i:index;
  begin
    write ('[');
    for i := low(index) to high(index) do
    begin
      if i>low(index) then write (' ');
      write (a[i])
    end;
    writeln (']')
  end;


  procedure quicksort (var a:arr; lo,hi:integer);

    function partition (lo,hi:integer) : integer;
    var pivot,v : val; i,j : integer;
    begin
      pivot := a[lo];

      i := lo - 1;
      j := hi + 1;
      while i<j do
      begin
        repeat i := i+1 until a[i] >= pivot;
        repeat j := j-1 until a[j] <= pivot;
        if i<j then begin
                      v := a[i];
                      a[i] := a[j];
                      a[j] := v
                    end
      end;
      partition := j
    end;


  var p : integer;
  begin
    if lo<hi
    then begin
           p := partition (lo,hi);
           quicksort (a, lo,p);
           quicksort (a, p+1,hi)
         end
  end;

var i : integer;
begin
  n := maxlen;

  randomize;
  for i := low(index) to high(index) do
    a[i] := random (high(val)-low(val)+1)+low(val);
  //print;

  quicksort (a,low(index),high(index));
  //print
end.