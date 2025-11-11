## Tests

Python tests live here, mirroring the layout of `src/`.

- Put fast unit tests under `tests/unit/`.
- Use `tests/integration/` for slower end-to-end workflows that hit external services or data.
- Shared fixtures belong in `tests/conftest.py` or `tests/fixtures/`.

Run `pytest` (optionally with `-m` markers) from the repo root so path resolution stays consistent.
