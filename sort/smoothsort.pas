program smoothsort;
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

  procedure smoothsort (var a:arr; n : integer);
  var
    q,r, p,b,c : integer;
    r1,b1,c1   : integer;

    function lower (v1, v2: val): boolean; inline;
    begin lower := v1 <= v2 end;

    procedure swap (i,j:index);
    var t:val;
    begin t := a[i]; a[i] := a[j]; a[j] := t end;

    procedure up (var vb,vc : integer);
    var t : integer;
    begin t  := vb; vb := vb + vc + 1; vc := t end;

    procedure down (var vb,vc : integer);
    var t : integer;
    begin t  := vc; vc := vb - vc - 1; vb := t end;

    procedure moveto (var x1,x2:integer);
    begin a [x1] := a[x2]; x1 := x2 end;

    procedure sift;
    var r0,r2 : integer; t : val;
    begin
      r0 := r1; t := a[r0];

      while b1 >= 3 do
      begin
        r2 := r1 - b1 + c1;
        if not lower (a[r1-1], a[r2])
        then begin r2 := r1 - 1; down(b1, c1) end;

        if lower (a[r2], t)
        then b1 := 1
        else begin moveto (r1,r2);  down (b1, c1) end
      end;

      if r1 <> r0 then a[r1] := t
    end;

    procedure trinkle;
    var p1, r0,r2,r3 : integer; t : val;
    begin
      r0 := r1; t := a[r0];
      p1 := p; b1 := b; c1 := c;
      while p1 > 0 do
      begin
        while not odd(p1)  do
        begin p1 := p1 div 2; up (b1, c1) end;
        r3 := r1 - b1;

        if (p1 = 1) or lower (a[r3], t)
        then p1 := 0
        else begin
               p1 := p1 - 1;
               if b1 = 1
               then moveto (r1,r3)
               else if b1 >= 3
                    then begin
                           r2 := r1 - b1 + c1;
                           if not lower (a[r1-1], a[r2])
                           then begin
                                  r2 := r1 - 1; down (b1,c1); p1 := p1 * 2
                                end;
                           if lower (a[r2], a[r3])
                           then moveto (r1,r3)
                           else begin
                                  moveto (r1,r2); down (b1,c1); p1 := 0
                                end
                         end
             end
      end;

      if r0 <> r1 then a[r1] := t;
      sift
    end;

    procedure semitrinkle;
    begin
      r1 := r - c;
      if not lower (a[r1], a[r])
      then begin swap (r,r1); trinkle end
    end;

  begin
    // building tree
    q := 1; r := 0;
    p := 1; b := 1; c := 1;
    while q <> n do
    begin
      r1 := r;
      if (p mod 8) = 3
      then begin
             b1 := b; c1 := c; sift;
             p := (p+1) div 4; up (b,c); up (b,c)
           end
      else if (p mod 4) = 1
           then begin
                  if q + c < n
                  then begin b1 := b; c1 := c; sift end
                  else trinkle;

                  repeat
                    down (b,c); p := p * 2
                  until b <= 1;
                  p := p + 1
                end;
      q := q + 1;
      r := r + 1
    end;
    r1 := r;
    trinkle;

    // bulding sorted array
    while q <> 1 do
    begin
      q := q - 1;
      if b = 1
      then begin
             r := r - 1; p := p - 1;
             while not odd (p) do
             begin
               p := p div 2;
               up (b,c)
             end
           end
      else if b >= 3 then
           begin
             p := p - 1; r := r - b + c;
             if p > 0 then semitrinkle;

             down (b,c); p := p shl 1 + 1; r := r + c; semitrinkle;
             down (b,c); p := p shl 1 + 1
           end
    end
  end;

var i : integer;
begin
  n := maxlen;
  for i := 0 to n-1 do a[i] := n-1-i;
  //print;

  smoothsort (a,n);
  //print
end.