--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 16.1

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: master
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO master;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ars_groups; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.ars_groups (
    name character varying NOT NULL,
    modus_name character varying,
    description character varying,
    icon character varying
);


ALTER TABLE public.ars_groups OWNER TO master;

--
-- Name: artes; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.artes (
    name character varying NOT NULL,
    ars_group_name character varying,
    level integer,
    casting_time character varying,
    target character varying,
    ars_range character varying,
    challenge character varying,
    cost character varying,
    duration character varying,
    maintenance character varying,
    description character varying
);


ALTER TABLE public.artes OWNER TO master;

--
-- Name: aspecti; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.aspecti (
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.aspecti OWNER TO master;

--
-- Name: character_sheets; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.character_sheets (
    chronicle character varying NOT NULL,
    player character varying NOT NULL,
    character_name character varying NOT NULL,
    character_stats jsonb,
    character_inventory jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.character_sheets OWNER TO master;

--
-- Name: json_schemas; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.json_schemas (
    entity character varying NOT NULL,
    version character varying NOT NULL,
    schema_definition jsonb NOT NULL
);


ALTER TABLE public.json_schemas OWNER TO master;

--
-- Name: modus; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.modus (
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.modus OWNER TO master;

--
-- Name: vias; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.vias (
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.vias OWNER TO master;

--
-- Name: vias_to_artes_association; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.vias_to_artes_association (
    via_name character varying,
    ars_group_name character varying
);


ALTER TABLE public.vias_to_artes_association OWNER TO master;

--
-- Name: vias_to_aspecti_association; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.vias_to_aspecti_association (
    via_name character varying,
    aspectus_name character varying
);


ALTER TABLE public.vias_to_aspecti_association OWNER TO master;

--
-- Name: weapon_class; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.weapon_class (
    name character varying NOT NULL,
    is_ranged boolean,
    weapon_range character varying,
    icon character varying
);


ALTER TABLE public.weapon_class OWNER TO master;

--
-- Name: weapons; Type: TABLE; Schema: public; Owner: master
--

CREATE TABLE public.weapons (
    name character varying NOT NULL,
    weapon_class_name character varying,
    proficiency integer,
    ammo integer,
    description character varying,
    damage jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.weapons OWNER TO master;

--
-- Name: weapon_spec; Type: VIEW; Schema: public; Owner: master
--

CREATE VIEW public.weapon_spec AS
 SELECT weapons.name,
    weapons.weapon_class_name,
    weapons.proficiency,
    weapon_class.is_ranged,
    weapon_class.weapon_range,
    weapons.damage,
    weapons.ammo,
    weapons.description,
    weapon_class.icon
   FROM (public.weapons
     LEFT JOIN public.weapon_class ON (((weapon_class.name)::text = (weapons.weapon_class_name)::text)));


ALTER VIEW public.weapon_spec OWNER TO master;

--
-- Name: json_schemas ID_PKEY; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.json_schemas
    ADD CONSTRAINT "ID_PKEY" PRIMARY KEY (entity, version);


--
-- Name: ars_groups ars_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.ars_groups
    ADD CONSTRAINT ars_groups_pkey PRIMARY KEY (name);


--
-- Name: artes artes_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.artes
    ADD CONSTRAINT artes_pkey PRIMARY KEY (name);


--
-- Name: aspecti aspecti_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.aspecti
    ADD CONSTRAINT aspecti_pkey PRIMARY KEY (name);


--
-- Name: character_sheets character_sheets_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.character_sheets
    ADD CONSTRAINT character_sheets_pkey PRIMARY KEY (chronicle, player, character_name);


--
-- Name: modus modus_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.modus
    ADD CONSTRAINT modus_pkey PRIMARY KEY (name);


--
-- Name: vias vias_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.vias
    ADD CONSTRAINT vias_pkey PRIMARY KEY (name);


--
-- Name: weapon_class weapon_class_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.weapon_class
    ADD CONSTRAINT weapon_class_pkey PRIMARY KEY (name);


--
-- Name: weapons weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (name);


--
-- Name: ars_groups ars_groups_modus_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.ars_groups
    ADD CONSTRAINT ars_groups_modus_name_fkey FOREIGN KEY (modus_name) REFERENCES public.modus(name);


--
-- Name: artes artes_ars_group_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.artes
    ADD CONSTRAINT artes_ars_group_name_fkey FOREIGN KEY (ars_group_name) REFERENCES public.ars_groups(name);


--
-- Name: vias_to_artes_association vias_to_artes_association_ars_group_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.vias_to_artes_association
    ADD CONSTRAINT vias_to_artes_association_ars_group_name_fkey FOREIGN KEY (ars_group_name) REFERENCES public.ars_groups(name);


--
-- Name: vias_to_artes_association vias_to_artes_association_via_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.vias_to_artes_association
    ADD CONSTRAINT vias_to_artes_association_via_name_fkey FOREIGN KEY (via_name) REFERENCES public.vias(name);


--
-- Name: vias_to_aspecti_association vias_to_aspecti_association_aspectus_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.vias_to_aspecti_association
    ADD CONSTRAINT vias_to_aspecti_association_aspectus_name_fkey FOREIGN KEY (aspectus_name) REFERENCES public.aspecti(name);


--
-- Name: vias_to_aspecti_association vias_to_aspecti_association_via_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.vias_to_aspecti_association
    ADD CONSTRAINT vias_to_aspecti_association_via_name_fkey FOREIGN KEY (via_name) REFERENCES public.vias(name);


--
-- Name: weapons weapons_weapon_class_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: master
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_weapon_class_name_fkey FOREIGN KEY (weapon_class_name) REFERENCES public.weapon_class(name);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: master
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

