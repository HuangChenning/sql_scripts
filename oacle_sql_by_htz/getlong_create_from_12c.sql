CREATE FUNCTION getlong (opcode IN NUMBER, p_rowid IN ROWID)
   RETURN VARCHAR2
AS
   l_cursor     INTEGER DEFAULT DBMS_SQL.open_cursor;
   l_n          NUMBER;
   l_long_val   VARCHAR2 (4000);
   l_long_len   NUMBER;
   l_buflen     NUMBER := 4000;
   l_curpos     NUMBER := 0;
BEGIN
   IF (opcode = 1)
   THEN
      DBMS_SQL.parse (l_cursor,
                      'select t.TEXT from SYS.VIEW$ t where t.rowid = :x',
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
   ELSIF (opcode = 2)
   THEN
      DBMS_SQL.parse (
         l_cursor,
         'select t.CONDITION from SYS.CDEF$ t where t.rowid = :x',
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
   ELSE
      l_long_val := '';
   END IF;

   RETURN l_long_val;
END getlong;
/