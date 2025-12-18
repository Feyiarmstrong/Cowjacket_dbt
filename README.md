# Cowjacket_dbt

## Project Overview

This project implements a **full data engineering pipeline** using dbt Cloud with Databricks as the execution platform. The pipeline follows a **three-layer structure**: `staging/`, `intermediate/`, and `marts/`, ensuring clean, tested, and production-safe data transformations.  

The pipeline supports **development, staging, and production environments**, with **guardrails in place** to prevent accidental data overwrites.  

---

## Project Structure

```
models/

├── staging/          # Staging layer (raw sources cleaned)

├── intermediate/     # Intermediate transformations (business logic)

├── marts/            # Final fact/dimension tables

seeds/                # CSV seed files

sources/              # Source table definitions

macros/               # Custom macros (e.g., logging)

snapshots/            # Snapshots if needed

analyses/             # Optional analysis queries

```

- **Staging models**: Materialized as `views`. Perform basic cleaning, PK/FK tests, and not-null validations.  

- **Intermediate models**: Materialized as `views`. Combine staging tables with business logic applied.  

- **Marts models**: Materialized as `tables`. Final production tables with **guardrails to enforce environment-safe deployment**.  

---

## Environment Setup

We use three separate environments:

| Environment  | Schema in Databricks  | Purpose                       |

|-------------|---------------------|--------------------------------|

| Development | `dbt_dev`           | Active development & testing  |

| Staging     | `dbt_staging`       | Pre-production testing         |

| Production  | `dbt_production`    | Final production tables |

- **Guardrails** ensure that marts models **write to `dbt_production` only in production**:

```sql

{{ config(

    materialized='table',

    schema='dbt_production' if target.name == 'production' else target.schema

) }}


{% if target.name != 'production' and config.get('schema') == 'dbt_production' %}

  {{ exceptions.raise_compiler_error("dbt_production is PROD-ONLY") }}

{% endif %}

```

- Dev and staging models continue writing to their respective schemas safely.  

---

## dbt Cloud & Jobs

- **Development workflow**: All code is developed in the dev environment (`dbt_dev`) and tested locally in dbt Cloud.  

- **Staging workflow**: After testing, code is run in the staging environment (`dbt_staging`) to validate full pipeline integration.  

- **Production workflow**: Production jobs build marts tables into `dbt_production`, ensuring dev/staging are untouched.  


**Jobs setup in dbt Cloud:**

1. **Development job** (manual runs)  

2. **Staging job** (manual or scheduled)  

3. **Production job** (manual or scheduled, uses guardrails)  

---

## Observability & Metadata

- Each dbt run logs metadata for observability.  

- Metrics captured include: `model_name`, `environment`, `duration`, `status`, `row_count`.  

- Custom macros (e.g., `log_run_metadata`) ensure **full auditability**.  

---

## Running the Project

1. **Install dependencies**:

```bash

dbt deps

```

2. **Run full project in dev**:

```bash

dbt run --target default

```

3. **Run staging job** in dbt Cloud to validate integration.  

4. **Run production job** to build marts tables into `dbt_production`.  

5. **Check tables**:

```sql

SHOW TABLES IN dbt_dev;

SHOW TABLES IN dbt_staging;

SHOW TABLES IN dbt_production;

```

6. **Generate documentation**:

```bash

dbt docs generate

dbt docs serve

```

---

## Key Features & Benefits

- **Environment-safe guardrails** prevent accidental production writes.  

- **Three-layer modeling** ensures modularity and maintainability.  

- **Schema separation** (`dbt_dev`, `dbt_staging`, `dbt_production`) supports proper CI/CD workflows.  

- **Observability and logging** for each dbt run.  

- Fully compatible with **Databricks free edition**, using schemas instead of multiple warehouses.  

---

## Notes

- All development occurs on the `main` branch in GitHub for simplicity.  

- Production guardrails are enforced through dbt model configs.  

- Schemas must exist in Databricks before running production jobs (`dbt_production` schema).  

---

## Conclusion

This project is a **fully functional dbt pipeline** with development, staging, production environments, proper schema partitioning, and guardrails
