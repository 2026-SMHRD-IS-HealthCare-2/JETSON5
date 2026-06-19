멘토: 김광진(router128@hanmail.net)

팀명: JETSON5
팀원: 임채현 박선혜 박건희 김성훈 김태헌
주제: 시니어 맞춤형 스마트 약 보관함 및 복약 안심 케어 시스템

* 서버구축정보(핵심: MySQL)

  HOSTNAME : project-db-campus.smhrd.com
  PORT     : 3307
  USER     : JETSON5
  PW       : 5555
  DataBase : JETSON5

[2][3][4][5][6][7][8][9][10][11][12][13][14][15][16]
[17][18][19][20][21][22][23][24][25][26][27][28][29][30]

* 데이터베이스 설계순서?
  요구사항분석 > 개념설계 >  논리설계 > 물리설계 > DB구현  (개.눈.물)

* ERD
  ER-Diagram
  Entity Relationship Diagram

* DDL(Data Definition Language)    정의 명령어: CREATE, ALTER, DROP (TABLE)
  DML(Data Manipulation Language)  조작 명령어: INSERT, UPDATE, DELETE * SELECT는 아님(주의: 정처기에서 SELCT를 DML로 취급)
  DCL(Data Control Language)       제어 명령어: GRANT, REVOKE, COMMIT, ROLLBACK 
  DQL(Data QueryLanguage)          질의 명령어: SELECT
  TCL(Transaction Control Language): DCL 명령어 중에서 COMMIT과 ROLLBACK을 따로 떼어서 TCL이라고 부르기도 함.

* 변수, 컬럼의 네이밍 규칙(naming rule)

  MemberId : PASKAL CASE 
  memberId  : CAMEL CASE 
  MEMBER_ID :  SNAKE UPPER CASE
  member_id  : snake lower case





트리거(trigger) 생성:
INSERT, UPDATE, DELETE 동작이 발생할 때, 추가적으로 어떤 프로세스를 처리.

DELIMITER $$
CREATE TRIGGER TRG_EVENT
BEFORE INSERT/UPDATE/DELETE ON TB_MEMBER
BEGIN
  ....;
  ....;
END$$
DELIMITER ;

-- 트리거는 DML 명령어에만 적용할 수 있다.(INSERT, UPDATE, DELETE)



* MySQL에서 트리거 생성하려면 다음과 같이 구성한다고 알고 있다.

CREATE TRIGGER TRG_EVENT
BEFORE INSERT/UPDATE/DELETE ON TB_MEMBER
FOR EACH ROW
BEGIN
  ....;
  ....;
END$$
DELIMITER ;

트리거는 DML명령어에만 적용할 수 있다고 하는데, SELECT가 DML명령어인가 DQL명령어인가?


# TB_MEMBER 테이블의 MEM_ID 키를 다른 테이블에서 외래키로 쓰고 있는 경우
# 테이블 전체 삭제 못함
# 해결책은?
# FK의 체크를 일시적으로 중지시킨다.

TRUNCATE TABLE TB_MEMBER;  -- (x)
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE TB_MEMBER;  -- (o)
SET FOREIGN_KEY_CHECKS=1;
------------------------------------------------------------------------
CREATE TABLE TB_MEMBER
(
    `MEM_ID`       VARCHAR(50)     NOT NULL    COMMENT '회원 아이디', 
    `MEM_PW`       VARCHAR(255)    NOT NULL    COMMENT '회원 비밀번호', 
    `MEM_NAME`     VARCHAR(50)     NOT NULL    COMMENT '회원 이름', 
    `MEM_EMAIL`    VARCHAR(100)    NOT NULL    COMMENT '회원 이메일', 
    `MEM_CONTACT`  VARCHAR(20)     NOT NULL    COMMENT '회원 연락처', 
    `MEM_ST`       CHAR(1)         NOT NULL CHECK(MEM_ST IN ('P', 'S', 'A'))   COMMENT '회원 구분', 
    `JOINED_AT`    DATETIME        NOT NULL    COMMENT '가입 일자', 
     PRIMARY KEY (MEM_ID)
);


* 체크 제약 조건 -> ENUM 타입(Enumerable Number)
`MEM_ST`       CHAR(1)         NOT NULL CHECK(MEM_ST IN ('P', 'S', 'A'))   COMMENT '회원 구분', 
=> `MEM_ST`       ENUM('P', 'S', 'A'))  NOT NULL COMMENT '회원 구분', 
 

* 부서 직원이 상사 정보 구할 때:

  직원 아이디(EMP_ID)
  이름
  부서
  연락처
  담당업부
  상사 아이디(SUPER_ID)


  Relation      : 일반적인 관계('날씨와 우산판매량의 관계')
  Relations     : 국가적인 관계(relations) between the two countries.
  Relationship  : 개인적인 관계/비즈니스 관계


  id1|id2|id3|id4

  String[] senior_id = str.split('|');

