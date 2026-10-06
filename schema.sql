DROP TABLE IF EXISTS blood_results;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS document;
DROP TABLE IF EXISTS cats;

CREATE TABLE cats (
    cat_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cat_name    TEXT NOT NULL UNIQUE,
    birth_date  DATE,
    breed       TEXT,
    sex         TEXT,
    neutered    BOOLEAN
);

CREATE TABLE documents (
    document_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_file     TEXT NOT NULL UNIQUE,
    cat_id          INTEGER NOT NULL REFERENCES cats (cat_id),
    report_datetime TIMESTAMP NOT NULL,
    panel_name      TEXT,
    doctor          TEXT,
    age_on_report   TEXT
);

CREATE TABLE blood_results (
    result_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    document_id  INTEGER NOT NULL REFERENCES documents (document_id),
    test         TEXT NOT NULL,
    value        NUMERIC,
    shown_value  TEXT NOT NULL,
    unit         TEXT,
    ref_low      NUMERIC,
    ref_high     NUMERIC,
    flag         TEXT,
    UNIQUE (document_id, test)
);
