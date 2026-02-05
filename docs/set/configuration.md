# Configuration

Codexify Core uses environment variables for all configuration. `.env.example` and `.env.template` show the supported values.

## Required (default Compose stack)

- `GUARDIAN_API_KEY`: API auth token for backend requests
- `VITE_GUARDIAN_API_KEY`: Same token for the frontend
- `NEO4J_PASS`: Neo4j password used by `neo4j` and `graph-init`
- `LOCAL_BASE_URL`: Base URL for a local OpenAI-compatible LLM (e.g., Ollama)
- `LOCAL_CHAT_MODEL`: Chat model tag/name on your local LLM
- `LOCAL_EMBED_MODEL`: Embedding model path inside the container

## Optional Providers

Enable cloud providers by setting:

- `ALLOW_CLOUD_PROVIDERS=true`
- `LLM_PROVIDER=openai` or `groq`
- `OPENAI_API_KEY` / `GROQ_API_KEY`
- `ANTHROPIC_API_KEY` / `GEMINI_API_KEY` (if used)

## Vector Store

- `CODEXIFY_VECTOR_STORE`: `chroma` or `faiss`
- `CODEXIFY_CHROMA_PATH`: path for Chroma persistence
- `CODEXIFY_COLLECTION`: Chroma collection name

## Notes

- Keep `.env` local. Do not commit it.
- If running Docker on macOS/Windows, `host.docker.internal` is usually the correct host for local services.
