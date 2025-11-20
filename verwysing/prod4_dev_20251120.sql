--
-- PostgreSQL database dump
--

-- Dumped from database version 16.10
-- Dumped by pg_dump version 17.5

-- Started on 2025-11-20 12:04:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: azure_pg_admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO azure_pg_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24818)
-- Name: calendar; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.calendar (
    id integer NOT NULL,
    weekday integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.calendar OWNER TO myadmin;

--
-- TOC entry 216 (class 1259 OID 24821)
-- Name: calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.calendar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calendar_id_seq OWNER TO myadmin;

--
-- TOC entry 4285 (class 0 OID 0)
-- Dependencies: 216
-- Name: calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;


--
-- TOC entry 239 (class 1259 OID 24971)
-- Name: holidays; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.holidays (
    id integer NOT NULL,
    date date NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    resources jsonb
);


ALTER TABLE public.holidays OWNER TO myadmin;

--
-- TOC entry 238 (class 1259 OID 24970)
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.holidays_id_seq OWNER TO myadmin;

--
-- TOC entry 4286 (class 0 OID 0)
-- Dependencies: 238
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.holidays_id_seq OWNED BY public.holidays.id;


--
-- TOC entry 217 (class 1259 OID 24822)
-- Name: job; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.job (
    id integer NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255),
    order_date timestamp without time zone NOT NULL,
    promised_date timestamp without time zone NOT NULL,
    quantity integer NOT NULL,
    price_each double precision NOT NULL,
    customer character varying(100),
    completed boolean DEFAULT false NOT NULL,
    blocked boolean DEFAULT false NOT NULL
);


ALTER TABLE public.job OWNER TO myadmin;

--
-- TOC entry 218 (class 1259 OID 24827)
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_id_seq OWNER TO myadmin;

--
-- TOC entry 4287 (class 0 OID 0)
-- Dependencies: 218
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.job_id_seq OWNED BY public.job.id;


--
-- TOC entry 237 (class 1259 OID 24959)
-- Name: job_material; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.job_material (
    id integer NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) NOT NULL
);


ALTER TABLE public.job_material OWNER TO myadmin;

--
-- TOC entry 236 (class 1259 OID 24958)
-- Name: job_material_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.job_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_material_id_seq OWNER TO myadmin;

--
-- TOC entry 4288 (class 0 OID 0)
-- Dependencies: 236
-- Name: job_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.job_material_id_seq OWNED BY public.job_material.id;


--
-- TOC entry 219 (class 1259 OID 24828)
-- Name: material; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.material (
    id integer NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) NOT NULL
);


ALTER TABLE public.material OWNER TO myadmin;

--
-- TOC entry 220 (class 1259 OID 24831)
-- Name: material_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.material_id_seq OWNER TO myadmin;

--
-- TOC entry 4289 (class 0 OID 0)
-- Dependencies: 220
-- Name: material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.material_id_seq OWNED BY public.material.id;


--
-- TOC entry 221 (class 1259 OID 24832)
-- Name: resource; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.resource (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(1) NOT NULL
);


ALTER TABLE public.resource OWNER TO myadmin;

--
-- TOC entry 222 (class 1259 OID 24835)
-- Name: resource_group; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.resource_group (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(1) NOT NULL
);


ALTER TABLE public.resource_group OWNER TO myadmin;

--
-- TOC entry 223 (class 1259 OID 24838)
-- Name: resource_group_association; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.resource_group_association (
    resource_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.resource_group_association OWNER TO myadmin;

--
-- TOC entry 224 (class 1259 OID 24841)
-- Name: resource_group_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.resource_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_group_id_seq OWNER TO myadmin;

--
-- TOC entry 4290 (class 0 OID 0)
-- Dependencies: 224
-- Name: resource_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.resource_group_id_seq OWNED BY public.resource_group.id;


--
-- TOC entry 225 (class 1259 OID 24842)
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_id_seq OWNER TO myadmin;

--
-- TOC entry 4291 (class 0 OID 0)
-- Dependencies: 225
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;


--
-- TOC entry 226 (class 1259 OID 24843)
-- Name: schedule; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    resources_used character varying(255) NOT NULL
);


ALTER TABLE public.schedule OWNER TO myadmin;

--
-- TOC entry 227 (class 1259 OID 24846)
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_id_seq OWNER TO myadmin;

--
-- TOC entry 4292 (class 0 OID 0)
-- Dependencies: 227
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- TOC entry 228 (class 1259 OID 24847)
-- Name: task; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.task (
    id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255),
    setup_time double precision NOT NULL,
    time_each double precision NOT NULL,
    predecessors character varying(255),
    resources character varying(255) NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    completed_at timestamp without time zone,
    busy boolean DEFAULT false NOT NULL
);


ALTER TABLE public.task OWNER TO myadmin;

--
-- TOC entry 229 (class 1259 OID 24853)
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_id_seq OWNER TO myadmin;

--
-- TOC entry 4293 (class 0 OID 0)
-- Dependencies: 229
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- TOC entry 230 (class 1259 OID 24854)
-- Name: template; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.template (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    price_each real DEFAULT 0
);


ALTER TABLE public.template OWNER TO myadmin;

--
-- TOC entry 231 (class 1259 OID 24858)
-- Name: template_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_id_seq OWNER TO myadmin;

--
-- TOC entry 4294 (class 0 OID 0)
-- Dependencies: 231
-- Name: template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.template_id_seq OWNED BY public.template.id;


--
-- TOC entry 232 (class 1259 OID 24859)
-- Name: template_material; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.template_material (
    id integer NOT NULL,
    template_id integer NOT NULL,
    description character varying(255) NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) NOT NULL
);


ALTER TABLE public.template_material OWNER TO myadmin;

--
-- TOC entry 233 (class 1259 OID 24862)
-- Name: template_material_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.template_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_material_id_seq OWNER TO myadmin;

--
-- TOC entry 4295 (class 0 OID 0)
-- Dependencies: 233
-- Name: template_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.template_material_id_seq OWNED BY public.template_material.id;


--
-- TOC entry 234 (class 1259 OID 24863)
-- Name: template_task; Type: TABLE; Schema: public; Owner: myadmin
--

CREATE TABLE public.template_task (
    id integer NOT NULL,
    template_id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    description character varying(255),
    setup_time integer NOT NULL,
    time_each integer NOT NULL,
    predecessors character varying(255),
    resources character varying(255) NOT NULL
);


ALTER TABLE public.template_task OWNER TO myadmin;

--
-- TOC entry 235 (class 1259 OID 24868)
-- Name: template_task_id_seq; Type: SEQUENCE; Schema: public; Owner: myadmin
--

CREATE SEQUENCE public.template_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_task_id_seq OWNER TO myadmin;

--
-- TOC entry 4296 (class 0 OID 0)
-- Dependencies: 235
-- Name: template_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myadmin
--

ALTER SEQUENCE public.template_task_id_seq OWNED BY public.template_task.id;


--
-- TOC entry 3972 (class 2604 OID 24948)
-- Name: calendar id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);


--
-- TOC entry 3988 (class 2604 OID 24974)
-- Name: holidays id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.holidays ALTER COLUMN id SET DEFAULT nextval('public.holidays_id_seq'::regclass);


--
-- TOC entry 3973 (class 2604 OID 24949)
-- Name: job id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.job_id_seq'::regclass);


--
-- TOC entry 3987 (class 2604 OID 24962)
-- Name: job_material id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job_material ALTER COLUMN id SET DEFAULT nextval('public.job_material_id_seq'::regclass);


--
-- TOC entry 3976 (class 2604 OID 24950)
-- Name: material id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.material ALTER COLUMN id SET DEFAULT nextval('public.material_id_seq'::regclass);


--
-- TOC entry 3977 (class 2604 OID 24951)
-- Name: resource id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);


--
-- TOC entry 3978 (class 2604 OID 24952)
-- Name: resource_group id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group ALTER COLUMN id SET DEFAULT nextval('public.resource_group_id_seq'::regclass);


--
-- TOC entry 3979 (class 2604 OID 24953)
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- TOC entry 3980 (class 2604 OID 24954)
-- Name: task id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- TOC entry 3983 (class 2604 OID 24955)
-- Name: template id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template ALTER COLUMN id SET DEFAULT nextval('public.template_id_seq'::regclass);


--
-- TOC entry 3985 (class 2604 OID 24956)
-- Name: template_material id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_material ALTER COLUMN id SET DEFAULT nextval('public.template_material_id_seq'::regclass);


--
-- TOC entry 3986 (class 2604 OID 24957)
-- Name: template_task id; Type: DEFAULT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_task ALTER COLUMN id SET DEFAULT nextval('public.template_task_id_seq'::regclass);


--
-- TOC entry 4180 (class 0 OID 24818)
-- Dependencies: 215
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.calendar (id, weekday, start_time, end_time) FROM stdin;
6	6	00:00:00	00:00:00
5	5	07:00:00	13:00:00
4	4	07:00:00	16:00:00
3	3	07:00:00	16:00:00
2	2	07:00:00	16:00:00
1	1	07:00:00	16:00:00
7	7	00:00:00	00:00:00
\.


--
-- TOC entry 4204 (class 0 OID 24971)
-- Dependencies: 239
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.holidays (id, date, start_time, end_time, resources) FROM stdin;
\.


--
-- TOC entry 4182 (class 0 OID 24822)
-- Dependencies: 217
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.job (id, job_number, description, order_date, promised_date, quantity, price_each, customer, completed, blocked) FROM stdin;
1	24330	FIXED RAMP	2025-01-14 22:21:00	2025-03-14 09:30:00	1	141730	FRANS DU TOIT	t	f
3	24366	LARGE GATE	2025-02-14 08:00:00	2025-03-12 10:00:00	6	3691	PFG	t	f
6	24368	Anderson Fronts	2025-02-14 08:00:00	2025-03-12 10:00:00	8	1873	PFG	t	f
8	24371	IDC Fronts	2025-02-14 08:00:00	2025-03-12 10:00:00	8	1873	PFG	t	f
9	24385	Cantilver Raam	2025-02-20 08:00:00	2025-03-06 10:00:00	3	3780	Rackstar	t	f
10	24386	Carbide Bins	2025-02-21 08:00:00	2025-03-10 09:00:00	10	3473	Element 6	t	f
11	24388	Safety Cage	2025-02-27 08:00:00	2025-03-13 10:00:00	1	19430	ARROW	t	f
13	24392	Cullet Bins	2025-03-01 08:00:00	2025-03-20 10:00:00	3	27120	PFG	t	f
14	24393	Slider Flex Bracket (prototipe)	2025-03-01 08:00:00	2025-03-06 09:00:00	1	733	PFG	t	f
15	24397&8	Tafelblad 1670x650	2025-03-05 07:00:00	2025-03-11 19:38:00	2	1415	Rackstar	t	f
5	24369	Anderson A-raam	2025-02-14 00:00:00	2025-03-12 00:00:00	4	9624.35	PFG	t	f
7	24370	IDC A-raam	2025-02-14 00:00:00	2025-03-12 00:00:00	4	9624.35	PFG	t	f
76	25080	Sif Mandjies	2025-05-06 00:00:00	2025-05-14 00:00:00	20	150	THYS PRETORIUS	t	f
22	25007	Hek Stoppers	2025-03-12 00:00:00	2025-03-20 00:00:00	3	0	NIGEL METAL	t	f
29	25014	A-frame refurb	2025-03-14 00:00:00	2025-03-21 00:00:00	4	973	PFG	t	f
31	25016	880 Grab Refurbish	2025-03-14 00:00:00	2025-03-21 00:00:00	1	6505	PFG	t	f
66	25056	ESP Bin	2025-04-07 00:00:00	2025-04-29 00:00:00	1	49108	ARDAGH	t	f
55	25039	MEDIUM GATE	2025-04-08 00:00:00	2025-04-15 00:00:00	8	3634	PFG	t	f
79	25071	Ardagh Upright	2025-04-25 00:00:00	2025-05-26 00:00:00	20	2373	IDC	t	f
52	25042	Slider Flex T-nuts	2025-04-08 00:00:00	2025-04-15 00:00:00	50	87	PFG	t	f
64	25058	Tarp Protector Spring Replacement	2025-04-08 00:00:00	2025-04-15 00:00:00	3	78.7	PFG	t	f
67	25061	Wielpalet	2025-04-09 00:00:00	2025-04-25 00:00:00	2	1270	MAXION	t	f
68	25062	Boonste raam	2025-04-09 00:00:00	2025-04-25 00:00:00	2	670	MAXION	t	f
12	24389	MLR10	2025-03-03 08:00:00	2025-03-17 10:00:00	1	204069	EVEREST STEEL	t	f
16	25001	880 GRAB	2025-03-06 19:41:00	2025-03-12 17:00:00	1	16127.19	PFG	t	f
19	25004	Grab wassers (3mm)	2025-03-11 15:09:00	2025-03-18 15:09:00	30	19.73	PFG	t	f
20	25005	Grab wassers (4.5mm)	2025-03-11 15:32:00	2025-03-18 15:32:00	30	23	PFG	t	f
21	25006	Grab wassers (6mm)	2025-03-11 15:33:00	2025-03-18 15:33:00	30	27.3	PFG	t	f
23	25008	Drupplate (2450 seksie)	2025-03-12 16:14:00	2025-03-18 16:15:00	94	0	Estellae	t	f
24	25009	Cantilver Raam (modifikasie)	2025-03-12 16:36:00	2025-03-13 16:37:00	1	3430	Rackstar	t	f
32	25017	Step Ramp Huur	2025-03-17 18:19:00	2025-03-18 18:19:00	1	1575	Tamarin Bay Traders	t	f
33	25018	IPE Boog	2025-03-17 18:46:00	2025-03-20 18:46:00	1	0	Estellae	t	f
25	25010	Handrail Brackets	2025-03-13 16:38:00	2025-03-21 16:38:00	6	47	Caldas	t	f
26	25011	Rear Handrail	2025-03-13 17:23:00	2025-03-21 17:23:00	2	2373	Caldas	t	f
27	25012	Tarp Protector Bend Refurb	2025-03-14 17:31:00	2025-03-21 17:31:00	5	197	PFG	t	f
28	25013	Tarp Protector Spring Replacement	2025-03-14 17:34:00	2025-03-21 17:34:00	5	78.7	PFG	t	f
30	25015	Tarp Prot Straight Refurb	2025-03-14 17:56:00	2025-03-21 17:56:00	2	178	PFG	t	f
50	25036	IDC Fronts	2025-04-08 00:00:00	2025-04-15 00:00:00	12	1873	PFG	t	f
51	25043	PFG Fronts	2025-04-08 00:00:00	2025-04-15 00:00:00	15	1873	PFG	t	f
69	25064	MLR10	2025-04-14 00:00:00	2025-04-30 00:00:00	1	204069	TECHNICAL SYSTEMS	t	f
58	25044	LARGE GATE	2025-04-08 00:00:00	2025-04-15 00:00:00	7	3691	PFG	t	f
70	25065	Raam	2025-04-14 00:00:00	2025-04-15 00:00:00	1	7300	RACKSTAR	t	f
53	25037	IDC A-raam	2025-04-08 00:00:00	2025-04-15 00:00:00	6	9276	PFG	t	f
60	25048	DRUMLIFTER REFURBISH	2025-04-03 00:00:00	2025-04-22 00:00:00	2	3773	CLIVE TEUBES	t	f
83	25071(c)	Ardagh Upright	2025-04-25 00:00:00	2025-05-28 00:00:00	20	2373	IDC	t	f
56	25034	A-frame refurb	2025-04-08 00:00:00	2025-04-15 00:00:00	1	973	PFG	f	t
46	25025	HIGH JIB	2025-03-19 00:00:00	2025-04-11 00:00:00	1	23873	PFG	t	f
47	25031	915x610x610 BIN	2025-04-08 00:00:00	2025-04-15 00:00:00	10	3285.75	Salchain	t	f
54	25038	LARGE GATE	2025-04-08 00:00:00	2025-04-15 00:00:00	8	3691	PFG	t	f
63	25057	Tarp Protector Bend Refurb	2025-04-08 00:00:00	2025-04-15 00:00:00	5	197	PFG	t	f
2	24356	J800	2025-02-03 00:00:00	2025-03-10 00:00:00	1	19337	PRO PROCESS	t	f
44	25023	880 GRAB	2025-04-08 00:00:00	2025-04-15 00:00:00	1	16127.19	PFG	t	f
45	25024	880 GRAB	2025-04-08 00:00:00	2025-04-15 00:00:00	1	16127.19	PFG	t	f
59	25045	IDC A-raam	2025-04-08 00:00:00	2025-04-15 00:00:00	5	9624.35	PFG	t	f
61	25049	CUSTOM PALLET	2025-04-03 00:00:00	2025-04-17 00:00:00	11	873	MULTI PKG	t	f
62	25054	CR3	2025-04-04 00:00:00	2025-04-22 00:00:00	1	15730	Tamarin Bay Traders	t	f
65	25055	Galv Pallet	2025-04-07 00:00:00	2025-04-22 00:00:00	5	1725	TERRA PARTS	t	f
87	25098	1200x915x610 BIN	2025-05-20 00:00:00	2025-06-09 00:00:00	20	4099	Fedatech	t	f
57	25040	Small Gate	2025-04-08 00:00:00	2025-06-04 00:00:00	6	3088.9	PFG	t	f
74	25091	Drumlifter	2025-05-12 00:00:00	2025-05-30 00:00:00	2	1	NIGEL METAL INDUSTRIES	t	f
17	25002	Skudmasjien oordoen	2025-03-10 00:00:00	2025-04-07 00:00:00	1	0	ALTYDBO	t	f
73	25067	Drumlifter	2025-05-12 00:00:00	2025-05-19 00:00:00	1	10864.76	STRUB LUBRICANTS	t	f
80	25072	Ardagh Upright	2025-04-25 00:00:00	2025-06-03 00:00:00	50	2373	IDC	t	f
78	25091(W)	TRAPPIES	2025-05-13 00:00:00	2025-05-26 00:00:00	4	743	MAXION	t	f
72	25066	Drop Sides	2025-04-15 00:00:00	2025-05-16 00:00:00	4	1750	EDEN PROJECTS	t	f
82	25071(b)	Ardagh Upright	2025-04-25 00:00:00	2025-05-28 00:00:00	20	2373	IDC	t	f
84	25071(d)	Ardagh Upright	2025-04-25 00:00:00	2025-05-29 00:00:00	20	2373	IDC	t	f
86	25072(b)	Ardagh Upright	2025-04-25 00:00:00	2025-06-06 00:00:00	50	2373	IDC	t	f
85	25071(e)	Ardagh Upright	2025-04-25 00:00:00	2025-05-30 00:00:00	20	2373	IDC	t	f
75	25076	Drum Tilter	2025-05-05 00:00:00	2025-05-19 00:00:00	2	20500	APPLICATO GROUP	t	f
81	25073	Ardagh Upright	2025-04-25 00:00:00	2025-06-09 00:00:00	50	2373	IDC	t	f
49	25035	MLR10	2025-04-08 00:00:00	2025-04-15 00:00:00	1	0	NIGEL METAL INDUSTRIES	t	f
4	24367	Small Gate	2025-02-14 00:00:00	2025-06-04 00:00:00	4	3089	PFG	t	f
77	25082	MLR10	2025-05-12 00:00:00	2025-05-30 00:00:00	1	204069	AGRICO	t	f
18	25003	Nuwe Skudmasjien	2025-03-10 15:03:00	2025-04-14 15:03:00	1	0	ALTYDBO	t	f
118	23051	U-pallet mods	2023-06-20 00:00:00	2025-12-12 00:00:00	19	373	PFG	f	t
141	25184	False Rafters	2025-07-22 13:40:23.544389	2025-07-22 13:40:23.544389	6	0	EENDRACHT	t	f
142	25185	BASE PLATES	2025-07-22 13:42:38.035444	2025-07-25 00:00:00	20	157	PFG	t	f
131	25172	MLR10 Custom	2025-07-09 00:00:00	2025-07-28 00:00:00	1	15000	TECHNICAL SYSTEMS	t	f
160	25244	2030 Grab Refurbish	2025-09-10 00:00:00	2025-09-26 00:00:00	1	7093	PFG	t	f
149	25192	Upright Mod	2025-07-28 00:00:00	2025-08-06 00:00:00	50	150	LP Truck	t	f
89	25083	Stoor Hokke	2025-05-07 00:00:00	2025-05-29 00:00:00	4	9730	PFG	t	f
90	25097	Crate Support Arms	2025-05-23 00:00:00	2025-06-06 00:00:00	8	4780	PFG	t	f
99	25112	Crate Support Stand	2025-05-29 00:00:00	2025-05-30 00:00:00	1	3730	PFG	t	f
100	25113	3m Angle Guides	2025-05-29 00:00:00	2025-05-30 00:00:00	6	387	PFG	t	f
101	25114	1m Angle Guides	2025-05-28 00:00:00	2025-05-30 00:00:00	6	157	PFG	t	f
102	25115	Galvanised Strip	2025-05-29 00:00:00	2025-05-30 00:00:00	2	140	PFG	t	f
130	25171	Old Tarp Protector	2025-07-09 00:00:00	2025-07-31 00:00:00	10	1130	PFG	t	f
150	25193	Upright Mod	2025-07-28 00:00:00	2025-08-06 00:00:00	50	150	LP Truck	t	f
91	25100	Sliderflex Brackets	2025-05-21 00:00:00	2025-06-06 00:00:00	16	663	PFG	t	f
88	25096	880 Grab Refurbish	2025-05-20 00:00:00	2025-06-09 00:00:00	1	6505	PFG	t	f
105	25099	IMPACTOR	2025-05-20 00:00:00	2025-06-25 00:00:00	1	296000	Caldas	t	f
92	25101	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-02 00:00:00	16	663	PFG	t	f
93	25102	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-04 00:00:00	16	663	PFG	t	f
94	25103	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-06 00:00:00	16	663	PFG	t	f
95	25104	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-09 00:00:00	16	663	PFG	t	f
96	25105	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-12 00:00:00	16	663	PFG	t	f
97	25106	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-12 00:00:00	16	663	PFG	t	f
98	25107	Sliderflex Brackets	2025-05-28 00:00:00	2025-06-12 00:00:00	16	663	PFG	t	f
103	25109	IMPACTOR	2025-05-26 00:00:00	2025-06-27 00:00:00	1	296000	Caldas	t	f
106	25116	HYDROSWING DOOR	2025-05-28 00:00:00	2025-06-17 00:00:00	1	67730	Stab-A-Load	t	f
108	25119	Jumbo Grab	2025-06-02 00:00:00	2025-06-18 00:00:00	1	24783	PFG	f	t
109	25120	TRESTLES	2025-06-02 00:00:00	2025-06-06 00:00:00	6	13659	John Deere	t	f
110	25121	AIF TANK	2025-06-03 00:00:00	2025-06-23 00:00:00	1	54930	Radian	t	f
111	25125	VLAGPAAL	2025-06-09 00:00:00	2025-06-17 00:00:00	14	250	Rackstar	t	f
122	25169	N-Pallet Bottoms	2025-07-09 00:00:00	2025-07-24 00:00:00	40	690	PFG	t	f
151	25194	Upright Mod	2025-07-28 00:00:00	2025-08-06 00:00:00	50	150	LP Truck	t	f
116	25122	Trollies Modifiseer	2025-06-04 00:00:00	2025-08-29 00:00:00	1	9470	John Deere	f	t
148	25196	ESP Bin	2025-07-29 00:00:00	2025-08-28 00:00:00	1	48419	ARDAGH	t	f
121	25154	N-Pallet Bottoms	2025-06-30 00:00:00	2025-07-24 00:00:00	40	690	PFG	t	f
134	25175	ALUMINIUM LEER	2025-07-11 00:00:00	2025-07-31 00:00:00	9	4937	IDC	t	f
138	25179	Rubberize HD Pallet	2025-07-16 00:00:00	2025-07-31 00:00:00	60	168	Rackstar	t	f
135	25176	LADDER BRACKTS	2025-07-11 00:00:00	2025-07-31 00:00:00	9	1973	IDC	t	f
136	25177	PADLOCKS	2025-07-11 00:00:00	2025-07-31 00:00:00	18	230	IDC	t	f
152	25199	Drumlifter	2025-07-30 00:00:00	2025-08-15 00:00:00	1	12364.76	G-chem	t	f
157	25238(a)	MLR10	2025-09-05 00:00:00	2025-10-24 00:00:00	1	204730	ATLANTIS	t	f
126	25170	N-Pallet Backs	2025-06-30 00:00:00	2025-07-24 00:00:00	60	437	PFG	t	f
155	25221	TARP HOLDER BASE	2025-08-18 00:00:00	2025-09-19 00:00:00	16	1320	PFG	t	f
144	25195	Hot end bin	2025-07-29 00:00:00	2025-08-28 00:00:00	2	34730	Ardagh	t	f
137	25178	Rubberize SSP	2025-07-16 00:00:00	2025-07-31 00:00:00	60	232	Rackstar	t	f
112	25111	DL2	2025-06-12 00:00:00	2025-06-13 00:00:00	2	0	NIGEL METAL INDUSTRIES	t	f
125	25155	N-Pallet Backs	2025-06-30 00:00:00	2025-07-24 00:00:00	60	437	PFG	t	f
113	25124	Rubber Pallet	2025-06-09 00:00:00	2025-06-17 00:00:00	1	2637	Rackstar	t	f
128	25160	ESP Bin	2025-04-07 00:00:00	2025-04-29 00:00:00	2	48419	ARDAGH	t	f
161	25248	CJ12566	2025-09-11 00:00:00	2025-09-26 00:00:00	7	285.74	JOHN DEERE	t	f
129	25165	915x915x457 BIN	2025-07-04 00:00:00	2025-07-25 00:00:00	5	4556.92	Lee's Dozers	t	f
143	25187	DOWN PIPE GUARDS	2025-07-24 00:00:00	2025-08-14 00:00:00	6	3970	PFG	t	f
123	25180	N-Pallet Bottoms	2025-07-17 00:00:00	2025-07-31 00:00:00	40	690	PFG	t	f
119	24183	E-pallet Extensions	2024-08-20 00:00:00	2025-12-12 00:00:00	50	924.29	PFG	f	t
132	25173	880 Grab Refurbish	2025-07-09 00:00:00	2025-07-31 00:00:00	1	6505	PFG	t	f
133	25174	RUBBER STRIPS	2025-07-09 00:00:00	2025-07-24 00:00:00	3	840	PFG	t	f
156	25237	AFDAKKE	2025-09-01 00:00:00	2025-09-22 00:00:00	1	497750	ESTELLAE	t	f
140	25183	Rafters	2025-07-22 12:44:23.414008	2025-07-22 12:44:23.414008	12	0	Eendracht	t	f
139	25182	CJ15761	2025-07-17 00:00:00	2025-07-31 00:00:00	12	458.13	John Deere	t	f
145	25188	N-Pallet Bottoms	2025-07-24 00:00:00	2025-08-08 00:00:00	40	690	PFG	t	f
146	25189	N-Pallet Backs	2025-07-24 00:00:00	2025-08-08 00:00:00	60	437	PFG	t	f
147	25190	IMPACTOR	2025-07-28 00:00:00	2025-08-29 00:00:00	1	296000	Caldas	t	f
124	25143	Drumlifter	2025-05-12 00:00:00	2025-05-30 00:00:00	2	0	NIGEL METAL INDUSTRIES	t	f
127	25181	N-Pallet Backs	2025-06-30 00:00:00	2025-07-31 00:00:00	60	437	PFG	t	f
104	25110	JAW SKID	2025-05-26 00:00:00	2025-07-11 00:00:00	1	279000	Caldas	t	f
159	25241	SP2 Locators	2025-09-08 00:00:00	2025-09-19 00:00:00	6	6973	PFG	t	f
158	25238(b)	PLATFORM	2025-09-05 00:00:00	2025-10-24 00:00:00	1	291599	ATLANTIS	t	f
164	25253	8mm STAANDERS	2025-09-16 20:03:46.052687	2025-09-22 00:00:00	200	0	Altydbo	t	f
162	25249	CJ12566	2025-09-11 00:00:00	2025-09-26 00:00:00	2	285.74	JOHN DEERE	t	f
163	25250	CJ16544	2025-09-11 00:00:00	2025-09-26 00:00:00	16	303.41	JOHN DEERE	t	f
165	25254	SORTING PALLET MODS	2025-09-16 20:05:21.61196	2025-09-19 00:00:00	1	0	PFG	t	f
154	25220	TARP PROTECTOR HOLDER POST	2025-08-18 00:00:00	2025-09-19 00:00:00	16	1337	PFG	t	f
153	25217	PAAL	2025-08-07 00:00:00	2025-09-15 00:00:00	1	40096.87	Applicato	t	f
166	25228(b)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	30	280	PFG	f	f
167	25228(c)	Fronts Verkort	2025-08-18 00:00:00	2025-11-28 00:00:00	15	280	PFG	f	t
168	25229(a)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	30	280	PFG	f	t
169	25229(b)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	15	280	PFG	f	t
172	25230(a)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	30	280	PFG	f	t
170	25230(b)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	15	280	PFG	f	t
173	25231(a)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	30	280	PFG	f	t
171	25231(b)	Fronts Verkort	2025-08-18 00:00:00	2025-11-21 00:00:00	15	280	PFG	f	t
179	25308	TRANSFORMER TANK	2025-11-10 00:00:00	2025-11-26 00:00:00	1	31730	CASTLET	f	f
180	25309	YOKE BOX	2025-11-10 00:00:00	2025-11-26 00:00:00	2	450	CASTLET	f	f
174	25273	MLR10	2025-04-08 00:00:00	2025-04-15 00:00:00	1	0	NIGEL METAL INDUSTRIES	f	t
176	25294	MLR7	2025-10-29 00:00:00	2025-11-19 00:00:00	1	210730	CORICRAFT	f	f
175	25293	4-WAY ENTRY PALLETS	2025-10-27 00:00:00	2025-12-01 00:00:00	50	1280	CRYSTAL CANDY	f	f
178	25306	MLR10	2025-10-28 00:00:00	2025-11-24 00:00:00	1	209730	CATALYST X	f	f
177	25295	MLR7	2025-10-28 00:00:00	2025-11-26 00:00:00	1	194730	TAKE5	f	f
\.


