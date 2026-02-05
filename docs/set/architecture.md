# Architecture

Codexify Core is a local-first system with a FastAPI backend and a React frontend. It is designed to keep data on your machine by default, while allowing optional cloud integrations.

## Core Components

- **Backend (Guardian)**: FastAPI service exposing API routes and orchestration logic.
- **Frontend**: Vite-powered React UI.
- **Postgres**: Primary persistence for threads, documents, and system records.
- **Redis**: Task queues and event streams.
- **Vector Store**: Chroma or FAISS for semantic retrieval.
- **Neo4j (optional)**: Graph logging/context.

## Data Flow (High-Level)

1. UI sends requests to the Guardian API.
2. Guardian persists records in Postgres.
3. Background workers handle tasks via Redis.
4. Embeddings are generated and stored in the vector store.
5. Optional graph operations are written to Neo4j.

## Runtime Topology (Docker Compose)

- `backend`: API server
- `db`: Postgres
- `redis`: queue + events
- `neo4j`: optional graph store
- `workers`: optional background processors
- `frontend`: Vite dev server

The `docker-compose.yml` file defines the authoritative local stack.
