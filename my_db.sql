--
-- PostgreSQL database dump
--

\restrict EdpW9GXvWYezMjndyDTmOAhOsyWFUjYZphWjdMzlrouXhaKhtwpK4gtHxZyl7Da

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-01 16:51:20

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
-- TOC entry 896 (class 1247 OID 16390)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'creative',
    'fan',
    'industry',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 16973)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16400)
-- Name: app_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_users (
    id integer NOT NULL,
    email text NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    password_hash text,
    role public.user_role DEFAULT 'fan'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    disabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.app_users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16399)
-- Name: app_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_users_id_seq OWNER TO postgres;

--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 219
-- Name: app_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_users_id_seq OWNED BY public.app_users.id;


--
-- TOC entry 224 (class 1259 OID 16445)
-- Name: auth_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token text NOT NULL,
    type text NOT NULL,
    data jsonb,
    expires_at timestamp with time zone,
    used boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.auth_tokens OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16444)
-- Name: auth_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_tokens_id_seq OWNED BY public.auth_tokens.id;


--
-- TOC entry 258 (class 1259 OID 16898)
-- Name: content_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.content_reports (
    id integer NOT NULL,
    reporter_user_id integer,
    target_type text NOT NULL,
    target_id integer NOT NULL,
    reason text,
    status text DEFAULT 'open'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.content_reports OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 16897)
-- Name: content_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.content_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.content_reports_id_seq OWNER TO postgres;

--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 257
-- Name: content_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.content_reports_id_seq OWNED BY public.content_reports.id;


--
-- TOC entry 252 (class 1259 OID 16832)
-- Name: conversation_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversation_participants (
    conversation_id integer NOT NULL,
    user_id integer NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    last_read_at timestamp with time zone
);


ALTER TABLE public.conversation_participants OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16819)
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    title text,
    is_group boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16818)
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO postgres;

--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 250
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- TOC entry 260 (class 1259 OID 16919)
-- Name: engagement_counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engagement_counters (
    id integer NOT NULL,
    entity_type text NOT NULL,
    entity_id integer NOT NULL,
    likes bigint DEFAULT 0 NOT NULL,
    comments bigint DEFAULT 0 NOT NULL,
    shares bigint DEFAULT 0 NOT NULL,
    views bigint DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.engagement_counters OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16918)
-- Name: engagement_counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.engagement_counters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.engagement_counters_id_seq OWNER TO postgres;

--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 259
-- Name: engagement_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.engagement_counters_id_seq OWNED BY public.engagement_counters.id;


--
-- TOC entry 245 (class 1259 OID 16748)
-- Name: event_hypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_hypes (
    id integer NOT NULL,
    event_id integer NOT NULL,
    user_id integer NOT NULL,
    amount integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.event_hypes OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16747)
-- Name: event_hypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_hypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_hypes_id_seq OWNER TO postgres;

--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 244
-- Name: event_hypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_hypes_id_seq OWNED BY public.event_hypes.id;


--
-- TOC entry 239 (class 1259 OID 16657)
-- Name: event_ticket_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_ticket_types (
    id integer NOT NULL,
    event_id integer NOT NULL,
    title text NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0.00 NOT NULL,
    currency character(3) DEFAULT 'USD'::bpchar NOT NULL,
    quantity integer,
    sales_start timestamp with time zone,
    sales_end timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.event_ticket_types OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16656)
-- Name: event_ticket_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_ticket_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_ticket_types_id_seq OWNER TO postgres;

--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 238
-- Name: event_ticket_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_ticket_types_id_seq OWNED BY public.event_ticket_types.id;


--
-- TOC entry 237 (class 1259 OID 16628)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id integer NOT NULL,
    creator_id integer,
    title text NOT NULL,
    description text,
    poster_media_id integer,
    location jsonb,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    is_virtual boolean DEFAULT false NOT NULL,
    max_attendees integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16627)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO postgres;