--
-- TOC entry 4202 (class 0 OID 24959)
-- Dependencies: 237
-- Data for Name: job_material; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.job_material (id, job_number, description, quantity, unit) FROM stdin;
\.


--
-- TOC entry 4184 (class 0 OID 24828)
-- Dependencies: 219
-- Data for Name: material; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.material (id, job_number, description, quantity, unit) FROM stdin;
3	25005	4.5mm Plaat	0.1	2500x1200
4	25007	3mm / 4.5mm / 6mm	3	off-cut soos nodig
6	25010	6mm Plaat	0.1	2500x1200
9	25013	Veer	5	elk
10	25013	M10 spring washer	5	elk
11	25013	10mm Rond	250	mm
12	25006	6mm Plaat	0.1	2500x1200
13	25008	1mm Galv Plaat	14	2450
16	25004	3mm Plaat	0.1	2450x1225
59	25048	DL Heliks vere	4	elk
60	25048	DL Plaat vere	4	elk
61	25048	Boute & Moere	2	kyk op DL2 P.Plan vir details
62	25058	Veer	5	elk
63	25058	M10 spring washer	5	elk
64	25058	10mm Rond	250	mm
65	25071(b)	3mm PL	1	2450x1225
\.


--
-- TOC entry 4186 (class 0 OID 24832)
-- Dependencies: 221
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.resource (id, name, type) FROM stdin;
1	Andrew	H
2	Gert	H
3	James	H
7	Pieter	H
9	Thys	H
10	Vince	H
11	Wikus	H
12	Boor1	M
13	Boor2	M
14	Cincinatti	M
15	Cupgun	M
16	Groot_guillotine	M
17	Hamburger	M
18	Klein_buig	M
19	Klein_guillotine	M
20	Magboor	M
21	Promecam	M
22	Saag1	M
23	Saag2	M
25	Verflyn	M
26	Renier	H
31	Ethan	H
34	DJ	H
8	Quintin	H
36	JP	H
37	Smiley	H
\.


--
-- TOC entry 4187 (class 0 OID 24835)
-- Dependencies: 222
-- Data for Name: resource_group; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.resource_group (id, name, type) FROM stdin;
3	Verf	H
4	Saag	M
5	HSaag	H
7	Boor	M
8	HBoor	H
17	Moeilik	H
18	Maklik	H
20	HBuig	H
1	Sweis	H
19	BouG	H
6	Grind	H
2	Handlanger	H
14	BouK	H
\.


--
-- TOC entry 4188 (class 0 OID 24838)
-- Dependencies: 223
-- Data for Name: resource_group_association; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.resource_group_association (resource_id, group_id) FROM stdin;
7	3
8	3
22	4
23	4
1	5
2	5
3	5
9	5
10	5
11	5
2	19
3	19
12	7
13	7
2	8
3	8
10	8
11	8
9	19
11	19
34	6
31	6
3	6
36	6
7	6
8	6
26	6
37	6
9	6
10	6
1	2
34	2
3	2
7	2
8	2
26	2
9	2
10	2
2	17
11	17
2	18
3	18
9	18
10	18
11	18
1	14
34	14
2	14
3	14
7	14
26	14
9	14
10	14
11	14
1	20
2	20
3	20
9	20
10	20
11	20
1	1
2	1
3	1
9	1
10	1
\.


--
-- TOC entry 4191 (class 0 OID 24843)
-- Dependencies: 226
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.schedule (id, task_number, start_time, end_time, resources_used) FROM stdin;
12045	25308-2	2025-11-20 13:45:00	2025-11-20 14:15:00	Vince
12046	25309-2	2025-11-21 07:30:00	2025-11-21 08:30:00	Smiley
12047	25309-3	2025-11-20 15:30:00	2025-11-21 07:30:00	James, Wikus
12048	25309-1	2025-11-20 14:10:00	2025-11-20 15:30:00	Gert, Thys
12049	25228(b)-1	2025-11-20 07:01:00	2025-11-20 07:41:00	Vince, Saag2
12050	25293-10	2025-11-20 13:25:00	2025-11-20 15:15:00	Groot_guillotine, Quintin, Wikus
12051	25293-11	2025-11-25 08:31:00	2025-11-25 12:42:00	Renier, James
12052	25228(b)-2	2025-11-20 13:45:00	2025-11-20 14:10:00	Gert
12053	25228(b)-3	2025-11-20 14:10:00	2025-11-20 14:35:00	Andrew, Klein_buig
12054	25293-12	2025-11-25 12:42:00	2025-11-26 09:33:00	Andrew
12055	25228(b)-4	2025-11-20 14:35:00	2025-11-21 07:15:00	Vince, Andrew
12056	25228(b)-5	2025-11-21 07:15:00	2025-11-21 09:46:00	Renier
12057	25228(b)-6	2025-11-21 09:46:00	2025-11-21 12:21:00	Pieter, Cupgun
12058	25293-9	2025-11-27 08:54:00	2025-11-28 12:25:00	Pieter, Quintin
12059	25293-8	2025-11-26 09:33:00	2025-11-27 08:54:00	JP, Quintin, James
12060	25293-4	2025-11-20 13:25:00	2025-11-20 15:20:00	James, DJ
12061	25293-5	2025-11-20 10:40:00	2025-11-20 13:25:00	James, DJ
12062	25293-6	2025-11-20 15:30:00	2025-11-24 09:10:00	Gert, DJ
12063	25293-7	2025-11-24 09:10:00	2025-11-25 08:31:00	Andrew, Vince
12064	25293-3	2025-11-20 10:40:00	2025-11-20 13:15:00	Gert, Andrew
12065	25293-2	2025-11-20 08:50:00	2025-11-20 10:40:00	Gert, DJ, Groot_guillotine
12066	25293-1	2025-11-20 07:01:00	2025-11-20 08:51:00	Gert, Thys, Groot_guillotine
12067	25295-600	2025-11-20 15:50:00	2025-11-24 09:40:00	Quintin, Verflyn
12068	25295-500	2025-11-20 07:01:00	2025-11-20 08:02:00	Wikus
12069	25306-600	2025-11-20 07:01:00	2025-11-20 15:51:00	Pieter, Verflyn
12070	25308-1	2025-11-20 13:15:00	2025-11-20 13:45:00	Gert, Thys
\.