* 대시보드 차트 구현하기

  추천: Apache Echarts
  -----------------------------------------------------------------
  (SQL)
  -- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- TB_MEMBER Table Create SQL
-- 테이블 생성 SQL - TB_MEMBER
CREATE TABLE TB_MEMBER
(
    `MEM_ID`       VARCHAR(50)     NOT NULL    COMMENT '회원 아이디', 
    `MEM_PW`       VARCHAR(255)    NOT NULL    COMMENT '회원 비밀번호', 
    `MEM_NAME`     VARCHAR(50)     NOT NULL    COMMENT '회원 이름', 
    `MEM_EMAIL`    VARCHAR(100)    NOT NULL    COMMENT '회원 이메일', 
    `MEM_CONTACT`  VARCHAR(20)     NOT NULL    COMMENT '회원 연락처', 
    `MEM_ADDR`     VARCHAR(255)    NULL        COMMENT '회원 주소', 
    `MEM_ST`       CHAR(1)         NOT NULL    DEFAULT 'U' COMMENT '회원 구분', 
    `JOINED_AT`    DATETIME        NOT NULL    COMMENT '가입 일자', 
     PRIMARY KEY (MEM_ID)
);

-- 테이블 Comment 설정 SQL - TB_MEMBER
ALTER TABLE TB_MEMBER COMMENT '회원';


-- TB_SENIOR Table Create SQL
-- 테이블 생성 SQL - TB_SENIOR
CREATE TABLE TB_SENIOR
(
    `SENIOR_ID`       VARCHAR(50)     NOT NULL    COMMENT '시니어 아이디', 
    `SENIOR_PW`       VARCHAR(255)    NOT NULL    COMMENT '시니어 비밀번호', 
    `MEM_ID`          VARCHAR(50)     NOT NULL    COMMENT '회원 아이디', 
    `SENIOR_NAME`     VARCHAR(50)     NOT NULL    COMMENT '시니어 이름', 
    `SENIOR_EMAIL`    VARCHAR(100)    NOT NULL    COMMENT '시니어 이메일', 
    `SENIOR_CONTACT`  VARCHAR(20)     NOT NULL    COMMENT '시니어 연락처', 
    `SENIOR_ADDR`     VARCHAR(255)    NULL        COMMENT '시니어 주소', 
    `JOINED_AT`       DATETIME        NOT NULL    COMMENT '가입 일자', 
     PRIMARY KEY (SENIOR_ID)
);

-- 테이블 Comment 설정 SQL - TB_SENIOR
ALTER TABLE TB_SENIOR COMMENT '시니어 정보';

