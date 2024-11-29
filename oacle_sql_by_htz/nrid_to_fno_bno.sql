col nrid new_v nrid10 noprint;
select to_number('&nrid','xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') nrid from dual;
select dbms_utility.data_block_address_file(&nrid10) "file",
 dbms_utility.data_block_address_block(&nrid10) "block"
 from dual;