--
-- TOC entry 4193 (class 0 OID 24847)
-- Dependencies: 228
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.task (id, task_number, job_number, description, setup_time, time_each, predecessors, resources, completed, completed_at, busy) FROM stdin;
1	24330-500	24330	Verf	1	180	nan	Pieter, Quinton	t	\N	f
22	24366-10	24366	Saag tubing	5	5	nan	Saag, HSaag	t	\N	f
23	24366-20	24366	Saag round bars	1	2	nan	Saag, HSaag	t	\N	f
24	24366-30	24366	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t	\N	f
25	24366-100	24366	Boor tubing	5	8	24366-10	Boor, HBoor	t	\N	f
27	24366-300	24366	Sweis hekkie	1	30	24366-200	Sweis	t	\N	f
28	24366-400	24366	Grind hekkie	1	30	24366-300	Grind	t	\N	f
29	24366-500	24366	Verf hekkie	1	10	24366-400	Verf	t	\N	f
30	24366-600	24366	Plak rubber	1	10	24366-500	Quinton	t	\N	f
40	24368-10	24368	Saag tubing	5	2	nan	Saag, HSaag	t	\N	f
41	24368-20	24368	Saag pypies	5	5	nan	Saag, HSaag	t	\N	f
42	24368-30	24368	Sny plaatparte	5	5	nan	Gert	t	\N	f
43	24368-100	24368	Bou front	10	5	24368-10, 24368-20, 24368-30	Wikus	t	\N	f
44	24368-200	24368	Sweis front	1	20	24368-100	Sweis	t	\N	f
45	24368-300	24368	Grind front	1	10	24368-200	Grind	t	\N	f
46	24368-400	24368	Verf front	1	10	24368-300	Verf	t	\N	f
47	24368-500	24368	Plak rubber	1	3	24368-400	Quinton	t	\N	f
48	24371-10	24371	Saag tubing	5	2	nan	Saag, HSaag	t	\N	f
49	24371-20	24371	Saag pypies	5	5	nan	Saag, HSaag	t	\N	f
50	24371-30	24371	Sny plaatparte	5	5	nan	Gert	t	\N	f
51	24371-100	24371	Bou front	10	5	24371-10, 24371-20, 24371-30	Wikus	t	\N	f
52	24371-200	24371	Sweis front	1	20	24371-100	Sweis	t	\N	f
53	24371-300	24371	Grind front	1	10	24371-200	Grind	t	\N	f
54	24371-400	24371	Verf front	1	10	24371-300	Verf	t	\N	f
55	24371-500	24371	Plak rubber	1	3	24371-400	Quinton	t	\N	f
58	24369-30	24369	Sny plaatparte	5	5	nan	Gert	t	\N	f
69	24370-30	24370	Sny plaatparte	5	5	nan	Gert	t	\N	f
56	24369-10	24369	Saag channels	5	5	nan	Saag,HSaag	t	\N	f
57	24369-20	24369	Saag tubing	5	10	nan	Saag,HSaag	t	\N	f
59	24369-40	24369	Saag pyp	1	2	nan	Saag,HSaag	t	\N	f
78	24385-10	24385	Saag tubing	10	30	nan	Saag, HSaag	t	\N	f
79	24385-20	24385	Sny plaatparte	5	15	nan	Gert	t	\N	f
81	24385-200	24385	Sweis raam	1	30	24385-100	Sweis	t	\N	f
82	24385-300	24385	Grind raam	1	15	24385-200	Grind	t	\N	f
3	24356-20	24356	Sny body	10	10	nan	Gert	t	\N	f
34	24367-100	24367	Boor tubing	5	8	24367-10	Boor,HBoor	t	\N	f
36	24367-300	24367	Sweis hekkie	1	30	24367-200	Sweis	t	\N	f
60	24369-110	24369	Plasma channels	5	8	24369-10	Wikus, Thys	t	\N	f
61	24369-120	24369	Buig plaatparte	10	2	24369-30	Gert, Andrew	t	\N	f
62	24369-200	24369	Bou in jig	10	30	24369-20, 24369-40, 24369-110, 24369-120	Wikus, Vince	t	\N	f
71	24370-110	24370	Plasma channels	5	8	24370-10	Wikus, Vince	t	\N	f
74	24370-300	24370	Sweis A-raam	1	30	24370-200	Sweis, Andrew	t	\N	f
9	24356-110	24356	Sweis body	1	45	24356-100	Sweis	t	\N	f
14	24356-230	24356	Draai bullets	10	20	24356-220	Quinton	t	\N	f
19	24356-310	24356	Sweis bin	1	60	24356-300	Sweis	t	\N	f
5	24356-60	24356	Sny en buig channels	5	15	nan	Gert	t	\N	f
26	24366-200	24366	Bou hekkie	10	30	24366-20, 24366-30, 24366-100	Wikus	t	\N	f
80	24385-100	24385	Bou raam	45	15	24385-10, 24385-20	Wikus	t	\N	f
64	24369-400	24369	Grind A-raam	1	15	24369-300	Grind, Fernando, Dean	t	\N	f
65	24369-500	24369	Verf A-raam	1	20	24369-400	Pieter, Quinton	t	\N	f
73	24370-200	24370	Bou in jig	10	30	24370-20, 24370-40, 24370-110, 24370-120	Wikus, James	t	\N	f
75	24370-400	24370	Grind A-raam	1	15	24370-300	Grind, Fernando, Dean	t	\N	f
76	24370-500	24370	Verf A-raam	1	20	24370-400	Pieter, Quinton	t	\N	f
77	24370-600	24370	Plak rubber	1	15	24370-500	Quinton	t	\N	f
4	24356-50	24356	Buig body	15	10	24356-20	Gert, Andrew	t	\N	f
6	24356-70	24356	Sny 10mm parte	5	10	nan	Gert	t	\N	f
7	24356-80	24356	Buig en boor spore	10	30	24356-70	Wikus	t	\N	f
8	24356-100	24356	Bou body	10	40	24356-10, 24356-50, 24356-60	Gert, Fernando	t	\N	f
10	24356-120	24356	Grind body	1	30	24356-110	Grind	t	\N	f
11	24356-200	24356	Sny pockets	5	10	nan	Gert	t	\N	f
12	24356-210	24356	Buig pockets	10	2	24356-200	Gert, Fernando	t	\N	f
15	24356-250	24356	Bou pockets	1	15	24356-210, 24356-230	Gert	t	\N	f
16	24356-260	24356	Sweis pockets	1	25	24356-250	Sweis	t	\N	f
17	24356-270	24356	Grind pockets	1	15	24356-260	Grind	t	\N	f
18	24356-300	24356	Bou bin	10	45	24356-120, 24356-270	Wikus, Dean	t	\N	f
20	24356-400	24356	Grind bin	1	30	24356-310	Grind	t	\N	f
384	25023-9	25023	Verf	10	60	25023-8	Pieter,Quinton	t	\N	f
379	25023-4	25023	Sweis raam	1	60	25023-3	Andrew	t	\N	f
21	24356-500	24356	Verf bin	1	180	24356-400	Pieter, Quinton	t	\N	f
386	25023-11	25023	Maak grab klaar	1	45	25023-10	Quinton	t	\N	f
31	24367-10	24367	Saag tubing	5	5	nan	Saag,HSaag	t	\N	f
376	25023-1	25023	Saag raam	10	30		Saag, HSaag	t	\N	f
37	24367-400	24367	Grind hekkie	1	30	24367-300	Grind	t	\N	f
38	24367-500	24367	Verf hekkie	1	10	24367-400	Verf	t	\N	f
39	24367-600	24367	Plak rubber	1	10	24367-500	Quinton	t	\N	f
83	24385-400	24385	Verf raam	1	30	24385-300	Verf	t	\N	f
87	24386-100	24386	Saag bene	5	5	nan	Saag, HSaag	t	\N	f
88	24386-200	24386	Sny voete plate	5	2	nan	Groot_guillotine, Quinton	t	\N	f
89	24386-210	24386	Press voete	30	1	24386-200	Quinton	t	\N	f
91	24386-400	24386	Sweis bins	1	20	24386-300	Sweis, Andrew	t	\N	f
92	24386-500	24386	Grind bins	1	15	24386-400	Grind, Fernando, Dean	t	\N	f
93	24386-600	24386	Verf bins	1	30	24386-500	Pieter	t	\N	f
98	24388-200	24388	Sweis cage	1	90	24388-100, 24388-30	Sweis	t	\N	f
99	24388-300	24388	Grind cage	1	60	24388-200	Grind, Fernando, Dean	t	\N	f
100	24388-400	24388	Verf cage	1	90	24388-300	Pieter	t	\N	f
102	24389-11	24389	Grind plasma tubes	1	180	24389-10	Grind, Fernando, Dean	t	\N	f
103	24389-12	24389	Sny plaatparte	10	45	nan	Gert	t	\N	f
106	24389-40	24389	Sweis ribbes	1	300	24389-30	Sweis, Andrew	t	\N	f
107	24389-50	24389	Grind ribbes	1	180	24389-40	Grind, Fernando, Dean	t	\N	f
109	24389-200	24389	Sweis raam	1	300	24389-100	Sweis, Andrew	t	\N	f
113	24389-420	24389	Sweis flappe	1	30	24389-400	Sweis	t	\N	f
114	24389-430	24389	Sweis onderstel	1	20	24389-410	Sweis	t	\N	f
962	25110-15	25110	Bou feedbox	1	120	25110-2, 25110-4	Wikus, Handlanger	t	\N	f
117	24392-10	24392	Sny kante	10	20	nan	Gert	t	\N	f
118	24392-20	24392	Sny body	10	10	nan	Gert	t	\N	f
120	24392-60	24392	Sny en buig channels	5	15	nan	Gert	t	\N	f
121	24392-70	24392	Sny 10mm parte	5	10	nan	Gert	t	\N	f
122	24392-80	24392	Buig en boor spore	10	30	24392-70	Wikus	t	\N	f
124	24392-110	24392	Sweis body	1	45	24392-100	Sweis	t	\N	f
125	24392-120	24392	Grind body	1	30	24392-110	Grind	t	\N	f
126	24392-200	24392	Sny pockets	5	10	nan	Gert	t	\N	f
128	24392-220	24392	Saag bullets	1	5	nan	Saag, HSaag	t	\N	f
129	24392-230	24392	Draai bullets	10	20	24392-220	Quinton	t	\N	f
130	24392-250	24392	Bou pockets	1	15	24392-210, 24392-230	Gert	t	\N	f
131	24392-260	24392	Sweis pockets	1	25	24392-250	Sweis	t	\N	f
132	24392-270	24392	Grind pockets	1	15	24392-260	Grind	t	\N	f
134	24392-310	24392	Sweis bin	1	60	24392-300	Sweis	t	\N	f
135	24392-400	24392	Grind bin	1	30	24392-310	Grind	t	\N	f
136	24392-500	24392	Verf bin	1	120	24392-400	Pieter	t	\N	f
137	24393-10	24393	Saag EA	1	10	nan	Saag, HSaag	t	\N	f
138	24393-20	24393	Saag pyp	1	2	nan	Saag, HSaag	t	\N	f
139	24393-30	24393	Sny plaatparte	5	5	nan	Gert	t	\N	f
141	24393-110	24393	Sweis T-nuts	1	3	24393-100	Sweis	t	\N	f
143	24393-210	24393	Sweis bracket	1	3	24393-200	Sweis	t	\N	f
144	24393-300	24393	Grind	1	10	24393-110, 24393-210	Grind	t	\N	f
145	24393-400	24393	Verf	1	5	24393-300	Pieter	t	\N	f
146	24397-10	24397&8	Plasma	5	5		Gert	t	\N	f
148	25001-1	25001	Saag raam	10	30		Saag, HSaag	t	\N	f
149	25001-2	25001	Plasma	1	15		Gert	t	\N	f
150	25001-3	25001	Bou raam	10	90	25001-1, 25001-2	Wikus, Vince	t	\N	f
151	25001-4	25001	Sweis raam	1	60	25001-3	Andrew	t	\N	f
152	25001-5	25001	Saag los parte	5	30		Saag, HSaag	t	\N	f
153	25001-6	25001	Sit los parte op	1	60	25001-4, 25001-5	Wikus, Vince	t	\N	f
154	25001-7	25001	Sweis grab volledig	1	30	25001-6	Sweis	t	\N	f
155	25001-8	25001	Grind	1	30	25001-7	Dean, Grind	t	\N	f
156	25001-9	25001	Verf	10	60	25001-8	Quinton, Pieter	t	\N	f
159	25002-1	25002	Strip	1	60		James	t	\N	f
157	25001-10	25001	Plak rubber	1	20	25001-9	Quinton	t	\N	f
158	25001-11	25001	Maak grab klaar	1	45	25001-10	Quinton, Pieter	t	\N	f
84	24386-10	24386	Sny plaatparte	5	15	nan	Groot_guillotine, Gert	t	\N	f
108	24389-100	24389	Bou raam	45	360	24389-50	Wikus	t	\N	f
110	24389-300	24389	Sit grating op	1	180	24389-200	Wikus	t	\N	f
111	24389-400	24389	Bou flappe	10	120	24389-12	Gert	t	\N	f
112	24389-410	24389	Bou onderstel	15	60	24389-20	Gert	t	\N	f
115	24389-500	24389	Sit raam aanmekaar	1	60	24389-300, 24389-420, 24389-430	Wikus	t	\N	f
119	24392-50	24392	Buig body	15	10	24392-20	Gert, Andrew	t	\N	f
123	24392-100	24392	Bou body	10	40	24392-10, 24392-50, 24392-60	Gert	t	\N	f
127	24392-210	24392	Buig pockets	10	2	24392-200	Gert	t	\N	f
133	24392-300	24392	Bou bin	10	45	24392-120, 24392-270	Wikus	t	\N	f
140	24393-100	24393	Bou T-nuts	10	2	24393-30	Wikus	t	\N	f
142	24393-200	24393	Bou bracket	10	4	24393-10, 24393-20, 24393-30	Wikus	t	\N	f
161	25002-3	25002	Deurgaan en regmaak	1	180	25002-2	Wikus, James	t	\N	f
382	25023-7	25023	Sweis grab volledig	1	30	25023-6	Sweis	t	\N	f
380	25023-5	25023	Saag los parte	5	30		Saag, HSaag	t	\N	f
396	25024-3	25024	Bou raam	10	90	25024-1, 25024-2	Wikus, Vince	t	\N	f
389	25024-6	25024	Sit los parte op	1	60	25024-4, 25024-5	Wikus, Vince	t	\N	f
390	25024-9	25024	Verf	10	60	25024-8	Quinton, Pieter	t	\N	f
394	25024-7	25024	Sweis grab volledig	1	30	25024-6	Sweis	t	\N	f
395	25024-10	25024	Plak rubber	1	20	25024-9	Quinton	t	\N	f
385	25023-10	25023	Plak rubber	1	20	25023-9	Quinton	t	\N	f
391	25024-11	25024	Maak grab klaar	1	45	25024-10	Quinton, Pieter	t	\N	f
401	25025-1	25025	Saag parte	15	60		HSaag	t	\N	f
377	25023-2	25023	Plasma	1	15		Gert	t	\N	f
171	25004-1	25004	Plasma	1	1		Gert	t	\N	f
174	25005-1	25005	Plasma	1	1		Gert	t	\N	f
173	25004-3	25004	Verf	1	1	25004-2	Cupgun,Verf	t	\N	f
175	25005-2	25005	Grind	1	1	25005-1	Grind	t	\N	f
216	25006-1	25006	Plasma	1	1		Gert	t	\N	f
217	25006-2	25006	Grind	1	1	25006-1	Grind	t	\N	f
219	25008-1	25008	Sny plaat	5	0.5		Gert	t	\N	f
67	24370-10	24370	Saag channels	5	5	nan	Saag,HSaag	t	\N	f
70	24370-40	24370	Saag pyp	1	2	nan	Saag,HSaag	t	\N	f
63	24369-300	24369	Sweis A-raam	1	30	24369-200	Sweis, Andrew	t	\N	f
104	24389-20	24389	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
32	24367-20	24367	Saag round bars	1	2	nan	Saag,HSaag	t	\N	f
116	24389-600	24389	Verf raam	20	510	24389-500	Verf	t	\N	f
2	24356-10	24356	Sny kante	10	20	nan	Gert	t	\N	f
172	25004-2	25004	Grind	1	1	25004-1	Grind	t	\N	f
176	25005-3	25005	Verf	1	1	25005-2	Verf	t	\N	f
218	25006-3	25006	Verf	1	1	25006-2	Pieter, Quinton	t	\N	f
180	25007-1	25007	Sny plaatjies	1	5		Gert	t	\N	f
188	25010-3	25010	Buig	5	0.5	25010-2	Gert	t	\N	f
189	25010-4	25010	Verf	1	2	25010-3	Verf	t	\N	f
33	24367-30	24367	Sny end caps en gussets	5	1	nan	Groot_guillotine,Andrew	t	\N	f
185	25009-1	25009	Modifikasie	1	480		Wikus, Gert, Andrew, Vince	t	\N	f
186	25010-1	25010	Plasma	5	1		Gert	t	\N	f
213	25017-1	25017	Skoonmaak	1	45		Pieter, Quinton	t	\N	f
214	25018-1	25018	Saag	5	15		Saag,HSaag	t	\N	f
215	25018-2	25018	Buig	30	240	25018-1	James	t	\N	f
160	25002-2	25002	Skoonmaak	1	120	25002-1	Quinton, Pieter	t	\N	f
162	25002-4	25002	Oorverf	1	120	25002-3	Verf	t	\N	f
192	25011-3	25011	Buig	10	0.5	25011-2	Gert, Vince	t	\N	f
197	25012-1	25012	Deurgaan	1	2		Wikus	t	\N	f
198	25012-2	25012	Regmaak	10	5		Gert, Thys	t	\N	f
199	25013-1	25013	Bou komponente	1	5		Gert	t	\N	f
209	25016-2	25016	Deurgaan	1	10	25016-1	Wikus	t	\N	f
85	24386-20	24386	Corrugate parte	10	10	24386-10	Gert, Andrew	t	\N	f
86	24386-30	24386	Buig parte	15	10	24386-20	Gert, Andrew	t	\N	f
90	24386-300	24386	Bou bins	30	20	24386-30, 24386-100, 24386-210	Gert	t	\N	f
94	24388-10	24388	Saag tubing	5	45	nan	Wikus	t	\N	f
95	24388-20	24388	Sny plaatparte	5	45	nan	Groot_guillotine, Gert	t	\N	f
96	24388-30	24388	Sny mesh	1	20	nan	Wikus	t	\N	f
97	24388-100	24388	Bou cage	30	180	24388-10, 24388-20	Wikus	t	\N	f
101	24389-10	24389	Plasma tubings	15	570	nan	Wikus	t	\N	f
105	24389-30	24389	Bou ribbes	30	510	24389-11, 24389-20	Gert	t	\N	f
167	25003-4	25003	Bou skudmasjien	1	180	25003-3	Wikus	t	\N	f
170	25003-7	25003	Sit aanmekaar	1	240	25003-6	Wikus, Gert	t	\N	f
181	25007-2	25007	Sit plaatjies op	10	10	25007-1	Gert	t	\N	f
220	25008-2	25008	Buig	15	0.3	25008-1	Gert	t	\N	f
187	25010-2	25010	Skoonmaak	1	2	25010-1	Grind	t	\N	f
191	25011-2	25011	Plasma	5	5		Gert	t	\N	f
194	25011-5	25011	Sweis	1	15	25011-4	Sweis	t	\N	f
196	25011-7	25011	Verf	5	15	25011-6	Pieter, Quinton	t	\N	f
195	25011-6	25011	Grind	1	10	25011-5	Grind	t	\N	f
190	25011-1	25011	Saag	5	1		Saag,HSaag	t	\N	f
193	25011-4	25011	Bou Raam	10	10	25011-1, 25011-3	Gert, Thys	t	\N	f
200	25013-2	25013	Tack op	1	5	25013-1	Gert	t	\N	f
201	25013-3	25013	Verf	1	10	25013-2	Verf	t	\N	f
205	25015-1	25015	Deurgaan	5	2		Wikus	t	\N	f
206	25015-2	25015	Regmaak	1	10	25015-1	James	t	\N	f
207	25015-3	25015	Verf	5	5	25015-2	Verf	t	\N	f
1068	24183-9	24183	Grind pale	0	5	24183-7	Grind	f	\N	f
72	24370-120	24370	Buig plaatparte	10	2	24370-30	Gert, Andrew	t	\N	f
182	25007-3	25007	Verf	10	10	25007-2	Pieter, Quinton	t	\N	f
202	25014-1	25014	Deurgaan	5	5		Wikus	t	\N	f
203	25014-2	25014	Regmaak	5	30	25014-1	James	t	\N	f
204	25014-3	25014	Verf	1	20	25014-2	Verf	t	\N	f
208	25016-1	25016	Strip	5	30		Grind	t	\N	f
210	25016-3	25016	Regmaak	10	60	25016-2	Gert, Andrew	t	\N	f
211	25016-4	25016	Sweis	1	45	25016-3	Andrew	t	\N	f
212	25016-5	25016	Verf	10	60	25016-4	Pieter, Quinton	t	\N	f
13	24356-220	24356	Saag bullets	1	5	nan	Saag,HSaag	t	\N	f
387	25024-1	25024	Saag raam	10	30		Saag, HSaag	t	\N	f
397	25024-8	25024	Grind	1	30	25024-7	Dean, Grind	t	\N	f
388	25024-4	25024	Sweis raam	1	60	25024-3	Andrew	t	\N	f
392	25024-2	25024	Plasma	1	15		Gert	t	\N	f
393	25024-5	25024	Saag los parte	5	30		Saag, HSaag	t	\N	f
383	25023-8	25023	Grind	1	30	25023-7	Dean, Grind	t	\N	f
163	25002-5	25002	Aanmekaarsit	1	60	25002-4	Wikus, James	t	\N	f
378	25023-3	25023	Bou raam	10	90	25023-1, 25023-2	Wikus, Vince	t	\N	f
35	24367-200	24367	Bou hekkie	10	30	24367-20, 24367-30, 24367-100	Wikus, Vince	t	\N	f
165	25003-2	25003	Saag seksies	1	60		HSaag, Saag	t	\N	f
166	25003-3	25003	Berei parte voor	1	60	25003-1, 25003-2	Wikus	t	\N	f
168	25003-5	25003	Sweis	1	120	25003-4	Andrew	t	\N	f
169	25003-6	25003	Verf	1	120	25003-5	Verf	t	\N	f
402	25025-2	25025	Plasma	10	30		Gert	t	\N	f
404	25025-4	25025	Bou Jib	1	60	25025-1, 25025-3	Gert, Handlanger	t	\N	f
1164	25171-6	25171	Verf	0	2	25171-5	Verf	t	\N	f
1298	25192-6	25192	Pak en strap	1	1	25192-5	Grind,Pieter,Quintin	t	\N	t
1069	24183-10	24183	Verf pallets	0	10	24183-8	Verf	f	\N	f
1232	25180-9	25180	Buig 4mm	5	1	25180-2	HBuig	t	\N	f
1213	25183-1	25183	Saag EA	10	4		HSaag,Saag	t	\N	f
1215	25183-3	25183	Bou	1	10	25183-1,25183-2	Gert,Handlanger	t	\N	f
1217	25183-5	25183	Verf	1	7	25183-4	Verf	t	\N	f
1216	25183-4	25183	Grind	1	10	25183-3	Grind	t	\N	f
1336	25217-1	25217	Plasma flense	5	5		Gert	t	\N	f
1337	25217-2	25217	Sweis seksies	5	20		Andrew,Thys	t	\N	t
1352	25221-1	25221	Plasma	10	10		Gert	t	\N	t
1353	25221-2	25221	Maak handvatsels	5	2		BouK	t	\N	t
1421	25249-3	25249	Countersink	5	1	25249-2	HBoor	t	\N	f
1422	25249-4	25249	Was	1	1	25249-3	Verf	t	\N	f
1420	25249-2	25249	Buig	5	1	25249-1	HBuig	t	\N	f
1563	25308-2	25308	Grind	0	30	25308-1	Grind	f	\N	f
403	25025-3	25025	Buig	15	30	25025-2	Gert, Handlanger	t	\N	f
1233	25187-1	25187	Saag pyp	5	3		Handlanger,HSaag,Saag	t	\N	f
1300	25193-1	25193	Strip	1	3		Gerrie,Ethan	t	\N	f
1070	24183-11	24183	Verf pale	0	10	24183-9	Verf	f	\N	f
1299	25193-6	25193	Pak en strap	1	1	25193-5	Grind,Pieter,Quintin	t	\N	f
1303	25193-4	25193	Boor tube	10	1	25193-1	James,Louis,Magiel	t	\N	f
1302	25193-3	25193	Grind	1	1	25193-2	Grind,Ethan,Louis	t	\N	f
1301	25193-2	25193	Plasma	5	3	25193-1	Gert,Grind	t	\N	f
1165	25172-11	25172	Grind plasma tubes	1	180	25172-10	Grind, Renier, Hendré	t	\N	f
1304	25193-5	25193	Verf	20	2	25193-3,25193-4	Pieter,Quintin	t	\N	f
1175	25172-410	25172	Bou onderstel	15	60	25172-20	Gert	t	\N	f
1180	25172-30	25172	Bou ribbes	30	510	25172-11,25172-20	Gert	t	\N	f
1167	25172-40	25172	Sweis ribbes	1	300	25172-30	Sweis, Andrew	t	\N	f
1168	25172-50	25172	Grind ribbes	1	180	25172-40	Grind, Renier, Hendré	t	\N	f
1174	25172-400	25172	Bou flappe	10	120	25172-12	Gert	t	\N	f
1071	24183-12	24183	Pak	0	2	24183-10,24183-11	Quintin	f	\N	f
1214	25183-2	25183	Plasma 6mm	10	2		Gert	t	\N	f
1218	25184-1	25184	Sny plaat	0	8		Gert	t	\N	f
1219	25184-2	25184	Buig	30	4	25184-1	Gert	t	\N	f
1179	25172-10	25172	Plasma tubings	15	570		Wikus	t	\N	f
1177	25172-20	25172	Saag tubing	30	360		Saag,HSaag	t	\N	f
1172	25172-100	25172	Bou raam	45	360	25172-50	Wikus	t	\N	f
1171	25172-430	25172	Sweis onderstel	1	20	25172-410	Sweis	t	\N	f
1178	25172-600	25172	Verf raam	20	510	25172-500	Verf	t	\N	f
1166	25172-12	25172	Sny plaatparte	10	45		Gert	t	\N	f
1169	25172-200	25172	Sweis raam	1	300	25172-100	Sweis, Andrew	t	\N	f
1173	25172-300	25172	Sit grating op	1	180	25172-200	Wikus	t	\N	f
1170	25172-420	25172	Sweis flappe	1	30	25172-400	Sweis	t	\N	f
1176	25172-500	25172	Sit raam aanmekaar	1	60	25172-300,25172-420,25172-430	Wikus	t	\N	f
1564	25309-2	25309	Grind	0	30	25309-3	Grind	f	\N	f
1566	25309-3	25309	Bou en sweis	0	30	25309-1	Handlanger,BouG	f	\N	f
1338	25217-3	25217	Sweis pale aanmekaar	20	60	25217-2	Sweis,Wikus	t	\N	f
1355	25221-4	25221	Sweis	1	10	25221-3	Sweis,James	t	\N	f
1354	25221-3	25221	Bou houer	15	10	25221-1,25221-2	BouM	t	\N	f
1418	25249-5	25249	Verf	1	1	25249-4	Verf	t	\N	f
1423	25250-1	25250	Plasma	5	1		Gert	t	\N	f
1424	25250-2	25250	Press	10	1	25250-1	Quintin,Handlanger	t	\N	f
1565	25309-1	25309	Plasma en buig	0	40		Gert,Handlanger	f	\N	f
409	25025-7	25025	Verf	10	60	25025-6	Pieter, Quinton	t	\N	f
1234	25187-2	25187	Plasma 10	5	3		Gert,Handlanger	t	\N	f
1307	25194-2	25194	Plasma	5	3	25194-1	Gert,Grind	t	\N	f
1072	25154-1	25154	Saag tubing	10	1		HSaag,Saag	t	\N	f
1182	25173-1	25173	Strip	5	30		Grind	t	\N	f
1183	25173-3	25173	Regmaak	10	60	25173-2	Gert, Andrew	t	\N	f
1184	25173-4	25173	Sweis	1	45	25173-3	Andrew	t	\N	f
1185	25173-5	25173	Verf	10	60	25173-4	Pieter, Quinton	t	\N	f
1181	25173-2	25173	Deurgaan	1	10	25173-1	Wikus	t	\N	f
1220	25184-3	25184	Las	0	15	25184-2	Handlanger,Gert	t	\N	f
1309	25194-4	25194	Boor tube	10	1	25194-1	James,Louis,Magiel	t	\N	f
1308	25194-3	25194	Grind	1	1	25194-2	Grind,Ethan,Louis	t	\N	f
1306	25194-1	25194	Strip	1	3		Gerrie,Ethan	t	\N	f
1310	25194-5	25194	Verf	20	2	25194-3,25194-4	Pieter,Quintin	t	\N	f
1305	25194-6	25194	Pak en strap	1	1	25194-5	Grind,Pieter,Quintin	t	\N	f
1340	25217-5	25217	Sweis klaar	1	30	25217-4	Andrew,Thys	t	\N	f
1339	25217-4	25217	Sit flense op	10	30	25217-1,25217-3	BouM,Handlanger	t	\N	f
1341	25217-6	25217	Grind	10	60	25217-5	Handlanger,Grind	t	\N	t
1358	25221-7	25221	Verf	5	10	25221-6	Verf	t	\N	f
1357	25221-6	25221	Was	5	5	25221-5	Verf	t	\N	f
1356	25221-5	25221	Grind	1	10	25221-4	Grind,Handlanger	t	\N	f
1425	25250-3	25250	Was	1	1	25250-2	Verf	t	\N	f
1426	25250-4	25250	Verf	1	1	25250-3	Verf	t	\N	f
1441	25228(b)-1	25228(b)	Saag	10	1		HSaag,Saag	f	\N	f
1567	25293-10	25293	Sny end caps	10	2	25293-5	Groot_guillotine,Handlanger,BouK	f	\N	f
407	25025-5	25025	Sweis	1	60	25025-4	Andrew	t	\N	f
417	25031-20	25031	Corrugate parte	10	10	25031-10	Gert, Andrew	t	\N	f
412	25031-210	25031	Press voete	30	1	25031-200	Quinton	t	\N	f
1314	25199-16	25199	Sit aanmekaar	1	30	25199-14,25199-15	Wikus, Handlanger	t	\N	t
1318	25199-17	25199	Toets	1	15	25199-16	Wikus	t	\N	f
1316	25199-2	25199	Buig pockets	10	5	25199-1	Gert, Handlanger	t	\N	f
1317	25199-18	25199	Strip	1	15	25199-17	Handlanger	t	\N	f
1073	25154-2	25154	Plasma 4mm	10	0.5		Gert	t	\N	f
1334	25199-19	25199	Verf	1	50	25199-25	Verf	t	\N	f
1186	25174-1	25174	Sny strips	30	200		Handlanger,Grind	t	\N	f
1221	25184-4	25184	Sweis	0	15	25184-3	Sweis	t	\N	f
1320	25199-20	25199	Finale aanmekaarsit	1	45	25199-19	Wikus, Handlanger	t	\N	f
1328	25199-21	25199	Grind 20mm blokkies	1	16	25199-10	Grind	t	\N	f
1331	25199-22	25199	Boor 76x38	5	5	25199-4	Boor,HBoor	t	\N	f
1332	25199-23	25199	Sny Roundbar	1	2		Groot_guillotine	t	\N	f
1333	25199-24	25199	20Rond Boor	2	5	25199-4	Boor,HBoor	t	\N	f
1568	25293-11	25293	Sny en bou notches	1	5	25293-7,25293-10	Grind,BouG	f	\N	f
1326	25199-3	25199	Buig dromgidse	10	5	25199-1	Vince	t	\N	f
1335	25199-25	25199	Was	5	30	25199-18	Verf	t	\N	f
1319	25199-4	25199	Saag	10	15		Saag, HSaag	t	\N	f
1321	25199-5	25199	Boor hoekysters	5	20	25199-4	Boor, HBoor	t	\N	f
1329	25199-6	25199	Bou raam	10	30	25199-2,25199-3,25199-4,25199-5	Wikus	t	\N	f
1323	25199-7	25199	Plasma 20mm	10	5		Gert	t	\N	f
1327	25199-9	25199	Boor 8mm	1	1		Boor, HBoor	t	\N	f
1325	25199-8	25199	Plasma 8mm	10	5		Gert	t	\N	f
1235	25187-3	25187	Pyp halveer	1	5	25187-1	Vince	t	\N	f
1313	25199-1	25199	Plasma 4.5mm	5	30		Gert	t	\N	f
1312	25199-10	25199	Boor 20mm	5	50	25199-7	Boor, HBoor	t	\N	f
1322	25199-12	25199	Sweis raam	1	45	25199-6	Sweis	t	\N	f
1311	25199-11	25199	Bou arms	1	10	25199-8,25199-21,25199-22,25199-23,25199-24	Wikus	t	\N	f
1330	25199-14	25199	Grind raam	1	45	25199-12	Grind	t	\N	f
1324	25199-13	25199	Sweis arms	1	20	25199-11	Sweis	t	\N	f
1315	25199-15	25199	Grind arms	1	15	25199-13	Grind	t	\N	f
1342	25217-7	25217	Was	15	30	25217-6	Verf	t	\N	f
1428	25253-2	25253	Cut-off	10	1	25253-1	Handlanger	t	\N	t
1427	25253-1	25253	Was en verf	10	1		Verf	t	\N	f
1442	25228(b)-2	25228(b)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1359	25237-1	25237	Verf kolomme	5	120		Verf	t	\N	f
416	25031-10	25031	Sny plaatparte	5	15	nan	Groot_guillotine, Gert	t	\N	f
66	24369-600	24369	Plak rubber	1	15	24369-500	Quinton	t	\N	f
68	24370-20	24370	Saag tubing	5	10	nan	Saag,HSaag	t	\N	f
419	25031-300	25031	Bou bins	30	20	25031-30, 25031-100, 25031-210	Gert	t	\N	f
418	25031-30	25031	Buig parte	15	10	25031-20	Gert, Andrew	t	\N	f
414	25031-500	25031	Grind bins	1	15	25031-400	Grind, Fernando, Dean	t	\N	f
415	25031-600	25031	Verf bins	1	30	25031-500	Pieter	t	\N	f
481	25038-400	25038	Grind hekkie	1	30	25038-300	Grind	t	\N	f
411	25031-200	25031	Sny voete plate	5	2	nan	Groot_guillotine, Quinton	t	\N	f
413	25031-400	25031	Sweis bins	1	20	25031-300	Sweis, Andrew	t	\N	f
429	25035-430	25035	Sweis onderstel	1	20	25035-410	Sweis	t	\N	f
433	25035-410	25035	Bou onderstel	15	60	25035-20	Gert	t	\N	f
427	25035-200	25035	Sweis raam	1	300	25035-100	Sweis, Andrew	t	\N	f
496	25034-3	25034	Verf	1	20	25034-2	Verf	f	\N	f
408	25025-6	25025	Grind	1	60	25025-5	Ruan	t	\N	f
432	25035-400	25035	Bou flappe	10	120	25035-12	Gert	t	\N	f
1236	25187-4	25187	Grind parte	1	8	25187-2,25187-3	Grind	t	\N	f
439	25036-10	25036	Saag tubing	5	2	nan	Saag, HSaag	t	\N	f
426	25035-50	25035	Grind ribbes	1	180	25035-40	Grind, Renier, Hendré	t	\N	f
436	25035-600	25035	Verf raam	20	510	25035-500	Verf	t	\N	f
437	25035-10	25035	Plasma tubings	15	570	nan	Wikus	t	\N	f
434	25035-500	25035	Sit raam aanmekaar	1	60	25035-300, 25035-420, 25035-430	Wikus	t	\N	f
431	25035-300	25035	Sit grating op	1	180	25035-200	Wikus	t	\N	f
424	25035-12	25035	Sny plaatparte	10	45	nan	Gert	t	\N	f
435	25035-20	25035	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
430	25035-100	25035	Bou raam	45	360	25035-50	Wikus	t	\N	f
440	25036-20	25036	Saag pypies	5	5	nan	Saag, HSaag	t	\N	f
441	25036-30	25036	Sny plaatparte	5	5	nan	Gert	t	\N	f
442	25036-100	25036	Bou front	10	5	25036-10, 25036-20, 25036-30	Wikus	t	\N	f
443	25036-200	25036	Sweis front	1	20	25036-100	Sweis	t	\N	f
444	25036-300	25036	Grind front	1	10	25036-200	Grind	t	\N	f
445	25036-400	25036	Verf front	1	10	25036-300	Verf	t	\N	f
465	25037-30	25037	Sny plaatparte	5	5	nan	Gert	t	\N	f
466	25037-110	25037	Plasma channels	5	8	25037-10	Wikus, Vince	t	\N	f
452	25043-300	25043	Grind front	1	10	25043-200	Grind	t	\N	f
462	25042-100	25042	Bou T-nuts	10	1	25042-30	Wikus	t	\N	f
447	25043-10	25043	Saag tubing	5	2	nan	Saag, HSaag	t	\N	f
458	25042-110	25042	Sweis T-nuts	1	3	25042-100	Sweis	t	\N	f
467	25037-300	25037	Sweis A-raam	1	30	25037-200	Sweis, Andrew	t	\N	f
468	25037-200	25037	Bou in jig	10	30	25037-20, 25037-40, 25037-110, 25037-120	Wikus, James	t	\N	f
469	25037-400	25037	Grind A-raam	1	15	25037-300	Grind, Fernando, Dean	t	\N	f
470	25037-500	25037	Verf A-raam	1	20	25037-400	Pieter, Quinton	t	\N	f
471	25037-600	25037	Plak rubber	1	15	25037-500	Quinton	t	\N	f
472	25037-10	25037	Saag channels	5	5	nan	Saag,HSaag	t	\N	f
473	25037-40	25037	Saag pyp	1	2	nan	Saag,HSaag	t	\N	f
474	25037-120	25037	Buig plaatparte	10	2	25037-30	Gert, Andrew	t	\N	f
475	25037-20	25037	Saag tubing	5	10	nan	Saag,HSaag	t	\N	f
476	25038-10	25038	Saag tubing	5	5	nan	Saag, HSaag	t	\N	f
477	25038-20	25038	Saag round bars	1	2	nan	Saag, HSaag	t	\N	f
478	25038-30	25038	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t	\N	f
479	25038-100	25038	Boor tubing	5	8	25038-10	Boor, HBoor	t	\N	f
480	25038-300	25038	Sweis hekkie	1	30	25038-200	Sweis	t	\N	f
484	25038-200	25038	Bou hekkie	10	30	25038-20, 25038-30, 25038-100	Wikus	t	\N	f
485	25039-10	25039	Saag tubing	5	5	nan	Saag, HSaag	t	\N	f
486	25039-20	25039	Saag round bars	1	2	nan	Saag, HSaag	t	\N	f
487	25039-30	25039	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t	\N	f
488	25039-100	25039	Boor tubing	5	8	25039-10	Boor, HBoor	t	\N	f
489	25039-300	25039	Sweis hekkie	1	30	25039-200	Sweis	t	\N	f
446	25036-500	25036	Plak rubber	1	3	25036-400	Quinton	t	\N	f
457	25042-30	25042	Sny plaatparte	5	1	nan	Gert	t	\N	f
448	25043-20	25043	Saag pypies	5	5	nan	Saag, HSaag	t	\N	f
449	25043-30	25043	Sny plaatparte	5	5	nan	Gert	t	\N	f
450	25043-100	25043	Bou front	10	5	25043-10, 25043-20, 25043-30	Wikus	t	\N	f
451	25043-200	25043	Sweis front	1	20	25043-100	Sweis	t	\N	f
381	25023-6	25023	Sit los parte op	1	60	25023-4, 25023-5	Wikus, Vince	t	\N	f
410	25031-100	25031	Saag bene	5	5	nan	Saag, HSaag	t	\N	f
482	25038-500	25038	Verf hekkie	1	10	25038-400	Verf	t	\N	f
483	25038-600	25038	Plak rubber	1	10	25038-500	Quinton	t	\N	f
464	25042-120	25042	Verf	1	1	25042-115	Quinton	t	\N	f
453	25043-400	25043	Verf front	1	10	25043-300	Verf	t	\N	f
454	25043-500	25043	Plak rubber	1	3	25043-400	Quinton	t	\N	f
495	25034-2	25034	Regmaak	5	30	25034-1	James	f	\N	f
490	25039-400	25039	Grind hekkie	1	30	25039-300	Grind	t	\N	f
968	25110-27	25110	Grind ander parte	1	120	25110-26	Grind	t	\N	f
1189	25175-3	25175	Boor sq tubing	5	4	25175-1	Boor,HBoor	t	\N	t
1187	25175-1	25175	Saag sq tubing	10	2		HSaag,Saag	t	\N	f
1443	25228(b)-3	25228(b)	Buig koppelstukke	10	0.5	25228(b)-2	HBuig,Klein_buig	f	\N	f
1074	25154-3	25154	Sny end caps	5	0.5		Groot_guillotine,HSaag	t	\N	f
1190	25175-4	25175	Plasma 4.5mm	10	1		Gert	t	\N	f
1191	25175-5	25175	Bou leertjie	0	20	25175-2,25175-3,25175-4	BouM	t	\N	f
1188	25175-2	25175	Saag round tubing	10	3		HSaag,Saag	t	\N	f
1222	25184-5	25184	Grind	0	10	25184-4	Handlanger,Grind	t	\N	f
1223	25184-6	25184	Verf	0	15	25184-5	Verf	t	\N	f
1360	25237-2	25237	Was sag angles	5	30		Verf	t	\N	f
1237	25187-5	25187	Bou pyp	5	8	25187-4	BouM	t	\N	f
1361	25237-3	25237	Verf sag angles	1	120	25237-2	Verf	t	\N	f
1569	25293-12	25293	Sweis notch end caps	1	7	25293-11	Sweis	f	\N	f
1343	25217-8	25217	Verf	15	45	25217-7	Verf	t	\N	f
1429	25254-1	25254	Verleng voete	1	30		BouK	t	\N	f
1432	25254-4	25254	Sit vleuels op	1	30	25254-3	BouK	t	\N	f
1431	25254-3	25254	Sweis vleuels	1	40	25254-2	Sweis	t	\N	f
1430	25254-2	25254	Bou vleuels	1	30		BouK	t	\N	t
494	25034-1	25034	Deurgaan	5	5		Wikus	f	\N	f
491	25039-500	25039	Verf hekkie	1	10	25039-400	Verf	t	\N	f
1192	25175-6	25175	Bou arms	0	15	25175-2	BouM	t	\N	f
1238	25187-6	25187	Sweis	1	12	25187-5	Sweis	t	\N	f
1433	25254-5	25254	Sweis pallet	1	30	25254-1,25254-4	Sweis	t	\N	f
1344	25220-1	25220	Plasma	10	2		Gert	t	\N	t
1224	25185-1	25185	Plasma 6mm	10	2		Gert	t	\N	f
1226	25185-3	25185	Verf	0	2	25185-2	Verf	t	\N	f
1225	25185-2	25185	Skoonmaak	0	1	25185-1	Grind	t	\N	f
1075	25154-4	25154	Sit aanmekaar	0	2	25154-1,25154-2,25154-3	BouM	t	\N	f
1076	25154-5	25154	Sweis	0	3	25154-4	Sweis	t	\N	f
1077	25154-6	25154	Grind	0	5	25154-5	Grind,Handlanger	t	\N	f
1444	25228(b)-4	25228(b)	Las en sweis	10	3	25228(b)-1,25228(b)-3	BouK,Handlanger	f	\N	f
1362	25237-4	25237	Maak ankerboute	5	180		BouK	t	\N	f
492	25039-600	25039	Plak rubber	1	10	25039-500	Quinton	t	\N	f
1078	25154-7	25154	Verf	0	2	25154-6	Verf	t	\N	f
1079	25154-8	25154	Sit boute in	0	1	25154-7	Verf	t	\N	f
1193	25175-7	25175	Sweis	0	20	25175-5,25175-6	Wikus	t	\N	f
1239	25187-7	25187	Grind	1	15	25187-6	Grind	t	\N	f
1435	25254-7	25254	Verf pallet	1	30	25254-6	Verf	t	\N	f
1437	25254-9	25254	Grind platform	1	30	25254-8	Grind	t	\N	t
1345	25220-2	25220	Saag tubing	5	1		HSaag,Saag	t	\N	f
1445	25228(b)-5	25228(b)	Grind	1	5	25228(b)-4	Grind	f	\N	f
1446	25228(b)-6	25228(b)	Verf	5	5	25228(b)-5	Verf,Cupgun	f	\N	f
1364	25237-6	25237	Was kruise	5	30	25237-5	Verf	t	\N	f
1365	25237-7	25237	Verf kruise	1	30	25237-6	Verf	t	\N	f
1363	25237-5	25237	Maak kruise	5	120		BouM	t	\N	f
1366	25237-8	25237	Bou purlins	10	180		BouM,Handlanger	t	\N	f
423	25035-11	25035	Grind plasma tubes	1	180	25035-10	Grind, Renier, Hendré	t	\N	f
1439	25254-11	25254	Laai setup op trok	1	20	25254-7,25254-10	James	t	\N	f
1438	25254-10	25254	Verf platform	1	90	25254-9	Verf	t	\N	f
1434	25254-6	25254	Grind pallet	1	20	25254-5	Grind	t	\N	t
1436	25254-8	25254	Modifiseer blou platforms	1	120		Handlanger,Wikus	t	\N	t
532	25049-3	25049	Corrugate dek	5	3	25049-1	Gert, Handlanger	t	\N	f
520	25045-500	25045	Verf A-raam	1	20	25045-400	Pieter, Quinton	t	\N	f
557	25055-7	25055	Sweis	1	10	25055-6	James, Andrew	t	\N	f
506	25044-10	25044	Saag tubing	5	5	nan	Saag, HSaag	t	\N	f
507	25044-20	25044	Saag round bars	1	2	nan	Saag, HSaag	t	\N	f
508	25044-30	25044	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t	\N	f
509	25044-100	25044	Boor tubing	5	8	25044-10	Boor, HBoor	t	\N	f
510	25044-300	25044	Sweis hekkie	1	30	25044-200	Sweis	t	\N	f
514	25044-200	25044	Bou hekkie	10	30	25044-20, 25044-30, 25044-100	Wikus	t	\N	f
493	25039-200	25039	Bou hekkie	10	30	25039-20, 25039-30, 25039-100	Wikus	t	\N	f
522	25045-10	25045	Saag channels	5	5	nan	Saag,HSaag	t	\N	f
525	25045-20	25045	Saag tubing	5	10	nan	Saag,HSaag	t	\N	f
515	25045-30	25045	Sny plaatparte	5	5	nan	Gert	t	\N	f
516	25045-110	25045	Plasma channels	5	8	25045-10	Wikus, Vince	t	\N	f
524	25045-120	25045	Buig plaatparte	10	2	25045-30	Gert, Andrew	t	\N	f
552	25055-1	25055	Sny Dek	10	2		Gert, Handlanger, Groot_guillotine	t	\N	f
551	25055-2	25055	Sny voete	10	2		Gert, Handlanger, Groot_guillotine	t	\N	f
553	25055-3	25055	Corrugate dek	5	3	25055-1	Gert, Handlanger	t	\N	f
567	25056-8	25056	Modifikasie (deurtjie)	1	240	25056-7	Wikus	t	\N	f
568	25056-9	25056	Verf	15	120	25056-8	Quinton, Pieter	t	\N	f
574	25061-5	25061	Sweis	1	20	25061-4	Andrew	t	\N	f
576	25061-7	25061	Inspeksie	1	10	25061-6	Wikus	t	\N	f
577	25062-1	25062	Saag	15	10		HSaag, Saag	t	\N	f
511	25044-400	25044	Grind hekkie	1	30	25044-300	Grind	t	\N	f
512	25044-500	25044	Verf hekkie	1	10	25044-400	Verf	t	\N	f
513	25044-600	25044	Plak rubber	1	10	25044-500	Quinton	t	\N	f
523	25045-40	25045	Saag los parte	1	2	nan	Saag,HSaag	t	\N	f
518	25045-200	25045	Bou in jig	10	30	25045-20, 25045-40, 25045-110, 25045-120	Wikus, James	t	\N	f
517	25045-300	25045	Sweis A-raam	1	30	25045-200	Sweis, Andrew	t	\N	f
519	25045-400	25045	Grind A-raam	1	15	25045-300	Grind, Fernando, Dean	t	\N	f
531	25049-2	25049	Sny voete	10	2		Gert, Handlanger, Groot_guillotine	t	\N	f
534	25049-5	25049	Buig voete	15	1	25049-2	James, Handlanger	t	\N	f
554	25055-4	25055	Buig dek	15	1	25055-3	James, Handlanger	t	\N	f
555	25055-5	25055	Buig voete	15	1	25055-2	James, Handlanger	t	\N	f
556	25055-6	25055	Bou	10	10	25055-4, 25055-5	Gert	t	\N	f
545	25057-1	25057	Deurgaan	1	2		Wikus	t	\N	f
546	25057-2	25057	Regmaak	10	5	25057-1	Gert, Thys	t	\N	f
521	25045-600	25045	Plak rubber	1	15	25045-500	Quinton	t	\N	f
533	25049-4	25049	Buig dek	15	1	25049-3	James, Handlanger	t	\N	f
535	25049-6	25049	Bou	10	10	25049-4, 25049-5	Gert	t	\N	f
536	25049-7	25049	Sweis	1	10	25049-6	James, Andrew	t	\N	f
537	25049-8	25049	Grind	1	10	25049-7	Thys, Vince, Ruan	t	\N	f
538	25049-9	25049	Verf	1	15	25049-8	Pieter, Quinton	t	\N	f
540	25054-1	25054	Sny vastrap	5	10		Thys, Vince	t	\N	f
541	25054-2	25054	Plasma	5	15		Gert	t	\N	f
542	25054-3	25054	Bou	1	60	25054-1, 25054-2	Wikus, Handlanger	t	\N	f
543	25054-4	25054	Sweis	1	60	25054-3	Andrew	t	\N	f
544	25054-5	25054	Verf	1	90	25054-4	Pieter, Quinton	t	\N	f
558	25055-8	25055	Grind	1	10	25055-7	Thys, Vince, Ruan	t	\N	f
560	25056-1	25056	Plasma	15	30		Gert	t	\N	f
561	25056-2	25056	Buig parte	15	30	25056-1	James, Handlanger	t	\N	f
562	25056-3	25056	Buig kegel	15	60	25056-1	Gert, Handlanger	t	\N	f
563	25056-4	25056	Rol	15	120	25056-1	Gert, Handlanger	t	\N	f
564	25056-5	25056	Bou	15	120	25056-2, 25056-3, 25056-4	Wikus, Vince	t	\N	f
565	25056-6	25056	Sweis	1	120	25056-5	Andrew	t	\N	f
566	25056-7	25056	Grind	1	60	25056-6	Ruan	t	\N	f
547	25058-1	25058	Bou komponente	1	5		Gert	t	\N	f
548	25058-2	25058	Tack op	1	5	25058-1	Gert	t	\N	f
549	25058-3	25058	Verf	1	10	25058-2	Verf	t	\N	f
570	25061-1	25061	Saag	15	10		HSaag, Saag	t	\N	f
571	25061-2	25061	Plasma	10	10		Gert	t	\N	f
572	25061-3	25061	Buig	10	5	25061-2	Gert	t	\N	f
573	25061-4	25061	Bou	30	10	25061-3, 25061-1	Gert, Handlanger	t	\N	f
575	25061-6	25061	Grind	1	15	25061-5	Ruan	t	\N	f
526	25048-1	25048	Strip	1	30		Wikus, Handlanger	t	\N	f
527	25048-2	25048	Maak reg	1	60	25048-1	Wikus, Handlanger	t	\N	f
528	25048-3	25048	Verf	1	60	25048-2	Quinton	t	\N	f
505	25040-30	25040	Sny end caps en gussets	5	1	nan	Groot_guillotine,Andrew	t	\N	f
502	25040-100	25040	Boor tubing	5	8	25040-10	Boor,HBoor	t	\N	f
501	25040-10	25040	Saag tubing	5	5	nan	Saag,HSaag	t	\N	f
503	25040-20	25040	Saag round bars	1	2	nan	Saag,HSaag	t	\N	f
504	25040-200	25040	Bou hekkie	10	30	25040-20, 25040-30, 25040-100	Wikus, Vince	t	\N	f
497	25040-300	25040	Sweis hekkie	1	30	25040-200	Sweis	t	\N	f
498	25040-400	25040	Grind hekkie	1	30	25040-300	Grind	t	\N	f
500	25040-600	25040	Plak rubber	1	10	25040-500	Quinton	t	\N	f
499	25040-500	25040	Verf hekkie	1	10	25040-400	Verf	t	\N	f
578	25062-2	25062	Plasma	10	10		Gert	t	\N	f
581	25062-4	25062	Bou	30	10	25062-3, 25062-1	Gert, Handlanger	t	\N	f
1033	25124-4	25124	Bou en sweis pallet	1	15	25124-1, 25124-2	Maklik, Sweis	t	\N	f
1080	25169-1	25169	Saag tubing	10	1		HSaag,Saag	t	\N	f
1081	25169-2	25169	Plasma 4mm	10	0.5		Gert	t	\N	f
1082	25169-3	25169	Sny end caps	5	0.5		Groot_guillotine,HSaag	t	\N	f
1084	25169-4	25169	Sit aanmekaar	0	2	25169-1,25169-2,25169-3	BouM	t	\N	f
1083	25169-5	25169	Sweis	0	3	25169-4	Sweis	t	\N	f
1085	25169-6	25169	Grind	0	5	25169-5	Grind,Handlanger	t	\N	f
1086	25169-7	25169	Verf	0	2	25169-6	Verf	t	\N	f
1087	25169-8	25169	Sit boute in	0	1	25169-7	Verf	t	\N	f
1194	25175-8	25175	Grind	0	15	25175-7	Grind	t	\N	t
1240	25187-8	25187	Was	5	4	25187-7	Verf	t	\N	f
1440	25244-5	25244	Verf	10	60	25244-4	Verf	t	\N	f
1346	25220-3	25220	Maak handvatsels	10	2		BouK	t	\N	f
1347	25220-4	25220	Bou pale	15	10	25220-1,25220-2,25220-3	BouM	t	\N	t
1350	25220-7	25220	Was	5	2	25220-6	Verf	t	\N	f
1348	25220-5	25220	Sweis	1	15	25220-4	Sweis	t	\N	f
1351	25220-8	25220	Verf	1	5	25220-7	Verf	t	\N	f
1349	25220-6	25220	Grind	1	5	25220-5	Grind,Handlanger	t	\N	f
1447	25228(c)-1	25228(c)	Saag	10	1		HSaag,Saag	f	\N	f
1448	25228(c)-2	25228(c)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1449	25228(c)-3	25228(c)	Buig koppelstukke	10	0.5	25228(c)-2	HBuig,Klein_buig	f	\N	f
1450	25228(c)-4	25228(c)	Las en sweis	10	3	25228(c)-1,25228(c)-3	BouK,Handlanger	f	\N	f
1451	25228(c)-5	25228(c)	Grind	1	5	25228(c)-4	Grind	f	\N	f
1452	25228(c)-6	25228(c)	Verf	5	5	25228(c)-5	Verf,Cupgun	f	\N	f
1367	25237-9	25237	Sweis purlins	1	180	25237-8	Andrew,Thys,James	t	\N	f
579	25062-3	25062	Buig	10	5	25062-2	Gert	t	\N	f
582	25062-6	25062	Grind	1	15	25062-5	Ruan	t	\N	f
1408	25244-1	25244	Strip	5	30		Grind	t	\N	t
1453	25229(a)-1	25229(a)	Saag	10	1		HSaag,Saag	f	\N	f
1454	25229(a)-2	25229(a)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1195	25175-9	25175	Sit aanmekaar	0	15	25175-8	Verf	t	\N	t
1241	25187-9	25187	Verf	50	1	25187-8	Verf	t	\N	f
1455	25229(a)-3	25229(a)	Buig koppelstukke	10	0.5	25229(a)-2	HBuig,Klein_buig	f	\N	f
1456	25229(a)-4	25229(a)	Las en sweis	10	3	25229(a)-1,25229(a)-3	BouK,Handlanger	f	\N	f
1457	25229(a)-5	25229(a)	Grind	1	5	25229(a)-4	Grind	f	\N	f
1458	25229(a)-6	25229(a)	Verf	5	5	25229(a)-5	Verf,Cupgun	f	\N	f
1459	25229(b)-1	25229(b)	Saag	10	1		HSaag,Saag	f	\N	f
1460	25229(b)-2	25229(b)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1461	25229(b)-3	25229(b)	Buig koppelstukke	10	0.5	25229(b)-2	HBuig,Klein_buig	f	\N	f
1462	25229(b)-4	25229(b)	Las en sweis	10	3	25229(b)-1,25229(b)-3	BouK,Handlanger	f	\N	f
1463	25229(b)-5	25229(b)	Grind	1	5	25229(b)-4	Grind	f	\N	f
1464	25229(b)-6	25229(b)	Verf	5	5	25229(b)-5	Verf,Cupgun	f	\N	f
1368	25237-10	25237	Grind purlins	1	120	25237-9	Grind,Handlanger	t	\N	f
1088	25180-1	25180	Saag tubing	10	1		HSaag,Saag	t	\N	f
1089	25180-2	25180	Plasma 4mm	10	0.5		Gert	t	\N	f
1090	25180-3	25180	Sny end caps	5	0.5		Groot_guillotine,HSaag	t	\N	f
1091	25180-5	25180	Sweis	0	3	25180-4	Sweis	t	\N	f
1093	25180-6	25180	Grind	0	5	25180-5	Grind,Handlanger	t	\N	f
1092	25180-4	25180	Sit aanmekaar	0	2	25180-1,25180-9,25180-3	BouK	t	\N	f
1094	25180-7	25180	Verf	0	2	25180-6	Verf	t	\N	f
1095	25180-8	25180	Sit boute in	0	1	25180-7	Verf	t	\N	f
1369	25237-11	25237	Was purlins	10	60	25237-10	Verf,Handlanger	t	\N	f
1370	25237-12	25237	Verf purlins	5	60	25237-11	Verf,Handlanger	t	\N	f
1371	25237-13	25237	Laai trok	1	120	25237-3,25237-7,25237-12	James	t	\N	f
1096	25143-11	25143	Bou arms	1	10	25143-8,25143-21,25143-22,25143-23,25143-24	Wikus	t	\N	f
650	25091-11	25091	Bou arms	1	20	25091-9, 25091-10	Wikus	t	\N	f
550	25042-115	25042	Grind	1	5	25042-110	Ruan	t	\N	f
584	25064-10	25064	Plasma tubings	15	570	nan	Wikus	t	\N	f
585	25064-11	25064	Grind plasma tubes	1	180	25064-10	Grind, Fernando, Dean	t	\N	f
597	25064-20	25064	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
599	25064-30	25064	Bou ribbes	30	510	25064-11, 25064-20	Gert	t	\N	f
530	25049-1	25049	Sny Dek	10	2		Gert, Handlanger, Groot_guillotine	t	\N	f
580	25062-5	25062	Sweis	1	20	25062-4	Andrew	t	\N	f
583	25062-7	25062	Inspeksie	1	10	25062-6	Wikus	t	\N	f
590	25064-12	25064	Sny plaatparte	10	45	nan	Gert	t	\N	f
587	25064-40	25064	Sweis ribbes	1	300	25064-30	Sweis, Andrew	t	\N	f
588	25064-50	25064	Grind ribbes	1	180	25064-40	Grind, Fernando, Dean	t	\N	f
592	25064-100	25064	Bou raam	45	360	25064-50	Wikus	t	\N	f
589	25064-200	25064	Sweis raam	1	300	25064-100	Sweis, Andrew	t	\N	f
593	25064-300	25064	Sit grating op	1	180	25064-200	Wikus	t	\N	f
586	25064-400	25064	Bou flappe	10	120	25064-12	Gert	t	\N	f
595	25064-410	25064	Bou onderstel	15	60	25064-20	Gert	t	\N	f
594	25064-420	25064	Sweis flappe	1	30	25064-400	Sweis	t	\N	f
591	25064-430	25064	Sweis onderstel	1	20	25064-410	Sweis	t	\N	f
596	25064-500	25064	Sit raam aanmekaar	1	60	25064-300, 25064-420, 25064-430	Wikus	t	\N	f
598	25064-600	25064	Verf raam	20	510	25064-500	Verf	t	\N	f
601	25065-1	25065	Saag	10	15		HSaag,Saag	t	\N	f
602	25065-2	25065	Bou	15	30	25065-1	James, Handlanger	t	\N	f
603	25065-3	25065	Sweis	1	20	25065-2	Thys	t	\N	f
604	25065-4	25065	Grind	1	30	25065-3	Vince	t	\N	f
605	25065-5	25065	Verf	10	30	25065-4	Quinton	t	\N	f
529	25048-4	25048	Sit aanmekaar	1	30	25048-3	Quinton, Pieter	t	\N	f
649	25091-10	25091	Boor 20mm	5	50	25091-7	Boor, HBoor	t	\N	f
1098	25143-1	25143	Plasma 4.5mm	5	30		Gert	t	\N	f
640	25091-1	25091	Plasma 4.5mm	5	30		Gert	t	\N	f
1100	25143-15	25143	Grind arms	1	15	25143-13	Grind	t	\N	f
655	25091-16	25091	Sit aanmekaar	1	30	25091-14, 25091-15	Wikus, Handlanger	t	\N	f
1099	25143-16	25143	Sit aanmekaar	1	30	25143-14,25143-15	Wikus, Handlanger	t	\N	f
1097	25143-10	25143	Boor 20mm	5	50	25143-7	Boor, HBoor	t	\N	f
1102	25143-18	25143	Strip	1	15	25143-17	Handlanger	t	\N	f
1419	25249-1	25249	Plasma	5	1		Gert	t	\N	f
617	25066-3	25066	Plasma	5	10		Gert	t	\N	f
654	25091-15	25091	Grind arms	1	15	25091-13	Grind	t	\N	f
641	25091-2	25091	Buig pockets	10	5	25091-1	Gert, Handlanger	t	\N	f
657	25091-18	25091	Strip	1	15	25091-17	Handlanger	t	\N	f
658	25091-19	25091	Verf	1	30	25091-18	Pieter, Quinton	t	\N	f
656	25091-17	25091	Toets	1	15	25091-16	Wikus	t	\N	f
659	25091-20	25091	Finale aanmekaarsit	1	45	25091-19	Wikus, Handlanger	t	\N	f
643	25091-4	25091	Saag	10	15		Saag, HSaag	t	\N	f
644	25091-5	25091	Boor hoekysters	5	20	25091-4	Boor, HBoor	t	\N	f
615	25066-1	25066	Guillotine	15	2		Wikus, Guillotine	t	\N	f
616	25066-2	25066	Buig	15	3	25066-1	Gert, Handlanger	t	\N	f
618	25066-4	25066	Bou	1	15	25066-2, 25066-3	Wikus, Handlanger	t	\N	f
620	25067-1	25067	Plasma 4.5mm	5	30		Gert	t	\N	f
621	25067-2	25067	Buig pockets	10	5	25067-1	Gert, Handlanger	t	\N	f
622	25067-3	25067	Buig dromgidse	10	5	25067-1	Gert, Handlanger	t	\N	f
623	25067-4	25067	Saag	10	15		Saag, HSaag	t	\N	f
624	25067-5	25067	Boor hoekysters	5	20	25067-4	Boor, HBoor	t	\N	f
625	25067-6	25067	Bou raam	10	30	25067-2, 25067-3, 25067-5	Wikus	t	\N	f
626	25067-7	25067	Plasma 20mm	10	5		Gert	t	\N	f
627	25067-8	25067	Plasma 8mm	10	5		Gert	t	\N	f
628	25067-9	25067	Boor 8mm	5	10	25067-8	Boor, HBoor	t	\N	f
629	25067-10	25067	Boor 20mm	5	50	25067-7	Boor, HBoor	t	\N	f
630	25067-11	25067	Bou arms	1	20	25067-9, 25067-10	Wikus	t	\N	f
631	25067-12	25067	Sweis raam	1	45	25067-6	Sweis	t	\N	f
632	25067-13	25067	Sweis arms	1	20	25067-11	Sweis	t	\N	f
633	25067-14	25067	Grind raam	1	30	25067-12	Grind	t	\N	f
634	25067-15	25067	Grind arms	1	15	25067-13	Grind	t	\N	f
636	25067-17	25067	Toets	1	15	25067-16	Wikus	t	\N	f
637	25067-18	25067	Strip	1	15	25067-17	Handlanger	t	\N	f
638	25067-19	25067	Verf	1	30	25067-18	Pieter, Quinton	t	\N	f
639	25067-20	25067	Finale aanmekaarsit	1	45	25067-19	Wikus, Handlanger	t	\N	f
642	25091-3	25091	Buig dromgidse	10	5	25091-1	Gert, Handlanger	t	\N	f
651	25091-12	25091	Sweis raam	1	45	25091-6	Sweis	t	\N	f
646	25091-7	25091	Plasma 20mm	10	5		Gert	t	\N	f
645	25091-6	25091	Bou raam	10	30	25091-2, 25091-3, 25091-5	Wikus	t	\N	f
652	25091-13	25091	Sweis arms	1	20	25091-11	Sweis	t	\N	f
653	25091-14	25091	Grind raam	1	30	25091-12	Grind	t	\N	f
647	25091-8	25091	Plasma 8mm	10	5		Gert	t	\N	f
648	25091-9	25091	Boor 8mm	5	10	25091-8	Boor, HBoor	t	\N	f
1465	25230(b)-1	25230(b)	Saag	10	1		HSaag,Saag	f	\N	f
619	25066-5	25066	Verf	1	15	25066-4	Pieter, Quinton	t	\N	f
1104	25143-17	25143	Toets	1	15	25143-16	Wikus	t	\N	f
1106	25143-4	25143	Saag	10	15		Saag, HSaag	t	\N	f
1105	25143-20	25143	Finale aanmekaarsit	1	45	25143-19	Wikus, Handlanger	t	\N	f
1466	25230(b)-2	25230(b)	Sny koppelstukke	10	0.5		Gert	f	\N	f
635	25067-16	25067	Sit aanmekaar	1	30	25067-14, 25067-15	Wikus, Handlanger	t	\N	f
670	25076-11	25076	Strip	1	30	25076-10	Grind, Handlanger	t	2025-06-04 17:23:42.495414	f
669	25076-10	25076	Toets	15	5	25076-9	Wikus	t	2025-06-04 17:23:34.939012	f
666	25076-7	25076	Sweis raam	1	45	25076-5	Sweis	t	\N	f
661	25076-2	25076	Plasma	5	15		Gert	t	\N	f
665	25076-6	25076	Masjineer as	15	15	25076-2	Wikus	t	\N	f
675	25080-4	25080	Sit strips op	1	10		Thys, Vince	t	\N	f
674	25080-5	25080	Sweis mandjie	1	5	25080-4	Thys	t	\N	f
676	25080-6	25080	Skoonmaak	1	10	25080-5	Grind	t	\N	f
702	25071-5	25071	Buig 3mm	20	2	25071-1	Gert, Handlanger	t	\N	f
723	25072-9	25072	Bou pilaar	1	5	25072-5,25072-6,25072-7,25072-8	James	t	\N	f
689	25082-20	25082	Saag tubing	30	360	nan	Saag,HSaag	t	2025-05-27 20:09:24.937766	f
677	25082-11	25082	Grind plasma tubes	1	180	25082-10	Grind, Fernando, Dean	t	2025-05-27 20:09:31.850783	f
692	25082-30	25082	Bou ribbes	30	510	25082-11, 25082-20	Gert	t	2025-05-27 20:14:09.528401	f
693	25091(W)-1	25091(W)	Sny Grating	1	15		Thys	t	2025-05-27 20:18:44.347252	f
678	25082-12	25082	Sny plaatparte	10	45	nan	Gert	t	2025-05-27 20:19:12.04758	f
679	25082-40	25082	Sweis ribbes	1	300	25082-30	Sweis, Andrew	t	2025-05-27 20:19:52.555265	f
680	25082-50	25082	Grind ribbes	1	180	25082-40	Grind, Fernando, Dean	t	2025-05-27 20:24:48.569455	f
684	25082-100	25082	Bou raam	45	360	25082-50	Wikus	t	2025-05-27 20:24:57.080806	f
694	25091(W)-2	25091(W)	Plasma kante	5	5		Gert	t	\N	f
696	25091(W)-4	25091(W)	Sweis	1	10	25091(W)-3	Sweis	t	\N	f
697	25091(W)-5	25091(W)	Verf	1	15	25091(W)-4	Pieter, Quinton	t	\N	f
704	25071-7	25071	Saag roundbar	5	1		HSaag,Saag	t	2025-05-27 20:49:29.964316	f
700	25071-3	25071	Saag tubing	10	1		HSaag,Saag	t	2025-05-27 20:49:37.492417	f
698	25071-1	25071	Plasma 3mm	15	10		Gert	t	\N	f
699	25071-2	25071	Plasma 2mm	15	6		Gert	t	\N	f
705	25071-8	25071	Plasma 6mm	15	1		Gert	t	\N	f
701	25071-4	25071	Plasma tubing	5	8	25071-3	Gert	t	\N	f
703	25071-6	25071	Buig 2mm	20	3	25071-2	Gert, Handlanger	t	\N	f
708	25071-11	25071	Bou tubing	1	10	25071-4,25071-6,25071-10	Thys	t	\N	f
710	25071-13	25071	Sweis pilaar	1	5	25071-9	Sweis	t	\N	f
711	25071-14	25071	Sweis tubing	1	3	25071-11	Sweis	t	\N	f
717	25072-3	25072	Saag tubing	10	1		HSaag,Saag	t	\N	f
732	25073-3	25073	Saag tubing	10	1		HSaag,Saag	t	\N	f
681	25082-200	25082	Sweis raam	1	300	25082-100	Sweis, Andrew	t	\N	f
685	25082-300	25082	Sit grating op	1	180	25082-200	Wikus	t	\N	f
686	25082-400	25082	Bou flappe	10	120	25082-12	Gert	t	\N	f
687	25082-410	25082	Bou onderstel	15	60	25082-20	Gert	t	\N	f
683	25082-430	25082	Sweis onderstel	1	20	25082-410	Sweis	t	\N	f
715	25072-1	25072	Plasma 3mm	15	10		Gert	t	\N	f
716	25072-2	25072	Plasma 2mm	15	6		Gert	t	\N	f
720	25072-4	25072	Plasma tubing	5	8	25072-3	Gert	t	\N	f
718	25072-5	25072	Buig 3mm	20	2	25072-1	Gert, Handlanger	t	\N	f
719	25072-6	25072	Buig 2mm	20	3	25072-2	Gert, Handlanger	t	\N	f
722	25072-8	25072	Plasma 6mm	15	1		Gert	t	\N	f
721	25072-7	25072	Saag roundbar	5	1		HSaag,Saag	t	\N	f
724	25072-10	25072	Buig kop	10	1	25072-8	Gert	t	\N	f
671	25076-12	25076	Verf	5	30	25076-11	Quinton, Pieter	t	2025-06-04 17:23:53.950776	f
735	25073-1	25073	Plasma 3mm	15	10		Gert	t	\N	f
664	25076-5	25076	Bou raam	1	45	25076-1, 25076-2	Gert, Handlanger	t	\N	f
663	25076-4	25076	Bou ronding	1	30	25076-1, 25076-3	Gert, Handlanger	t	2025-06-04 17:23:46.182564	f
662	25076-3	25076	Rol	15	45	25076-2	Gert, Handlanger	t	2025-06-04 17:23:39.252567	f
688	25082-500	25082	Sit raam aanmekaar	1	60	25082-300, 25082-420, 25082-430	Wikus	t	2025-06-04 17:24:00.746859	f
690	25082-600	25082	Verf raam	20	510	25082-500	Verf	t	2025-06-04 17:24:02.674916	f
709	25071-12	25071	Bou armpie	1	5	25071-6,25071-8	Wikus	t	\N	f
712	25071-15	25071	Sweis armpie	1	4	25071-12	Sweis	t	\N	f
713	25071-16	25071	Verf	1	10	25071-13, 25071-14, 25071-15	Pieter, Quinton	t	\N	f
714	25071-17	25071	Sit aanmekaar	1	5	25071-16	Wikus, Handlanger	t	\N	f
725	25072-11	25072	Bou tubing	1	10	25072-4,25072-6,25072-10	Thys	t	\N	f
726	25072-12	25072	Bou armpie	1	5	25072-6,25072-8	Wikus	t	\N	f
727	25072-13	25072	Sweis pilaar	1	5	25072-9	Sweis	t	\N	f
728	25072-14	25072	Sweis tubing	1	3	25072-11	Sweis	t	\N	f
729	25072-15	25072	Sweis armpie	1	4	25072-12	Sweis	t	\N	f
731	25072-17	25072	Sit aanmekaar	1	5	25072-16	Wikus, Handlanger	t	\N	f
660	25076-1	25076	Saag	10	15		Saag, HSaag	t	\N	f
672	25076-13	25076	Sit finaal aanmekaar	1	45	25076-12	Gert, Handlanger	t	\N	f
733	25073-5	25073	Buig 3mm	20	2	25073-1	Gert, Handlanger	t	\N	f
738	25073-7	25073	Saag roundbar	5	1		HSaag,Saag	t	\N	f
734	25073-6	25073	Buig 2mm	20	3	25073-2	Gert, Handlanger	t	\N	f
742	25073-11	25073	Bou tubing	1	10	25073-4,25073-6,25073-10	Thys	t	\N	f
745	25073-14	25073	Sweis tubing	1	3	25073-11	Sweis	t	\N	f
748	25073-17	25073	Sit aanmekaar	1	5	25073-16	Wikus, Handlanger	t	\N	f
739	25073-8	25073	Plasma 6mm	15	1		Gert	t	\N	f
1112	25143-13	25143	Sweis arms	1	20	25143-11	Sweis	t	\N	f
1467	25230(b)-3	25230(b)	Buig koppelstukke	10	0.5	25230(b)-2	HBuig,Klein_buig	f	\N	f
1109	25143-12	25143	Sweis raam	1	45	25143-6	Sweis	t	\N	f
1468	25230(b)-4	25230(b)	Las en sweis	10	3	25230(b)-1,25230(b)-3	BouK,Handlanger	f	\N	f
1113	25143-14	25143	Grind raam	1	45	25143-12	Grind	t	\N	f
1469	25230(b)-5	25230(b)	Grind	1	5	25230(b)-4	Grind	f	\N	f
1227	25143-21	25143	Grind 20mm blokkies	1	16	25143-10	Grind	t	\N	f
1101	25143-2	25143	Buig pockets	10	5	25143-1	Gert, Handlanger	t	\N	f
1470	25230(b)-6	25230(b)	Verf	5	5	25230(b)-5	Verf,Cupgun	f	\N	f
1108	25143-3	25143	Buig dromgidse	10	5	25143-1	Vince	t	\N	f
1107	25143-5	25143	Boor hoekysters	5	20	25143-4	Boor, HBoor	t	\N	f
1111	25143-6	25143	Bou raam	10	30	25143-2,25143-3,25143-4,25143-5	Wikus	t	\N	f
1110	25143-7	25143	Plasma 20mm	10	5		Gert	t	\N	f
1114	25143-8	25143	Plasma 8mm	10	5		Gert	t	\N	f
1471	25231(b)-1	25231(b)	Saag	10	1		HSaag,Saag	f	\N	f
1115	25143-9	25143	Boor 8mm	1	1		Boor, HBoor	t	\N	f
1472	25231(b)-2	25231(b)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1473	25231(b)-3	25231(b)	Buig koppelstukke	10	0.5	25231(b)-2	HBuig,Klein_buig	f	\N	f
1474	25231(b)-4	25231(b)	Las en sweis	10	3	25231(b)-1,25231(b)-3	BouK,Handlanger	f	\N	f
1475	25231(b)-5	25231(b)	Grind	1	5	25231(b)-4	Grind	f	\N	f
1476	25231(b)-6	25231(b)	Verf	5	5	25231(b)-5	Verf,Cupgun	f	\N	f
1198	25176-3	25176	Bou	0	15	25176-1,25176-2	BouM	t	\N	f
1197	25176-2	25176	Plasma brackets	5	2		Gert	t	\N	f
1196	25176-1	25176	Saag Angles	10	4		HSaag,Saag	t	\N	f
1242	25195-1	25195	Plasma 12mm	10	10		Gert	t	\N	f
1243	25195-2	25195	Saag channels	5	30		HSaag,Saag	t	\N	f
1228	25143-22	25143	Boor 76x38	5	5	25143-4	Boor,HBoor	t	\N	f
1199	25176-4	25176	Sweis	0	20	25176-3	Sweis	t	\N	t
743	25073-12	25073	Bou armpie	1	5	25073-6,25073-8	Wikus	t	\N	f
746	25073-15	25073	Sweis armpie	1	4	25073-12	Sweis	t	\N	f
740	25073-9	25073	Bou pilaar	1	5	25073-5,25073-6,25073-7,25073-8	James	t	\N	f
1244	25195-3	25195	Saag EA	5	30		HSaag,Saag	t	\N	f
1245	25195-4	25195	Bou	30	40	25195-1,25195-2,25195-3	BouM,Handlanger	t	\N	f
1116	25155-1	25155	Plasma 6mm	5	1		Gert	t	\N	f
1117	25155-2	25155	Plasma 8mm	5	1		Gert	t	\N	f
1118	25155-3	25155	Sit aanmekaar	10	2	25155-1,25155-2	BouM	t	\N	f
1119	25155-4	25155	Sweis	0	2	25155-3	Sweis	t	\N	f
1373	25238(a)-400	25238(a)	Bou flappe	10	120	25238(a)-12	Gert	t	\N	f
1382	25238(a)-410	25238(a)	Bou onderstel	15	60	25238(a)-20	Gert	t	\N	f
1383	25238(a)-500	25238(a)	Sit raam aanmekaar	1	60	25238(a)-300,25238(a)-420,25238(a)-430	Wikus	t	\N	f
1379	25238(a)-430	25238(a)	Sweis onderstel	1	20	25238(a)-410	Sweis	t	\N	f
1372	25238(a)-420	25238(a)	Sweis flappe	1	30	25238(a)-400	Sweis	t	\N	f
1377	25238(a)-50	25238(a)	Grind ribbes	1	180	25238(a)-40	Grind, Renier, Hendré	t	\N	f
1385	25238(a)-600	25238(a)	Laai vir shotblast	1	30	25238(a)-500	James	t	\N	f
1477	25230(a)-1	25230(a)	Saag	10	1		HSaag,Saag	f	\N	f
1478	25230(a)-2	25230(a)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1479	25230(a)-3	25230(a)	Buig koppelstukke	10	0.5	25230(a)-2	HBuig,Klein_buig	f	\N	f
1480	25230(a)-4	25230(a)	Las en sweis	10	3	25230(a)-1,25230(a)-3	BouK,Handlanger	f	\N	f
1481	25230(a)-5	25230(a)	Grind	1	5	25230(a)-4	Grind	f	\N	f
1482	25230(a)-6	25230(a)	Verf	5	5	25230(a)-5	Verf,Cupgun	f	\N	f
1483	25231(a)-1	25231(a)	Saag	10	1		HSaag,Saag	f	\N	f
1484	25231(a)-2	25231(a)	Sny koppelstukke	10	0.5		Gert	f	\N	f
1485	25231(a)-3	25231(a)	Buig koppelstukke	10	0.5	25231(a)-2	HBuig,Klein_buig	f	\N	f
1486	25231(a)-4	25231(a)	Las en sweis	10	3	25231(a)-1,25231(a)-3	BouK,Handlanger	f	\N	f
1487	25231(a)-5	25231(a)	Grind	1	5	25231(a)-4	Grind	f	\N	f
1488	25231(a)-6	25231(a)	Verf	5	5	25231(a)-5	Verf,Cupgun	f	\N	f
1380	25238(a)-100	25238(a)	Bou raam	45	360	25238(a)-50	Wikus	t	\N	t
1375	25238(a)-10	25238(a)	Plasma tubings	15	570	nan	Wikus	t	\N	t
1378	25238(a)-200	25238(a)	Sweis raam	1	300	25238(a)-100	Sweis, Andrew	t	\N	t
1386	25238(a)-30	25238(a)	Bou ribbes	30	510	25238(a)-11,25238(a)-20	Gert	t	\N	f
1387	25238(a)-11	25238(a)	Grind plasma tubes	1	180	25238(a)-10	Grind, Renier, Hendré	t	\N	f
1376	25238(a)-40	25238(a)	Sweis ribbes	1	300	25238(a)-30	Sweis, Andrew	t	\N	f
1384	25238(a)-20	25238(a)	Saag tubing	30	360	nan	Saag,HSaag	t	\N	t
1374	25238(a)-12	25238(a)	Sny plaatparte	10	45	nan	Gert	t	\N	f
1381	25238(a)-300	25238(a)	Sit grating op	1	180	25238(a)-200	Wikus	t	\N	f
438	25035-30	25035	Bou ribbes	30	510	25035-11, 25035-20	Gert	t	\N	f
1120	25155-5	25155	Grind	0	2	25155-4	Handlanger,Grind	t	\N	f
750	25071(b)-2	25071(b)	Plasma 2mm	15	6		Gert	t	\N	f
751	25071(b)-3	25071(b)	Saag tubing	10	1		HSaag,Saag	t	\N	f
707	25071-10	25071	Buig kop	10	1	25071-8	Wikus	t	\N	f
753	25071(b)-6	25071(b)	Buig 2mm	20	3	25071(b)-2	Gert, Handlanger	t	\N	f
755	25071(b)-7	25071(b)	Saag roundbar	5	1		HSaag,Saag	t	\N	f
756	25071(b)-8	25071(b)	Plasma 6mm	15	1		Gert	t	\N	f
766	25071(c)-1	25071(c)	Plasma 3mm	15	10		Gert	t	\N	f
767	25071(c)-2	25071(c)	Plasma 2mm	15	6		Gert	t	\N	f
768	25071(c)-3	25071(c)	Saag tubing	10	1		HSaag,Saag	t	\N	f
770	25071(c)-6	25071(c)	Buig 2mm	20	3	25071(c)-2	Gert, Handlanger	t	\N	f
779	25071(c)-15	25071(c)	Sweis armpie	1	4	25071(c)-12	Sweis	t	2025-06-04 17:15:48.741476	f
783	25071(d)-1	25071(d)	Plasma 3mm	15	10		Gert	t	\N	f
784	25071(d)-2	25071(d)	Plasma 2mm	15	6		Gert	t	\N	f
787	25071(d)-6	25071(d)	Buig 2mm	20	3	25071(d)-2	Gert, Handlanger	t	\N	f
793	25071(d)-12	25071(d)	Bou armpie	1	5	25071(d)-6,25071(d)-8	Wikus	t	2025-06-04 17:16:54.149217	f
800	25071(e)-1	25071(e)	Plasma 3mm	15	10		Gert	t	\N	f
801	25071(e)-2	25071(e)	Plasma 2mm	15	6		Gert	t	\N	f
802	25071(e)-3	25071(e)	Saag tubing	10	1		HSaag,Saag	t	\N	f
804	25071(e)-6	25071(e)	Buig 2mm	20	3	25071(e)-2	Gert, Handlanger	t	\N	f
810	25071(e)-12	25071(e)	Bou armpie	1	5	25071(e)-6,25071(e)-8	Wikus	t	2025-06-04 17:17:20.657232	f
769	25071(c)-5	25071(c)	Buig 3mm	20	2	25071(c)-1	Gert, Handlanger	t	\N	f
776	25071(c)-12	25071(c)	Bou armpie	1	5	25071(c)-6,25071(c)-8	Wikus	t	2025-06-04 17:15:32.508514	f
778	25071(c)-14	25071(c)	Sweis tubing	1	3	25071(c)-11	Sweis	t	2025-06-04 17:15:56.283484	f
777	25071(c)-13	25071(c)	Sweis pilaar	1	5	25071(c)-9	Sweis	t	2025-06-04 17:15:51.337767	f
775	25071(c)-11	25071(c)	Bou tubing	1	10	25071(c)-4,25071(c)-6,25071(c)-10	Thys	t	2025-06-04 17:15:53.716243	f
781	25071(c)-17	25071(c)	Sit aanmekaar	1	5	25071(c)-16	Wikus, Handlanger	t	2025-06-04 17:16:22.202527	f
789	25071(d)-7	25071(d)	Saag roundbar	5	1		HSaag,Saag	t	2025-06-04 17:16:23.828604	f
788	25071(d)-4	25071(d)	Plasma tubing	5	8	25071(d)-3	Gert	t	2025-06-04 17:16:25.652432	f
790	25071(d)-8	25071(d)	Plasma 6mm	15	1		Gert	t	2025-06-04 17:16:27.47065	f
786	25071(d)-5	25071(d)	Buig 3mm	20	2	25071(d)-1	Gert, Handlanger	t	\N	f
791	25071(d)-9	25071(d)	Bou pilaar	1	5	25071(d)-5,25071(d)-6,25071(d)-7,25071(d)-8	James	t	2025-06-04 17:16:40.918887	f
795	25071(d)-14	25071(d)	Sweis tubing	1	3	25071(d)-11	Sweis	t	2025-06-04 17:17:04.857232	f
794	25071(d)-13	25071(d)	Sweis pilaar	1	5	25071(d)-9	Sweis	t	2025-06-04 17:16:56.712301	f
796	25071(d)-15	25071(d)	Sweis armpie	1	4	25071(d)-12	Sweis	t	2025-06-04 17:17:00.430929	f
806	25071(e)-7	25071(e)	Saag roundbar	5	1		HSaag,Saag	t	2025-06-04 17:17:09.902296	f
792	25071(d)-11	25071(d)	Bou tubing	1	10	25071(d)-4,25071(d)-6,25071(d)-10	Thys	t	2025-06-04 17:17:02.914899	f
798	25071(d)-17	25071(d)	Sit aanmekaar	1	5	25071(d)-16	Wikus, Handlanger	t	\N	f
814	25071(e)-16	25071(e)	Verf	1	10	25071(e)-13, 25071(e)-14, 25071(e)-15	Pieter, Quinton	t	\N	f
807	25071(e)-8	25071(e)	Plasma 6mm	15	1		Gert	t	2025-06-04 17:17:14.131701	f
808	25071(e)-9	25071(e)	Bou pilaar	1	5	25071(e)-5,25071(e)-6,25071(e)-7,25071(e)-8	James	t	2025-06-04 17:17:18.52375	f
812	25071(e)-14	25071(e)	Sweis tubing	1	3	25071(e)-11	Sweis	t	2025-06-04 17:17:28.807081	f
811	25071(e)-13	25071(e)	Sweis pilaar	1	5	25071(e)-9	Sweis	t	2025-06-04 17:17:23.696863	f
813	25071(e)-15	25071(e)	Sweis armpie	1	4	25071(e)-12	Sweis	t	2025-06-04 17:17:25.205641	f
759	25071(b)-12	25071(b)	Bou armpie	1	5	25071(b)-6,25071(b)-8	Wikus	t	\N	f
809	25071(e)-11	25071(e)	Bou tubing	1	10	25071(e)-4,25071(e)-6,25071(e)-10	Thys	t	2025-06-04 17:17:27.01515	f
815	25071(e)-17	25071(e)	Sit aanmekaar	1	5	25071(e)-16	Wikus, Handlanger	t	\N	f
818	25072(b)-5	25072(b)	Buig 3mm	20	2	25072(b)-1	Gert, Handlanger	t	\N	f
817	25072(b)-3	25072(b)	Saag tubing	10	1		HSaag,Saag	t	\N	f
754	25071(b)-4	25071(b)	Plasma tubing	5	8	25071(b)-3	Gert	t	\N	f
757	25071(b)-9	25071(b)	Bou pilaar	1	5	25071(b)-5,25071(b)-6,25071(b)-7,25071(b)-8	James	t	\N	f
765	25071(b)-10	25071(b)	Buig kop	10	1	25071(b)-8	Wikus	t	\N	f
758	25071(b)-11	25071(b)	Bou tubing	1	10	25071(b)-4,25071(b)-6,25071(b)-10	Thys	t	\N	f
761	25071(b)-14	25071(b)	Sweis tubing	1	3	25071(b)-11	Sweis	t	\N	f
772	25071(c)-7	25071(c)	Saag roundbar	5	1		HSaag,Saag	t	2025-06-04 17:15:13.359212	f
773	25071(c)-8	25071(c)	Plasma 6mm	15	1		Gert	t	2025-06-04 17:15:17.597457	f
782	25071(c)-10	25071(c)	Buig kop	10	1	25071(c)-8	Wikus	t	2025-06-04 17:15:20.273772	f
799	25071(d)-10	25071(d)	Buig kop	10	1	25071(d)-8	Wikus	t	2025-06-04 17:16:29.166145	f
805	25071(e)-4	25071(e)	Plasma tubing	5	8	25071(e)-3	Gert	t	2025-06-04 17:17:11.886448	f
816	25071(e)-10	25071(e)	Buig kop	10	1	25071(e)-8	Wikus	t	2025-06-04 17:17:16.447741	f
762	25071(b)-15	25071(b)	Sweis armpie	1	4	25071(b)-12	Sweis	t	\N	f
763	25071(b)-16	25071(b)	Verf	1	10	25071(b)-13, 25071(b)-14, 25071(b)-15	Pieter, Quinton	t	\N	f
764	25071(b)-17	25071(b)	Sit aanmekaar	1	5	25071(b)-16	Wikus, Handlanger	t	\N	f
797	25071(d)-16	25071(d)	Verf	1	10	25071(d)-13, 25071(d)-14, 25071(d)-15	Pieter, Quinton	t	\N	f
747	25073-16	25073	Verf	1	10	25073-13, 25073-14, 25073-15	Pieter, Quinton	t	\N	f
741	25073-10	25073	Buig kop	10	1	25073-8	Gert	t	\N	f
821	25072(b)-2	25072(b)	Plasma 2mm	15	6		Gert	t	\N	f
819	25072(b)-6	25072(b)	Buig 2mm	20	3	25072(b)-2	Gert, Handlanger	t	\N	f
823	25072(b)-7	25072(b)	Saag roundbar	5	1		HSaag,Saag	t	\N	f
825	25072(b)-9	25072(b)	Bou pilaar	1	5	25072(b)-5,25072(b)-6,25072(b)-7,25072(b)-8	James	t	\N	f
827	25072(b)-11	25072(b)	Bou tubing	1	10	25072(b)-4,25072(b)-6,25072(b)-10	Thys	t	\N	f
829	25072(b)-13	25072(b)	Sweis pilaar	1	5	25072(b)-9	Sweis	t	\N	f
831	25072(b)-15	25072(b)	Sweis armpie	1	4	25072(b)-12	Sweis	t	\N	f
833	25072(b)-17	25072(b)	Sit aanmekaar	1	5	25072(b)-16	Wikus, Handlanger	t	\N	f
1229	25143-23	25143	Sny Roundbar	1	2		Groot_guillotine	t	\N	f
1200	25176-5	25176	Grind	0	15	25176-4	Grind	t	\N	f
1247	25195-6	25195	Grind	1	45	25195-5	Grind	t	\N	f
1248	25195-7	25195	Was	15	15	25195-6	Verf	t	\N	f
1246	25195-5	25195	Sweis	1	90	25195-4	Sweis	t	\N	f
1121	25155-6	25155	Sny rubber	0	1		Verf	t	\N	f
1122	25155-7	25155	Verf	0	2	25155-5	Verf	t	\N	f
1123	25155-8	25155	Rubber en boute	0	3	25155-6,25155-7	Verf,Handlanger	t	\N	f
1390	25238(b)-3	25238(b)	Bou raam	1	240	25238(b)-1,25238(b)-2	BouM,Handlanger	t	\N	f
1389	25238(b)-2	25238(b)	Plasma	10	30		Gert	t	\N	f
1388	25238(b)-1	25238(b)	Saag tubing	10	45		HSaag,Saag	t	\N	t
425	25035-40	25035	Sweis ribbes	1	300	25035-30	Sweis, Andrew	t	\N	f
691	25082-10	25082	Plasma tubings	15	570	nan	Wikus	t	2025-05-27 20:09:29.148598	f
695	25091(W)-3	25091(W)	Bou	1	20	25091(W)-1, 25091(W)-2	Gert, Handlanger	t	\N	f
749	25071(b)-1	25071(b)	Plasma 3mm	15	10		Gert	t	\N	f
706	25071-9	25071	Bou pilaar	1	5	25071-5,25071-6,25071-7,25071-8	James	t	\N	f
752	25071(b)-5	25071(b)	Buig 3mm	20	2	25071(b)-1	Gert, Handlanger	t	\N	f
785	25071(d)-3	25071(d)	Saag tubing	10	1		HSaag,Saag	t	\N	f
803	25071(e)-5	25071(e)	Buig 3mm	20	2	25071(e)-1	Gert, Handlanger	t	\N	f
1249	25195-8	25195	Verf	5	45	25195-7	Verf	t	\N	f
1124	25170-1	25170	Plasma 6mm	5	1		Gert	t	\N	f
771	25071(c)-4	25071(c)	Plasma tubing	5	8	25071(c)-3	Gert	t	\N	f
853	25083-13	25083	Grind	1	15	25083-12	Dean, Ruan	t	2025-06-04 17:24:08.029389	f
1125	25170-2	25170	Plasma 8mm	5	1		Gert	t	\N	f
1127	25170-4	25170	Sweis	0	2	25170-3	Sweis	t	\N	f
893	25104-2	25104	Chop Angles	5	2	25104-1	Handlanger	t	\N	f
883	25102-8	25102	Verf	1	5	25102-6	Verf	t	\N	f
884	25103-1	25103	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:26:44.49082	f
871	25101-4	25101	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:26:30.214711	f
877	25102-2	25102	Chop Angles	5	2	25102-1	Handlanger	t	\N	f
862	25100-3	25100	Boor Angles	15	2	25100-1	HBoor, Boor	t	2025-06-04 17:25:56.413688	f
863	25100-4	25100	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:25:49.698164	f
850	25083-10	25083	Sny mesh	5	10		James	t	\N	f
820	25072(b)-1	25072(b)	Plasma 3mm	15	10		Gert	t	\N	f
852	25083-12	25083	Sweis	1	20	25083-11	James	t	2025-06-04 17:24:05.581691	f
854	25083-14	25083	Verf	1	30	25083-13	Pieter	t	2025-06-04 17:24:10.436677	f
855	25097-100	25097	Maak 70x70 sliders	1	5		Thys, Handlanger	t	2025-06-04 17:24:24.509576	f
857	25097-102	25097	Skuif lugs	1	10		Wikus	t	2025-06-04 17:24:26.652022	f
856	25097-101	25097	Maak vingers	1	10		Wikus, Handlanger	t	2025-06-04 17:24:29.171471	f
858	25097-110	25097	Grind	1	10	25097-100, 25097-101, 25097-102	Grind	t	2025-06-04 17:24:31.333878	f
859	25097-120	25097	Verf	1	15	25097-110	Verf	t	2025-06-04 17:24:35.508645	f
844	25096-1	25096	Strip	5	30		Handlanger	t	\N	f
867	25100-8	25100	Verf	1	5	25100-6	Verf	t	\N	f
866	25100-7	25100	Sit aanmekaar en sweis	5	5	25100-2, 25100-3, 25100-4, 25100-5	BouK	t	\N	f
860	25100-1	25100	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:25:47.536211	f
847	25096-4	25096	Sweis	1	45	25096-3	Andrew	t	\N	f
872	25101-5	25101	Plasma	5	1		Gert	t	\N	f
875	25101-8	25101	Verf	1	5	25101-6	Verf	t	\N	f
881	25102-6	25102	Grind	1	3	25102-7	Grind	t	\N	f
882	25102-7	25102	Sit aanmekaar en sweis	5	5	25102-2, 25102-3, 25102-4, 25102-5	BouK	t	\N	f
888	25103-5	25103	Plasma	5	1		Gert	t	\N	f
890	25103-7	25103	Sit aanmekaar en sweis	5	5	25103-2, 25103-3, 25103-4, 25103-5	BouK	t	\N	f
822	25072(b)-4	25072(b)	Plasma tubing	5	8	25072(b)-3	Gert	t	\N	f
824	25072(b)-8	25072(b)	Plasma 6mm	15	1		Gert	t	\N	f
826	25072(b)-10	25072(b)	Buig kop	10	1	25072(b)-8	Gert	t	\N	f
828	25072(b)-12	25072(b)	Bou armpie	1	5	25072(b)-6,25072(b)-8	Wikus	t	\N	f
830	25072(b)-14	25072(b)	Sweis tubing	1	3	25072(b)-11	Sweis	t	\N	f
832	25072(b)-16	25072(b)	Verf	1	10	25072(b)-13, 25072(b)-14, 25072(b)-15	Pieter, Quinton	t	\N	f
836	25098-10	25098	Sny plaatparte	5	15	nan	Groot_guillotine, Gert	t	\N	f
842	25098-400	25098	Sweis bins	1	20	25098-300	Sweis, Andrew	t	\N	f
837	25098-300	25098	Bou bins	30	20	25098-30, 25098-100, 25098-210	Gert	t	\N	f
839	25098-500	25098	Grind bins	1	15	25098-400	Grind, Fernando, Dean	t	\N	f
840	25098-600	25098	Verf bins	1	30	25098-500	Pieter	t	\N	f
841	25098-200	25098	Sny voete plate	5	2	nan	Groot_guillotine, Quinton	t	\N	f
834	25098-20	25098	Corrugate parte	10	10	25098-10	Gert, Andrew	t	\N	f
864	25100-5	25100	Plasma	5	1		Gert	t	2025-06-04 17:25:59.224985	f
845	25096-2	25096	Deurgaan	1	10	25096-1	Wikus	t	\N	f
861	25100-2	25100	Chop Angles	5	2	25100-1	Handlanger	t	2025-06-04 17:25:54.475091	f
848	25096-5	25096	Verf	10	60	25096-4	Pieter, Quinton	t	\N	f
846	25096-3	25096	Regmaak	10	60	25096-2	Gert, Andrew	t	\N	f
873	25101-6	25101	Grind	1	3	25101-7	Grind	t	\N	f
869	25101-2	25101	Chop Angles	5	2	25101-1	Handlanger	t	\N	f
868	25101-1	25101	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:26:28.278367	f
870	25101-3	25101	Boor Angles	15	2	25101-1	HBoor, Boor	t	\N	f
874	25101-7	25101	Sit aanmekaar en sweis	5	5	25101-2, 25101-3, 25101-4, 25101-5	BouK	t	\N	f
878	25102-3	25102	Boor Angles	15	2	25102-1	HBoor, Boor	t	\N	f
876	25102-1	25102	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:26:36.048409	f
880	25102-5	25102	Plasma	5	1		Gert	t	\N	f
879	25102-4	25102	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:26:37.995293	f
886	25103-3	25103	Boor Angles	15	2	25103-1	HBoor, Boor	t	\N	f
885	25103-2	25103	Chop Angles	5	2	25103-1	Handlanger	t	\N	f
887	25103-4	25103	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:26:46.471695	f
891	25103-8	25103	Verf	1	5	25103-6	Verf	t	\N	f
892	25104-1	25104	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:26:52.164421	f
894	25104-3	25104	Boor Angles	15	2	25104-1	HBoor, Boor	t	\N	f
899	25104-8	25104	Verf	1	5	25104-6	Verf	t	\N	f
902	25105-3	25105	Boor Angles	15	2	25105-1	HBoor, Boor	t	\N	f
907	25105-7	25105	Sit aanmekaar en sweis	5	5	25105-2, 25105-3, 25105-4, 25105-5	BouK	t	\N	f
910	25106-1	25106	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:27:07.949339	f
915	25106-4	25106	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:27:09.632082	f
918	25107-3	25107	Boor Angles	15	2	25107-1	HBoor, Boor	t	\N	f
923	25107-8	25107	Verf	1	5	25107-6	Verf	t	\N	f
1230	25143-24	25143	20Rond Boor	2	5	25143-4	Boor,HBoor	t	\N	f
1128	25170-5	25170	Grind	0	2	25170-4	Handlanger,Grind	t	\N	f
1129	25170-6	25170	Sny rubber	0	1		Verf	t	\N	f
1130	25170-7	25170	Verf	0	2	25170-5	Verf	t	\N	f
1131	25170-8	25170	Rubber en boute	0	3	25170-6,25170-7	Verf,Handlanger	t	\N	f
1391	25238(b)-4	25238(b)	Sweis raam	1	180	25238(b)-3	Sweis	t	\N	f
1397	25238(b)-10	25238(b)	Stuur vir shotblast	1	10	25238(b)-9	James	t	\N	f
1392	25238(b)-5	25238(b)	Bou bykomstighede	1	120	25238(b)-1,25238(b)-2	BouM,Handlanger	t	\N	f
1201	25176-6	25176	Verf	0	10	25176-5	Verf	t	\N	t
1251	25188-2	25188	Plasma 4mm	10	0.5		Gert	t	\N	f
1256	25188-1	25188	Saag tubing	10	1		HSaag,Saag	t	\N	t
1257	25188-3	25188	Sny end caps	5	0.5		Groot_guillotine,HSaag	t	\N	f
1258	25188-4	25188	Sit aanmekaar	0	2	25188-1,25188-9,25188-3	BouK	t	\N	f
1253	25188-6	25188	Grind	0	5	25188-5	Grind,Handlanger	t	\N	t
1254	25188-7	25188	Verf	0	2	25188-6	Verf	t	\N	f
1255	25188-8	25188	Sit boute in	0	1	25188-7	Verf	t	\N	f
1250	25188-9	25188	Buig 4mm	5	1	25188-2	HBuig	t	\N	f
1252	25188-5	25188	Sweis	0	3	25188-4	Sweis	t	\N	f
1393	25238(b)-6	25238(b)	Sweis bykomstighede	1	60	25238(b)-5	Sweis	t	\N	f
1394	25238(b)-7	25238(b)	Sit als aanmekaar	10	60	25238(b)-4,25238(b)-6	BouM,Handlanger	t	\N	f
1395	25238(b)-8	25238(b)	Sweis finaal	1	60	25238(b)-7	Sweis	t	\N	f
1396	25238(b)-9	25238(b)	Grind	1	60	25238(b)-8	Handlanger,Grind	t	\N	f
428	25035-420	25035	Sweis flappe	1	30	25035-400	Sweis	t	\N	f
889	25103-6	25103	Grind	1	3	25103-7	Grind	t	\N	f
895	25104-4	25104	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:26:53.862369	f
900	25105-1	25105	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:27:00.459981	f
905	25105-5	25105	Plasma	5	1		Gert	t	\N	f
908	25106-3	25106	Boor Angles	15	2	25106-1	HBoor, Boor	t	\N	f
913	25106-6	25106	Grind	1	3	25106-7	Grind	t	\N	f
916	25107-1	25107	Sny Angles	5	2		Saag, HSaag	t	2025-06-04 17:27:14.310796	f
921	25107-5	25107	Plasma	5	1		Gert	t	\N	f
1103	25143-19	25143	Verf	1	50	25143-25	Verf	t	\N	f
1132	25181-1	25181	Plasma 6mm	5	1		Gert	t	\N	f
1133	25181-2	25181	Plasma 8mm	5	1		Gert	t	\N	f
1136	25181-5	25181	Grind	0	2	25181-4	Handlanger,Grind	t	\N	f
1137	25181-6	25181	Sny rubber	0	1		Verf	t	\N	f
1138	25181-7	25181	Verf	0	2	25181-5	Verf	t	\N	f
1139	25181-8	25181	Rubber en boute	0	3	25181-6,25181-7	Verf,Handlanger	t	\N	f
1135	25181-4	25181	Sweis	0	2	25181-3	Sweis	t	\N	f
1134	25181-3	25181	Sit aanmekaar	10	2	25181-1,25181-2	BouM	t	\N	f
1399	25241-1	25241	Plasma	5	3		Gert	t	\N	f
1400	25241-2	25241	Saag tubing	10	1		HSaag,Saag	t	\N	f
1489	25273-430	25273	Sweis onderstel	1	20	25273-410	Sweis	f	\N	f
1490	25273-410	25273	Bou onderstel	15	60	25273-20	Gert	f	\N	f
1491	25273-200	25273	Sweis raam	1	300	25273-100	Sweis, Andrew	f	\N	f
1202	25177-1	25177	Pak in boks	0	1		Verf	t	\N	f
1260	25189-2	25189	Plasma 8mm	5	1		Gert	t	\N	f
1261	25189-3	25189	Sit aanmekaar	10	2	25189-1,25189-2	BouM	t	\N	f
1262	25189-4	25189	Sweis	0	2	25189-3	Sweis	t	\N	f
1259	25189-1	25189	Plasma 6mm	5	1		Gert	t	\N	f
1264	25189-6	25189	Sny rubber	0	1		Verf	t	\N	t
1263	25189-5	25189	Grind	0	2	25189-4	Handlanger,Grind	t	\N	f
1266	25189-8	25189	Rubber en boute	0	3	25189-6,25189-7	Verf,Handlanger	t	\N	f
1265	25189-7	25189	Verf	0	2	25189-5	Verf	t	\N	f
1492	25273-400	25273	Bou flappe	10	120	25273-12	Gert	f	\N	f
1494	25273-600	25273	Verf raam	20	510	25273-500	Verf	f	\N	f
1495	25273-10	25273	Plasma tubings	15	570	nan	Wikus	f	\N	f
1496	25273-500	25273	Sit raam aanmekaar	1	60	25273-300,25273-420,25273-430	Wikus	f	\N	f
1497	25273-300	25273	Sit grating op	1	180	25273-200	Wikus	f	\N	f
1498	25273-12	25273	Sny plaatparte	10	45	nan	Gert	f	\N	f
1499	25273-20	25273	Saag tubing	30	360	nan	Saag,HSaag	f	\N	f
1500	25273-100	25273	Bou raam	45	360	25273-50	Wikus	f	\N	f
1502	25273-30	25273	Bou ribbes	30	510	25273-11,25273-20	Gert	f	\N	f
1503	25273-40	25273	Sweis ribbes	1	300	25273-30	Sweis, Andrew	f	\N	f
1504	25273-420	25273	Sweis flappe	1	30	25273-400	Sweis	f	\N	f
1493	25273-50	25273	Grind ribbes	1	180	25273-40	Grind, Renier, Ethan	f	\N	f
1501	25273-11	25273	Grind plasma tubes	1	180	25273-10	Grind, Renier, Ethan	f	\N	f
896	25104-5	25104	Plasma	5	1		Gert	t	\N	f
901	25105-2	25105	Chop Angles	5	2	25105-1	Handlanger	t	\N	f
906	25105-6	25105	Grind	1	3	25105-7	Grind	t	\N	f
912	25106-2	25106	Chop Angles	5	2	25106-1	Handlanger	t	\N	f
917	25107-4	25107	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:27:16.052379	f
922	25107-7	25107	Sit aanmekaar en sweis	5	5	25107-2, 25107-3, 25107-4, 25107-5	BouK	t	\N	f
1142	25160-1	25160	Plasma	15	30		Gert	t	\N	f
1143	25160-2	25160	Buig parte	15	30	25160-1	James, Handlanger	t	\N	f
1231	25143-25	25143	Was	5	30	25143-18	Verf	t	\N	f
1145	25160-4	25160	Rol	15	120	25160-1	Gert, Handlanger	t	\N	f
1144	25160-3	25160	Buig kegel	15	60	25160-1	Gert, Handlanger	t	\N	f
1146	25160-5	25160	Bou	15	120	25160-2,25160-3,25160-4	Wikus, Vince	t	\N	f
1147	25160-6	25160	Sweis	1	120	25160-5	Andrew	t	\N	f
1140	25160-8	25160	Modifikasie (deurtjie)	1	240	25160-7	Wikus	t	\N	f
1148	25160-7	25160	Grind	1	60	25160-6	Ruan	t	\N	f
1274	25190-26	25190	Sweis ander parte	1	120	25190-25	Sweis	t	\N	f
1141	25160-9	25160	Verf	15	120	25160-8	Quinton, Pieter	t	\N	f
1273	25190-27	25190	Grind ander parte	1	120	25190-26	Grind	t	\N	f
1275	25190-3	25190	Saag	10	510		Saag1, Saag2, HSaag	t	\N	f
1277	25190-28	25190	Verf ander parte	1	120	25190-27	Verf	t	\N	f
1276	25190-30	25190	Vasbout en nagaan	1	120	25190-8,25190-18,25190-28	Wikus, Handlanger	t	\N	f
1278	25190-4	25190	Boor	1	240	25190-3	Boor, HBoor	t	\N	f
1512	25293-9	25293	Verf	1	15	25293-8	Pieter,Quintin	f	\N	f
1279	25190-7	25190	Grind struktuur	1	60	25190-6	Grind	t	\N	t
1280	25190-5	25190	Bou struktuur	1	240	25190-2,25190-4	Wikus, Handlanger	t	\N	t
1282	25190-6	25190	Sweis struktuur	1	180	25190-5	Sweis	t	\N	t
1281	25190-8	25190	Verf struktuur	1	120	25190-7	Verf	t	\N	f
1511	25293-8	25293	Grind	1	10	25293-12	JP, Grind, Handlanger	f	\N	f
1508	25293-4	25293	Buig dek	15	2	25293-3	James, Handlanger	f	\N	f
1507	25293-5	25293	Buig voete	15	3	25293-2	James, Handlanger	f	\N	f
1203	25178-1	25178	Skuur pallets	0	5		Grind,Handlanger	t	\N	f
1268	25190-1	25190	Plasma	30	900		Gert	t	\N	f
1270	25190-17	25190	Grind feedbox	1	60	25190-16	Grind	t	\N	f
1267	25190-16	25190	Sweis feedbox	1	120	25190-15	Sweis	t	\N	f
1269	25190-15	25190	Bou feedbox	1	120	25190-2,25190-4	Wikus, Handlanger	t	\N	f
1271	25190-18	25190	Verf feedbox	1	60	25190-17	Verf	t	\N	f
1283	25190-2	25190	Buig	1	540	25190-1	James, Promecam, Handlanger	t	\N	t
1272	25190-25	25190	Bou ander parte	1	180	25190-2,25190-4	Wikus, Handlanger	t	\N	f
1509	25293-6	25293	Bou	20	10	25293-4,25293-5	Gert,Handlanger	f	\N	f
1510	25293-7	25293	Sweis	1	10	25293-6	Andrew,Sweis	f	\N	f
1401	25241-3	25241	Sit aanmekaar	10	10	25241-1,25241-2	BouM	t	\N	f
1402	25241-4	25241	Sweis	1	15	25241-5	Sweis	t	\N	f
1403	25241-5	25241	Check M16 deur gate	1	3	25241-3	Gert	t	\N	f
1505	25293-3	25293	Corrugate dek	5	3	25293-1	Gert, Handlanger	f	\N	f
1506	25293-2	25293	Sny voete	10	2		Gert, Handlanger, Groot_guillotine	f	\N	f
1513	25293-1	25293	Sny Dek	10	2		Gert, Handlanger, Groot_guillotine	f	\N	f
897	25104-6	25104	Grind	1	3	25104-7	Grind	t	\N	f
903	25105-8	25105	Verf	1	5	25105-6	Verf	t	\N	f
911	25106-5	25106	Plasma	5	1		Gert	t	\N	f
919	25107-6	25107	Grind	1	3	25107-7	Grind	t	\N	f
1150	25165-210	25165	Press voete	30	1	25165-200	Quinton	t	\N	f
1149	25165-20	25165	Corrugate parte	10	10	25165-10	Gert, Andrew	t	\N	f
1153	25165-30	25165	Buig parte	15	10	25165-20	Gert, Andrew	t	\N	f
1152	25165-300	25165	Bou bins	30	20	25165-30,25165-100,25165-210	Gert	t	\N	f
1157	25165-400	25165	Sweis bins	1	20	25165-300	Sweis, Andrew	t	\N	f
1154	25165-500	25165	Grind bins	1	15	25165-400	Grind, Renier, Hendré	t	\N	f
1151	25165-10	25165	Sny plaatparte	5	15		Groot_guillotine, Gert	t	\N	f
1158	25165-100	25165	Saag bene	5	5		Saag, HSaag	t	\N	f
1156	25165-200	25165	Sny voete plate	5	2		Groot_guillotine, Quinton	t	\N	f
1155	25165-600	25165	Verf bins	1	30	25165-500	Pieter	t	\N	f
1126	25170-3	25170	Sit aanmekaar	10	2	25170-1,25170-2	BouM	t	\N	f
1522	25294-300	25294	Sit grating op	1	180	25294-200	Wikus	t	\N	f
1521	25294-500	25294	Sit raam aanmekaar	1	60	25294-300,25294-420,25294-430	Wikus	t	\N	f
1519	25294-600	25294	Verf raam	20	510	25294-500	Verf,Verflyn	t	\N	f
1404	25241-6	25241	Grind	1	10	25241-4	Grind	t	\N	f
1405	25241-7	25241	Was	1	3	25241-6	Verf	t	\N	f
1406	25241-8	25241	Verf	1	3	25241-7	Verf	t	\N	f
1204	25178-2	25178	Sny rubber	10	16		Grind,Handlanger	t	\N	f
1287	25196-3	25196	Buig kegel	15	180	25196-1	Gert, Handlanger	t	\N	t
1284	25196-1	25196	Plasma	15	30		Gert	t	\N	f
1285	25196-2	25196	Buig parte	15	30	25196-1	James, Handlanger	t	\N	t
1286	25196-4	25196	Rol	15	90	25196-1	Gert, Handlanger	t	\N	t
1288	25196-5	25196	Bou	15	120	25196-2,25196-3,25196-4	Wikus, Vince	t	\N	t
1289	25196-6	25196	Sweis	1	120	25196-5	Andrew	t	\N	f
1291	25196-7	25196	Grind	1	60	25196-6	Ruan	t	\N	f
1292	25196-9	25196	Verf	15	120	25196-8	Quintin, Pieter	t	\N	f
1290	25196-8	25196	Modifikasie (deurtjie)	1	240	25196-7	Wikus	t	\N	f
1524	25294-20	25294	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
1520	25294-10	25294	Plasma tubings	15	570	nan	Wikus	t	\N	f
1523	25294-12	25294	Sny plaatparte	10	45	nan	Gert	t	\N	f
1517	25294-400	25294	Bou flappe	10	120	25294-12	Gert	t	\N	f
1529	25294-420	25294	Sweis flappe	1	30	25294-400	Sweis	t	\N	f
1515	25294-410	25294	Bou onderstel	15	60	25294-20	Gert	t	\N	f
1514	25294-430	25294	Sweis onderstel	1	20	25294-410	Sweis	t	\N	f
1526	25294-11	25294	Grind plasma tubes	1	180	25294-10	Grind, Renier, Hendré	t	\N	f
1527	25294-30	25294	Bou ribbes	30	510	25294-11,25294-20	Gert	t	\N	f
1528	25294-40	25294	Sweis ribbes	1	300	25294-30	Sweis, Andrew	t	\N	f
1518	25294-50	25294	Grind ribbes	1	180	25294-40	Grind, Renier, Hendré	t	\N	f
1525	25294-100	25294	Bou raam	45	360	25294-50	Wikus	t	\N	f
1516	25294-200	25294	Sweis raam	1	300	25294-100	Sweis, Andrew	t	\N	f
920	25107-2	25107	Chop Angles	5	2	25107-1	Handlanger	t	\N	f
929	25112-6	25112	Verf	1	30	25112-5	Verf	t	2025-06-04 17:27:32.670423	f
932	25113-3	25113	Verf	1	10	25113-2	Verf	t	2025-06-04 17:27:37.536463	f
760	25071(b)-13	25071(b)	Sweis pilaar	1	5	25071(b)-9	Sweis	t	\N	f
682	25082-420	25082	Sweis flappe	1	30	25082-400	Sweis	t	\N	f
851	25083-11	25083	Sit mesh en slotte op	1	30	25083-10	James	t	\N	f
946	25109-16	25109	Sweis feedbox	1	120	25109-15	Sweis	t	\N	f
954	25110-2	25110	Buig	1	540	25110-1	Promecam,Handlanger,Wikus	t	\N	f
957	25110-4	25110	Boor	1	240	25110-3	Boor, HBoor	t	\N	f
970	25110-30	25110	Vasbout en nagaan	1	120	25110-8, 25110-18, 25110-28	Wikus, Handlanger	t	\N	f
925	25112-2	25112	Saag tubings	5	5		Saag, HSaag	t	2025-06-04 17:27:22.972768	f
926	25112-3	25112	Boor tubings	5	10	25112-2	Boor, HBoor	t	2025-06-04 17:27:24.781107	f
924	25112-1	25112	Plasma	5	10		Gert	t	2025-06-04 17:27:27.429775	f
927	25112-4	25112	Buig channel	5	5	25112-1	James	t	2025-06-04 17:27:29.313059	f
928	25112-5	25112	Bou & sweis	1	30	25112-3, 25112-4	James	t	2025-06-04 17:27:30.976908	f
930	25113-1	25113	Saag	5	5		Saag, HSaag	t	2025-06-04 17:27:34.414895	f
931	25113-2	25113	Buig	1	10	25113-1	Wikus	t	2025-06-04 17:27:35.835909	f
933	25114-1	25114	Saag	5	5		Saag, HSaag	t	2025-06-04 17:27:38.939049	f
935	25114-2	25114	Buig	1	10	25114-1	Wikus	t	2025-06-04 17:27:44.019143	f
934	25114-3	25114	Verf	1	10	25114-2	Verf	t	2025-06-04 17:27:48.409313	f
936	25115-1	25115	Guillotine	5	1		Vince	t	2025-06-04 17:27:52.874615	f
972	25099-1	25099	Plasma	30	900		Gert	t	\N	f
979	25099-15	25099	Bou feedbox	1	120	25099-2, 25099-4	Wikus, Handlanger	t	\N	f
980	25099-16	25099	Sweis feedbox	1	120	25099-15	Sweis	t	\N	f
971	25099-2	25099	Buig	1	540	25099-1	James, Promecam, Handlanger	t	\N	f
984	25099-26	25099	Sweis ander parte	1	120	25099-25	Sweis	t	\N	f
986	25099-28	25099	Verf ander parte	1	120	25099-27	Verf	t	\N	f
985	25099-27	25099	Grind ander parte	1	120	25099-26	Grind	t	\N	f
973	25099-3	25099	Saag	10	510		Saag1, Saag2, HSaag	t	\N	f
987	25099-30	25099	Vasbout en nagaan	1	120	25099-8, 25099-18, 25099-28	Wikus, Handlanger	t	\N	f
974	25099-4	25099	Boor	1	240	25099-3	Boor, HBoor	t	\N	f
976	25099-6	25099	Sweis struktuur	1	180	25099-5	Sweis	t	\N	f
977	25099-7	25099	Grind struktuur	1	60	25099-6	Grind	t	\N	f
975	25099-5	25099	Bou struktuur	1	240	25099-2, 25099-4	Wikus, Handlanger	t	\N	f
981	25099-17	25099	Grind feedbox	1	60	25099-16	Grind	t	\N	f
898	25104-7	25104	Sit aanmekaar en sweis	5	5	25104-2, 25104-3, 25104-4, 25104-5	BouK	t	\N	f
909	25106-7	25106	Sit aanmekaar en sweis	5	5	25106-2, 25106-3, 25106-4, 25106-5	BouK	t	\N	f
914	25106-8	25106	Verf	1	5	25106-6	Verf	t	\N	f
937	25109-1	25109	Plasma	30	900		Gert	t	\N	f
945	25109-15	25109	Bou feedbox	1	120	25109-2, 25109-4	Wikus, Handlanger	t	\N	f
947	25109-17	25109	Grind feedbox	1	60	25109-16	Grind	t	\N	f
948	25109-18	25109	Verf feedbox	1	60	25109-17	Verf	t	\N	f
949	25109-25	25109	Bou ander parte	1	180	25109-2, 25109-4	Wikus, Handlanger	t	\N	f
951	25109-27	25109	Grind ander parte	1	120	25109-26	Grind	t	\N	f
950	25109-26	25109	Sweis ander parte	1	120	25109-25	Sweis	t	\N	f
939	25109-3	25109	Saag	10	510		Saag1, Saag2, HSaag	t	\N	f
953	25109-30	25109	Vasbout en nagaan	1	120	25109-8, 25109-18, 25109-28	Wikus, Handlanger	t	\N	f
952	25109-28	25109	Verf ander parte	1	120	25109-27	Verf	t	\N	f
940	25109-4	25109	Boor	1	240	25109-3	Boor, HBoor	t	\N	f
943	25109-7	25109	Grind struktuur	1	60	25109-6	Grind	t	\N	f
941	25109-5	25109	Bou struktuur	1	240	25109-2, 25109-4	Wikus, Handlanger	t	\N	f
944	25109-8	25109	Verf struktuur	1	120	25109-7	Verf	t	\N	f
942	25109-6	25109	Sweis struktuur	1	180	25109-5	Sweis	t	\N	f
989	25116-2	25116	Plasma	15	60		Gert	t	\N	f
988	25116-1	25116	Saag Tubing	15	180		Saag1, Saag2, HSaag	t	\N	f
956	25110-3	25110	Saag	10	510		Saag1, Saag2, HSaag	t	\N	f
1205	25178-3	25178	Plak rubber	0	8	25178-1,25178-2	Verf,Handlanger	t	\N	f
1293	25192-1	25192	Strip	1	3		Gerrie,Ethan	t	\N	f
966	25110-25	25110	Bou ander parte	1	180	25110-2, 25110-4	Wikus, Handlanger	t	\N	f
961	25110-8	25110	Verf struktuur	1	120	25110-7	Verf	t	\N	t
964	25110-17	25110	Grind feedbox	1	60	25110-16	Grind	t	\N	f
1159	25171-1	25171	Saag pyp	10	1		HSaag,Saag	t	\N	f
967	25110-26	25110	Sweis ander parte	1	120	25110-25	Sweis	t	\N	f
955	25110-1	25110	Plasma	30	900		Gert	t	\N	f
1407	25244-2	25244	Deurgaan	1	10	25244-1	Wikus	t	\N	t
965	25110-18	25110	Verf feedbox	1	60	25110-17	Verf	t	\N	f
969	25110-28	25110	Verf ander parte	1	120	25110-27	Verf	t	\N	f
963	25110-16	25110	Sweis feedbox	1	120	25110-15	Sweis	t	\N	f
958	25110-5	25110	Bou struktuur	1	240	25110-2, 25110-4	Wikus, Handlanger	t	\N	f
959	25110-6	25110	Sweis struktuur	1	180	25110-5	Sweis	t	\N	t
960	25110-7	25110	Grind struktuur	1	60	25110-6	Grind	t	\N	t
992	25116-5	25116	Grind	1	90	25116-4	Grind	t	\N	f
990	25116-3	25116	Bou	30	180	25116-1, 25116-2	Moeilik, Handlanger	t	\N	f
1206	25179-1	25179	Skuur pallets	0	5		Grind,Handlanger	t	\N	f
1160	25171-2	25171	Plasma 4mm	10	0.25		Gert	t	\N	f
1207	25179-2	25179	Sny rubber	10	16		Grind,Handlanger	t	\N	f
1208	25179-3	25179	Plak rubber	0	8	25179-1,25179-2	Verf,Handlanger	t	\N	f
1294	25192-2	25192	Plasma	5	3	25192-1	Gert,Grind	t	\N	f
1410	25244-4	25244	Sweis	1	45	25244-3	Andrew	t	\N	t
1409	25244-3	25244	Regmaak	10	60	25244-2	Gert, Andrew	t	\N	t
1539	25295-12	25295	Sny plaatparte	10	45	nan	Gert	t	\N	f
1533	25295-400	25295	Bou flappe	10	120	25295-12	Gert	t	\N	f
1545	25295-420	25295	Sweis flappe	1	30	25295-400	Sweis	t	\N	f
1536	25295-10	25295	Plasma tubings	15	570	nan	Wikus	t	\N	f
1540	25295-20	25295	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
1542	25295-11	25295	Grind plasma tubes	1	180	25295-10	Grind, Renier, Hendré	t	\N	f
1543	25295-30	25295	Bou ribbes	30	510	25295-11,25295-20	Gert	t	\N	f
1531	25295-410	25295	Bou onderstel	15	60	25295-20	Gert	t	\N	f
1530	25295-430	25295	Sweis onderstel	1	20	25295-410	Sweis	t	\N	f
1544	25295-40	25295	Sweis ribbes	1	300	25295-30	Sweis, Andrew	t	\N	f
1534	25295-50	25295	Grind ribbes	1	180	25295-40	Grind, Renier, Hendré	t	\N	f
1541	25295-100	25295	Bou raam	45	360	25295-50	Wikus	t	\N	f
1538	25295-300	25295	Sit grating op	1	180	25295-200	Wikus	t	\N	f
1535	25295-600	25295	Verf raam	20	510	25295-500	Verf,Verflyn	f	\N	f
1537	25295-500	25295	Sit raam aanmekaar	1	60	25295-300,25295-420,25295-430	Wikus	f	\N	f
1532	25295-200	25295	Sweis raam	1	300	25295-100	Sweis, Andrew	t	\N	f
991	25116-4	25116	Sweis	15	180	25116-3	Sweis	t	\N	f
1209	25182-1	25182	Plasma 4.5mm	10	0.5		Gert	t	\N	f
1210	25182-2	25182	Skoonmaak	0	0.5	25182-1	Grind	t	\N	f
1211	25182-3	25182	Press	30	1	25182-2	Quinton	t	\N	f
1162	25171-4	25171	Sweis	0	10	25171-3	Sweis	t	\N	f
1161	25171-3	25171	Bou paal	10	6	25171-1,25171-2	BouM	t	\N	f
1295	25192-3	25192	Grind	1	1	25192-2	Grind,Ethan,Louis	t	\N	f
1413	25248-1	25248	Plasma	5	1		Gert	t	\N	f
1416	25248-4	25248	Was	1	1	25248-3	Verf	t	\N	f
1415	25248-3	25248	Countersink	5	1	25248-2	HBoor	t	\N	f
1417	25248-5	25248	Verf	1	1	25248-4	Verf	t	\N	f
1414	25248-2	25248	Buig	5	1	25248-1	HBuig	t	\N	f
1555	25306-12	25306	Sny plaatparte	10	45	nan	Gert	t	\N	f
1549	25306-400	25306	Bou flappe	10	120	25306-12	Gert	t	\N	f
1561	25306-420	25306	Sweis flappe	1	30	25306-400	Sweis	t	\N	f
1556	25306-20	25306	Saag tubing	30	360	nan	Saag,HSaag	t	\N	f
1552	25306-10	25306	Plasma tubings	15	570	nan	Wikus	t	\N	f
1547	25306-410	25306	Bou onderstel	15	60	25306-20	Gert	t	\N	f
1546	25306-430	25306	Sweis onderstel	1	20	25306-410	Sweis	t	\N	f
1558	25306-11	25306	Grind plasma tubes	1	180	25306-10	Grind, Renier, Hendré	t	\N	f
1559	25306-30	25306	Bou ribbes	30	510	25306-11,25306-20	Gert	t	\N	f
1560	25306-40	25306	Sweis ribbes	1	300	25306-30	Sweis, Andrew	t	\N	f
1550	25306-50	25306	Grind ribbes	1	180	25306-40	Grind, Renier, Hendré	t	\N	f
1557	25306-100	25306	Bou raam	45	360	25306-50	Wikus	t	\N	f
1548	25306-200	25306	Sweis raam	1	300	25306-100	Sweis, Andrew	t	\N	f
1554	25306-300	25306	Sit grating op	1	180	25306-200	Wikus	t	\N	f
1553	25306-500	25306	Sit raam aanmekaar	1	60	25306-300,25306-420,25306-430	Wikus	t	\N	f
1551	25306-600	25306	Verf raam	20	510	25306-500	Verf,Verflyn	f	\N	f
1018	25121-25	25121	Grind deksel	1	60	25121-22	Grind	t	\N	f
994	25119-1	25119	Saag raam	10	45		Saag, HSaag	f	\N	f
995	25119-2	25119	Bou raam	15	60	25119-1	Maklik	f	\N	f
996	25119-3	25119	Plasma	5	20		Gert	f	\N	f
997	25119-4	25119	Saag parte	10	30		Saag, HSaag	f	\N	f
998	25119-5	25119	Sweis raam	5	60	25119-2	Sweis	f	\N	f
999	25119-6	25119	Grind raam	1	30	25119-5	Grind	f	\N	f
1000	25119-7	25119	Bou klaar	10	60	25119-3, 25119-4, 25119-6	Moeilik	f	\N	f
1001	25119-8	25119	Sweis klaar	1	60	25119-7	Sweis	f	\N	f
1002	25119-9	25119	Grind	1	30	25119-8	Grind	f	\N	f
1003	25119-10	25119	Verf	1	60	25119-9	Verf	f	\N	f
1004	25119-11	25119	Rubber, penne ens	1	30	25119-10	Verf	f	\N	f
1019	25121-30	25121	Was vir shotblast	1	60	25121-5, 25121-15, 25121-25	Verf	t	\N	f
1008	25121-2	25121	Sweis tenk	1	240	25121-1	Thys	t	\N	f
1021	25125-2	25125	Plasma 4.5	5	1		Gert	t	\N	f
1013	25121-11	25121	Sweis conservator	1	60	25121-10	Thys	t	\N	f
774	25071(c)-9	25071(c)	Bou pilaar	1	5	25071(c)-5,25071(c)-6,25071(c)-7,25071(c)-8	James	t	2025-06-04 17:15:43.420396	f
1010	25121-4	25121	Sweis tenk klaar	1	180	25121-3	Thys	t	\N	f
1029	25111-1	25111	Sit aanmekaar	1	30		James	t	\N	f
1030	25124-1	25124	Saag 100x50	5	5		Saag, HSaag	t	\N	f
1031	25124-2	25124	Saag 76x38	5	15		Saag, HSaag	t	\N	f
780	25071(c)-16	25071(c)	Verf	1	10	25071(c)-13, 25071(c)-14, 25071(c)-15	Pieter, Quinton	t	\N	f
1039	24367-601	24367	Inspeksie	0	5	24367-600	Wikus	t	\N	f
730	25072-16	25072	Verf	1	10	25072-13, 25072-14, 25072-15	Pieter, Quinton	t	\N	f
843	25098-100	25098	Saag bene	5	5	nan	Saag, HSaag	t	\N	f
744	25073-13	25073	Sweis pilaar	1	5	25073-9	Sweis	t	\N	f
736	25073-2	25073	Plasma 2mm	15	6		Gert	t	\N	f
737	25073-4	25073	Plasma tubing	5	8	25073-3	Gert	t	\N	f
667	25076-8	25076	Sit tilter aanmekaar	1	60	25076-4, 25076-6, 25076-7	Gert, Handlanger	t	2025-06-04 17:23:52.161462	f
668	25076-9	25076	Sweis tilter	1	30	25076-7	Sweis	t	2025-06-04 17:23:32.116351	f
835	25098-210	25098	Press voete	30	1	25098-200	Quinton	t	\N	f
838	25098-30	25098	Buig parte	15	10	25098-20	Gert, Andrew	t	\N	f
865	25100-6	25100	Grind	1	3	25100-7	Grind	t	\N	f
982	25099-18	25099	Verf feedbox	1	60	25099-17	Verf	t	\N	f
1032	25124-3	25124	Sny rubber	5	10		Quinton	t	\N	f
1034	25124-5	25124	Grind	1	10	25124-4	Grind	t	\N	f
1035	25124-6	25124	Verf	1	20	25124-5	Verf	t	\N	f
1036	25124-7	25124	Plak rubber	1	15	25124-3, 25124-6	Verf	t	\N	f
1296	25192-4	25192	Boor tube	10	1	25192-1	James,Louis,Magiel	t	\N	f
1051	25122-2	25122	Sit op trollie	0	30	25122-1	BouG,Handlanger	f	\N	f
983	25099-25	25099	Bou ander parte	1	180	25099-2, 25099-4	Wikus, Handlanger	t	\N	f
978	25099-8	25099	Verf struktuur	1	120	25099-7	Verf	t	\N	f
904	25105-4	25105	Saag pyp	5	2		Saag, HSaag	t	2025-06-04 17:27:03.1742	f
938	25109-2	25109	Buig	1	540	25109-1	James, Promecam, Handlanger	t	\N	f
993	25116-6	25116	Verf	1	120	25116-5	Verf	t	\N	f
1005	25120-1	25120	Sit basisplaat op	1	15		Maklik, Sweis	t	\N	f
1006	25120-2	25120	Verf Geel	1	15	25120-1	Verf	t	\N	f
1007	25121-1	25121	Tack tenk	1	150		Moeilik, Handlanger	t	\N	f
1012	25121-10	25121	Tack conservator	1	60		Moeilik, Handlanger	t	\N	f
1017	25121-22	25121	Sit studs op	1	240	25121-21	Wikus	t	\N	f
1016	25121-21	25121	Sweis deksel	1	60	25121-20	Thys	t	\N	f
1009	25121-3	25121	Sit parte op tenk	1	150	25121-2	Moeilik, Handlanger	t	\N	f
1011	25121-5	25121	Grind tenk	1	120	25121-4	Grind	t	\N	f
1014	25121-15	25121	Grind conservator	1	60	25121-11	Grind	t	\N	f
1015	25121-20	25121	Tack deksel	1	60		Moeilik, Handlanger	t	\N	f
1020	25125-1	25125	Saag pyp	5	0.5		Saag, HSaag	t	\N	f
1023	25125-4	25125	Figure 10mm uit	1	15	25125-3	Wikus	t	\N	f
1024	25125-5	25125	Sny 10mm	5	1	25125-4	Saag, HSaag	t	\N	f
1022	25125-3	25125	Bou raampie	10	5	25125-1, 25125-2	Maklik	t	\N	f
1025	25125-6	25125	Sit 10mm op en sweis	1	5	25125-5	Sweis	t	\N	f
1026	25125-7	25125	Grind	1	5	25125-6	Grind	t	\N	f
1027	25125-8	25125	Verf	1	5	25125-7	Verf	t	\N	f
164	25003-1	25003	Plasma plaatparte	15	30		Gert	t	\N	f
1050	25122-1	25122	Sny plaat	15	10		Handlanger,Gert,Groot_guillotine	f	\N	f
1052	25122-3	25122	Sweis	0	60	25122-2	Sweis	f	\N	f
1053	25122-4	25122	Skoonmaak	0	30	25122-3	Grind	f	\N	f
1054	25122-5	25122	Verf optouch	0	30	25122-4	Verf	f	\N	f
1055	23051-1	23051	Sit slot aanmekaar	5	10		Sweis	f	\N	f
1056	23051-2	23051	Sit op pallet	0	10	23051-1	Sweis	f	\N	f
1057	23051-3	23051	Touch verf op	0	15	23051-2	Verf	f	\N	f
1058	24183-1	24183	Sny pallets korter	10	4		Grind	f	\N	f
1061	24183-2	24183	Saag pale	10	4		HSaag,Saag	f	\N	f
1062	24183-3	24183	Saag extensions	5	1		HSaag,Saag	f	\N	f
1063	24183-4	24183	Plasma 4.5mm	10	0.5		Gert	f	\N	f
1212	25182-4	25182	Verf	0	2	25182-3	Verf	t	\N	f
1163	25171-5	25171	Grind	0	5	25171-4	Handlanger,Grind	t	\N	t
1297	25192-5	25192	Verf	20	2	25192-3,25192-4	Pieter,Quintin	t	\N	f
1562	25308-1	25308	Sit fittings op	0	30		Gert,Handlanger	f	\N	f
1064	24183-5	24183	Bou extensions	0	10	24183-3,24183-4	Sweis	f	\N	f
1065	24183-6	24183	Sit extensions op pallets	0	10	24183-1,24183-5	Sweis	f	\N	f
1066	24183-7	24183	Sit extensions op pale	0	10	24183-2,24183-5	Sweis	f	\N	f
1067	24183-8	24183	Grind pallets	0	5	24183-6	Grind	f	\N	f
\.