--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 236
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 229 (class 1259 OID 16511)
-- Name: follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follows (
    follower_id integer NOT NULL,
    followee_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT follows_check CHECK ((follower_id <> followee_id))
);


ALTER TABLE public.follows OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16494)
-- Name: media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media (
    id integer NOT NULL,
    owner_user_id integer,
    url text NOT NULL,
    provider text,
    type text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.media OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16493)
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_id_seq OWNER TO postgres;

--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 227
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- TOC entry 254 (class 1259 OID 16852)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    conversation_id integer NOT NULL,
    sender_user_id integer,
    body text,
    attachments jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    edited_at timestamp with time zone,
    deleted boolean DEFAULT false NOT NULL,
    delivery_status text DEFAULT 'delivered'::text
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16851)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO postgres;

--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 253
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 256 (class 1259 OID 16878)
-- Name: moderation_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moderation_actions (
    id integer NOT NULL,
    admin_user_id integer,
    target_type text NOT NULL,
    target_id integer NOT NULL,
    action_type text NOT NULL,
    reason text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.moderation_actions OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 16877)
-- Name: moderation_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.moderation_actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.moderation_actions_id_seq OWNER TO postgres;

--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 255
-- Name: moderation_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.moderation_actions_id_seq OWNED BY public.moderation_actions.id;


--
-- TOC entry 222 (class 1259 OID 16423)
-- Name: oauth_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_accounts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    provider text NOT NULL,
    provider_account_id text NOT NULL,
    provider_data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.oauth_accounts OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16422)
-- Name: oauth_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oauth_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.oauth_accounts_id_seq OWNER TO postgres;

--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 221
-- Name: oauth_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oauth_accounts_id_seq OWNED BY public.oauth_accounts.id;


--
-- TOC entry 247 (class 1259 OID 16774)
-- Name: payouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payouts (
    id integer NOT NULL,
    creative_user_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character(3) DEFAULT 'USD'::bpchar NOT NULL,
    provider_info jsonb,
    status text DEFAULT 'requested'::text NOT NULL,
    requested_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone
);


ALTER TABLE public.payouts OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16773)
-- Name: payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payouts_id_seq OWNER TO postgres;

--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 246
-- Name: payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payouts_id_seq OWNED BY public.payouts.id;


--
-- TOC entry 235 (class 1259 OID 16594)
-- Name: post_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    author_id integer NOT NULL,
    parent_comment_id integer,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.post_comments OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16593)
-- Name: post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.post_comments_id_seq OWNER TO postgres;

--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 234
-- Name: post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_comments_id_seq OWNED BY public.post_comments.id;


--
-- TOC entry 233 (class 1259 OID 16574)
-- Name: post_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_likes (
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.post_likes OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16555)
-- Name: post_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_media (
    post_id integer NOT NULL,
    media_id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.post_media OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16532)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    author_id integer NOT NULL,
    content text,
    content_blocks jsonb,
    visibility text DEFAULT 'public'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    extra jsonb
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16531)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 230
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 226 (class 1259 OID 16469)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    username text NOT NULL,
    display_name text,
    bio text,
    avatar_url text,
    profile_type text,
    category text,
    socials jsonb,
    portfolio jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16468)
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq OWNER TO postgres;

--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 225
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- TOC entry 249 (class 1259 OID 16797)
-- Name: purchases_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases_log (
    id integer NOT NULL,
    user_id integer,
    transaction_id integer,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.purchases_log OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16796)
-- Name: purchases_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchases_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchases_log_id_seq OWNER TO postgres;

--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 248
-- Name: purchases_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchases_log_id_seq OWNED BY public.purchases_log.id;


--
-- TOC entry 262 (class 1259 OID 16943)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    refresh_token text,
    user_agent text,
    ip_address text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    revoked boolean DEFAULT false NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 16942)
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sessions_id_seq OWNER TO postgres;

