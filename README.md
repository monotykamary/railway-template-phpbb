# phpBB on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/phpbb?referralCode=ZqgrJ0)

Deploy phpBB 3.3.19 with a generated administrator password, private MariaDB, persistent forum files, and daily backups.

Sign in as `admin` with `PHPBB_ADMIN_PASSWORD`. The template disables email until SMTP is configured and removes the installer directory after setup. Use one application replica because phpBB files use an attached volume.

Upstream: https://github.com/phpbb/phpbb/tree/release-3.3.19 (GPL-2.0-only). Not affiliated with Railway.
