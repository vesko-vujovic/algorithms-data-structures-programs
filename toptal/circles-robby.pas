program circles;

const
  maxpts   = 100000;
  coordmax = 1000000000;

type
  integer = int64;
  tagtype = 'a'..'z';

  coordfull = -coordmax..coordmax;
  point = record
            x,y : coordfull;
            tag : tagtype
          end;

  ptarr = record
            p   : array [1..maxpts] of point;
            num : 0..maxpts
          end;

  distarr = array [tagtype] of record
                                 d1,d2 : real;
                                 i1,i2 : integer
                               end;

  function dist (p:point) : real;
  begin
    with p do dist := sqrt(sqr(x*1.0)+sqr(y*1.0))
  end;

  procedure outa (var a:ptarr);
  var i : integer;
  begin
    for i := 1 to a.num do
      with a.p[i] do
        write (tag,':',x,',',y,'(',dist(a.p[i]):3:1,') ');
    writeln
  end;

  procedure initda (var d : distarr);
  var t : tagtype;
  begin
    for t := low(tagtype) to high(tagtype) do
    begin
      d[t].i1 := 0;
      d[t].i2 := 0
    end
  end;

  procedure append (var da:distarr; var a:ptarr; pos:integer);
  var
    r : real;

    procedure order (t:tagtype);
    var i:integer; r:real;
    begin
      with da[t] do
        if d1>d2
        then begin
               i := i1; i1 := i2; i2 := i;
               r := d1; d1 := d2; d2 := r
             end
    end;

  begin
    with a, p[pos], da[tag] do
      if i1=0
      then begin
             i1 := pos;
             d1 := dist (p[pos])
           end
      else if i2=0
           then begin
                  i2 := pos;
                  d2 := dist (p[pos]);
                  order (tag)
                end
           else begin
                  r := dist(p[pos]);
                  if (r<d2)
                  then begin
                         i2 := pos;
                         d2 := r;
                         order (tag)
                       end
                end
  end;

  procedure ptarrfromdist (var s,d:ptarr; var da:distarr);
  var t : tagtype;
    procedure add (i:integer);
    begin
      with d do
      begin
        num    := num+1;
        p[num] := s.p[i]
      end
    end;
  begin
    d.num := 0;
    for t := low(tagtype) to high(tagtype) do
      with da[t] do
      if i1<>0
      then begin
             add (i1);
             if i2<>0
             then add (i2)
           end
  end;

  procedure setpts (var a:ptarr; s:string; xc,yc:array of integer);
  var i : integer;
  begin
    a.num := length(s);
    for i := 1 to a.num do
      with a.p[i] do
      begin
        tag := s[i];
        x := xc[i-1];
        y := yc[i-1]
      end;
  end;

  procedure rndpoints (var a:ptarr; n:integer);
  var i : integer;
  begin
    a.num := n;
    for i := 1 to a.num do
      with a.p[i] do
      begin
        tag := tagtype (random (ord(high(tagtype))-ord(low(tagtype))+1) + ord(low(tagtype)));
        x := random (coordmax-1);
        y := random (coordmax-1)
      end
  end;

  function solution (var a,b:ptarr) : integer;
  var
    tp : point;
    ct : tagtype;

    i,j : integer;
    dup : boolean;

    da : distarr;

    function closer (var a,b:point) : boolean;
    begin
      closer := dist(a)<dist(b)
    end;

  begin
    initda (da);
    for i := 1 to a.num do
      append (da,a,i);
    ptarrfromdist (a,b,da);
    //b := a;

    // sort b
    with b do
      for i := 1 to num-1 do
        for j := i+1 to num do
          if closer (p[j],p[i])
          then begin
                 tp   := p[i];
                 p[i] := p[j];
                 p[j] := tp
               end;

    // find duplicate
    with b do
    begin
      dup := false;
      i := 2;
      while not dup and (i<=num) do
      begin
        ct := p[i].tag;
        j := 1;
        while not dup and (j<i) do
          if p[j].tag=ct
          then dup := true
          else j := j+1;

        if not dup
        then i := i+1
      end;
      solution := i-1;

      // adjust for same distance
      if dup and (dist(p[solution]) = dist(p[solution+1]))
      then solution := solution-1
    end
  end;

  procedure test (var a,b:ptarr);
  var
    s : integer;

  begin
    write ('array:    ');
    if a.num<30
    then outa (a)
    else writeln (a.num,' elements');
    s := solution (a,b);

    writeln ('solution: ',s);
    writeln
  end;

var
  a,b : ptarr;

begin


  setpts (a,'abcda',[2,-1,-4,-3,3],[2,-2,4,1,3]);
  test (a,b);

  setpts (a,'abb',[1,2,-2],[1,-2,2]);
  test (a,b);

  setpts (a,'ccd',[1,-1,2],[1,-1,-2]);
  test (a,b);

  //randomize;
  rndpoints (a,maxpts);
  test (a,b)
end.