--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 261
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- TOC entry 243 (class 1259 OID 16716)
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    id integer NOT NULL,
    ticket_type_id integer NOT NULL,
    owner_user_id integer,
    purchase_id integer,
    code text,
    issued_at timestamp with time zone DEFAULT now() NOT NULL,
    used boolean DEFAULT false NOT NULL,
    used_at timestamp with time zone
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16715)
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tickets_id_seq OWNER TO postgres;

--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 242
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- TOC entry 241 (class 1259 OID 16682)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    user_id integer,
    event_id integer,
    ticket_type_id integer,
    amount numeric(12,2) NOT NULL,
    currency character(3) DEFAULT 'USD'::bpchar NOT NULL,
    provider text,
    provider_payload jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16681)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO postgres;

--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 240
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- TOC entry 4925 (class 2604 OID 16403)
-- Name: app_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users ALTER COLUMN id SET DEFAULT nextval('public.app_users_id_seq'::regclass);


--
-- TOC entry 4933 (class 2604 OID 16448)
-- Name: auth_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_tokens ALTER COLUMN id SET DEFAULT nextval('public.auth_tokens_id_seq'::regclass);


--
-- TOC entry 4989 (class 2604 OID 16901)
-- Name: content_reports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_reports ALTER COLUMN id SET DEFAULT nextval('public.content_reports_id_seq'::regclass);


--
-- TOC entry 4979 (class 2604 OID 16822)
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- TOC entry 4992 (class 2604 OID 16922)
-- Name: engagement_counters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engagement_counters ALTER COLUMN id SET DEFAULT nextval('public.engagement_counters_id_seq'::regclass);


--
-- TOC entry 4970 (class 2604 OID 16751)
-- Name: event_hypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_hypes ALTER COLUMN id SET DEFAULT nextval('public.event_hypes_id_seq'::regclass);


--
-- TOC entry 4958 (class 2604 OID 16660)
-- Name: event_ticket_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ticket_types ALTER COLUMN id SET DEFAULT nextval('public.event_ticket_types_id_seq'::regclass);


