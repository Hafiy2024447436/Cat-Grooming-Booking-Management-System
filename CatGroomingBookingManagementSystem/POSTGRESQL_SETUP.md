# PostgreSQL Local Setup

The project uses Maven. Do **not** manually copy PostgreSQL, Jakarta Mail, JSTL, or BCrypt JAR files into `WEB-INF/lib`.

## Import into Eclipse

1. Open Eclipse.
2. Select **File > Import > Maven > Existing Maven Projects**.
3. Select the folder containing `pom.xml`.
4. Finish the import.
5. Right-click the project and select **Maven > Update Project**.
6. Configure an **Apache Tomcat 10.1** server.

Maven downloads all required dependencies from `pom.xml`, including the PostgreSQL JDBC driver.

## Create the local database

Create an empty PostgreSQL database named:

```text
cat_grooming
```

Run:

```text
database/postgresql_schema.sql
```

This script recreates the application tables, so only run it on a new database or when you intentionally want to reset local data.

## Local environment variables

Configure these environment variables in the Tomcat launch configuration:

```text
DB_URL=jdbc:postgresql://localhost:5432/cat_grooming
DB_USER=postgres
DB_PASSWORD=your_postgres_password
DB_AUTO_INIT=false
```

For local email testing, also configure the `SMTP_*` variables listed in `.env.example`.

## Build from a terminal

With Java 21 and Maven installed:

```text
mvn clean package
```

The generated WAR is:

```text
target/cat-grooming.war
```

For Heroku instructions, read `HEROKU_DEPLOYMENT.md`.
