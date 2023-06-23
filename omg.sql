--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 15.1

-- Started on 2023-06-23 11:24:48

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
-- TOC entry 5 (class 2615 OID 16396)
-- Name: omg; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA omg;


ALTER SCHEMA omg OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16397)
-- Name: del_all_user_orders(); Type: FUNCTION; Schema: omg; Owner: postgres
--

CREATE FUNCTION omg.del_all_user_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE i integer;
BEGIN
	UPDATE omg."NUMOFORDER" SET id_user = null WHERE id_user=OLD.id;
	
	RETURN OLD;
END;
$$;


ALTER FUNCTION omg.del_all_user_orders() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16398)
-- Name: deleteOrder(integer); Type: PROCEDURE; Schema: omg; Owner: postgres
--

CREATE PROCEDURE omg."deleteOrder"(IN o_id integer)
    LANGUAGE sql
    AS $$
	DELETE FROM omg."NUMOFORDER"
	WHERE summa = '0'AND num_order = o_id;
	DELETE FROM omg."ORDER"
	WHERE number_order = o_id;
$$;


ALTER PROCEDURE omg."deleteOrder"(IN o_id integer) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16399)
-- Name: fn_sal(numeric); Type: FUNCTION; Schema: omg; Owner: postgres
--

CREATE FUNCTION omg.fn_sal(sale numeric) RETURNS numeric
    LANGUAGE sql
    AS $$
	SELECT (MAX(summa))*(100-sale)/100
	FROM omg."NUMOFORDER";
$$;


ALTER FUNCTION omg.fn_sal(sale numeric) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16400)
-- Name: get_pr_name(integer); Type: FUNCTION; Schema: omg; Owner: postgres
--

CREATE FUNCTION omg.get_pr_name(id_ct integer) RETURNS TABLE(product_id integer, product_name character varying)
    LANGUAGE sql
    AS $$
	SELECT product_id, product_name 
	FROM omg."PRODUCTS"
	WHERE category IN ( SELECT category_id FROM omg."CATEGORY" WHERE category_id = id_ct );
$$;


ALTER FUNCTION omg.get_pr_name(id_ct integer) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16401)
-- Name: update_del_ord(); Type: PROCEDURE; Schema: omg; Owner: postgres
--

CREATE PROCEDURE omg.update_del_ord()
    LANGUAGE sql
    AS $$
	UPDATE omg."NUMOFORDER" 
	SET summa = '0'
	WHERE id_user IS NULL;
$$;


ALTER PROCEDURE omg.update_del_ord() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16402)
-- Name: update_summa(); Type: FUNCTION; Schema: omg; Owner: postgres
--

CREATE FUNCTION omg.update_summa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_ord integer;
BEGIN
IF NEW IS NULL THEN
	RAISE EXCEPTION 'new is null';
END IF;
IF NEW.*  IS NOT NULL THEN
	num_ord := NEW.number_order;
END IF;
IF num_ord IS NULL  THEN
	RAISE EXCEPTION 'state is null';
END IF;
	UPDATE omg."NUMOFORDER"
	SET summa= (SELECT SUM(nf.quantity * pr.price)
	FROM omg."PRODUCTS" as pr, omg."ORDER" as nf
	WHERE nf.number_order = num_ord  AND nf.id_product = pr.product_id)
	WHERE "NUMOFORDER".num_order = num_ord;

	RETURN NULL;
END;
$$;


ALTER FUNCTION omg.update_summa() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16403)
-- Name: ADRESS; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."ADRESS" (
    "ID" integer NOT NULL,
    street character varying(100) NOT NULL,
    hause integer NOT NULL,
    flat integer
);


ALTER TABLE omg."ADRESS" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16406)
-- Name: CATEGORY; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."CATEGORY" (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL
);


ALTER TABLE omg."CATEGORY" OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE "CATEGORY"; Type: COMMENT; Schema: omg; Owner: postgres
--

COMMENT ON TABLE omg."CATEGORY" IS 'Код и наименование категорий товаров.';


--
-- TOC entry 212 (class 1259 OID 16409)
-- Name: COLOR; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."COLOR" (
    "#" integer NOT NULL,
    color character varying(80) NOT NULL
);


ALTER TABLE omg."COLOR" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16412)
-- Name: MATERIAL; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."MATERIAL" (
    "##" integer NOT NULL,
    material character varying(80) NOT NULL
);


ALTER TABLE omg."MATERIAL" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16415)
-- Name: NUMOFORDER; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."NUMOFORDER" (
    num_order integer NOT NULL,
    id_user integer,
    summa numeric(25,2)
);


ALTER TABLE omg."NUMOFORDER" OWNER TO postgres;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "NUMOFORDER"; Type: COMMENT; Schema: omg; Owner: postgres
--

