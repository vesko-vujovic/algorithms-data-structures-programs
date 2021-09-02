// to prepare for library creation
// binary - dec - string all conversions (inc negative)
//
program final;
const
   digits = 64;

type
  binary  = array [0..digits-1] of 0..1;
  decimal = int64;

var
  w : array [0..digits-1] of decimal;

  procedure init;
  begin end;

  function strfrombin (b: binary) : string;
  var s : string; i:integer;
  begin
    s := '';
    for i := 0 to length(b) do
      s := s + chr (b[i] + ord('0')); 
    strfrombin := s
  end;

  function binfromstr (s:string) : binary;
  var l,p,i : integer;
  begin
    for i := 0 to digits-1 do binfromstr[i] := 0;
    l := length(s); if l>digits then l := digits;

    p := 0;
    for i := l downto 1 do
      if s[i] in ['0'..'1']
      then begin
             binfromstr [p] :=  ord (s[i]='1');
             p := p+1
           end;
    if p>0
    then for i := p to digits-1 do
           binfromstr [i] := binfromstr [p-1];
  end;

  function binfromdec (d:decimal) : binary;
  begin binfromdec[0] := 1 end;

  function decfrombin (b:binary) : decimal;
  begin decfrombin := 10 end;


var d:decimal; b:binary; s:string;
begin
	init;

  s := '1010';
  b := binfromstr (s);

  writeln ('string: ',s,', bin: ',strfrombin(b))
end.
