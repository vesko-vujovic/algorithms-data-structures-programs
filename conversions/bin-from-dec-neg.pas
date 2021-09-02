program binfromdec; // including negative binary
const
  maxlen = 64;

type
  number = int64; // integer for max len
  bits   = array [0..maxlen-1] of 0..1;

var
  len, min, max, decdigits : number;

  procedure init (bitnum:integer);
  begin
    len := bitnum;
    min := ((not (0)) shr (len-1) shl (len-1));
    max := -(min+1);

    decdigits := trunc ((len-1)*(ln(2)/ln(10)))+2
  end;

  function validnumber (num:number) : boolean;
  begin
    validnumber := (num  >= min) and (num <= max)
  end;

  function bitsfromnum (num:number) : bits;

    function bitspos (num:number) : bits;
    var i : integer;
    begin
      for i := 0 to len-1 do
      begin
        bitspos [i] := ord (odd (num)); // num and 1    num mod 2
        num := num div 2                // num shr 1    num div 2
      end
    end;

  begin
    if num >= 0
    then bitsfromnum := bitspos (num)
    else begin
           bitsfromnum := bitspos (num-min);
           bitsfromnum [len-1] := 1
         end
  end;

  procedure printbits (b:bits);
  var groupby, i : integer;
  begin
    if len<=16 then groupby := 4 else groupby := 8;
    for i := len-1 downto 0 do
    begin
      if (i+1) mod groupby = 0 then write (' ');
      write (b[i])
    end
  end;

  procedure test (num:number);
  begin
    write ('number: ', num:decdigits);
    if not validnumber (num)
    then write (' is not valid number, min is ', min ,' and max is ', max)
    else begin
           write (' bits: ');
           printbits (bitsfromnum (num))
         end;
    writeln
  end;

begin
  init (64);
  writeln ('for ',len,' bits, min is ',min,' and max is ',max);

  test (1);
  test (-1);
  test (-6);
  test (-188);
  test (-122);
  test (-98);
  test (0);
  test (1);
  test (6);
  test (128);
  test (100);
  test (8);
  test (42);
  test (min);
  test (max)
end.