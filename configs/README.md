## Configs

Central place for configuration files that control experiments and services.

- `markets/` keeps market-specific settings such as symbols, venues, and fee tables.
- Add more subfolders to namespace different environments (dev, staging, prod).

Keep secrets out of this directory; use environment variables or a secure store instead.
