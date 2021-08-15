USE visas_tp;
-- creamos las el esquema para la base de datos con dos dimensiones y una fact table
DROP TABLE IF EXISTS bt_employers;
CREATE TABLE bt_employers
(
    employer_name VARCHAR (30),
    sos_name VARCHAR (30),
    sos_code VARCHAR(30),
    PRIMARY KEY (sos_code)
);

DROP TABLE IF EXISTS bt_states;
CREATE TABLE bt_states
(
    state_abb VARCHAR (10),
    state_name VARCHAR(30),
    PRIMARY KEY (state_abb)
);

DROP TABLE IF EXISTS ft_inscriptions;
CREATE TABLE ft_inscriptions
(
    case_number VARCHAR (30),
    case_status VARCHAR (30),
    sos_code VARCHAR (30),
    job_title VARCHAR(30),
    full_time VARCHAR(10),
    prevailing_wage INT NOT NULL,
    state_abb VARCHAR (10),
    worksite_city VARCHAR(30),
    year INT NOT NULL,

    FOREIGN KEY (state_abb) REFERENCES bt_states(state_abb),
    FOREIGN KEY (sos_code) REFERENCES bt_employers(sos_code),
    PRIMARY KEY (case_number),

);

-- copiamos los datos de la tabla general dentro de el schema creado

INSERT INTO bt_employers(employer_name,sos_name, sos_code)
SELECT DISTINCT (EMPLOYER_NAME,SOC_NAME,SOC_CODE)
FROM tabla_general;

INSERT INTO bt_states(state_abb,state_name)
SELECT DISTINCT (WORKSITE_STATE_ABB, WORKSITE_STATE_FULL)
FROM tabla_general;

INSERT INTO ft_inscriptions(case_number, case_status,job_title,full_time,prevailing_wage,worksite_city,year)
SELECT DISTINCT (CASE_NUMBER,CASE_STATUS,JOB_TITLE,FULL_TIME_POSITION,PREVAILING_WAGE,WORKSITE_CITY,YEAR)
FROM tabla_general;

-- Eliminamos la tabla general y nos quedamos con la estructura armada como dw.

DROP TABLE tabla_general;