--
-- TOC entry 4953 (class 2604 OID 16631)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 4939 (class 2604 OID 16497)
-- Name: media id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- TOC entry 4983 (class 2604 OID 16855)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 4987 (class 2604 OID 16881)
-- Name: moderation_actions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation_actions ALTER COLUMN id SET DEFAULT nextval('public.moderation_actions_id_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 16426)
-- Name: oauth_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_accounts ALTER COLUMN id SET DEFAULT nextval('public.oauth_accounts_id_seq'::regclass);


--
-- TOC entry 4973 (class 2604 OID 16777)
-- Name: payouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payouts ALTER COLUMN id SET DEFAULT nextval('public.payouts_id_seq'::regclass);


--
-- TOC entry 4949 (class 2604 OID 16597)
-- Name: post_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments ALTER COLUMN id SET DEFAULT nextval('public.post_comments_id_seq'::regclass);


--
-- TOC entry 4942 (class 2604 OID 16535)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 4936 (class 2604 OID 16472)
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- TOC entry 4977 (class 2604 OID 16800)
-- Name: purchases_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases_log ALTER COLUMN id SET DEFAULT nextval('public.purchases_log_id_seq'::regclass);


--
-- TOC entry 4998 (class 2604 OID 16946)
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- TOC entry 4967 (class 2604 OID 16719)
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- TOC entry 4962 (class 2604 OID 16685)
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- TOC entry 5267 (class 0 OID 16400)
-- Dependencies: 220
-- Data for Name: app_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_users (id, email, email_verified, password_hash, role, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 5271 (class 0 OID 16445)
-- Dependencies: 224
-- Data for Name: auth_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_tokens (id, user_id, token, type, data, expires_at, used, created_at) FROM stdin;
\.


--
-- TOC entry 5305 (class 0 OID 16898)
-- Dependencies: 258
-- Data for Name: content_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.content_reports (id, reporter_user_id, target_type, target_id, reason, status, created_at) FROM stdin;
\.


--
-- TOC entry 5299 (class 0 OID 16832)
-- Dependencies: 252
-- Data for Name: conversation_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversation_participants (conversation_id, user_id, joined_at, last_read_at) FROM stdin;
\.


--
-- TOC entry 5298 (class 0 OID 16819)
-- Dependencies: 251
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversations (id, title, is_group, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 5307 (class 0 OID 16919)
-- Dependencies: 260
-- Data for Name: engagement_counters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.engagement_counters (id, entity_type, entity_id, likes, comments, shares, views, last_updated) FROM stdin;
\.


--
-- TOC entry 5292 (class 0 OID 16748)
-- Dependencies: 245
-- Data for Name: event_hypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_hypes (id, event_id, user_id, amount, created_at) FROM stdin;
\.


--
-- TOC entry 5286 (class 0 OID 16657)
-- Dependencies: 239
-- Data for Name: event_ticket_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_ticket_types (id, event_id, title, description, price, currency, quantity, sales_start, sales_end, created_at) FROM stdin;
\.


--
-- TOC entry 5284 (class 0 OID 16628)
-- Dependencies: 237
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, creator_id, title, description, poster_media_id, location, starts_at, ends_at, is_virtual, max_attendees, created_at, updated_at, status) FROM stdin;
\.


--
-- TOC entry 5276 (class 0 OID 16511)
-- Dependencies: 229
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follows (follower_id, followee_id, created_at) FROM stdin;
\.


--
-- TOC entry 5275 (class 0 OID 16494)
-- Dependencies: 228
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media (id, owner_user_id, url, provider, type, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 5301 (class 0 OID 16852)
-- Dependencies: 254
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, conversation_id, sender_user_id, body, attachments, created_at, edited_at, deleted, delivery_status) FROM stdin;
\.


--
-- TOC entry 5303 (class 0 OID 16878)
-- Dependencies: 256
-- Data for Name: moderation_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moderation_actions (id, admin_user_id, target_type, target_id, action_type, reason, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 5269 (class 0 OID 16423)
-- Dependencies: 222
-- Data for Name: oauth_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_accounts (id, user_id, provider, provider_account_id, provider_data, created_at) FROM stdin;
\.


--
-- TOC entry 5294 (class 0 OID 16774)
-- Dependencies: 247
-- Data for Name: payouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payouts (id, creative_user_id, amount, currency, provider_info, status, requested_at, processed_at) FROM stdin;
\.


--
-- TOC entry 5282 (class 0 OID 16594)
-- Dependencies: 235
-- Data for Name: post_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_comments (id, post_id, author_id, parent_comment_id, body, created_at, updated_at, deleted) FROM stdin;
\.


--
-- TOC entry 5280 (class 0 OID 16574)
-- Dependencies: 233
-- Data for Name: post_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_likes (post_id, user_id, created_at) FROM stdin;
\.


--
-- TOC entry 5279 (class 0 OID 16555)
-- Dependencies: 232
-- Data for Name: post_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_media (post_id, media_id, "position") FROM stdin;
\.


--
-- TOC entry 5278 (class 0 OID 16532)
-- Dependencies: 231
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, author_id, content, content_blocks, visibility, created_at, updated_at, deleted, extra) FROM stdin;
\.


--
-- TOC entry 5273 (class 0 OID 16469)
-- Dependencies: 226
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, user_id, username, display_name, bio, avatar_url, profile_type, category, socials, portfolio, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5296 (class 0 OID 16797)
-- Dependencies: 249
-- Data for Name: purchases_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchases_log (id, user_id, transaction_id, details, created_at) FROM stdin;
\.


--
-- TOC entry 5309 (class 0 OID 16943)
-- Dependencies: 262
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, refresh_token, user_agent, ip_address, created_at, expires_at, revoked) FROM stdin;
\.


--
-- TOC entry 5290 (class 0 OID 16716)
-- Dependencies: 243
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (id, ticket_type_id, owner_user_id, purchase_id, code, issued_at, used, used_at) FROM stdin;
\.


--
-- TOC entry 5288 (class 0 OID 16682)
-- Dependencies: 241
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, user_id, event_id, ticket_type_id, amount, currency, provider, provider_payload, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 219
-- Name: app_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_users_id_seq', 1, false);


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_tokens_id_seq', 1, false);


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 257
-- Name: content_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.content_reports_id_seq', 1, false);


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 250
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conversations_id_seq', 1, false);


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 259
-- Name: engagement_counters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.engagement_counters_id_seq', 1, false);


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 244
-- Name: event_hypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_hypes_id_seq', 1, false);


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 238
-- Name: event_ticket_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_ticket_types_id_seq', 1, false);


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 236
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 1, false);


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 227
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_id_seq', 1, false);


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 253
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 255
-- Name: moderation_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moderation_actions_id_seq', 1, false);


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 221
-- Name: oauth_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oauth_accounts_id_seq', 1, false);


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 246
-- Name: payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payouts_id_seq', 1, false);


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 234
-- Name: post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_comments_id_seq', 1, false);


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 230
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 225
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 248
-- Name: purchases_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchases_log_id_seq', 1, false);


