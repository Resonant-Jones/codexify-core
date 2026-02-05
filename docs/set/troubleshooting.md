# Troubleshooting

## Backend won’t start

- Check `GUARDIAN_API_KEY` is set and non-empty.
- Confirm Postgres is reachable (`DATABASE_URL`).
- Ensure `LOCAL_BASE_URL` is reachable from Docker.

## Frontend can’t connect to backend

- Verify `VITE_GUARDIAN_API_KEY` matches `GUARDIAN_API_KEY`.
- Confirm backend is healthy: `curl http://localhost:8888/ping`.

## Local LLM not reachable from Docker

- Use `http://host.docker.internal:11434/v1` (macOS/Windows).
- If on Linux, use the Docker gateway IP or host networking.

## Embeddings errors

- `LOCAL_EMBED_MODEL` must be an absolute path inside the container.
- Ensure the model directory is mounted in Compose.

## Neo4j failures

- Set `NEO4J_PASS` in `.env`.
- Wait for `neo4j` to be healthy before `graph-init` runs.
