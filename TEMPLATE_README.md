# Deploy and Host phpBB on Railway

## About Hosting phpBB

phpBB is an open-source discussion board with forums, topics, moderation, permissions, private messages, themes, and extensions. This template deploys stable 3.3.19 with generated credentials and private MariaDB.

Sign in as `admin` with `PHPBB_ADMIN_PASSWORD`.

## Common Use Cases

- Community discussion forums
- Product and project support boards
- Private member communities

## Dependencies for phpBB Hosting

### Deployment Dependencies

phpBB and private MariaDB services each use a daily-backed-up volume. Railway provides HTTPS.

### Implementation Details

The supported CLI installer creates the board and generated administrator, forces canonical HTTPS, and removes the web installer directory. Email remains disabled until SMTP is configured. Use one application replica.

## Why Deploy phpBB on Railway?

Railway provides generated credentials, private networking, HTTPS, persistent storage, backups, health checks, and Git-driven updates.