--
-- TOC entry 4195 (class 0 OID 24854)
-- Dependencies: 230
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.template (id, name, description, price_each) FROM stdin;
1	J450	J450	0
2	880 Refurb	880 Grab Refurbish	6505
4	Double Drumlifter		1
5	Drum Tilter		1
6	Sliderflex Brackets		7.846
3	2030 Grab		0
\.


--
-- TOC entry 4197 (class 0 OID 24859)
-- Dependencies: 232
-- Data for Name: template_material; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.template_material (id, template_id, description, quantity, unit) FROM stdin;
1	1	3mm Plaat	2	2450x1225
2	1	4.5mm Plaat	1	2500x1200
3	1	25mm Bright Bar	300	mm
4	1	10mm Plaat	0.1	2500x1200
5	1	6mm Ketting	3	m
6	1	8mm carabine hook	2	ea
\.


--
-- TOC entry 4199 (class 0 OID 24863)
-- Dependencies: 234
-- Data for Name: template_task; Type: TABLE DATA; Schema: public; Owner: myadmin
--

COPY public.template_task (id, template_id, task_number, description, setup_time, time_each, predecessors, resources) FROM stdin;
1	1	1	Sny kante	10	10		Gert
2	1	2	Sny body	10	3		Gert, Handlanger
3	1	3	Buig body	15	10	2	Gert, Andrew, Handlanger
4	1	4	Sny en buig channels	5	15		Wikus
5	1	5	Sny 10mm parte	5	10		Gert
6	1	6	Buig en boor spore	10	30	5	Wikus
7	1	7	Bou body	10	40	1, 3, 4	Gert, Handlanger
8	1	8	Sweis body	5	40	7	Sweis
9	1	9	Grind body	1	30	8	Grind
10	1	10	Sny pockets	5	5		Gert
11	1	11	Buig pockets	10	2	10	Gert, Handlanger
12	1	12	Saag bullets	1	5		Saag, HSaag
13	1	13	Draai bullets	10	20	12	Quinton
14	1	14	Bou pockets	1	15	11, 13	Gert
15	1	15	Sweis pockets	1	25	14	Sweis
16	1	16	Grind pockets	1	15	15	Grind
17	1	17	Bou bin	10	45	6, 9, 16 	Wikus
18	1	18	Sweis bin	1	45	17	Sweis
19	1	19	Grind bin	1	30	18	Grind
20	1	20	Verf bin	1	120	19	Verf
21	2	1	Strip	5	30		Handlanger
22	2	2	Deurgaan	1	10	1	Wikus
23	2	3	Regmaak	10	60	2	Gert, Andrew
24	2	4	Sweis	1	45	3	Andrew
25	2	5	Verf	10	60	4	Pieter, Quinton
26	4	1	Plasma 4.5mm	5	30		Gert
27	4	2	Buig pockets	10	5	1	Gert, Handlanger
28	4	3	Buig dromgidse	10	5	1	Gert, Handlanger
29	4	4	Saag	10	15		Saag, HSaag
30	4	5	Boor hoekysters	5	20	4	Boor, HBoor
31	4	6	Bou raam	10	30	2, 3, 5	Wikus
32	4	7	Plasma 20mm	10	5		Gert
33	4	8	Plasma 8mm	10	5		Gert
35	4	10	Boor 8mm	5	10	8	Boor, HBoor
34	4	9	Boor 20mm	5	50	7	Boor, HBoor
36	4	11	Bou arms	1	20	9, 10	Wikus
37	4	12	Sweis raam	1	45	6	Sweis
38	4	13	Sweis arms	1	20	11	Sweis
39	4	14	Grind raam	1	30	12	Grind
40	4	15	Grind arms	1	15	13	Grind
41	4	16	Sit aanmekaar	1	30	14, 15	Wikus, Handlanger
42	4	17	Toets	1	15	16	Wikus
43	4	18	Strip	1	15	17	Handlanger
44	4	19	Verf	1	30	18	Pieter, Quinton
45	4	20	Finale aanmekaarsit	1	45	19	Wikus, Handlanger
46	5	1	Saag	10	15		Saag, HSaag
47	5	2	Plasma	5	15		Gert
48	5	3	Rol	15	45	2	Gert, Handlanger
49	5	4	Bou ronding	1	30	1, 3	Gert, Handlanger
50	5	5	Bou raam	1	45	1, 2	Gert, Handlanger
51	5	6	Masjineer as	15	15	2	Wikus
53	5	8	Sweis raam	1	45	5	Sweis
52	5	7	Sit tilter aanmekaar	1	60	4, 5, 8	Gert, Handlanger
54	5	9	Sweis tilter	1	30	7	Sweis
55	5	10	Toets	15	5	9	Wikus
56	5	11	Strip	1	30	10	Grind, Handlanger
57	5	12	Verf	5	30	11	Quinton, Pieter
58	5	13	Sit finaal aanmekaar	1	45	12	Gert, Handlanger
59	6	1	Sny Angles	5	2		Saag, HSaag
60	6	2	Chop Angles	5	2	1	Handlanger
61	6	3	Boor Angles	15	2	1	HBoor, Boor
63	6	5	Saag pyp	5	2		Saag, HSaag
62	6	4	Plasma	5	1		Gert
65	6	7	Grind	1	3	6	Grind
64	6	6	Sit aanmekaar en sweis	5	5	2,3,4,5	BouK
66	6	8	Verf	1	5	7	Verf
67	3	1	Saag raam	10	45		Saag, HSaag
68	3	2	Bou raam	15	60	1	Maklik
69	3	3	Plasma	5	20		Gert
70	3	4	Saag parte	10	30		Saag, HSaag
71	3	5	Sweis raam	5	60	2	Sweis
72	3	6	Grind raam	1	30	5	Grind
73	3	7	Bou klaar	10	60	3,4,6	Moeilik
74	3	8	Sweis klaar	1	60	7	Sweis
75	3	9	Grind	1	30	8	Grind
76	3	10	Verf	1	60	9	Verf
77	3	11	Rubber, penne ens	1	30	10	Verf
\.


