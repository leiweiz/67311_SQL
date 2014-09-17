--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: people; Type: TABLE; Schema: public; Owner: profh; Tablespace: 
--

CREATE TABLE people (
    person_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    advisor_id integer
);


ALTER TABLE public.people OWNER TO profh;

--
-- Name: people_person_id_seq; Type: SEQUENCE; Schema: public; Owner: profh
--

CREATE SEQUENCE people_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.people_person_id_seq OWNER TO profh;

--
-- Name: people_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: profh
--

ALTER SEQUENCE people_person_id_seq OWNED BY people.person_id;


--
-- Name: people_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: profh
--

SELECT pg_catalog.setval('people_person_id_seq', 11, true);


--
-- Name: person_id; Type: DEFAULT; Schema: public; Owner: profh
--

ALTER TABLE ONLY people ALTER COLUMN person_id SET DEFAULT nextval('people_person_id_seq'::regclass);


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: profh
--

COPY people (person_id, first_name, last_name, advisor_id) FROM stdin;
1	Professor	Heimann	\N
2	Professor	Quesenberry	\N
3	Professor	Weinberg	\N
4	Seth	Vargo	1
5	Jocelyn	Kong	1
6	Nolan	Carroll	2
7	Jon	Tan	3
8	Lester	Xue	2
9	Derin	Akintilo	1
10	Anthony	Lorubbio	1
11	Stephanie	Falsone	2
\.


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: profh; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (person_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: profh
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM profh;
GRANT ALL ON SCHEMA public TO profh;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

