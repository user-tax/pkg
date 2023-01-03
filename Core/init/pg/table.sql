SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;
COMMENT ON SCHEMA public IS 'standard public schema';
CREATE OR REPLACE FUNCTION client_new(client_id u64, ip bytea, browser_name character varying, browser_ver u32, os_name character varying, os_ver u32, device_vendor character varying, device_model character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  now u64;
browser_id u32;
os_id u32;
device_id u32;
BEGIN
  IF browser_name != '' THEN
    SELECT id INTO browser_id
    FROM browser
    WHERE name = browser_name
      AND ver = browser_ver;
IF browser_id IS NULL THEN
      INSERT INTO browser (name, ver)
        VALUES (browser_name, browser_ver)
      ON CONFLICT (name, ver)
        DO NOTHING
      RETURNING id INTO browser_id;
END IF;
ELSE
    browser_id = 0;
END IF;
IF os_name != '' THEN
    WITH e AS (
INSERT INTO os (name, ver)
        VALUES (os_name, os_ver)
      ON CONFLICT (name, ver)
        DO NOTHING
      RETURNING id)
      SELECT id INTO os_id
      FROM e
      UNION
      SELECT id
      FROM os
      WHERE name = os_name
          AND ver = os_ver;
ELSE
    os_id = 0;
END IF;
IF device_vendor != '' THEN
    WITH e AS (
INSERT INTO device (device_vendor, device_model)
        VALUES (device_vendor, device_model)
      ON CONFLICT (vendor, model)
        DO NOTHING
      RETURNING id)
      SELECT id INTO device_id
      FROM e
      UNION
      SELECT id
      FROM device
      WHERE vendor = device_vendor
          AND model = device_model;
ELSE
    device_id = 0;
END IF;
now = (date_part('epoch'::text, now()))::integer;
INSERT INTO client_ip (client_id, ip, ctime)
    VALUES (client_id, ip, now)
  ON CONFLICT
    DO NOTHING;
INSERT INTO client_meta (client_id, os_id, browser_id, device_id, ctime)
    VALUES (client_id, os_id, browser_id, device_id, now);
END;
$$;
CREATE OR REPLACE FUNCTION drop_func(_name text, OUT functions_dropped integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  _sql text;
BEGIN
  SELECT count(*)::int, 'drop function ' || string_agg(oid::regprocedure::text, ';
drop function ')
  FROM pg_catalog.pg_proc
  WHERE proname = _name
    AND pg_function_is_visible(oid) -- restrict to current search_path
    INTO functions_dropped, _sql;
IF functions_dropped > 0 THEN
    -- only if function(s) found
    EXECUTE _sql;
END IF;
END
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE IF NOT EXISTS browser (
    id u32 NOT NULL,
    name character varying(255) NOT NULL,
    ver u32 NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS browser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE browser_id_seq OWNED BY browser.id;
CREATE TABLE IF NOT EXISTS client_ip (
    id u64 NOT NULL,
    client_id u64 NOT NULL,
    ip bytea NOT NULL,
    ctime u64 DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS client_ip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE client_ip_id_seq OWNED BY client_ip.id;
CREATE TABLE IF NOT EXISTS client_meta (
    id u64 NOT NULL,
    device_id u32 NOT NULL,
    browser_id u32 NOT NULL,
    os_id u32 NOT NULL,
    client_id u64 NOT NULL,
    ctime u64 DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS client_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE client_meta_id_seq OWNED BY client_meta.id;
CREATE SEQUENCE IF NOT EXISTS device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE IF NOT EXISTS device (
    id u32 DEFAULT nextval('device_id_seq'::regclass) NOT NULL,
    vendor character varying(255) NOT NULL,
    model character varying(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS os (
    id u64 NOT NULL,
    name character varying(255) NOT NULL,
    ver u32 NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS os_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE os_id_seq OWNED BY os.id;
ALTER TABLE ONLY browser ALTER COLUMN id SET DEFAULT nextval('browser_id_seq'::regclass);
ALTER TABLE ONLY client_ip ALTER COLUMN id SET DEFAULT nextval('client_ip_id_seq'::regclass);
ALTER TABLE ONLY client_meta ALTER COLUMN id SET DEFAULT nextval('client_meta_id_seq'::regclass);
ALTER TABLE ONLY os ALTER COLUMN id SET DEFAULT nextval('os_id_seq'::regclass);
ALTER TABLE ONLY browser
    ADD CONSTRAINT "browser.name.ver" UNIQUE (name, ver);
ALTER TABLE ONLY browser
    ADD CONSTRAINT browser_pkey PRIMARY KEY (id);
ALTER TABLE ONLY client_ip
    ADD CONSTRAINT "client_ip.ctime" UNIQUE (ip, ctime);
ALTER TABLE ONLY client_ip
    ADD CONSTRAINT client_ip_pkey PRIMARY KEY (id);
ALTER TABLE ONLY client_meta
    ADD CONSTRAINT client_meta_pkey PRIMARY KEY (id);
ALTER TABLE ONLY device
    ADD CONSTRAINT "device.vendor.model" UNIQUE (vendor, model);
ALTER TABLE ONLY device
    ADD CONSTRAINT device_model_pkey PRIMARY KEY (id);
ALTER TABLE ONLY os
    ADD CONSTRAINT "os.name.ver" UNIQUE (name, ver);
ALTER TABLE ONLY os
    ADD CONSTRAINT os_pkey PRIMARY KEY (id);