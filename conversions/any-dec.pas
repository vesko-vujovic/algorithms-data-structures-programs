program any_base;

const
  maxbase   = 36; // 0..9 + alphabet
  maxdigits = 64; // in binary

type
  digit  = 0..maxbase-1;
  number = array [0..maxdigits-1] of digit;

  decimal = qword;  // decimal values can be assigned to this type and it can be printed in decimal system
                    //   conversions are done by compiler
                    //   it is, of course, represented as binary
                    //     but we use it as decimal in our program
var
  base   : integer; // current base
  digits : integer; // curent length

  w : array [0..maxdigits-1] of decimal; // current digit weights



  procedure setsystem (b:integer);
  var i : integer; r : real;
  begin
    base := b;

    if base = 2
    then digits := maxdigits
    else begin
           digits := trunc(maxdigits*(ln(2)/ln(b)));
           if not (base in [2,4,8,16,32,64])
           then digits := digits+1
         end;
    w[0] := 1; for i := 1 to digits-1 do w[i]:=w[i-1]*b
  end;

  procedure writenum (n:number);
  var space, f, i : integer;
  begin
    case base of
      2  : space := 4;
      8  : space := 3;
      16 : space := 2;
      10 : space := 3;
      else space := 0
    end;
    f := digits-1; while (f>=1) and (n[f]=0) do f := f-1; // first non zero digit
    for i := f downto 0 do
    begin
      if space<>0
      then if (i<>f) and ((i+1) mod space = 0)
           then if base=10
                then write (',')
                else write (' ');

      if n[i]<=9
      then write (n[i])
      else write (chr (ord('a') + n[i] - 10))
    end
  end;



  function numfromdec (d:decimal) : number;
  var i : integer;
  begin
    for i := digits-1 downto 0 do
    begin
      numfromdec[i] := d div w[i];
      d             := d mod w[i]
    end
  end;

  function decfromnum (n:number) : decimal;
  var i : integer;
  begin
    decfromnum := 0;
    for i := 0 to digits-1 do
      decfromnum := decfromnum + n[i]*w[i]
  end;

  function numfromstr (s:string) : number;
  var l,i,d,p : integer;
  begin
    for i := 0 to digits-1 do
      numfromstr[i] := 0;

    l := length(s);
    if l>digits then l := digits; // trim

    p := 0;
    for i := l downto 1 do
    begin
      case s[i] of
        '0'..'9' : d := ord(s[i])-ord('0');
        'a'..'z' : d := ord(s[i])-ord('a')+10;
        else d := -1 // fallback
      end;
      if d>base-1 then d := -1; // overflow
      if d<>-1
      then begin
             numfromstr [p] := d;
             p := p+1
          end
    end
  end;



  procedure commonbases (d:decimal);

    procedure dobase (b:integer);
    begin
      setsystem (b);
      write (' base ',base:2,' : ');
      writenum (numfromdec(d));
      writeln
    end;

  begin
    writeln ('Number: ',d);
    dobase (2);
    dobase (3);
    dobase (8);
    dobase (16);
    dobase (10);
    writeln
  end;

  procedure literal (b:integer; s:string);
  var
    n : number;
  begin
    setsystem (b);
    n := numfromstr (s);
    write ('number: '); writenum(n);
    write (' in base ',base,' is ',decfromnum(n),' in base 10');
    writeln
  end;


begin
  commonbases (65535 << 63);

  literal (16,'ff ff');
  literal (10,'123,456');
  literal (maxbase,'vesko');
  literal (2,'0100 0110')
end.