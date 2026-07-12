# Security Notice

The earlier source archive contained a Gmail App Password directly in `EmailUtil.java`. That credential has been removed from this cloud-ready project.

Revoke the exposed App Password in the Google Account security settings and create a new App Password. Store the replacement only as the Heroku `SMTP_PASSWORD` config variable. Do not reuse or recommit the exposed credential.

The cloud-ready archive contains placeholders only and does not contain the previous Gmail address or App Password.
