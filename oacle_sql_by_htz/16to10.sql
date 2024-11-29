set verify off
col number10 for 999999999999999999999999999
select to_number(replace('&number16',' '),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')  number10 from dual;
