

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


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."update_timestamp"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_timestamp"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."brand" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "user_id" "uuid"
);


ALTER TABLE "public"."brand" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."item_category" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."item_category" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."item_metadata" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "wardrobe_item_id" "uuid",
    "metadata" "jsonb"
);


ALTER TABLE "public"."item_metadata" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."outfit" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "name" "text" NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "deleted_at" timestamp without time zone
);


ALTER TABLE "public"."outfit" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."outfit_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "outfit_id" "uuid",
    "wardrobe_item_id" "uuid"
);


ALTER TABLE "public"."outfit_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pic" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "storage" "text" NOT NULL,
    "wardrobe_item_id" "uuid",
    "outfit_id" "uuid",
    "description" "text"
);


ALTER TABLE "public"."pic" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."use_item" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "wardrobe_item_id" "uuid",
    "used_at" timestamp without time zone DEFAULT "now"(),
    "user_id" "uuid"
);


ALTER TABLE "public"."use_item" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."use_outfit" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "outfit_id" "uuid",
    "used_at" timestamp without time zone DEFAULT "now"(),
    "user_id" "uuid"
);


ALTER TABLE "public"."use_outfit" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."wardrobe_item" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "brand_id" "uuid",
    "category_id" "uuid",
    "name" "text" NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "deleted_at" timestamp without time zone
);


ALTER TABLE "public"."wardrobe_item" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_recent_usage" AS
 SELECT "ui"."user_id",
    "ui"."wardrobe_item_id",
    "wi"."name" AS "item_name",
    "ui"."used_at"
   FROM ("public"."use_item" "ui"
     JOIN "public"."wardrobe_item" "wi" ON (("ui"."wardrobe_item_id" = "wi"."id")))
  WHERE ("ui"."used_at" > ("now"() - '30 days'::interval));


ALTER TABLE "public"."v_recent_usage" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_outfits" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"uuid" AS "user_id",
    NULL::"text" AS "name",
    NULL::timestamp without time zone AS "created_at",
    NULL::timestamp without time zone AS "updated_at",
    NULL::timestamp without time zone AS "deleted_at",
    NULL::bigint AS "item_count";


ALTER TABLE "public"."v_user_outfits" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_wardrobe" AS
 SELECT "w"."id",
    "w"."user_id",
    "w"."brand_id",
    "w"."category_id",
    "w"."name",
    "w"."created_at",
    "w"."updated_at",
    "w"."deleted_at",
    "b"."name" AS "brand_name",
    "c"."name" AS "category_name"
   FROM (("public"."wardrobe_item" "w"
     LEFT JOIN "public"."brand" "b" ON (("w"."brand_id" = "b"."id")))
     LEFT JOIN "public"."item_category" "c" ON (("w"."category_id" = "c"."id")))
  WHERE ("w"."deleted_at" IS NULL);


ALTER TABLE "public"."v_user_wardrobe" OWNER TO "postgres";


ALTER TABLE ONLY "public"."brand"
    ADD CONSTRAINT "brand_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."item_category"
    ADD CONSTRAINT "item_category_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."item_category"
    ADD CONSTRAINT "item_category_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."item_metadata"
    ADD CONSTRAINT "item_metadata_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."outfit_items"
    ADD CONSTRAINT "outfit_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."outfit"
    ADD CONSTRAINT "outfit_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pic"
    ADD CONSTRAINT "pic_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."use_item"
    ADD CONSTRAINT "use_item_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."use_outfit"
    ADD CONSTRAINT "use_outfit_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wardrobe_item"
    ADD CONSTRAINT "wardrobe_item_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_outfit_user_id" ON "public"."outfit" USING "btree" ("user_id");



CREATE INDEX "idx_use_item_wardrobe_item_id" ON "public"."use_item" USING "btree" ("wardrobe_item_id");



CREATE INDEX "idx_use_outfit_outfit_id" ON "public"."use_outfit" USING "btree" ("outfit_id");



