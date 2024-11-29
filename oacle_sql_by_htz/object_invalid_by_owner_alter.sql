BEGIN
  FOR crec IN (SELECT object_name,
                      object_type,
                      DECODE(object_type,
                             'TYPE',
                             1,
                             'FUNCTION',
                             2,
                             'PROCEDURE',
                             3,
                             'TRIGGER',
                             4,
                             'VIEW',
                             5,
                             'PACKAGE',
                             6,
                             'TYPE BODY',
                             7,
                             'PACKAGE BODY',
                             8,
                             'MATERIALIZED VIEW',
                             9,
                             10) object_type_seq
                 FROM all_objects
                WHERE owner in (&owner_list)
                  AND status = 'INVALID'
                  AND object_type IN ('FUNCTION',
                                      'PACKAGE',
                                      'PACKAGE BODY',
                                      'PROCEDURE',
                                      'TYPE',
                                      'TYPE BODY',
                                      'TRIGGER',
                                      'VIEW',
                                      'MATERIALIZED VIEW')
                ORDER BY object_type_seq, object_type, created) LOOP
    BEGIN
    
      IF (crec.object_type = 'PACKAGE BODY') THEN
      
        -- If package body is invalid, just compile the body and not
        -- the specification
        EXECUTE IMMEDIATE 'ALTER PACKAGE ' || crec.object_name ||
                          ' compile body';
      ELSIF (crec.object_type = 'TYPE') THEN
        -- If type spec is invalid, just compile the specification and not
        -- the body
        EXECUTE IMMEDIATE 'ALTER TYPE ' || crec.object_name ||
                          ' compile specification';
      ELSIF (crec.object_type = 'TYPE BODY') THEN
        -- If type body is invalid, just compile the body and not
        -- the specification
        EXECUTE IMMEDIATE 'ALTER TYPE ' || crec.object_name ||
                          ' compile body';
      ELSE
        EXECUTE IMMEDIATE 'ALTER ' || crec.object_type || ' ' ||
                          crec.object_name || ' compile';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Recompile Fail:' || crec.object_name);
      
      --RAISE;
    END;
  
  END LOOP;
END;
/
