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
CREATE SCHEMA IF NOT EXISTS u;
SET search_path TO u,public;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE IF NOT EXISTS u.log (
    id u64 NOT NULL,
    action u16 NOT NULL,
    uid u64 NOT NULL,
    val bytea DEFAULT '\x'::bytea NOT NULL,
    ctime u64 DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    client_id u64 NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS u.log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE u.log_id_seq OWNED BY u.log.id;
CREATE TABLE IF NOT EXISTS u.password (
    id u64 NOT NULL,
    hash md5hash NOT NULL,
    ctime u64 NOT NULL
);
CREATE SEQUENCE IF NOT EXISTS u.password_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE u.password_id_seq OWNED BY u.password.id;
CREATE SEQUENCE IF NOT EXISTS u.uid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY u.log ALTER COLUMN id SET DEFAULT nextval('u.log_id_seq'::regclass);
ALTER TABLE ONLY u.password ALTER COLUMN id SET DEFAULT nextval('u.password_id_seq'::regclass);
ALTER TABLE ONLY u.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);
ALTER TABLE ONLY u.password
    ADD CONSTRAINT password_pkey PRIMARY KEY (id);