CREATE INDEX "idx_wardrobe_item_user_id" ON "public"."wardrobe_item" USING "btree" ("user_id");



CREATE OR REPLACE VIEW "public"."v_user_outfits" AS
 SELECT "o"."id",
    "o"."user_id",
    "o"."name",
    "o"."created_at",
    "o"."updated_at",
    "o"."deleted_at",
    "count"("oi"."wardrobe_item_id") AS "item_count"
   FROM ("public"."outfit" "o"
     LEFT JOIN "public"."outfit_items" "oi" ON (("o"."id" = "oi"."outfit_id")))
  WHERE ("o"."deleted_at" IS NULL)
  GROUP BY "o"."id";



CREATE OR REPLACE TRIGGER "trigger_update_outfit" BEFORE UPDATE ON "public"."outfit" FOR EACH ROW EXECUTE FUNCTION "public"."update_timestamp"();



CREATE OR REPLACE TRIGGER "trigger_update_wardrobe_item" BEFORE UPDATE ON "public"."wardrobe_item" FOR EACH ROW EXECUTE FUNCTION "public"."update_timestamp"();



ALTER TABLE ONLY "public"."brand"
    ADD CONSTRAINT "brand_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."item_metadata"
    ADD CONSTRAINT "item_metadata_wardrobe_item_id_fkey" FOREIGN KEY ("wardrobe_item_id") REFERENCES "public"."wardrobe_item"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."outfit_items"
    ADD CONSTRAINT "outfit_items_outfit_id_fkey" FOREIGN KEY ("outfit_id") REFERENCES "public"."outfit"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."outfit_items"
    ADD CONSTRAINT "outfit_items_wardrobe_item_id_fkey" FOREIGN KEY ("wardrobe_item_id") REFERENCES "public"."wardrobe_item"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."outfit"
    ADD CONSTRAINT "outfit_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pic"
    ADD CONSTRAINT "pic_outfit_id_fkey" FOREIGN KEY ("outfit_id") REFERENCES "public"."outfit"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."pic"
    ADD CONSTRAINT "pic_wardrobe_item_id_fkey" FOREIGN KEY ("wardrobe_item_id") REFERENCES "public"."wardrobe_item"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."use_item"
    ADD CONSTRAINT "use_item_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."use_item"
    ADD CONSTRAINT "use_item_wardrobe_item_id_fkey" FOREIGN KEY ("wardrobe_item_id") REFERENCES "public"."wardrobe_item"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."use_outfit"
    ADD CONSTRAINT "use_outfit_outfit_id_fkey" FOREIGN KEY ("outfit_id") REFERENCES "public"."outfit"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."use_outfit"
    ADD CONSTRAINT "use_outfit_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wardrobe_item"
    ADD CONSTRAINT "wardrobe_item_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brand"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."wardrobe_item"
    ADD CONSTRAINT "wardrobe_item_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."item_category"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."wardrobe_item"
    ADD CONSTRAINT "wardrobe_item_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



CREATE POLICY "Users can manage brands" ON "public"."brand" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage item metadata" ON "public"."item_metadata" USING ((EXISTS ( SELECT 1
   FROM "public"."wardrobe_item"
  WHERE (("wardrobe_item"."id" = "item_metadata"."wardrobe_item_id") AND ("wardrobe_item"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."wardrobe_item"
  WHERE (("wardrobe_item"."id" = "item_metadata"."wardrobe_item_id") AND ("wardrobe_item"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can manage pictures" ON "public"."pic" USING (((EXISTS ( SELECT 1
   FROM "public"."wardrobe_item"
  WHERE (("wardrobe_item"."id" = "pic"."wardrobe_item_id") AND ("wardrobe_item"."user_id" = "auth"."uid"())))) OR (EXISTS ( SELECT 1
   FROM "public"."outfit"
  WHERE (("outfit"."id" = "pic"."outfit_id") AND ("outfit"."user_id" = "auth"."uid"())))))) WITH CHECK (((EXISTS ( SELECT 1
   FROM "public"."wardrobe_item"
  WHERE (("wardrobe_item"."id" = "pic"."wardrobe_item_id") AND ("wardrobe_item"."user_id" = "auth"."uid"())))) OR (EXISTS ( SELECT 1
   FROM "public"."outfit"
  WHERE (("outfit"."id" = "pic"."outfit_id") AND ("outfit"."user_id" = "auth"."uid"()))))));