--
-- TOC entry 4297 (class 0 OID 0)
-- Dependencies: 216
-- Name: calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.calendar_id_seq', 7, true);


--
-- TOC entry 4298 (class 0 OID 0)
-- Dependencies: 238
-- Name: holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.holidays_id_seq', 27, true);


--
-- TOC entry 4299 (class 0 OID 0)
-- Dependencies: 218
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.job_id_seq', 180, true);


--
-- TOC entry 4300 (class 0 OID 0)
-- Dependencies: 236
-- Name: job_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.job_material_id_seq', 1, false);


--
-- TOC entry 4301 (class 0 OID 0)
-- Dependencies: 220
-- Name: material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.material_id_seq', 65, true);


--
-- TOC entry 4302 (class 0 OID 0)
-- Dependencies: 224
-- Name: resource_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.resource_group_id_seq', 20, true);


--
-- TOC entry 4303 (class 0 OID 0)
-- Dependencies: 225
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.resource_id_seq', 37, true);


--
-- TOC entry 4304 (class 0 OID 0)
-- Dependencies: 227
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.schedule_id_seq', 12070, true);


--
-- TOC entry 4305 (class 0 OID 0)
-- Dependencies: 229
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.task_id_seq', 1569, true);


--
-- TOC entry 4306 (class 0 OID 0)
-- Dependencies: 231
-- Name: template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.template_id_seq', 6, true);


