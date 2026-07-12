# Deploy Cat Grooming Booking Management System to Heroku

This project is already prepared as a Maven WAR application using Tomcat 10.1 Webapp Runner and PostgreSQL.

## What is already configured

- `pom.xml` lets Heroku detect and build the Java application.
- `Procfile` starts Tomcat on Heroku's assigned `$PORT`.
- `system.properties` selects Java 21.
- PostgreSQL credentials are read from Heroku's `DATABASE_URL`.
- A non-destructive database bootstrap creates missing tables automatically on the first Heroku startup.
- SMTP credentials and the optional notification microservice URL are environment variables.

## 1. Open Command Prompt in the project folder

The folder containing `pom.xml` must be the current folder:

```bat
cd C:\path\to\CatGroomingBookingManagementSystem
```

Confirm:

```bat
dir pom.xml
```

## 2. Login and create the Heroku app

Replace `YOUR_APP_NAME` with a globally unique lowercase name:

```bat
heroku login
heroku create YOUR_APP_NAME --stack heroku-24
```

For an existing Heroku app instead:

```bat
heroku git:remote -a YOUR_APP_NAME
```

## 3. Add Heroku Postgres

```bat
heroku addons:create heroku-postgresql:essential-0 -a YOUR_APP_NAME
```

Heroku automatically supplies `DATABASE_URL`. Do not manually copy the database password into the source code.

## 4. Configure the first owner account

Set these before the first deployment so the empty cloud database receives an owner account:

```bat
heroku config:set BOOTSTRAP_OWNER_USERNAME=owner -a YOUR_APP_NAME
heroku config:set "BOOTSTRAP_OWNER_PASSWORD=Use-A-Strong-Password-123!" -a YOUR_APP_NAME
heroku config:set "BOOTSTRAP_OWNER_NAME=System Owner" -a YOUR_APP_NAME
heroku config:set BOOTSTRAP_OWNER_EMAIL=owner@example.com -a YOUR_APP_NAME
```

Optional profile details:

```bat
heroku config:set BOOTSTRAP_OWNER_PHONE=0123456789 -a YOUR_APP_NAME
heroku config:set "BOOTSTRAP_OWNER_ADDRESS=Melaka, Malaysia" -a YOUR_APP_NAME
```

The application creates missing tables automatically when `DATABASE_URL` exists. You do not need the local `psql` command for an empty Heroku database.

## 5. Configure email

Create a new Gmail App Password and set it in Heroku. Never put it in a Java file.

```bat
heroku config:set SMTP_HOST=smtp.gmail.com -a YOUR_APP_NAME
heroku config:set SMTP_PORT=465 -a YOUR_APP_NAME
heroku config:set SMTP_USERNAME=yourgmail@gmail.com -a YOUR_APP_NAME
heroku config:set SMTP_PASSWORD=your_new_app_password_without_spaces -a YOUR_APP_NAME
heroku config:set SMTP_FROM_EMAIL=yourgmail@gmail.com -a YOUR_APP_NAME
heroku config:set "SMTP_FROM_NAME=Meowy Groom" -a YOUR_APP_NAME
heroku config:set SMTP_SSL=true -a YOUR_APP_NAME
heroku config:set SMTP_STARTTLS=false -a YOUR_APP_NAME
```

## 6. Optional notification microservice

Only set this after the notification service itself has a public HTTPS URL:

```bat
heroku config:set NOTIFICATION_BOOKING_CONFIRMED_URL=https://YOUR-NOTIFICATION-APP.herokuapp.com/api/notifications/booking-confirmed -a YOUR_APP_NAME
```

Without this setting, booking confirmation still works; only the external notification call is skipped.

## 7. Push the project

```bat
git init
git add .
git commit -m "Prepare cat grooming system for Heroku"
git branch -M main
git push heroku main
```

If Git reports that there is nothing to commit, continue with `git push heroku main`.

## 8. Check the application

```bat
heroku open -a YOUR_APP_NAME
heroku logs --tail -a YOUR_APP_NAME
```

A successful startup includes messages similar to:

```text
PostgreSQL cloud schema is ready.
Initial owner account created from BOOTSTRAP_OWNER_* environment variables.
```

After you confirm that the owner can log in, remove the bootstrap password from Heroku:

```bat
heroku config:unset BOOTSTRAP_OWNER_PASSWORD -a YOUR_APP_NAME
```

You can also remove the other `BOOTSTRAP_OWNER_*` variables after the first owner is created.

## Updating the deployed system later

```bat
git add .
git commit -m "Update system"
git push heroku main
```

## Common checks

Show configured variables without editing the source:

```bat
heroku config -a YOUR_APP_NAME
```

Check dyno state:

```bat
heroku ps -a YOUR_APP_NAME
```

Restart after changing environment variables:

```bat
heroku restart -a YOUR_APP_NAME
```
