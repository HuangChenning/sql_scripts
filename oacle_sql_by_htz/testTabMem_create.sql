create or replace package testTabMem as

type t_tabTest is table of varchar2(20) index by binary_integer;

procedure addToTab(p_numRows number);

procedure cleanUp;

function getCount return number;
end;
/

create or replace package body testTabMem as

g_tabVar t_tabTest;

procedure addToTab(p_numRows number) is
v_startVal number;
begin
v_startVal := g_tabVar.count;

for i in 1..p_numRows loop
g_tabVar(v_startVal + i) := to_char(i);
end loop;
end;

procedure cleanUp is
begin
g_tabVar.delete;
end;

function getCount return number is
begin
return g_tabVar.count;
end;
end;
/