CREATE POLICY "Users can manage their outfits" ON "public"."outfit" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their wardrobe items" ON "public"."wardrobe_item" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can use outfits" ON "public"."use_outfit" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can use wardrobe items" ON "public"."use_item" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view item categories" ON "public"."item_category" FOR SELECT USING (true);



ALTER TABLE "public"."brand" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."item_category" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."item_metadata" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."outfit" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pic" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."use_item" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."use_outfit" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."wardrobe_item" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";


























































































































































































GRANT ALL ON FUNCTION "public"."update_timestamp"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_timestamp"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_timestamp"() TO "service_role";


















GRANT ALL ON TABLE "public"."brand" TO "anon";
GRANT ALL ON TABLE "public"."brand" TO "authenticated";
GRANT ALL ON TABLE "public"."brand" TO "service_role";



GRANT ALL ON TABLE "public"."item_category" TO "anon";
GRANT ALL ON TABLE "public"."item_category" TO "authenticated";
GRANT ALL ON TABLE "public"."item_category" TO "service_role";



GRANT ALL ON TABLE "public"."item_metadata" TO "anon";
GRANT ALL ON TABLE "public"."item_metadata" TO "authenticated";
GRANT ALL ON TABLE "public"."item_metadata" TO "service_role";



GRANT ALL ON TABLE "public"."outfit" TO "anon";
GRANT ALL ON TABLE "public"."outfit" TO "authenticated";
GRANT ALL ON TABLE "public"."outfit" TO "service_role";



GRANT ALL ON TABLE "public"."outfit_items" TO "anon";
GRANT ALL ON TABLE "public"."outfit_items" TO "authenticated";
GRANT ALL ON TABLE "public"."outfit_items" TO "service_role";



GRANT ALL ON TABLE "public"."pic" TO "anon";
GRANT ALL ON TABLE "public"."pic" TO "authenticated";
GRANT ALL ON TABLE "public"."pic" TO "service_role";



GRANT ALL ON TABLE "public"."use_item" TO "anon";
GRANT ALL ON TABLE "public"."use_item" TO "authenticated";
GRANT ALL ON TABLE "public"."use_item" TO "service_role";



GRANT ALL ON TABLE "public"."use_outfit" TO "anon";
GRANT ALL ON TABLE "public"."use_outfit" TO "authenticated";
GRANT ALL ON TABLE "public"."use_outfit" TO "service_role";



GRANT ALL ON TABLE "public"."wardrobe_item" TO "anon";
GRANT ALL ON TABLE "public"."wardrobe_item" TO "authenticated";
GRANT ALL ON TABLE "public"."wardrobe_item" TO "service_role";



GRANT ALL ON TABLE "public"."v_recent_usage" TO "anon";
GRANT ALL ON TABLE "public"."v_recent_usage" TO "authenticated";
GRANT ALL ON TABLE "public"."v_recent_usage" TO "service_role";



GRANT ALL ON TABLE "public"."v_user_outfits" TO "anon";
GRANT ALL ON TABLE "public"."v_user_outfits" TO "authenticated";
GRANT ALL ON TABLE "public"."v_user_outfits" TO "service_role";



GRANT ALL ON TABLE "public"."v_user_wardrobe" TO "anon";
GRANT ALL ON TABLE "public"."v_user_wardrobe" TO "authenticated";
GRANT ALL ON TABLE "public"."v_user_wardrobe" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;

--
-- Dumped schema changes for auth and storage
--

