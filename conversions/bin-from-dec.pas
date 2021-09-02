program dec_to_bin;
const
  maxbits = 64;

type
  numpos = qword;
  numneg = int64;

const
  neg  = true;
  bits = 63; // bits must be > 0

type
  bit     = 0..1;
  binary  = array [0..bits-1] of bit;
  number = numneg;

var
  min, max  : number;
  bitn      : array [0..bits-1] of number;

  procedure init;
  var i : byte;
  begin
    bitn[0] := 1; max := bitn[0];
    for i := 1 to bits - 1 do
    begin
      bitn[i] := bitn[i-1] shl 1;
      max := max or bitn[i]
    end;
    min := 0;

    if neg
    then begin
           bitn[bits-1] := -bitn[bits-1];
           min := bitn [bits-1];
           max := not min
         end
  end;

  procedure numtobin (num:number; var b:binary; var err:boolean);
  var i : byte;
  begin
    err := (num<min) or (num>max);
    if not err
    then for i := 0 to bits-1 do
           b[i] := ord ((num and bitn[i]) <> 0)
  end;

  procedure test (num : array of number);
  var i,j : byte; b : binary; e : boolean;
  begin
    for i := 0 to length(num)-1 do
    begin
      write ('number: ',num[i]:8);
      numtobin (num[i],b,e);
      if e
      then writeln (' out of range, for ',bits,' bits number must be in [',min,'..',max,'] !')
      else begin
             write (' bits: ');
             for j := bits-1 downto 0 do
             begin
               if (j+1) mod 4 = 0 then write (' ');
               write (b[j]);
             end;
             writeln
           end
    end
  end;

begin
  init;
  test ([0,1,-1,2,-2,min,max])
end.