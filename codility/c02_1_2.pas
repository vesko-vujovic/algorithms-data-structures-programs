// rotate an array to the right by a given number of steps
program c02_1_2;

const
  max = 101;

type
  range  = 0..max-1;
  val    = -1000..1000; // int16

  noderef = ^node;
  node    = record
              el   : val;
              next : noderef
            end;

  arr = record
          head : noderef;
          num  : integer
        end;

  // alternative solution with circular list
  // just move head k times
  procedure solution (var a:arr; k:range);
  var i : integer;
  begin
    with a do
      if num<>0
      then begin
             k := k mod num;
             for i := 1 to k do
               head := head^.next
           end
  end;

  procedure test (inp:array of val; k:range);
  var a:arr; i:integer;

    procedure print (a:arr);
    var p:noderef; i:integer;
    begin
      with a do
      begin
        p := head;
        write ('[');
        for i := 1 to num do
        begin
          if i>1 then write (',');
          write (p^.el);
          p := p^.next
        end;
        write (']')
      end
    end;

    procedure initarr (var a:arr);
    begin
      a.num := 0
    end;

    procedure disposearr (var a:arr);
    var i:integer; p:noderef;
    begin
      with a do
      begin
        for i := 1 to a.num do
        begin
          if i<a.num then p := head^.next;
          dispose (head);
          if i<a.num then head := p
        end;
        a.num := 0
      end
    end;

    procedure append (var a:arr; v:val);
    var p,n : noderef; i:integer;
    begin
      new (n);
      with a,n^ do
      begin
        el := v;

        if num=0
        then head := n
        else begin
               p := head; for i := 1 to num-1 do p := p^.next; // last el.
               p^.next := n
               end;

        next := head;
        num  := num+1
      end;
    end;

  begin
    initarr (a);
    for i := 0 to length(inp)-1 do append (a,inp[i]);

    write ('input:  '); print(a); write (', n: ',a.num,', k: ',k); writeln;
    solution (a,k);
    write ('output: '); print (a); writeln;
    writeln;
    disposearr (a)
  end;


begin
  test ([3,8,9,7,6],3);
  test ([0,0,0],1);
  test ([1,2,3,4],4)
end.