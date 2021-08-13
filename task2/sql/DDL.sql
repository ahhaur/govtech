
DROP TABLE IF EXISTS "car";
DROP SEQUENCE IF EXISTS car_car_id_seq;
CREATE SEQUENCE car_car_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."car" (
    "car_id" integer DEFAULT nextval('car_car_id_seq') NOT NULL,
    "manufacturer_id" smallint NOT NULL,
    "model_name" character varying(255) NOT NULL,
    "serial_number" character varying(100) NOT NULL,
    "weight" real NOT NULL,
    "price" real NOT NULL,
    CONSTRAINT "car_pkey" PRIMARY KEY ("car_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "customer";
DROP SEQUENCE IF EXISTS customer_customer_id_seq;
CREATE SEQUENCE customer_customer_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."customer" (
    "customer_id" integer DEFAULT nextval('customer_customer_id_seq') NOT NULL,
    "customer_name" character varying(255) NOT NULL,
    "customer_phone" character varying(30) NOT NULL,
    CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "manufacturer";
DROP SEQUENCE IF EXISTS manufacturer_manufacturer_id_seq;
CREATE SEQUENCE manufacturer_manufacturer_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 32767 CACHE 1;

CREATE TABLE "public"."manufacturer" (
    "manufacturer_id" smallint DEFAULT nextval('manufacturer_manufacturer_id_seq') NOT NULL,
    "manufacturer_name" character varying(255) NOT NULL,
    CONSTRAINT "manufacturer_pkey" PRIMARY KEY ("manufacturer_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "sales";
DROP SEQUENCE IF EXISTS sales_sales_id_seq;
CREATE SEQUENCE sales_sales_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."sales" (
    "sales_id" integer DEFAULT nextval('sales_sales_id_seq') NOT NULL,
    "salesperson_id" smallint NOT NULL,
    "car_id" integer NOT NULL,
    "customer_id" integer NOT NULL,
    "sales_datetime" timestamptz NOT NULL,
    CONSTRAINT "sales_pkey" PRIMARY KEY ("sales_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "salesperson";
DROP SEQUENCE IF EXISTS salesperson_salesperson_id_seq;
CREATE SEQUENCE salesperson_salesperson_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 32767 CACHE 1;

CREATE TABLE "public"."salesperson" (
    "salesperson_id" smallint DEFAULT nextval('salesperson_salesperson_id_seq') NOT NULL,
    "salesperson_name" character varying(255) NOT NULL,
    CONSTRAINT "salesperson_pkey" PRIMARY KEY ("salesperson_id")
) WITH (oids = false);

INSERT INTO "salesperson" ("salesperson_id", "salesperson_name") VALUES
(1,	'aa'),
(2,	'bbb'),
(3,	'bbbssss');

ALTER TABLE ONLY "public"."car" ADD CONSTRAINT "car_manufacturer_id_fkey" FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(manufacturer_id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."sales" ADD CONSTRAINT "sales_car_id_fkey1" FOREIGN KEY (car_id) REFERENCES car(car_id) NOT DEFERRABLE;
ALTER TABLE ONLY "public"."sales" ADD CONSTRAINT "sales_customer_id_fkey1" FOREIGN KEY (customer_id) REFERENCES customer(customer_id) NOT DEFERRABLE;
ALTER TABLE ONLY "public"."sales" ADD CONSTRAINT "sales_salesperson_id_fkey" FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id) NOT DEFERRABLE;
