SET SQL DIALECT 3;

SET NAMES UTF8;

SET CLIENTLIB 'fbclient.dll';

CREATE DATABASE {DATABASE}
USER 'SYSDBA' PASSWORD 'masterkey'
PAGE_SIZE 8192;


/******************************************************************************/
/****                               Domains                                ****/
/******************************************************************************/

CREATE DOMAIN TBLOB AS BLOB SUB_TYPE 0 SEGMENT SIZE 80;
CREATE DOMAIN TDATETIME AS INTEGER;
CREATE DOMAIN TID AS INTEGER NOT NULL;
CREATE DOMAIN TLONGNAME AS VARCHAR(300);
CREATE DOMAIN TSHORTNAME AS VARCHAR(32);
CREATE DOMAIN TTEXT AS VARCHAR(3000);

/******************************************************************************/
/****                              Generators                              ****/
/******************************************************************************/

CREATE GENERATOR GEN_GROUP_ID;
CREATE GENERATOR GEN_QUESTION_ID;
CREATE GENERATOR GEN_SESSION_ID;
CREATE GENERATOR GEN_STUDENT_ID;
CREATE GENERATOR GEN_TEACHER_ID;
CREATE GENERATOR GEN_TEST_ID;


/******************************************************************************/
/****                                Tables                                ****/
/******************************************************************************/



CREATE TABLE ANSWERS (
    SESSION_ID   TID,
    QUESTION_ID  TID,
    TEXT         TBLOB,
    BALL         INTEGER,
    TIME_SPENT   INTEGER
);

CREATE TABLE GROUP_TEST (
    GROUP_ID  TID,
    TEST_ID   TID
);

CREATE TABLE GROUPS (
    ID           TID,
    NAME         TLONGNAME,
    DESCRIPTION  TLONGNAME
);

CREATE TABLE QUESTIONS (
    ID             TID,
    TEST_ID        TID,
    NAME           TLONGNAME,
    NUMBER         INTEGER,
    WEIGHT         INTEGER,
    QUESTION_TYPE  INTEGER,
    TOPIC          TLONGNAME,
    CONTENT        TBLOB
);

CREATE TABLE SESSIONS (
    ID           TID,
    STUDENT_ID   TID,
    TEST_ID      TID,
    LIFE_TIME    INTEGER,
    "ACTIVE"       INTEGER,
    START_TIME   TDATETIME,
    FINISH_TIME  TDATETIME
);

CREATE TABLE STUDENTS (
    ID        TID,
    GROUP_ID  INTEGER,
    LOGIN     TLONGNAME,
    PASSW     TLONGNAME,
    NAME      TLONGNAME,
    SURNAME   TLONGNAME
);

CREATE TABLE TEACHERS (
    ID       TID,
    LOGIN    TLONGNAME,
    PASSW    TLONGNAME,
    NAME     TLONGNAME,
    SURNAME  TLONGNAME,
    PULPIT   TLONGNAME,
    JOB      TLONGNAME
);

CREATE TABLE TESTS (
    ID               TID,
    TEACHER_ID       TID,
    NAME             TLONGNAME,
    MIX_QUESTIONS    INTEGER,
    MIX_VARIANTS     INTEGER,
    TIME_LIMIT       INTEGER,
    ACCESSIBILITY    INTEGER,
    CAN_CLOSE        INTEGER,
    GREETING         TBLOB,
    CONGRATULATIONS  TBLOB
);

CREATE TABLE VARIANTS (
    QUESTION_ID  TID,
    NUMBER       INTEGER,
    TEXT         TBLOB,
    CORRECT      INTEGER
);



/******************************************************************************/
/****                          Unique Constraints                          ****/
/******************************************************************************/

ALTER TABLE QUESTIONS ADD CONSTRAINT UNQ_TESTID_NUMBER UNIQUE (TEST_ID, NUMBER) USING INDEX UNQ1_QUESTION;
ALTER TABLE TESTS ADD CONSTRAINT UNQ_NAME UNIQUE (NAME, TEACHER_ID);


