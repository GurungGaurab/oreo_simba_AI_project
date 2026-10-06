# Schema design (Phase 1)

Database: `catrag` (PostgreSQL 15 + pgvector). Three tables, created in this order because each one points to the one before:

`cats` → `documents` → `blood_results`

Rule followed: **each fact is stored once, in the table it belongs to** (normalisation). Facts about a cat live in `cats`, facts about a report in `documents`, and facts about a single test result in `blood_results`.

## cats

One row per cat.

| Column | Type | Why |
|---|---|---|
| `cat_id` | INTEGER, primary key, auto-numbered | Short, stable number other tables point to |
| `cat_name` | TEXT, unique | "Oreo", "Simba". Unique so the same cat can't be added twice |
| `birth_date` | DATE | Only the day matters, not the time |
| `breed` | TEXT | Can be empty; the lab reports leave it blank |
| `sex` | TEXT | "male" / "female" |
| `neutered` | BOOLEAN | Yes/no |

## documents

One row per report PDF (one lab report = one document).

| Column | Type | Why |
|---|---|---|
| `document_id` | INTEGER, primary key, auto-numbered | What `blood_results` points to |
| `source_file` | TEXT, unique | The PDF file name, e.g. `2026-08-10_oreo_chemistry.pdf`. Used for citations. Unique, so re-running the loader can't register the same PDF twice |
| `cat_id` | INTEGER, points to `cats` | Which cat the report is about |
| `report_datetime` | TIMESTAMP | Time matters: Oreo had three reports on 10 Aug 2026 (16:49, 17:05, 18:12). Lets queries sort by "latest" correctly |
| `panel_name` | TEXT | Chemistry, haematology, SDMA, ... |
| `doctor` | TEXT | Belongs to the report, not to each result (would repeat ~22 times otherwise) |
| `age_on_report` | TEXT | As printed, e.g. "15 Months" |

## blood_results

One row per test value on a report.

| Column | Type | Why |
|---|---|---|
| `result_id` | INTEGER, primary key, auto-numbered | Every row needs its own identifier |
| `document_id` | INTEGER, points to `documents` | Which report the value came from; the cat and the time come through this link (JOIN) |
| `test` | TEXT | e.g. CREA, SDMA, HCT |
| `value` | NUMERIC | The number for maths and sorting, e.g. `6.01`. Empty (NULL) when the report printed no number (`--.-`, `Negative`) |
| `shown_value` | TEXT | Exactly what the report printed, e.g. `6.01*`, `<0.1`, `Negative`. Nothing is lost |
| `unit` | TEXT | mg/dL, K/µL, ... |
| `ref_low` | NUMERIC | Lower end of the printed reference range. Stored per result because ranges changed with age (kitten vs adult) |
| `ref_high` | NUMERIC | Upper end. Makes "is this above the range?" a simple comparison |
| `flag` | TEXT | HIGH / LOW as printed by the analyser; empty if none |

**UNIQUE rule:** `document_id` + `test`. Within one report each test appears once, so the pair can never repeat. This is what lets the loader be re-run without creating duplicates.

## Decisions

- **Previous values are not stored.** Each report reprints the previous visit's results, but those already exist as rows from the earlier report (checked: 230/230 match).
- **No time removed from dates.** Dropping the time would lose information that can't be recovered.
- **Option B (normalised) chosen over keeping cat/date in every result row.** Queries need a JOIN, in exchange for no duplicated facts.
