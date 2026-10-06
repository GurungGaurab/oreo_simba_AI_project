# Using AI + RAG to keep track of my cats' health

A chatbot that answers questions about my two cats, Oreo and Simba, from their real vet records: blood tests, urine tests, vaccinations and weights. Every answer points to the report it came from.

Example questions:
- "When is Simba's next vaccine due?"
- "How has Oreo's creatinine changed since 2024?"

The project is a full pipeline: **ingesting → storing → retrieving → answering**.

## Why I built it

1. **For my cats.** I want their health information in one place, so I can find it quickly and keep track of how they're doing.
2. **For my research.** I'm a research contributor at the University of Wollongong College Hong Kong (UOWCHK) on a project about RAG and keeping documents up to date. My cats get blood tests and vaccines every year, so new records keep replacing old ones. The chatbot has to use the **latest** result, but still answer history questions like "What was it in 2024?". That's the same problem my research looks at.
3. **To build a complete pipeline myself,** from raw paper records to an AI answer with sources.

## Data and privacy

The real vet records are private and are **not** in this repository. The chatbot answers from them locally.

## Status

Phase 1: database and blood-test loading, **In progress**
