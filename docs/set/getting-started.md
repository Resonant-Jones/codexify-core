# Getting Started

Codexify Core is local-first. The quickest way to run the full stack is Docker Compose.

## Prerequisites

- Docker + Docker Compose v2
- A local OpenAI-compatible LLM endpoint (e.g., Ollama) or cloud API keys

## Quick Start

1. Copy a template `.env` file:

```bash
cp .env.template .env
```

2. Set the minimum required variables:

```env
GUARDIAN_API_KEY=replace-with-long-token
VITE_GUARDIAN_API_KEY=replace-with-same-token
NEO4J_PASS=replace-with-neo4j-password
LOCAL_BASE_URL=http://host.docker.internal:11434/v1
LOCAL_CHAT_MODEL=your-ollama-model-tag
LOCAL_EMBED_MODEL=/models/bge-large-en-v1.5
```

3. Start the stack:

```bash
docker compose up --build
```

4. Open the UI and API docs:

- UI: http://localhost:5173
- API docs: http://localhost:8888/docs

## Verify Health

```bash
curl http://localhost:8888/ping
curl -H "X-API-Key: $GUARDIAN_API_KEY" http://localhost:8888/health
```
