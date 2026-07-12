-- Cat Grooming Booking Management System
-- PostgreSQL schema
--
-- WARNING: This script recreates the application tables.
-- Run it on a new/empty PostgreSQL database.

BEGIN;

DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS furbasedservice CASCADE;
DROP TABLE IF EXISTS weightbasedservice CASCADE;
DROP TABLE IF EXISTS service CASCADE;
DROP TABLE IF EXISTS cat CASCADE;
DROP TABLE IF EXISTS breed CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS staff CASCADE;

DROP SEQUENCE IF EXISTS appointmentid_seq;
DROP SEQUENCE IF EXISTS serviceid_seq;
DROP SEQUENCE IF EXISTS catid_seq;
DROP SEQUENCE IF EXISTS breedid_seq;
DROP SEQUENCE IF EXISTS custid_seq;
DROP SEQUENCE IF EXISTS staffid_seq;

CREATE SEQUENCE staffid_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE custid_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE breedid_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE catid_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serviceid_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE appointmentid_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE staff (
    staffid             INTEGER PRIMARY KEY DEFAULT nextval('staffid_seq'),
    staffusername       VARCHAR(100) NOT NULL,
    staffpassword       VARCHAR(255) NOT NULL,
    stafffullname       VARCHAR(150) NOT NULL,
    staffphonenumber    VARCHAR(30),
    staffemail          VARCHAR(255) NOT NULL,
    staffaddress        VARCHAR(500),
    staffrole           VARCHAR(20) NOT NULL DEFAULT 'Staff',
    staffprofilephoto   BYTEA,
    ownerid             INTEGER,
    staffstatus         VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT staff_owner_fk
        FOREIGN KEY (ownerid) REFERENCES staff(staffid)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT staff_role_ck
        CHECK (UPPER(staffrole) IN ('STAFF', 'OWNER')),
    CONSTRAINT staff_status_ck
        CHECK (UPPER(staffstatus) IN ('ACTIVE', 'INACTIVE'))
);

ALTER SEQUENCE staffid_seq OWNED BY staff.staffid;
CREATE UNIQUE INDEX staff_username_uk ON staff (LOWER(TRIM(staffusername)));
CREATE UNIQUE INDEX staff_email_uk ON staff (LOWER(TRIM(staffemail)));
CREATE INDEX staff_owner_ix ON staff(ownerid);
CREATE INDEX staff_status_ix ON staff(staffstatus);

CREATE TABLE customer (
    custid              INTEGER PRIMARY KEY DEFAULT nextval('custid_seq'),
    custusername        VARCHAR(100) NOT NULL,
    custpassword        VARCHAR(255) NOT NULL,
    custfullname        VARCHAR(150) NOT NULL,
    custphonenumber     VARCHAR(30),
    custemail           VARCHAR(255) NOT NULL,
    custprofilephoto    BYTEA,
    custstatus          VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT customer_status_ck
        CHECK (UPPER(custstatus) IN ('ACTIVE', 'INACTIVE'))
);

ALTER SEQUENCE custid_seq OWNED BY customer.custid;
CREATE UNIQUE INDEX customer_username_uk ON customer (LOWER(TRIM(custusername)));
CREATE UNIQUE INDEX customer_email_uk ON customer (LOWER(TRIM(custemail)));
CREATE INDEX customer_status_ix ON customer(custstatus);

CREATE TABLE breed (
    breedid             INTEGER PRIMARY KEY DEFAULT nextval('breedid_seq'),
    breedname           VARCHAR(120) NOT NULL UNIQUE
);

ALTER SEQUENCE breedid_seq OWNED BY breed.breedid;

CREATE TABLE cat (
    catid               INTEGER PRIMARY KEY DEFAULT nextval('catid_seq'),
    catname             VARCHAR(120) NOT NULL,
    dateofbirth         DATE,
    gender              VARCHAR(20),
    conditionnotes      TEXT,
    catphoto            BYTEA,
    custid              INTEGER NOT NULL,
    breedid             INTEGER NOT NULL,
    catstatus           VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT cat_customer_fk
        FOREIGN KEY (custid) REFERENCES customer(custid)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT cat_breed_fk
        FOREIGN KEY (breedid) REFERENCES breed(breedid)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT cat_status_ck
        CHECK (UPPER(catstatus) IN ('ACTIVE', 'INACTIVE'))
);

ALTER SEQUENCE catid_seq OWNED BY cat.catid;
CREATE INDEX cat_customer_ix ON cat(custid);
CREATE INDEX cat_breed_ix ON cat(breedid);
CREATE INDEX cat_status_ix ON cat(catstatus);

CREATE TABLE service (
    serviceid           INTEGER PRIMARY KEY DEFAULT nextval('serviceid_seq'),
    servicename         VARCHAR(150) NOT NULL,
    category            VARCHAR(20) NOT NULL DEFAULT 'ADDON',
    description         TEXT,
    price               NUMERIC(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT service_category_ck
        CHECK (UPPER(REPLACE(category, '-', '')) IN ('MAIN', 'ADDON')),
    CONSTRAINT service_price_ck CHECK (price >= 0)
);

ALTER SEQUENCE serviceid_seq OWNED BY service.serviceid;
CREATE INDEX service_category_ix ON service(category);

CREATE TABLE furbasedservice (
    serviceid           INTEGER PRIMARY KEY,
    furtype             VARCHAR(30) NOT NULL,
    CONSTRAINT fur_service_fk
        FOREIGN KEY (serviceid) REFERENCES service(serviceid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE weightbasedservice (
    serviceid           INTEGER PRIMARY KEY,
    weightrange         VARCHAR(80) NOT NULL,
    CONSTRAINT weight_service_fk
        FOREIGN KEY (serviceid) REFERENCES service(serviceid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- One appointment may contain several services. Therefore appointmentid is
-- intentionally repeated, while (appointmentid, serviceid) identifies a row.
CREATE TABLE appointment (
    appointmentid       INTEGER NOT NULL DEFAULT nextval('appointmentid_seq'),
    catid               INTEGER NOT NULL,
    serviceid           INTEGER NOT NULL,
    appointmentdate     DATE NOT NULL,
    appointmenttime     TIME NOT NULL,
    appointmentstatus   VARCHAR(30) NOT NULL DEFAULT 'Pending',
    weight              NUMERIC(8,2),
    totalamount         NUMERIC(10,2) NOT NULL DEFAULT 0,
    staffid             INTEGER,
    recordstatus        VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT appointment_pk PRIMARY KEY (appointmentid, serviceid),
    CONSTRAINT appointment_cat_fk
        FOREIGN KEY (catid) REFERENCES cat(catid)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT appointment_service_fk
        FOREIGN KEY (serviceid) REFERENCES service(serviceid)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT appointment_staff_fk
        FOREIGN KEY (staffid) REFERENCES staff(staffid)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT appointment_status_ck
        CHECK (UPPER(appointmentstatus) IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT appointment_record_status_ck
        CHECK (UPPER(recordstatus) IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT appointment_weight_ck CHECK (weight IS NULL OR weight > 0),
    CONSTRAINT appointment_total_ck CHECK (totalamount >= 0)
);

ALTER SEQUENCE appointmentid_seq OWNED BY appointment.appointmentid;
CREATE INDEX appointment_cat_ix ON appointment(catid);
CREATE INDEX appointment_service_ix ON appointment(serviceid);
CREATE INDEX appointment_staff_ix ON appointment(staffid);
CREATE INDEX appointment_date_time_ix ON appointment(appointmentdate, appointmenttime);
CREATE INDEX appointment_status_ix ON appointment(appointmentstatus, recordstatus);

COMMIT;
