BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "media_files" (
    "id" bigserial PRIMARY KEY,
    "url" text NOT NULL,
    "fileName" text NOT NULL,
    "fileType" text NOT NULL,
    "mimeType" text NOT NULL,
    "fileSize" bigint NOT NULL,
    "uploadedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uploadedBy" text NOT NULL
);


--
-- MIGRATION VERSION FOR ctecka_etiket
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('ctecka_etiket', '20251130160708225', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251130160708225', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