-- Foreign Key 설정 SQL - TB_SENIOR(MEM_ID) -> TB_MEMBER(MEM_ID)
ALTER TABLE TB_SENIOR
    ADD CONSTRAINT FK_TB_SENIOR_MEM_ID_TB_MEMBER_MEM_ID FOREIGN KEY (MEM_ID)
        REFERENCES TB_MEMBER (MEM_ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - TB_SENIOR(MEM_ID)
-- ALTER TABLE TB_SENIOR
-- DROP FOREIGN KEY FK_TB_SENIOR_MEM_ID_TB_MEMBER_MEM_ID;


-- TB_SCHEDULE Table Create SQL
-- 테이블 생성 SQL - TB_SCHEDULE
CREATE TABLE TB_SCHEDULE
(
    `SCHE_CD`        INT            NOT NULL    AUTO_INCREMENT COMMENT '스케줄 코드', 
    `SENIOR_ID`      VARCHAR(50)    NOT NULL    COMMENT '시니어 아이디', 
    `TAKING_DATE`    DATE           NOT NULL    COMMENT '복용 날짜', 
    `PILLBOX_ORDER`  INT            NOT NULL    COMMENT '약통칸 번호', 
    `TAKING_TYPE`    VARCHAR(10)    NOT NULL    COMMENT '복용 구분', 
    `TAKING_TIME`    TIME           NOT NULL    COMMENT '복용 예정 시간', 
    `TAKEN_TIME`     DATETIME       NULL        COMMENT '복용 시간', 
    `TAKING_YN`      CHAR(1)        NOT NULL    DEFAULT 'N' COMMENT '복용 여부', 
    `CREATED_AT`     DATETIME       NOT NULL    COMMENT '등록 일시', 
     PRIMARY KEY (SCHE_CD)
);

-- 테이블 Comment 설정 SQL - TB_SCHEDULE
ALTER TABLE TB_SCHEDULE COMMENT '복약 스케줄';

-- Foreign Key 설정 SQL - TB_SCHEDULE(SENIOR_ID) -> TB_SENIOR(SENIOR_ID)
ALTER TABLE TB_SCHEDULE
    ADD CONSTRAINT FK_TB_SCHEDULE_SENIOR_ID_TB_SENIOR_SENIOR_ID FOREIGN KEY (SENIOR_ID)
        REFERENCES TB_SENIOR (SENIOR_ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - TB_SCHEDULE(SENIOR_ID)
-- ALTER TABLE TB_SCHEDULE
-- DROP FOREIGN KEY FK_TB_SCHEDULE_SENIOR_ID_TB_SENIOR_SENIOR_ID;


-- TB_PILLBOX_LOG Table Create SQL
-- 테이블 생성 SQL - TB_PILLBOX_LOG
CREATE TABLE TB_PILLBOX_LOG
(
    `LOG_CD`     INT            NOT NULL    AUTO_INCREMENT COMMENT '로그 코드', 
    `SENIOR_ID`  VARCHAR(50)    NOT NULL    COMMENT '시니어 아이디', 
    `SLOT_NUM`   INT            NOT NULL    COMMENT '약통칸 번호', 
    `LOG_TYPE`   VARCHAR(10)    NOT NULL    COMMENT '로그 종류', 
    `LOGGED_AT`  DATETIME       NOT NULL    COMMENT '기록 시간', 
     PRIMARY KEY (LOG_CD)
);

-- 테이블 Comment 설정 SQL - TB_PILLBOX_LOG
ALTER TABLE TB_PILLBOX_LOG COMMENT '약통의 하드웨어 로그';

-- Foreign Key 설정 SQL - TB_PILLBOX_LOG(SENIOR_ID) -> TB_SENIOR(SENIOR_ID)
ALTER TABLE TB_PILLBOX_LOG
    ADD CONSTRAINT FK_TB_PILLBOX_LOG_SENIOR_ID_TB_SENIOR_SENIOR_ID FOREIGN KEY (SENIOR_ID)
        REFERENCES TB_SENIOR (SENIOR_ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - TB_PILLBOX_LOG(SENIOR_ID)
-- ALTER TABLE TB_PILLBOX_LOG
-- DROP FOREIGN KEY FK_TB_PILLBOX_LOG_SENIOR_ID_TB_SENIOR_SENIOR_ID;


-- TB_ALERT Table Create SQL
-- 테이블 생성 SQL - TB_ALERT
CREATE TABLE TB_ALERT
(
    `ALERT_CD`     INT            NOT NULL    AUTO_INCREMENT COMMENT '알림 코드', 
    `MEM_ID`       VARCHAR(50)    NOT NULL    COMMENT '회원 아이디', 
    `SENIOR_ID`    VARCHAR(50)    NOT NULL    COMMENT '시니어 아이디', 
    `ALERT_TYPE`   VARCHAR(10)    NOT NULL    COMMENT '알림 구분', 
    `ALERT_MSG`    TEXT           NOT NULL    COMMENT '알림 메시지', 
    `ALERT_TIME`   DATETIME       NOT NULL    COMMENT '알림 시간', 
    `IS_RECEIVED`  CHAR(1)        NOT NULL    COMMENT '수신 여부', 
    `CREATED_AT`   DATETIME       NOT NULL    COMMENT '등록 일자', 
     PRIMARY KEY (ALERT_CD)
);

-- 테이블 Comment 설정 SQL - TB_ALERT
ALTER TABLE TB_ALERT COMMENT '알림';

-- Foreign Key 설정 SQL - TB_ALERT(SENIOR_ID) -> TB_SENIOR(SENIOR_ID)
ALTER TABLE TB_ALERT
    ADD CONSTRAINT FK_TB_ALERT_SENIOR_ID_TB_SENIOR_SENIOR_ID FOREIGN KEY (SENIOR_ID)
        REFERENCES TB_SENIOR (SENIOR_ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - TB_ALERT(SENIOR_ID)
-- ALTER TABLE TB_ALERT
-- DROP FOREIGN KEY FK_TB_ALERT_SENIOR_ID_TB_SENIOR_SENIOR_ID;

-- Foreign Key 설정 SQL - TB_ALERT(MEM_ID) -> TB_MEMBER(MEM_ID)
ALTER TABLE TB_ALERT
    ADD CONSTRAINT FK_TB_ALERT_MEM_ID_TB_MEMBER_MEM_ID FOREIGN KEY (MEM_ID)
        REFERENCES TB_MEMBER (MEM_ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - TB_ALERT(MEM_ID)
-- ALTER TABLE TB_ALERT
-- DROP FOREIGN KEY FK_TB_ALERT_MEM_ID_TB_MEMBER_MEM_ID;