--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 261
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_id_seq', 1, false);


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 242
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 1, false);


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 240
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- TOC entry 5003 (class 2606 OID 16421)
-- Name: app_users app_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_email_key UNIQUE (email);


--
-- TOC entry 5005 (class 2606 OID 16419)
-- Name: app_users app_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_pkey PRIMARY KEY (id);


--
-- TOC entry 5011 (class 2606 OID 16460)
-- Name: auth_tokens auth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5013 (class 2606 OID 16462)
-- Name: auth_tokens auth_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_token_key UNIQUE (token);


--
-- TOC entry 5069 (class 2606 OID 16912)
-- Name: content_reports content_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_reports
    ADD CONSTRAINT content_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 5062 (class 2606 OID 16840)
-- Name: conversation_participants conversation_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_pkey PRIMARY KEY (conversation_id, user_id);


--
-- TOC entry 5060 (class 2606 OID 16831)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- TOC entry 5071 (class 2606 OID 16941)
-- Name: engagement_counters engagement_counters_entity_type_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engagement_counters
    ADD CONSTRAINT engagement_counters_entity_type_entity_id_key UNIQUE (entity_type, entity_id);


--
-- TOC entry 5073 (class 2606 OID 16939)
-- Name: engagement_counters engagement_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engagement_counters
    ADD CONSTRAINT engagement_counters_pkey PRIMARY KEY (id);


--
-- TOC entry 5052 (class 2606 OID 16762)
-- Name: event_hypes event_hypes_event_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_hypes
    ADD CONSTRAINT event_hypes_event_id_user_id_key UNIQUE (event_id, user_id);


--
-- TOC entry 5054 (class 2606 OID 16760)
-- Name: event_hypes event_hypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_hypes
    ADD CONSTRAINT event_hypes_pkey PRIMARY KEY (id);


--
-- TOC entry 5040 (class 2606 OID 16675)
-- Name: event_ticket_types event_ticket_types_event_id_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ticket_types
    ADD CONSTRAINT event_ticket_types_event_id_title_key UNIQUE (event_id, title);


--
-- TOC entry 5042 (class 2606 OID 16673)
-- Name: event_ticket_types event_ticket_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ticket_types
    ADD CONSTRAINT event_ticket_types_pkey PRIMARY KEY (id);


--
-- TOC entry 5037 (class 2606 OID 16645)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 5025 (class 2606 OID 16520)
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (follower_id, followee_id);


--
-- TOC entry 5023 (class 2606 OID 16505)
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- TOC entry 5065 (class 2606 OID 16866)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5067 (class 2606 OID 16891)
-- Name: moderation_actions moderation_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation_actions
    ADD CONSTRAINT moderation_actions_pkey PRIMARY KEY (id);


--
-- TOC entry 5007 (class 2606 OID 16436)
-- Name: oauth_accounts oauth_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_accounts
    ADD CONSTRAINT oauth_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 5009 (class 2606 OID 16438)
