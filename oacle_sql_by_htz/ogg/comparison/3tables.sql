drop table dsg_no_sup;
CREATE TABLE DSG.DSG_NO_SUP
(
  OWNER        VARCHAR2(10 BYTE),
  TABLE_NAME   VARCHAR2(50 BYTE),
  NO_SUP_TYPE  VARCHAR2(20 BYTE)
) ;


drop table dsg_check_table;
create table DSG_CHECK_TABLE
(
  DS_OWNER        VARCHAR2(50) not null,
  DT_OWNER        VARCHAR2(50),
  DS_NAME         VARCHAR2(50) not null,
  DT_NAME         VARCHAR2(50),
  TABLE_PARTITION VARCHAR2(50) not null,
  SYNONYM_NO      NUMBER default 0,
  CHECK_TYPE      VARCHAR2(20),
  DS_COUNT        NUMBER,
  DT_COUNT        NUMBER,
  MINUS_COUNT     NUMBER,
  SEG_BYTE        NUMBER,
  SEQ             NUMBER,
  STATUS          NUMBER,
  DIFF_TIME       NUMBER,
  PRIVAL          NUMBER,
  START_DIFF      DATE,
  MINUS_DIFF      DATE,
  DS_COUNT_DIFF   DATE,
  DT_COUNT_DIFF   DATE,
  ERR_MSG         VARCHAR2(500),
  CHECK_SQL       CLOB
);

-- Create/Recreate primary, unique and foreign key constraints 
alter table DSG_CHECK_TABLE
  add constraint PK_DSG_CHECK_TABLE primary key (DS_OWNER, DS_NAME, TABLE_PARTITION)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );


drop table dsg_check_his;
create table DSG_CHECK_HIS
(
  DS_OWNER        VARCHAR2(50) not null,
  DT_OWNER        VARCHAR2(50),
  DS_NAME         VARCHAR2(50) not null,
  DT_NAME         VARCHAR2(50),
  TABLE_PARTITION VARCHAR2(50) not null,
  SYNONYM_NO      NUMBER default 0,
  CHECK_TYPE      VARCHAR2(20),
  DS_COUNT        NUMBER,
  DT_COUNT        NUMBER,
  MINUS_COUNT     NUMBER,
  SEG_BYTE        NUMBER,
  SEQ             NUMBER,
  STATUS          NUMBER,
  DIFF_TIME       NUMBER,
  PRIVAL          NUMBER,
  START_DIFF      DATE,
  MINUS_DIFF      DATE,
  DS_COUNT_DIFF   DATE,
  DT_COUNT_DIFF   DATE,
  ERR_MSG         VARCHAR2(500),
  CHECK_SQL       CLOB
);