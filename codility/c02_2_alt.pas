// find element which occurs odd number of times in array
program c02_2_alt;

const
  maxnum  = round (1e6) - 1; // must be odd number
  maxval  = round (1e9);     // must be >= 1

type
  val   = 1..maxval;
  index = 0..maxnum-1;
  arr   = array [0..maxnum-1] of val;

  integer = int32;

  procedure heapsort (var a:arr; n:integer);

    procedure swap (i,j:index);
    var t : val;
    begin
      t := a[i]; a[i] := a[j]; a[j] := t
    end;

    procedure siftdown (first,last : integer);
    var root,child : integer; done : boolean;
    begin
      root := first; child := root*2+1;
      done := false;

      while not done and (child <= last) do
      begin
        if (child<last) and (a[child]<a[child+1])
        then child := child + 1;

        if a[root] >= a[child]
        then done := true
        else begin
               swap (root, child);
               root := child; child := root * 2 + 1
             end
      end
    end;

    procedure heapify (count:integer);
    var i : integer;
    begin
      for i := (count-1) div 2 downto 0 do
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

  // memory efficent solution - o(n*log(n)) = o(15mil) swaps
  //   arround five times slower then previous solution
  //   if you have 120MB to spare use previous solution otherwise use this one
  function unique (var a:arr; n:integer) : val;
  var
    pr    : integer; // previous run
    found : boolean;

    i : integer;

  begin
    // heapsort is better then plain quicksort because of duplicates
    // if array have sorted chunks smoothsort would be better
    heapsort (a,n);

    found := false;
    pr := 1;
    i  := 1;
    while not found and (i<n-1) do
    begin
      if a[i]=a[i-1]
      then pr := pr+1
      else if not odd(pr)
           then pr := 1
           else found := true;
      if not found
      then i := i+1
    end;
    unique := a[i-1]
  end;

  procedure test (a : array of val);
  var n : integer;

    procedure print;
    var i:integer;
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

    print;

    if not odd(n)
    then writeln (' have even number of elements')
    else writeln (', first element with odd number of ocurences: ', unique(a,n))
  end;

  procedure testworstcase;
  var
    a : arr;   n : integer;
    i : index; v : val;

  begin
    n := maxnum;

    write ('worst case init ...');
    i := 0;
    for v := 1 to (n-1) div 2 do
    begin
      a[i] := v; i := i+1;
      a[i] := v; i := i+1
    end;
    a[n-1] := maxval;
    write (' done');

    writeln (', first element with odd number of ocurences: ',unique (a,n))
  end;

  procedure testrandomcase;
  var
    a : arr; n : integer;
    v : val; i : index;

  begin
    n := maxnum;
    v := maxval-1;

    write ('random case init ...');
    //randomize;
    i := 0;
    for i := 0 to n-1 do
      a[i] := random (v)+1;
    a[n-1] := maxval;
    write (' done');

    writeln (', first element with odd number of ocurences: ',unique (a,n))
 end;

begin
  test ([9,3,9,3,9,7,9]);
  testworstcase;
  testrandomcase
end.