--
-- TOC entry 4307 (class 0 OID 0)
-- Dependencies: 233
-- Name: template_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.template_material_id_seq', 6, true);


--
-- TOC entry 4308 (class 0 OID 0)
-- Dependencies: 235
-- Name: template_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myadmin
--

SELECT pg_catalog.setval('public.template_task_id_seq', 77, true);


--
-- TOC entry 3990 (class 2606 OID 24880)
-- Name: calendar calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (id);


--
-- TOC entry 3992 (class 2606 OID 24882)
-- Name: calendar calendar_weekday_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_weekday_key UNIQUE (weekday);


--
-- TOC entry 4026 (class 2606 OID 24978)
-- Name: holidays holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- TOC entry 3994 (class 2606 OID 24884)
-- Name: job job_job_number_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_job_number_key UNIQUE (job_number);


--
-- TOC entry 4024 (class 2606 OID 24964)
-- Name: job_material job_material_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job_material
    ADD CONSTRAINT job_material_pkey PRIMARY KEY (id);


--
-- TOC entry 3996 (class 2606 OID 24886)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- TOC entry 3998 (class 2606 OID 24888)
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (id);


--
-- TOC entry 4008 (class 2606 OID 24890)
-- Name: resource_group_association resource_group_association_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_pkey PRIMARY KEY (resource_id, group_id);