-- Name: oauth_accounts oauth_accounts_provider_provider_account_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_accounts
    ADD CONSTRAINT oauth_accounts_provider_provider_account_id_key UNIQUE (provider, provider_account_id);


--
-- TOC entry 5056 (class 2606 OID 16790)
-- Name: payouts payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payouts
    ADD CONSTRAINT payouts_pkey PRIMARY KEY (id);


--
-- TOC entry 5035 (class 2606 OID 16611)
-- Name: post_comments post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 5033 (class 2606 OID 16582)
-- Name: post_likes post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_pkey PRIMARY KEY (post_id, user_id);


--
-- TOC entry 5031 (class 2606 OID 16563)
-- Name: post_media post_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_media
    ADD CONSTRAINT post_media_pkey PRIMARY KEY (post_id, media_id);


--
-- TOC entry 5029 (class 2606 OID 16549)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 16483)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5018 (class 2606 OID 16485)
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 5020 (class 2606 OID 16487)
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- TOC entry 5058 (class 2606 OID 16807)
-- Name: purchases_log purchases_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases_log
    ADD CONSTRAINT purchases_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5076 (class 2606 OID 16956)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5078 (class 2606 OID 16958)
-- Name: sessions sessions_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_refresh_token_key UNIQUE (refresh_token);


--
-- TOC entry 5048 (class 2606 OID 16731)
-- Name: tickets tickets_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_code_key UNIQUE (code);


--
-- TOC entry 5050 (class 2606 OID 16729)
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 5045 (class 2606 OID 16699)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5074 (class 1259 OID 16972)
-- Name: idx_engagement_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_engagement_entity ON public.engagement_counters USING btree (entity_type, entity_id);


--
-- TOC entry 5038 (class 1259 OID 16967)
-- Name: idx_events_starts_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_starts_at ON public.events USING btree (starts_at);


--
-- TOC entry 5026 (class 1259 OID 16970)
-- Name: idx_follows_followee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_follows_followee ON public.follows USING btree (followee_id);


--
-- TOC entry 5021 (class 1259 OID 16965)
-- Name: idx_media_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_media_owner ON public.media USING btree (owner_user_id);


--
-- TOC entry 5063 (class 1259 OID 16971)
-- Name: idx_messages_conv_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_conv_created ON public.messages USING btree (conversation_id, created_at DESC);


--
-- TOC entry 5027 (class 1259 OID 16966)
-- Name: idx_posts_author_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_posts_author_created ON public.posts USING btree (author_id, created_at DESC);


--
-- TOC entry 5014 (class 1259 OID 16964)
-- Name: idx_profiles_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profiles_username ON public.profiles USING btree (username);


--
-- TOC entry 5046 (class 1259 OID 16969)
-- Name: idx_tickets_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tickets_owner ON public.tickets USING btree (owner_user_id);


--
-- TOC entry 5043 (class 1259 OID 16968)
-- Name: idx_transactions_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_user ON public.transactions USING btree (user_id);


--
-- TOC entry 5117 (class 2620 OID 16978)
-- Name: events trg_update_events_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_events_updated_at BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5116 (class 2620 OID 16976)
-- Name: posts trg_update_posts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_posts_updated_at BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5115 (class 2620 OID 16975)
-- Name: profiles trg_update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5118 (class 2620 OID 16977)
-- Name: transactions trg_update_transactions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_transactions_updated_at BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5114 (class 2620 OID 16974)
-- Name: app_users trg_update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_users_updated_at BEFORE UPDATE ON public.app_users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5080 (class 2606 OID 16463)
-- Name: auth_tokens auth_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5112 (class 2606 OID 16913)
-- Name: content_reports content_reports_reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_reports
    ADD CONSTRAINT content_reports_reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.app_users(id);


--
-- TOC entry 5107 (class 2606 OID 16841)
-- Name: conversation_participants conversation_participants_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- TOC entry 5108 (class 2606 OID 16846)
-- Name: conversation_participants conversation_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5102 (class 2606 OID 16763)
-- Name: event_hypes event_hypes_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_hypes
    ADD CONSTRAINT event_hypes_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 5103 (class 2606 OID 16768)
