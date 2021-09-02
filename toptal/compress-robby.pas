program compress_not_efficient;

const
  maxchars = 100000;

type
  str = record
          ch  : array [1..maxchars] of char;
          len : integer
        end;

  function strfromtext (text:string) : str;
  var i : integer;
  begin
    with strfromtext do
    begin
      len := length (text);
      for i := 1 to len do ch[i] := text[i]
    end
  end;

  procedure outstr (s:str);
  var i : integer;
  begin
    for i := 1 to s.len do write (s.ch[i])
  end;

  procedure addch (var s:str; chr:char);
  begin
    with s do
    begin
      len := len+1;
      ch[len] := chr
    end
  end;

  procedure addnum (var s:str; num:integer);
  var l : integer;
    procedure insdigit (pos:integer; digit:byte);
    var i:integer;
    begin
      with s do
      begin
        len := len+1;
        for i := s.len downto pos+1 do
          ch[i] := ch[i-1];
        ch[pos] := chr (ord ('0')+digit)
      end
    end;
  begin
    l := s.len+1;
    if num=0
    then addch (s,'0')
    else while num<>0 do
         begin
           insdigit (l, num mod 10);
           num := num div 10
         end
  end;

  function compressed (s:str) : str;
  var curr : char; pos,num : integer;

  begin
    compressed.len := 0;

    pos := 1;
    while pos <= s.len do
    begin
      curr := s.ch[pos]; num := 0;
      while (pos<=s.len) and (s.ch[pos]=curr) do
      begin
        num := num+1;
        pos := pos+1
      end;
      if num>1
      then addnum (compressed,num);
      addch (compressed,curr)
    end
  end;

  function decompressed (s:str) : str;
  var c : str; pos,num,i : integer;

  begin
    c.len := 0;
    pos := 1;
    while pos<=s.len do
      if not (s.ch[pos] in ['0'..'9'])
      then begin
             addch (c,s.ch[pos]);
             pos := pos+1
           end
      else begin
             num := 0;
             while (pos<=s.len) and (s.ch[pos] in ['0'..'9']) do
             begin
               num := num*10+ord(s.ch[pos])-ord('0');
               pos := pos+1
             end;
             if pos<=s.len
             then begin
                    for i := 1 to num do
                      addch (c,s.ch[pos]);
                    pos := pos+1
                  end
           end;
    decompressed := c
  end;

  procedure try (text:string);
  var
    s : str;
  begin
    s := strfromtext (text);
    write ('original:     '); outstr (s); writeln;
    write ('compressed:   '); outstr (compressed(s)); writeln;
    write ('decompressed: '); outstr (decompressed(compressed(s))); writeln;
    writeln
  end;

begin
  try ('abbbccddccc');
  try ('aaaaaaaaaaabxxaaaaaaaaaa');
  try ('abbbcccc');
  try ('aaaaaaaaaaaaaaaaaaa')
end.