--
-- TOC entry 4004 (class 2606 OID 24892)
-- Name: resource_group resource_group_name_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group
    ADD CONSTRAINT resource_group_name_key UNIQUE (name);


--
-- TOC entry 4006 (class 2606 OID 24894)
-- Name: resource_group resource_group_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group
    ADD CONSTRAINT resource_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4000 (class 2606 OID 24896)
-- Name: resource resource_name_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_name_key UNIQUE (name);


--
-- TOC entry 4002 (class 2606 OID 24898)
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- TOC entry 4010 (class 2606 OID 24900)
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 4012 (class 2606 OID 24902)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- TOC entry 4014 (class 2606 OID 24904)
-- Name: task task_task_number_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_task_number_key UNIQUE (task_number);


--
-- TOC entry 4020 (class 2606 OID 24906)
-- Name: template_material template_material_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_material
    ADD CONSTRAINT template_material_pkey PRIMARY KEY (id);


--
-- TOC entry 4016 (class 2606 OID 24908)
-- Name: template template_name_key; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_name_key UNIQUE (name);


--
-- TOC entry 4018 (class 2606 OID 24910)
-- Name: template template_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- TOC entry 4022 (class 2606 OID 24912)
-- Name: template_task template_task_pkey; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_task
    ADD CONSTRAINT template_task_pkey PRIMARY KEY (id);