/******************************************************************************/
/****                             Primary Keys                             ****/
/******************************************************************************/

ALTER TABLE GROUPS ADD CONSTRAINT PK_GROUP PRIMARY KEY (ID);
ALTER TABLE QUESTIONS ADD CONSTRAINT PK_QUESTION PRIMARY KEY (ID);
ALTER TABLE SESSIONS ADD CONSTRAINT PK_SESSION PRIMARY KEY (ID);
ALTER TABLE STUDENTS ADD CONSTRAINT PK_STUDENT PRIMARY KEY (ID);
ALTER TABLE TEACHERS ADD CONSTRAINT PK_TEACHER PRIMARY KEY (ID);
ALTER TABLE TESTS ADD CONSTRAINT PK_TEST PRIMARY KEY (ID);


/******************************************************************************/
/****                             Foreign Keys                             ****/
/******************************************************************************/

ALTER TABLE ANSWERS ADD CONSTRAINT FK_ANSWER_1 FOREIGN KEY (SESSION_ID) REFERENCES SESSIONS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ANSWERS ADD CONSTRAINT FK_ANSWER_2 FOREIGN KEY (QUESTION_ID) REFERENCES QUESTIONS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE GROUP_TEST ADD CONSTRAINT FK_GROUP_TEST_1 FOREIGN KEY (GROUP_ID) REFERENCES GROUPS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE GROUP_TEST ADD CONSTRAINT FK_GROUP_TEST_2 FOREIGN KEY (TEST_ID) REFERENCES TESTS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE QUESTIONS ADD CONSTRAINT FK_QUESTION_1 FOREIGN KEY (TEST_ID) REFERENCES TESTS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE SESSIONS ADD CONSTRAINT FK_SESSION_1 FOREIGN KEY (STUDENT_ID) REFERENCES STUDENTS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE SESSIONS ADD CONSTRAINT FK_SESSION_2 FOREIGN KEY (TEST_ID) REFERENCES TESTS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE STUDENTS ADD CONSTRAINT FK_STUDENT_1 FOREIGN KEY (GROUP_ID) REFERENCES GROUPS (ID) ON DELETE SET NULL;
ALTER TABLE TESTS ADD CONSTRAINT FK_TEST_1 FOREIGN KEY (TEACHER_ID) REFERENCES TEACHERS (ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE VARIANTS ADD CONSTRAINT FK_VARIANT_1 FOREIGN KEY (QUESTION_ID) REFERENCES QUESTIONS (ID) ON DELETE CASCADE ON UPDATE CASCADE;


/******************************************************************************/
/****                               Triggers                               ****/
/******************************************************************************/


SET TERM ^ ;


/******************************************************************************/
/****                         Triggers for tables                          ****/
/******************************************************************************/



/* Trigger: GROUP_BI */
CREATE TRIGGER GROUP_BI FOR GROUPS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_GROUP_ID,1);
END
^

/* Trigger: QUESTION_BI */
CREATE TRIGGER QUESTION_BI FOR QUESTIONS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_QUESTION_ID,1);
END
^

/* Trigger: SESSION_BI */
CREATE TRIGGER SESSION_BI FOR SESSIONS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_SESSION_ID,1);
END
^

/* Trigger: STUDENT_BI */
CREATE TRIGGER STUDENT_BI FOR STUDENTS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_STUDENT_ID,1);
END
^

/* Trigger: TEACHER_BI */
CREATE TRIGGER TEACHER_BI FOR TEACHERS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_TEACHER_ID,1);
END
^

/* Trigger: TEST_BI */
CREATE TRIGGER TEST_BI FOR TESTS
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_TEST_ID,1);
END
^

SET TERM ; ^


INSERT INTO TEACHERS(LOGIN) VALUES('admin');

COMMIT;