COMMENT ON TABLE omg."NUMOFORDER" IS 'Список заказов.';


--
-- TOC entry 215 (class 1259 OID 16418)
-- Name: ORDER; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."ORDER" (
    number_order integer NOT NULL,
    id_product integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE omg."ORDER" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16421)
-- Name: POLZ; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."POLZ" (
    id_c integer NOT NULL,
    log character varying(100) NOT NULL,
    pass integer NOT NULL,
    ava character varying(100),
    id integer NOT NULL
);


ALTER TABLE omg."POLZ" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16424)
-- Name: PRODUCTS; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."PRODUCTS" (
    product_id integer NOT NULL,
    product_name character varying(100) NOT NULL,
    category integer DEFAULT 1 NOT NULL,
    size character varying(4) NOT NULL,
    price numeric(18,2),
    color integer NOT NULL,
    type_of_material integer NOT NULL
);


ALTER TABLE omg."PRODUCTS" OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "PRODUCTS"; Type: COMMENT; Schema: omg; Owner: postgres
--

COMMENT ON TABLE omg."PRODUCTS" IS 'Таблица товаров.';


--
-- TOC entry 218 (class 1259 OID 16428)
-- Name: PRODUCTS_product_id_seq; Type: SEQUENCE; Schema: omg; Owner: postgres
--

ALTER TABLE omg."PRODUCTS" ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME omg."PRODUCTS_product_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16429)
-- Name: USERS; Type: TABLE; Schema: omg; Owner: postgres
--

CREATE TABLE omg."USERS" (
    id integer NOT NULL,
    surname character varying(80) NOT NULL,
    name character varying(80) NOT NULL,
    email character varying(100) NOT NULL,
    adress integer NOT NULL
);


ALTER TABLE omg."USERS" OWNER TO postgres;

--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE "USERS"; Type: COMMENT; Schema: omg; Owner: postgres
--

COMMENT ON TABLE omg."USERS" IS 'Информация о клиентах.';


--
-- TOC entry 220 (class 1259 OID 16432)
-- Name: USERS_id_seq; Type: SEQUENCE; Schema: omg; Owner: postgres
--

CREATE SEQUENCE omg."USERS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE omg."USERS_id_seq" OWNER TO postgres;

--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 220
-- Name: USERS_id_seq; Type: SEQUENCE OWNED BY; Schema: omg; Owner: postgres
--

ALTER SEQUENCE omg."USERS_id_seq" OWNED BY omg."USERS".id;


--
-- TOC entry 221 (class 1259 OID 16433)
-- Name: info_us_orders; Type: VIEW; Schema: omg; Owner: postgres
--

CREATE VIEW omg.info_us_orders AS
 SELECT DISTINCT inf.num_order,
    users.name,
    pr.product_name,
    ct.category_name
   FROM ((((omg."NUMOFORDER" inf
     LEFT JOIN omg."USERS" users ON ((inf.id_user = users.id)))
     LEFT JOIN omg."ORDER" ord ON ((inf.num_order = ord.number_order)))
     LEFT JOIN omg."PRODUCTS" pr ON ((pr.product_id = ord.id_product)))
     LEFT JOIN omg."CATEGORY" ct ON ((pr.category = ct.category_id)))
  WHERE (pr.product_name IS NOT NULL)
  ORDER BY inf.num_order;


ALTER TABLE omg.info_us_orders OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16438)
-- Name: user_orders_count; Type: VIEW; Schema: omg; Owner: postgres
--

CREATE VIEW omg.user_orders_count AS
 SELECT "NUMOFORDER".id_user,
    count(*) AS count
   FROM omg."NUMOFORDER"
  GROUP BY "NUMOFORDER".id_user
 HAVING ("NUMOFORDER".id_user IS NOT NULL);


ALTER TABLE omg.user_orders_count OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16442)
-- Name: info_user_orders_count; Type: VIEW; Schema: omg; Owner: postgres
--

CREATE VIEW omg.info_user_orders_count AS
 SELECT users.name,
    users.email,
    inf.count AS orders_count
   FROM (omg.user_orders_count inf
     RIGHT JOIN omg."USERS" users ON ((inf.id_user = users.id)));


ALTER TABLE omg.info_user_orders_count OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16446)
-- Name: post_client; Type: VIEW; Schema: omg; Owner: postgres
--

CREATE VIEW omg.post_client AS
 SELECT "USERS".name,
    "USERS".email
   FROM omg."USERS"
  WHERE ("USERS".id IN ( SELECT "NUMOFORDER".id_user
           FROM omg."NUMOFORDER"
          WHERE ("NUMOFORDER".summa > (7000)::numeric)));


ALTER TABLE omg.post_client OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16450)
-- Name: users_id; Type: VIEW; Schema: omg; Owner: postgres
--