--
-- TOC entry 4028 (class 2606 OID 24980)
-- Name: holidays unique_date; Type: CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT unique_date UNIQUE (date);


--
-- TOC entry 4036 (class 2606 OID 24965)
-- Name: job_material job_material_job_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.job_material
    ADD CONSTRAINT job_material_job_number_fkey FOREIGN KEY (job_number) REFERENCES public.job(job_number);


--
-- TOC entry 4029 (class 2606 OID 24913)
-- Name: material material_job_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_job_number_fkey FOREIGN KEY (job_number) REFERENCES public.job(job_number);


--
-- TOC entry 4030 (class 2606 OID 24918)
-- Name: resource_group_association resource_group_association_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.resource_group(id);


--
-- TOC entry 4031 (class 2606 OID 24923)
-- Name: resource_group_association resource_group_association_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id);


--
-- TOC entry 4032 (class 2606 OID 24928)
-- Name: schedule schedule_task_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_task_number_fkey FOREIGN KEY (task_number) REFERENCES public.task(task_number);


--
-- TOC entry 4033 (class 2606 OID 24933)
-- Name: task task_job_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_job_number_fkey FOREIGN KEY (job_number) REFERENCES public.job(job_number);


--
-- TOC entry 4034 (class 2606 OID 24938)
-- Name: template_material template_material_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_material
    ADD CONSTRAINT template_material_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id);


--
-- TOC entry 4035 (class 2606 OID 24943)
-- Name: template_task template_task_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myadmin
--

ALTER TABLE ONLY public.template_task
    ADD CONSTRAINT template_task_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id);


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 240
-- Name: FUNCTION pg_replication_origin_advance(text, pg_lsn); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_advance(text, pg_lsn) TO azure_pg_admin;


--
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 253
-- Name: FUNCTION pg_replication_origin_create(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_create(text) TO azure_pg_admin;


--
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 245
-- Name: FUNCTION pg_replication_origin_drop(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_drop(text) TO azure_pg_admin;


--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 246
-- Name: FUNCTION pg_replication_origin_oid(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_oid(text) TO azure_pg_admin;


--
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 247
-- Name: FUNCTION pg_replication_origin_progress(text, boolean); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_progress(text, boolean) TO azure_pg_admin;


--
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 248
-- Name: FUNCTION pg_replication_origin_session_is_setup(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_is_setup() TO azure_pg_admin;


--
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 249
-- Name: FUNCTION pg_replication_origin_session_progress(boolean); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_progress(boolean) TO azure_pg_admin;


--
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 254
-- Name: FUNCTION pg_replication_origin_session_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_reset() TO azure_pg_admin;


--
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 250
-- Name: FUNCTION pg_replication_origin_session_setup(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_setup(text) TO azure_pg_admin;


--
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 251
-- Name: FUNCTION pg_replication_origin_xact_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_reset() TO azure_pg_admin;


--
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 252
-- Name: FUNCTION pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone) TO azure_pg_admin;


--
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 255
-- Name: FUNCTION pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn) TO azure_pg_admin;


--
-- TOC entry 4222 (class 0 OID 0)
-- Dependencies: 241
-- Name: FUNCTION pg_stat_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset() TO azure_pg_admin;


--
-- TOC entry 4223 (class 0 OID 0)
-- Dependencies: 242
-- Name: FUNCTION pg_stat_reset_shared(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_shared(text) TO azure_pg_admin;


--
-- TOC entry 4224 (class 0 OID 0)
-- Dependencies: 244
-- Name: FUNCTION pg_stat_reset_single_function_counters(oid); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_function_counters(oid) TO azure_pg_admin;


--
-- TOC entry 4225 (class 0 OID 0)
-- Dependencies: 243
-- Name: FUNCTION pg_stat_reset_single_table_counters(oid); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_table_counters(oid) TO azure_pg_admin;


--
-- TOC entry 4226 (class 0 OID 0)
-- Dependencies: 98
-- Name: COLUMN pg_config.name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(name) ON TABLE pg_catalog.pg_config TO azure_pg_admin;


--
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 98
-- Name: COLUMN pg_config.setting; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(setting) ON TABLE pg_catalog.pg_config TO azure_pg_admin;


--
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.line_number; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(line_number) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.type; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(type) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4230 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.database; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(database) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4231 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.user_name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(user_name) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4232 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.address; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(address) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4233 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.netmask; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(netmask) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4234 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.auth_method; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(auth_method) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4235 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.options; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(options) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4236 (class 0 OID 0)
-- Dependencies: 94
-- Name: COLUMN pg_hba_file_rules.error; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(error) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- TOC entry 4237 (class 0 OID 0)
-- Dependencies: 144
-- Name: COLUMN pg_replication_origin_status.local_id; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(local_id) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- TOC entry 4238 (class 0 OID 0)
-- Dependencies: 144
-- Name: COLUMN pg_replication_origin_status.external_id; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(external_id) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- TOC entry 4239 (class 0 OID 0)
-- Dependencies: 144
-- Name: COLUMN pg_replication_origin_status.remote_lsn; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(remote_lsn) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- TOC entry 4240 (class 0 OID 0)
-- Dependencies: 144
-- Name: COLUMN pg_replication_origin_status.local_lsn; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(local_lsn) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 99
-- Name: COLUMN pg_shmem_allocations.name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(name) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 99
-- Name: COLUMN pg_shmem_allocations.off; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(off) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 99
-- Name: COLUMN pg_shmem_allocations.size; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(size) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 99
-- Name: COLUMN pg_shmem_allocations.allocated_size; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(allocated_size) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- TOC entry 4245 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.starelid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(starelid) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4246 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staattnum; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staattnum) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4247 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stainherit; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stainherit) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4248 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanullfrac; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanullfrac) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4249 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stawidth; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stawidth) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4250 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stadistinct; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stadistinct) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4251 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stakind1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4252 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stakind2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4253 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stakind3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4254 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stakind4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4255 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stakind5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4256 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staop1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4257 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staop2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4258 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staop3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4259 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staop4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4260 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.staop5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4261 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stacoll1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4262 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stacoll2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4263 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stacoll3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4264 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stacoll4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4265 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stacoll5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4266 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanumbers1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4267 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanumbers2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4268 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanumbers3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4269 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanumbers4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4270 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stanumbers5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4271 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stavalues1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4272 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stavalues2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4273 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stavalues3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4274 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stavalues4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4275 (class 0 OID 0)
-- Dependencies: 39
-- Name: COLUMN pg_statistic.stavalues5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- TOC entry 4276 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.oid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(oid) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4277 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subdbid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subdbid) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4278 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subname; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subname) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4279 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subowner; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subowner) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4280 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subenabled; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subenabled) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4281 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subconninfo; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subconninfo) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4282 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subslotname; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subslotname) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4283 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subsynccommit; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subsynccommit) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- TOC entry 4284 (class 0 OID 0)
-- Dependencies: 64
-- Name: COLUMN pg_subscription.subpublications; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subpublications) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


-- Completed on 2025-11-20 12:04:05

--
-- PostgreSQL database dump complete
--

