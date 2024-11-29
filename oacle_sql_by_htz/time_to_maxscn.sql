alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
col max_scn for 9999999999999999999999999
SELECT (  (  (  (  TO_NUMBER (
                      TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'),
                               'YYYY'))
                 - 1988)
              * 12
              * 31
              * 24
              * 60
              * 60)
           + (  (  TO_NUMBER (
                      TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'),
                               'MM'))
                 - 1)
              * 31
              * 24
              * 60
              * 60)
           + (  ( (  TO_NUMBER (
                        TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'),
                                 'DD'))
                   - 1))
              * 24
              * 60
              * 60)
           + (  TO_NUMBER (
                   TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'),
                            'HH24'))
              * 60
              * 60)
           + (  TO_NUMBER (
                   TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'),
                            'MI'))
              * 60)
           + (TO_NUMBER (
                 TO_CHAR (TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss'), 'SS'))))
        * (16 * 1024))
          max_scn
  FROM DUAL;
undefine date;