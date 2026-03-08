BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "username" text NOT NULL,
    "passwordHash" text NOT NULL,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "lastLogin" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "username_unique_idx" ON "app_user" USING btree ("username");
CREATE INDEX "email_idx" ON "app_user" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "coffee" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "composition" text NOT NULL,
    "moreInfo" text NOT NULL,
    "videoUrl" text NOT NULL,
    "imageUrl" text NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "coffee_name_idx" ON "coffee" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "qr_code_mapping" (
    "id" bigserial PRIMARY KEY,
    "qrCode" text NOT NULL,
    "coffeeId" bigint NOT NULL,
    "createdAt" timestamp without time zone,
    "isActive" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "qr_code_unique_idx" ON "qr_code_mapping" USING btree ("qrCode");


--
-- MIGRATION VERSION FOR ctecka_etiket
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('ctecka_etiket', '20251129142223910', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251129142223910', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
