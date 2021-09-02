program bin_dec_str;
const
  digits = 63;

type
  digit    = 0..1;
  number   = array [0..digits-1] of digit;
  decimal  = int64;

var
  w : array [0..digits-1] of decimal;

  procedure init;
  var i : integer;
  begin
    w[0] := 1; for i := 1 to digits-1 do w[i]:=w[i-1]*2
  end;

  function numfromstr (s:string) : number;
  var l,p,i : integer;
  begin
    for i := 0 to digits-1 do numfromstr[i] := 0;
    l := length(s); if l>digits then l := digits;

    p := 0;
    for i := l downto 1 do
      if s[i] in ['0'..'1']
      then begin
             numfromstr [p] :=  ord (s[i]='1');
             p := p+1
           end;

    if p>0
    then for i := p to digits-1 do
           numfromstr [i] := numfromstr [p-1]
  end;


  procedure writenum (n:number);
  var f, i : integer;
  begin

    f := digits-1;
    //while (f>=1) and (n[f]=0) do f := f-1;

    write (n[f]);
    for i := f-1 downto 0 do
    begin
      if (i+1) mod 4 = 0 then write (' ');
      write (n[i])
    end
  end;

  function decfromnum (n:number) : decimal;
  var i : integer;
  begin
    decfromnum := 0;
    for i := 0 to digits-1 do
      if i=digits-1
      then decfromnum := decfromnum - n[i]*w[i]
      else decfromnum := decfromnum + n[i]*w[i]
  end;

  procedure convert (s: string);
  var n : number;
  begin
    n := numfromstr (s);

    write ('string ''',s,''' in base 2 ('); writenum (n);
    writeln (') = base 10 (', decfromnum(n),')')
  end;

begin
  init;

  convert ('0111');      //  7
  convert ('zbrlj');      //  7
  convert ('123123');      //  7
  convert ('0128!!!23');      //  7
  convert ('111');       //  -1
  convert ('00000000');  //  0
  convert ('00010111');  //  23
  convert ('00001100');  //  12
  convert ('01111111');  // 127
  convert ('11111111');  // - 1
  convert ('10100000');  // -96
  convert ('10010000');  // -112
  convert ('10011000')   // -104
end.