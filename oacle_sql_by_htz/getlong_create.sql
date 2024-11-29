/* Formatted on 2016/10/19 10:54:54 (QP5 v5.256.13226.35510) */
CREATE  FUNCTION getlong (p_tname   IN VARCHAR2,
                         p_cname   IN VARCHAR2,
                         p_rowid   IN ROWID)
   RETURN VARCHAR2
AS
   l_cursor     INTEGER DEFAULT DBMS_SQL.open_cursor;
   l_n          NUMBER;
   l_long_val   VARCHAR2 (4000);
   l_long_len   NUMBER;
   l_buflen     NUMBER := 4000;
   l_curpos     NUMBER := 0;
BEGIN
   DBMS_SQL.parse (
      l_cursor,
      'select ' || p_cname || ' from ' || p_tname || ' where rowid = :x',
      DBMS_SQL.native);
   DBMS_SQL.bind_variable (l_cursor, ':x', p_rowid);

   DBMS_SQL.define_column_long (l_cursor, 1);
   l_n := DBMS_SQL.execute (l_cursor);

   IF (DBMS_SQL.fetch_rows (l_cursor) > 0)
   THEN
      DBMS_SQL.column_value_long (l_cursor,
                                  1,
                                  l_buflen,
                                  l_curpos,
                                  l_long_val,
                                  l_long_len);
   END IF;

   DBMS_SQL.close_cursor (l_cursor);
   RETURN l_long_val;
END getlong;
/