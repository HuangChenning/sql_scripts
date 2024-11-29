/* Formatted on 2017/9/5 23:08:49 (QP5 v5.300) */
DECLARE
    i_sql       VARCHAR2 (1000);
    i_count     NUMBER;
    i_version   VARCHAR2 (12);
    i_pdbname   VARCHAR2 (100);
BEGIN
    SELECT SUBSTR (banner, INSTR (banner, '.', 1) - 2, 8)
      INTO i_version
      FROM v$version
     WHERE banner LIKE 'Oracle Database%';

    SELECT COUNT (*)
      INTO i_count
      FROM dba_objects a
     WHERE     a.owner = 'SYS'
           AND a.object_name = UPPER ('password_verify_function')
           AND a.object_type = 'FUNCTION';

    IF i_count > 0
    THEN
        IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
        THEN
            SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
              INTO i_pdbname
              FROM DUAL;

            IF i_pdbname = 'CDB$ROOT'
            THEN
                SELECT COUNT (*)
                  INTO i_count
                  FROM dba_profiles
                 WHERE profile = UPPER ('C##PROFILE_USER');
            ELSE
                SELECT COUNT (*)
                  INTO i_count
                  FROM dba_profiles
                 WHERE profile = UPPER ('PROFILE_USER');
            END IF;
        ELSE
            SELECT COUNT (*)
              INTO i_count
              FROM dba_profiles
             WHERE profile = UPPER ('PROFILE_USER');
        END IF;

        IF i_count < 1
        THEN
            IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
            THEN
                SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
                  INTO i_pdbname
                  FROM DUAL;

                IF i_pdbname = 'CDB$ROOT'
                THEN
                    i_sql :=
                        'create PROFILE c##profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                ELSE
                    i_sql :=
                        'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                END IF;
            ELSE
                i_sql :=
                    'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
            END IF;

            DBMS_OUTPUT.put_line (i_sql);

            EXECUTE IMMEDIATE i_sql;
        END IF;

        IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
        THEN
            SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
              INTO i_pdbname
              FROM DUAL;

            IF i_pdbname = 'CDB$ROOT'
            THEN
                FOR c_value
                    IN (SELECT profile
                          FROM dba_profiles
                         WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                               AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                LOOP
                    i_sql :=
                           'alter profile '
                        || c_value.profile
                        || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;
                END LOOP;
            ELSE
                FOR c_value
                    IN (SELECT profile
                          FROM dba_profiles
                         WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                               AND profile NOT LIKE 'C##P%'
                               AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                LOOP
                    i_sql :=
                           'alter profile '
                        || c_value.profile
                        || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;
                END LOOP;
            END IF;
        ELSE
            FOR c_value
                IN (SELECT profile
                      FROM dba_profiles
                     WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                           AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
            LOOP
                i_sql :=
                       'alter profile '
                    || c_value.profile
                    || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                DBMS_OUTPUT.put_line (i_sql);

                EXECUTE IMMEDIATE i_sql;
            END LOOP;
        END IF;
    END IF;
END;
/