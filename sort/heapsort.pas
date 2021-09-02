program heapsort;
const
  maxlen = 8000000;
  maxval = 200;

type
  index = 0..maxlen-1;
  val   = 0..maxval;
  arr   = array [index] of val;

  integer = qword;

var
  a : arr;
  n : integer;

  procedure print;
  var i:integer;
  begin
    write ('[');
    for i := 0 to n-1 do
    begin
      if i>0 then write (' ');
      write (a[i])
    end;
    writeln (']')
  end;

  procedure heapsort (var a:arr; n:integer);

    function parent (i:integer) : integer; inline;
    begin
      parent := (i-1) div 2
    end;

    function left (i:integer) : integer; inline;
    begin
      left := i*2+1
    end;

    procedure swap (i,j:index);
    var t : val;
    begin
      t := a[i]; a[i] := a[j]; a[j] := t
    end;

    procedure siftdown (first,last : integer);
    var root,child : integer; done : boolean;
    begin
      root := first; child := left (root);
      done := false;
      while not done and (child <= last) do
      begin
        // move to bigger child
        if (child<last) and (a[child+1]>a[child])
        then child := child + 1;


        if a[child] > a[root]
        then begin
               swap (root, child);
               root := child; child := left (root)
             end
        else done := true

      end
    end;

    procedure heapify (count:integer);
    var i : integer;
    begin
      for i := parent(count) downto 0 do
        siftdown (i, count-1)
    end;

  var i : integer;
  begin
    heapify (n);
    for i := n-1 downto 1 do
    begin
      swap (i,0);
      siftdown (0,i-1)
    end
  end;

var i : integer;
begin
  n := maxlen;
  for i := 0 to n-1 do a[i] := n-1-i;
  //print;

  heapsort (a,n);
  //print
end.