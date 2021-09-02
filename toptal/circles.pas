program circles_not_efficent;

const
  max = 100000;

type
  point = record
            x,y : integer;
            tag : char
          end;

  function solution (s : string; xc,yc : array of integer) : integer;
  var
    a : array [1..max] of point;
    n : integer;
    p : point;

    i,j : integer;
    dup : boolean;

    function dist (i:integer) : real;
    begin
      with a[i] do dist := sqrt(sqr(x)+sqr(y))
    end;

    function before (i,j:integer) : boolean;
    begin
      before := dist(i)<dist(j)
    end;

    procedure outa;
    var
      i : integer;
    begin
      for i := 1 to n do
        with a[i] do
          write (tag,':',x,',',y,'(',dist(i):3:1,') ');
      writeln
    end;

  begin
    n := length(s);
    for i := 1 to n do
      with a[i] do
      begin
        tag := s[i];
        x := xc[i-1];
        y := yc[i-1]
      end;
    outa;
    for i := 1 to n-1 do
      for j := i+1 to n do
        if not before(i,j)
        then begin
               p    := a[i];
               a[i] := a[j];
               a[j] := p
             end;
    outa;
    dup := false;
    i := 2;
    while (i<=n) and not dup do
    begin
      for j := 1 to i-1 do
        if a[j].tag=a[i].tag then dup := true;
      if not dup then i := i+1
    end;

    solution := i-1;
    if dup and (dist(solution)=dist(solution+1))
    then solution := solution-1

  end;

begin
  writeln (solution ('abcda',[2,-1,-4,-3,3],[2,-2,4,1,3])); writeln;
  writeln (solution ('abb',[1,2,-2],[1,-2,2])); writeln;
  writeln (solution ('ccd',[1,-1,2],[1,-1,-2])); writeln
end.