CREATE VIEW omg.users_id AS
 SELECT "NUMOFORDER".num_order,
    "NUMOFORDER".id_user,
    "NUMOFORDER".summa
   FROM omg."NUMOFORDER"
  WHERE ("NUMOFORDER".id_user = 1)
  WITH CASCADED CHECK OPTION;


ALTER TABLE omg.users_id OWNER TO postgres;

--
-- TOC entry 3225 (class 2604 OID 16515)
-- Name: USERS id; Type: DEFAULT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."USERS" ALTER COLUMN id SET DEFAULT nextval('omg."USERS_id_seq"'::regclass);


--
-- TOC entry 3398 (class 0 OID 16403)
-- Dependencies: 210
-- Data for Name: ADRESS; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."ADRESS" ("ID", street, hause, flat) FROM stdin;
3	Декабристов	13	63
2	Бажова	5	45
1	Энергетиков	8	12
4	Ульяновская	4	78
\.


--
-- TOC entry 3399 (class 0 OID 16406)
-- Dependencies: 211
-- Data for Name: CATEGORY; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."CATEGORY" (category_id, category_name) FROM stdin;
1	Attack on Titan
2	Evangelion
3	Naruto
4	HunterXHunter
\.


--
-- TOC entry 3400 (class 0 OID 16409)
-- Dependencies: 212
-- Data for Name: COLOR; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."COLOR" ("#", color) FROM stdin;
1	Black
2	White
3	Gray
\.


--
-- TOC entry 3401 (class 0 OID 16412)
-- Dependencies: 213
-- Data for Name: MATERIAL; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."MATERIAL" ("##", material) FROM stdin;
1	Warm
2	Without fleece
3	Double fleece
\.


--
-- TOC entry 3402 (class 0 OID 16415)
-- Dependencies: 214
-- Data for Name: NUMOFORDER; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."NUMOFORDER" (num_order, id_user, summa) FROM stdin;
2	2	3500.00
12	3	3500.00
13	2	3500.00
15	2	3500.00
16	3	3500.00
11	3	7000.00
14	1	10500.00
17	3	7000.00
18	3	\N
19	1	6000.00
20	2	4000.00
1	1	21000.00
25	\N	\N
\.


--
-- TOC entry 3403 (class 0 OID 16418)
-- Dependencies: 215
-- Data for Name: ORDER; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."ORDER" (number_order, id_product, quantity) FROM stdin;
1	1	1
2	2	2
1	2	1
12	1	1
13	3	1
15	6	1
16	7	1
11	4	2
14	5	3
17	8	2
1	3	4
\.


--
-- TOC entry 3404 (class 0 OID 16421)
-- Dependencies: 216
-- Data for Name: POLZ; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."POLZ" (id_c, log, pass, ava, id) FROM stdin;
1	la	123	\N	1
2	ta	456	\N	2
3	fa	789	\N	3
4	ha	12	\N	4
\.


--
-- TOC entry 3405 (class 0 OID 16424)
-- Dependencies: 217
-- Data for Name: PRODUCTS; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."PRODUCTS" (product_id, product_name, category, size, price, color, type_of_material) FROM stdin;
1	Hoodie	1	S	3500.00	1	1
2	Hoodie	2	S	3500.00	2	2
3	Hoodie	3	S	3500.00	1	2
6	Hoodie	3	M	3500.00	2	2
8	Hoodie	2	L	3500.00	2	1
5	Sweatshirt	2	M	3500.00	1	1
7	Sweatshirt	1	L	3500.00	1	2
9	Sweatshirt	3	L	3500.00	1	2
4	Hoodie	1	M	3500.00	2	1
10	Sweatshirt	3	XL	3500.00	1	2
11	T-short	1	M	3000.00	3	2
\.


--
-- TOC entry 3407 (class 0 OID 16429)
-- Dependencies: 219
-- Data for Name: USERS; Type: TABLE DATA; Schema: omg; Owner: postgres
--

COPY omg."USERS" (id, surname, name, email, adress) FROM stdin;
1	Harrson	Andrew	anhar@mail.ru	1
2	Garlic	Ann	garlan@mail.ru	2
3	Swan	Bella	vampireforever@mail.ru	3
4	DC	AC	AC-DC@mail.ru	4
\.


--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 218
-- Name: PRODUCTS_product_id_seq; Type: SEQUENCE SET; Schema: omg; Owner: postgres
--

SELECT pg_catalog.setval('omg."PRODUCTS_product_id_seq"', 11, true);


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 220
-- Name: USERS_id_seq; Type: SEQUENCE SET; Schema: omg; Owner: postgres
--

SELECT pg_catalog.setval('omg."USERS_id_seq"', 4, true);


