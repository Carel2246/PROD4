-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.calendar
(
    id serial NOT NULL,
    weekday integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT calendar_pkey PRIMARY KEY (id),
    CONSTRAINT calendar_weekday_key UNIQUE (weekday)
);

CREATE TABLE IF NOT EXISTS public.holidays
(
    id serial NOT NULL,
    date date NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    resources jsonb,
    CONSTRAINT holidays_pkey PRIMARY KEY (id),
    CONSTRAINT unique_date UNIQUE (date)
);

CREATE TABLE IF NOT EXISTS public.job
(
    id serial NOT NULL,
    job_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    order_date timestamp without time zone NOT NULL,
    promised_date timestamp without time zone NOT NULL,
    quantity integer NOT NULL,
    price_each double precision NOT NULL,
    customer character varying(100) COLLATE pg_catalog."default",
    completed boolean NOT NULL DEFAULT false,
    blocked boolean NOT NULL DEFAULT false,
    CONSTRAINT job_pkey PRIMARY KEY (id),
    CONSTRAINT job_job_number_key UNIQUE (job_number)
);

CREATE TABLE IF NOT EXISTS public.job_material
(
    id serial NOT NULL,
    job_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT job_material_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.material
(
    id serial NOT NULL,
    job_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT material_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.resource
(
    id serial NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    type character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT resource_pkey PRIMARY KEY (id),
    CONSTRAINT resource_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.resource_group
(
    id serial NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    type character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT resource_group_pkey PRIMARY KEY (id),
    CONSTRAINT resource_group_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.resource_group_association
(
    resource_id integer NOT NULL,
    group_id integer NOT NULL,
    CONSTRAINT resource_group_association_pkey PRIMARY KEY (resource_id, group_id)
);

CREATE TABLE IF NOT EXISTS public.schedule
(
    id serial NOT NULL,
    task_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    resources_used character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT schedule_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.task
(
    id serial NOT NULL,
    task_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    job_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    setup_time double precision NOT NULL,
    time_each double precision NOT NULL,
    predecessors character varying(255) COLLATE pg_catalog."default",
    resources character varying(255) COLLATE pg_catalog."default" NOT NULL,
    completed boolean NOT NULL DEFAULT false,
    completed_at timestamp without time zone,
    CONSTRAINT task_pkey PRIMARY KEY (id),
    CONSTRAINT task_task_number_key UNIQUE (task_number)
);

CREATE TABLE IF NOT EXISTS public.template
(
    id serial NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    price_each real DEFAULT 0,
    CONSTRAINT template_pkey PRIMARY KEY (id),
    CONSTRAINT template_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.template_material
(
    id serial NOT NULL,
    template_id integer NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT template_material_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.template_task
(
    id serial NOT NULL,
    template_id integer NOT NULL,
    task_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    setup_time integer NOT NULL,
    time_each integer NOT NULL,
    predecessors character varying(255) COLLATE pg_catalog."default",
    resources character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT template_task_pkey PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.job_material
    ADD CONSTRAINT job_material_job_number_fkey FOREIGN KEY (job_number)
    REFERENCES public.job (job_number) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.material
    ADD CONSTRAINT material_job_number_fkey FOREIGN KEY (job_number)
    REFERENCES public.job (job_number) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.resource_group_association
    ADD CONSTRAINT resource_group_association_group_id_fkey FOREIGN KEY (group_id)
    REFERENCES public.resource_group (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.resource_group_association
    ADD CONSTRAINT resource_group_association_resource_id_fkey FOREIGN KEY (resource_id)
    REFERENCES public.resource (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.schedule
    ADD CONSTRAINT schedule_task_number_fkey FOREIGN KEY (task_number)
    REFERENCES public.task (task_number) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.task
    ADD CONSTRAINT task_job_number_fkey FOREIGN KEY (job_number)
    REFERENCES public.job (job_number) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.template_material
    ADD CONSTRAINT template_material_template_id_fkey FOREIGN KEY (template_id)
    REFERENCES public.template (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.template_task
    ADD CONSTRAINT template_task_template_id_fkey FOREIGN KEY (template_id)
    REFERENCES public.template (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

END;