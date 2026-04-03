### Flyway — Database Migration Strategy

#### Configuration

- Configure one Flyway instance per datasource using Quarkus named datasource syntax.
- Name datasources meaningfully — for example `primary`, `secondary` — in `application.properties`.
- Never use the default unnamed datasource when managing multiple databases; always name explicitly.
```properties
# Primary datasource
quarkus.datasource.primary.db-kind=postgresql
quarkus.flyway.primary.locations=db/primary/migration
quarkus.flyway.primary.migrate-at-start=true

# Secondary datasource
quarkus.datasource.secondary.db-kind=postgresql
quarkus.flyway.secondary.locations=db/secondary/migration
quarkus.flyway.secondary.migrate-at-start=true
```

#### Script Location & Naming
```
src/main/resources/
└── db/
    ├── primary/
    │   └── migration/
    │       ├── V1__orders_create_table.sql
    │       └── V2__orders_add_confirmed_at_column.sql
    └── secondary/
        └── migration/
            └── V1__audit_create_log_table.sql
```

- Script naming: `V<version>__<bounded_context>_<description>.sql`
- Version numbers are sequential integers per datasource; never reuse or skip.
- Descriptions are lowercase snake_case and describe the change, not the ticket.
- Repeatable migrations (views, functions) use `R__<description>.sql`.

#### Rules

- Never modify an existing migration script; always add a new versioned one.
- Never share migration scripts across datasources; each datasource owns its schema independently.
- Use `IF NOT EXISTS` and `IF EXISTS` guards on all DDL statements for idempotency.
- Never use Flyway's `clean` in any environment other than local development;
  disable it explicitly in production configuration.
- Schema changes that accompany a code change must be deployed first;
  write migrations to be backward compatible with the previous version of the application.
- Never perform data migrations in the same script as schema migrations; separate them
  into distinct versioned scripts.

#### Mission-Critical Considerations

- All destructive changes (`DROP`, `DELETE`, `TRUNCATE`) require a peer review before merge.
- Column or table renames must be done in three steps: add new → migrate data → drop old;
  never in a single script.
- Keep a rollback plan for every migration; document it in a comment at the top of the script.
- Tag the Git commit that introduces a migration with the version number for traceability.