--
-- TOC entry 3227 (class 2606 OID 16456)
-- Name: ADRESS ADRESS_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."ADRESS"
    ADD CONSTRAINT "ADRESS_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3229 (class 2606 OID 16458)
-- Name: CATEGORY CATEGORY_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."CATEGORY"
    ADD CONSTRAINT "CATEGORY_pkey" PRIMARY KEY (category_id);


--
-- TOC entry 3231 (class 2606 OID 16460)
-- Name: COLOR COLOR_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."COLOR"
    ADD CONSTRAINT "COLOR_pkey" PRIMARY KEY ("#");


--
-- TOC entry 3233 (class 2606 OID 16462)
-- Name: MATERIAL MATERIAL_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."MATERIAL"
    ADD CONSTRAINT "MATERIAL_pkey" PRIMARY KEY ("##");


--
-- TOC entry 3235 (class 2606 OID 16464)
-- Name: NUMOFORDER NUMOFORDER_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."NUMOFORDER"
    ADD CONSTRAINT "NUMOFORDER_pkey" PRIMARY KEY (num_order);


--
-- TOC entry 3237 (class 2606 OID 16466)
-- Name: ORDER ORDER_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."ORDER"
    ADD CONSTRAINT "ORDER_pkey" PRIMARY KEY (number_order, id_product);


--
-- TOC entry 3239 (class 2606 OID 16468)
-- Name: POLZ POLZ_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."POLZ"
    ADD CONSTRAINT "POLZ_pkey" PRIMARY KEY (id_c);


--
-- TOC entry 3241 (class 2606 OID 16470)
-- Name: PRODUCTS PRODUCTS_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."PRODUCTS"
    ADD CONSTRAINT "PRODUCTS_pkey" PRIMARY KEY (product_id);


--
-- TOC entry 3243 (class 2606 OID 16472)
-- Name: USERS USERS_pkey; Type: CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."USERS"
    ADD CONSTRAINT "USERS_pkey" PRIMARY KEY (id);


--
-- TOC entry 3253 (class 2620 OID 16473)
-- Name: USERS remove_user; Type: TRIGGER; Schema: omg; Owner: postgres
--

CREATE TRIGGER remove_user BEFORE DELETE ON omg."USERS" FOR EACH ROW EXECUTE FUNCTION omg.del_all_user_orders();


--
-- TOC entry 3252 (class 2620 OID 16474)
-- Name: ORDER upd_summa; Type: TRIGGER; Schema: omg; Owner: postgres
--

CREATE TRIGGER upd_summa AFTER INSERT ON omg."ORDER" FOR EACH ROW EXECUTE FUNCTION omg.update_summa();


--
-- TOC entry 3251 (class 2606 OID 16475)
-- Name: USERS fk_adress; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."USERS"
    ADD CONSTRAINT fk_adress FOREIGN KEY (adress) REFERENCES omg."ADRESS"("ID") NOT VALID;


--
-- TOC entry 3248 (class 2606 OID 16480)
-- Name: PRODUCTS fk_category; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."PRODUCTS"
    ADD CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES omg."CATEGORY"(category_id) NOT VALID;


--
-- TOC entry 3249 (class 2606 OID 16485)
-- Name: PRODUCTS fk_color; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."PRODUCTS"
    ADD CONSTRAINT fk_color FOREIGN KEY (color) REFERENCES omg."COLOR"("#") NOT VALID;


--
-- TOC entry 3247 (class 2606 OID 16490)
-- Name: POLZ fk_id; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."POLZ"
    ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES omg."USERS"(id) NOT VALID;


--
-- TOC entry 3250 (class 2606 OID 16495)
-- Name: PRODUCTS fk_material; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."PRODUCTS"
    ADD CONSTRAINT fk_material FOREIGN KEY (type_of_material) REFERENCES omg."MATERIAL"("##") NOT VALID;


--
-- TOC entry 3244 (class 2606 OID 16500)
-- Name: NUMOFORDER id_user_usersFK; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."NUMOFORDER"
    ADD CONSTRAINT "id_user_usersFK" FOREIGN KEY (id_user) REFERENCES omg."USERS"(id) NOT VALID;


--
-- TOC entry 3245 (class 2606 OID 16505)
-- Name: ORDER number_orderFK; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."ORDER"
    ADD CONSTRAINT "number_orderFK" FOREIGN KEY (number_order) REFERENCES omg."NUMOFORDER"(num_order);


--
-- TOC entry 3246 (class 2606 OID 16510)
-- Name: ORDER prod_idFK; Type: FK CONSTRAINT; Schema: omg; Owner: postgres
--

ALTER TABLE ONLY omg."ORDER"
    ADD CONSTRAINT "prod_idFK" FOREIGN KEY (id_product) REFERENCES omg."PRODUCTS"(product_id);


--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-06-23 11:24:48

--
-- PostgreSQL database dump complete
--

