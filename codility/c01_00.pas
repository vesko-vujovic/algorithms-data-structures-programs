// transpose first k elements in array of length n
// python lists implementation with possible <empty> elements
program c01_0;
const
  maxarrlen = 100;
  num = 11;

type
  T = integer;
  tref = ^T;

  pyarr = record
            el  : array [0..maxarrlen-1] of tref;
            len : integer
          end;

  function empty (var a:pyarr; pos:integer) : boolean; inline;
  begin
    empty := a.el[pos] = nil
  end;

  procedure print (var a:pyarr);
  var i : integer;
  begin
    with a do
      for i := 0 to len-1 do
      begin
        if i>0 then write (' ');
        if empty (a,i)
        then write ('<empty>')
        else write (el[i]^)
      end;
    writeln
  end;

  procedure newarr (var a:pyarr);
  begin
    a.len := 0
  end;

  procedure disposearr (var a:pyarr);
  var i : integer;
  begin
    for i := 0 to a.len-1 do
      if not empty (a,i)
      then dispose (a.el[i]);
    a.len := 0
  end;

  procedure append (var a:pyarr; val:T);
  begin
    with a do
    begin
      len := len+1;
      new (el[len-1]);
      el[len-1]^ := val
    end
  end;

  procedure clearel (var a:pyarr; pos:integer);
  begin
    if not empty (a,pos)
    then dispose (a.el[pos]);
    a.el[pos] := nil
  end;

  procedure setel (var a:pyarr; pos:integer; val:T);
  begin
    if empty (a,pos)
    then new (a.el[pos]);
    a.el[pos]^ := val
  end;

  function index (var a:pyarr; val:T) : integer;
  begin
    with a do
    begin
      index := 0;
      while (index<len) and (empty(a,index) or (a.el[index]^<>val)) do index := index+1
    end
  end;

  function inarr (var a:pyarr; val:T) : boolean;
  var p : integer;
  begin
    p := index (a,val);
    inarr := p<a.len
  end;

  function count (var a:pyarr; val:T) : integer;
  var i : integer;
  begin
    count := 0;
    for i := 0 to a.len-1 do
      if (a.el[i]<>nil) and (a.el[i]^=val) then count := count + 1
  end;

  procedure insert (var a:pyarr; pos:integer; val:T);
  var i : integer;
  begin
    with a do
    begin
      len := len+1;
      for i := len downto pos+1 do
        el[i] := el[i-1];
      new (el[pos]);
      el[pos]^ := val
    end
  end;

  procedure pop (var a:pyarr; pos:integer);
  var i : integer;
  begin
    with a do
    begin
      clearel (a,pos);
      for i := pos to len-1 do
        el[i] := el[i+1];
      len := len-1
    end
  end;

  function pop (var a:pyarr; pos:integer) : T;
  var i : integer;
  begin
    with a do
    begin
      pop := el[pos]^;
      clearel (a,pos);
      for i := pos to len-1 do
        el[i] := el[i+1];
      len := len-1
    end
  end;

  procedure remove (var a:pyarr; val:T);
  var p : integer;
  begin
    p := index (a,val);
    if p<a.len then pop (a,p)
  end;

  procedure reverse (var a:pyarr; n:integer);
  var i : integer; temp : tref;
  begin
    with a do
      for i := 0 to num div 2 - 1 do
      begin
        temp      := el[i];
        el[i]     := el[n-1-i];
        el[n-1-i] := temp
      end;
  end;

var
  a : pyarr;
  n : integer;

  i : integer;

begin
  newarr (a);
  for i := 1 to num do append (a,i);
  print (a);

  // write ('Number of elements: '); readln (n);
  // n := 6;
  n := a.len;

  writeln ('reversing first ',n,' elements');
  reverse (a,n);
  print (a);

  disposearr (a)
end.