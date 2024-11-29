create or replace function long_length( p_cname in varchar2,
                                        p_tname in varchar2, 
                                        p_rowid in rowid )
return number
as
    l_cursor    integer default dbms_sql.open_cursor;
    l_n         number;
    l_long_val  varchar2(32760);
    l_long_len  number;
    l_buflen    number := 32760;
    l_curpos    number := 0;
begin
    dbms_sql.parse( l_cursor, 'select ' || p_cname ||
                               ' from ' || p_tname ||
                              ' where rowid = :rid', 
                    dbms_sql.native );

    dbms_sql.bind_variable( l_cursor, ':rid', p_rowid );

    dbms_sql.define_column_long(l_cursor, 1);
    l_n := dbms_sql.execute(l_cursor);

    if (dbms_sql.fetch_rows(l_cursor)>0)
    then
        loop
            dbms_sql.column_value_long(l_cursor, 1, l_buflen, 
                                       l_curpos ,
                                       l_long_val, l_long_len );
            l_curpos := l_curpos + l_long_len;
            exit when l_long_len = 0;
      end loop;
   end if;
   dbms_sql.close_cursor(l_cursor);
   return l_curpos;
exception
   when others then
      if dbms_sql.is_open(l_cursor) then
         dbms_sql.close_cursor(l_cursor);
      end if;
      raise;
end long_length;
/

