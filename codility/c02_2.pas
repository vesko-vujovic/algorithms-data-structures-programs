// find element which occurs odd number of times in array
program c02_2;

const
  maxnum     = round (1e6) - 1; // must be odd number
  maxvalorig = round (1e9);     // must be >= 1

  maxval = ((maxvalorig-1) div 64 + 1) * 64; // align on 64 bits

type
  val   = 1..maxval;
  index = 0..maxnum-1;
  arr   = array [index] of val;

  integer = int32;
  flags   = bitpacked array [val] of boolean;

var
  f : flags;

  // time efficent solution - o(n), memory (+120 MB alocated for flags)
  //   flag usage offset - 1billion clear flags + search last flag presumably in a range of 0.1 sec
  //   inner loop for o(n) extremly quick and compiler optimized for all 8,16,32 and 64bit architectures
  function unique (var a:arr; n:integer) : val;

  type // for typecasting 64 booleans to qword
    flags64ref  = ^flags64;
    flags64     = bitpacked array [1..maxval div 64] of qword;

    function f64 (v:val) : qword; inline;
    begin
      f64 := flags64ref(@f)^[v]
    end;

  var
    i : index;
    v : val;

  begin
    // clear flags
    fillqword (f,sizeof(f) div 8,0);

    // flag all elements
    for i := 0 to n-1 do
    begin
      v := a[i];
      f[v] := f[v] xor true
    end;

    v := 1;
    while f64(v) = 0 do v := v+1; // quick skip 64 false flags
    v := (v-1)*64+1;              // go back to begining of 64 block
    while not f[v] do v := v+1;
    unique := v

  end;

  procedure test (a : array of val);
  var n : integer;

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
    print;

    if not odd(n)
    then writeln (' have even number of elements')
    else writeln (', first element with odd number of ocurences: ',unique (a,n))
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
    randomize;
    i := 0;
    for i := 0 to n-1 do
      a[i] := random (v)+1;
    a[n-1] := maxval;
    write (' done');

    writeln (', first element with odd number of ocurences: ',unique (a,n))
 end;

begin
  writeln ('Extra memory needed: ',sizeof(f)/1024/1024:10:1,' MB');
  test ([9,3,9,3,9,7,9]);
  testworstcase;
  testrandomcase
end.