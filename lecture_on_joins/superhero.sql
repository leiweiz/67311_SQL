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
-- Name: heroes; Type: TABLE; Schema: public; Owner: profh; Tablespace: 
--

CREATE TABLE heroes (
    hero_id integer NOT NULL,
    name character varying(50),
    power character varying(255),
    active boolean DEFAULT true
);


ALTER TABLE public.heroes OWNER TO profh;

--
-- Name: heroes_hero_id_seq; Type: SEQUENCE; Schema: public; Owner: profh
--

CREATE SEQUENCE heroes_hero_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.heroes_hero_id_seq OWNER TO profh;

--
-- Name: heroes_hero_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: profh
--

ALTER SEQUENCE heroes_hero_id_seq OWNED BY heroes.hero_id;


--
-- Name: heroes_hero_id_seq; Type: SEQUENCE SET; Schema: public; Owner: profh
--

SELECT pg_catalog.setval('heroes_hero_id_seq', 13, true);


--
-- Name: identities; Type: TABLE; Schema: public; Owner: profh; Tablespace: 
--

CREATE TABLE identities (
    hero_id integer NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE public.identities OWNER TO profh;

--
-- Name: people; Type: TABLE; Schema: public; Owner: profh; Tablespace: 
--

CREATE TABLE people (
    person_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    height integer,
    weight integer,
    is_male boolean,
    active boolean DEFAULT true
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

SELECT pg_catalog.setval('people_person_id_seq', 15, true);


--
-- Name: hero_id; Type: DEFAULT; Schema: public; Owner: profh
--

ALTER TABLE ONLY heroes ALTER COLUMN hero_id SET DEFAULT nextval('heroes_hero_id_seq'::regclass);


--
-- Name: person_id; Type: DEFAULT; Schema: public; Owner: profh
--

ALTER TABLE ONLY people ALTER COLUMN person_id SET DEFAULT nextval('people_person_id_seq'::regclass);


--
-- Data for Name: heroes; Type: TABLE DATA; Schema: public; Owner: profh
--

COPY heroes (hero_id, name, power, active) FROM stdin;
1	Batman	None - just totally awesome	t
2	Superman	flys; great strength; xray vision	t
3	Green Lantern	Power ring creates solid constructs based on will	t
4	Wolverine	Healing factor; adamantium skelton; retractable claws	t
5	Spiderman	Spider senses; web-slinging	t
6	Nightcrawler	Teleportation; superhuman agility	t
7	Wonder Woman	Enhanced strength; various weapons	t
8	Storm	Control of weather; flys	t
9	Shadowcat	Can phase between solid objects	t
10	Angel	Has wings; flys	t
11	Archangel	Has wings; flys; shoots projectiles from wings	t
12	Colossus	Superhuman strength; body can turn into solid metal	t
13	Aquaman	Breathes underwater; communicates with marine life	t
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: public; Owner: profh
--

COPY identities (hero_id, person_id) FROM stdin;
2	1
3	2
3	3
3	4
1	6
4	7
6	8
11	15
8	10
9	13
10	15
5	11
14	9
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: profh
--

COPY people (person_id, first_name, last_name, height, weight, is_male, active) FROM stdin;
1	Clark	Kent	76	225	t	t
2	Hal	Jordan	71	189	t	t
3	Guy	Gardner	72	194	t	t
4	Kyle	Rayner	73	209	t	t
5	Dick	Greyson	69	168	t	t
6	Bruce	Wayne	75	230	t	t
7	Logan	\N	68	195	t	t
8	Kurt	Wagner	68	165	t	t
9	Larry	Heimann	76	230	t	t
10	Ororo	Munroe	71	180	f	t
11	Peter	Parker	70	180	t	t
12	Anna Marie	\N	67	160	f	t
13	Kitty	Pryde	66	155	f	t
14	Elizabeth	Braddock	68	165	f	t
15	Warren	Worthington	72	190	t	t
\.


--
-- Name: heroes_pkey; Type: CONSTRAINT; Schema: public; Owner: profh; Tablespace: 
--

ALTER TABLE ONLY heroes
    ADD CONSTRAINT heroes_pkey PRIMARY KEY (hero_id);


--
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: profh; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (hero_id, person_id);


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

