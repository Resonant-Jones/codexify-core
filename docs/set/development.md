# Development

Docker Compose is the reference setup, but local dev is supported.

## Python Backend (local)

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

```bash
export GUARDIAN_API_KEY=...
export DATABASE_URL=postgresql://user:pass@localhost:5432/Codexify
export LOCAL_BASE_URL=http://localhost:11434/v1
export LOCAL_CHAT_MODEL=your-ollama-model-tag
export LOCAL_EMBED_MODEL=/absolute/path/to/models/bge-large-en-v1.5
```

```bash
alembic -c backend/alembic.ini upgrade head
python backend/scripts/seed_defaults.py
uvicorn guardian.guardian_api:app --host 0.0.0.0 --port 8888
```

## Frontend (local)

```bash
pnpm --dir frontend/src install
pnpm --dir frontend/src dev
```

## Tests

```bash
pytest -v
```
