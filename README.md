# 🎬 StreamDB — Streaming Platform Database

Full relational database design for a streaming platform, built with **Oracle SQL/PL-SQL**. Covers the complete data lifecycle: schema modeling, constraints, triggers, views, and automated data generation.

> Academic project — Database Systems module, L3 Computer Science @ UVSQ

![SQL](https://img.shields.io/badge/Oracle_SQL-F80000?style=flat&logo=oracle&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-F80000?style=flat&logo=oracle&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Features

- Relational schema with 10+ tables (users, subscriptions, movies, series, episodes, actors, directors, characters)
- Integrity constraints: CHECK, FOREIGN KEY, UNIQUE, NOT NULL
- PL/SQL triggers for business logic (subscription management, age restrictions, content validation)
- Views for reporting (most popular content, user activity, subscription stats)
- Python script for realistic test data generation (Faker)
- SQL*Loader configuration for bulk data import

## Database schema overview

```
USERS ──→ SUBSCRIPTIONS (Basique / Premium)
  │
  ├──→ VIEWINGS (watch history with timestamps)
  ├──→ DOWNLOADS
  └──→ LIKES
  
CONTENT ──→ MOVIES ──→ DIRECTORS
         └→ SERIES ──→ SEASONS ──→ EPISODES
         
ACTORS ──→ CHARACTERS (many-to-many with content)
```

## Tech stack

| Component | Technology |
|-----------|-----------|
| Database | Oracle Database |
| Procedural | PL/SQL (triggers, procedures) |
| Data generation | Python (Faker library) |
| Bulk loading | SQL*Loader |

## Project structure

```
Plateforme-Streaming-DB-Oracle/
├── sql/                    # All SQL scripts
│   ├── create_tables.sql
│   ├── constraints.sql
│   ├── triggers.sql
│   └── views.sql
├── docs/                   # Documentation and diagrams
├── generation_donnee.py    # Python data generator
├── LICENSE
└── README.md
```

## Getting started

```bash
git clone https://github.com/AmZzPYJS/Plateforme-Streaming-DB-Oracle.git
```

1. Run the SQL scripts in order: tables → constraints → triggers → views
2. Generate test data: `python generation_donnee.py`
3. Load data into Oracle using SQL*Loader or manual INSERT

## What I learned

- Designing a normalized relational schema (3NF) from business requirements
- Writing PL/SQL triggers to enforce complex business rules (subscription limits, age verification)
- Creating efficient views for analytics and reporting
- Automating realistic test data generation with Python
- Using SQL*Loader for bulk data import into Oracle

## License

MIT