-- Name: event_hypes event_hypes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_hypes
    ADD CONSTRAINT event_hypes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5095 (class 2606 OID 16676)
-- Name: event_ticket_types event_ticket_types_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ticket_types
    ADD CONSTRAINT event_ticket_types_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 5093 (class 2606 OID 16646)
-- Name: events events_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- TOC entry 5094 (class 2606 OID 16651)
-- Name: events events_poster_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_poster_media_id_fkey FOREIGN KEY (poster_media_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- TOC entry 5083 (class 2606 OID 16526)
-- Name: follows follows_followee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_followee_id_fkey FOREIGN KEY (followee_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5084 (class 2606 OID 16521)
-- Name: follows follows_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5082 (class 2606 OID 16506)
-- Name: media media_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- TOC entry 5109 (class 2606 OID 16867)
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- TOC entry 5110 (class 2606 OID 16872)
-- Name: messages messages_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- TOC entry 5111 (class 2606 OID 16892)
-- Name: moderation_actions moderation_actions_admin_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation_actions
    ADD CONSTRAINT moderation_actions_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- TOC entry 5079 (class 2606 OID 16439)
-- Name: oauth_accounts oauth_accounts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_accounts
    ADD CONSTRAINT oauth_accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5104 (class 2606 OID 16791)
-- Name: payouts payouts_creative_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payouts
    ADD CONSTRAINT payouts_creative_user_id_fkey FOREIGN KEY (creative_user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5090 (class 2606 OID 16617)
-- Name: post_comments post_comments_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5091 (class 2606 OID 16622)
-- Name: post_comments post_comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.post_comments(id) ON DELETE CASCADE;


--
-- TOC entry 5092 (class 2606 OID 16612)
-- Name: post_comments post_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 5088 (class 2606 OID 16583)
-- Name: post_likes post_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 5089 (class 2606 OID 16588)
-- Name: post_likes post_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5086 (class 2606 OID 16569)
-- Name: post_media post_media_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_media
    ADD CONSTRAINT post_media_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON DELETE RESTRICT;


--
-- TOC entry 5087 (class 2606 OID 16564)
-- Name: post_media post_media_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_media
    ADD CONSTRAINT post_media_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 5085 (class 2606 OID 16550)
-- Name: posts posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5081 (class 2606 OID 16488)
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5105 (class 2606 OID 16813)
-- Name: purchases_log purchases_log_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases_log
    ADD CONSTRAINT purchases_log_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- TOC entry 5106 (class 2606 OID 16808)
-- Name: purchases_log purchases_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases_log
    ADD CONSTRAINT purchases_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id);


--
-- TOC entry 5113 (class 2606 OID 16959)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- TOC entry 5099 (class 2606 OID 16737)
-- Name: tickets tickets_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- TOC entry 5100 (class 2606 OID 16742)
-- Name: tickets tickets_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.transactions(id) ON DELETE SET NULL;


--
-- TOC entry 5101 (class 2606 OID 16732)
-- Name: tickets tickets_ticket_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_ticket_type_id_fkey FOREIGN KEY (ticket_type_id) REFERENCES public.event_ticket_types(id) ON DELETE CASCADE;


--
-- TOC entry 5096 (class 2606 OID 16705)
-- Name: transactions transactions_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- TOC entry 5097 (class 2606 OID 16710)
-- Name: transactions transactions_ticket_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_ticket_type_id_fkey FOREIGN KEY (ticket_type_id) REFERENCES public.event_ticket_types(id);


--
-- TOC entry 5098 (class 2606 OID 16700)
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id);


-- Completed on 2025-10-01 16:51:21

--
-- PostgreSQL database dump complete
--

\unrestrict EdpW9GXvWYezMjndyDTmOAhOsyWFUjYZphWjdMzlrouXhaKhtwpK4gtHxZyl7Da

