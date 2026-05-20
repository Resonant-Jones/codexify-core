````md
# Codexify Core

> Local-first memory infrastructure for people building with AI without surrendering their context, identity, or operating truth.

Codexify is an open, local-first AI workspace for persistent chat, retrieval, documents, memory boundaries, and operator-visible runtime truth.

It is built for people who want AI systems that can remember, retrieve, explain, and evolve without turning personal context into rented fog.

This repository is the public Codexify Core snapshot.

It contains the parts of Codexify that are safe to inspect, run, test, discuss, and build from:

- public documentation
- install guidance
- beta handoff materials
- contribution guidance
- security notes
- curated release artifacts

The private development vault contains internal planning, unreleased experiments, operational notes, and future-facing research that are not part of this public release promise.

---

## Why Codexify Exists

Most AI tools treat memory as a convenience feature.

Codexify treats memory as infrastructure.

The premise is simple:

**Your context should belong to you.**

Not the model provider.  
Not the platform layer.  
Not a black-box subscription surface.  

Codexify is designed around local operation, explicit consent, durable provenance, and inspectable system behavior.

It is not trying to be the loudest assistant.

It is trying to become a trustworthy cognitive workspace.

---

## What Codexify Core Currently Focuses On

Codexify Core is centered on the local beta path:

- thread-based AI chat
- project and document context
- local-first runtime posture
- uploaded document parsing and retrieval
- persistent messages and assistant outputs
- runtime health visibility
- proof-oriented development practices

The current supported path is intentionally narrow:

```text
Local Docker Compose
Postgres
Redis
FastAPI backend
React frontend
local-first provider posture
````

Codexify is expanding, but this repository does not pretend every future-facing subsystem is already a supported public surface.

---

## Start Here

| Path                               | Purpose                                     |
| ---------------------------------- | ------------------------------------------- |
| `releases/Codexify-Beta/README.md` | Current beta handoff bundle                 |
| `docs/public/install/README.md`    | Public install path                         |
| `docs/public/security/README.md`   | Security and privacy guidance               |
| `CONTRIBUTING.md`                  | Contribution workflow                       |
| `SECURITY.md`                      | Vulnerability reporting and security policy |

---

## Design Principles

### 1. Local-first before cloud-convenient

Codexify is designed so the default posture keeps user data close to the user.

Cloud providers may become useful in some contexts, but they should never be confused with ownership.

### 2. Memory is not a pile of logs

Codexify separates conversation history, retrieval context, identity modeling, and long-term memory.

A chat transcript is not automatically a personality label.

A retrieved document is not automatically truth.

A remembered preference is not automatically identity.

The system should know the difference.

### 3. Personas borrow identity. They do not own it.

Codexify supports persona-aware interaction, but personas are masks, modes, and interfaces.

The user remains the stable authority.

### 4. Proof over theater

Runtime claims should be backed by tests, docs, health surfaces, or live proof.

If a feature is experimental, internal, disabled, or future-facing, it should be labeled that way.

No fog machines in the control room.

### 5. Operator truth matters

A system that cannot explain whether it is healthy, degraded, blocked, or merely waiting is not ready to be trusted.

Codexify treats visibility as part of the product, not an afterthought.

---

## What This Repository Is

This repo is:

* a public release snapshot
* a documentation and handoff surface
* a collaboration point
* a place to inspect Codexify’s public architecture and beta posture
* a foundation for feedback, issue reports, and future contribution

This repo is not:

* the private development vault
* a full dump of internal planning
* a promise that every experimental subsystem is supported
* a hosted SaaS product
* a claim that Codexify is production-hardened for public internet exposure

---

## Current Status

Codexify is in local-first beta hardening.

The project is actively moving toward a more durable local cognitive workspace with:

* stronger retrieval boundaries
* clearer identity separation
* more honest runtime state
* better import and document handling
* public proof artifacts
* safer contribution and release practices

Some systems exist as internal, experimental, or architecture-planning surfaces. They are not automatically part of the public beta promise.

---

## Philosophy

Resonant Constructs builds systems around memory, meaning, consent, and agency.

Codexify is one expression of that work.

It asks a practical question:

> What would AI software look like if user sovereignty was not a feature, but the foundation?

The answer is not a single app.

It is a discipline:

* own the data
* preserve the lineage
* expose the truth surface
* separate identity from noise
* keep the human as final authority
* build systems that remember without consuming

---

## Contributing

Thoughtful contributors are welcome.

Before opening a pull request, please read:

* `CONTRIBUTING.md`
* `SECURITY.md`
* the current beta handoff notes

Good contributions are:

* focused
* testable
* documented
* respectful of current release boundaries
* clear about what is proven versus experimental

Codexify values careful work over heroic chaos.

Heroic chaos may be admired from a safe distance.

---

## Security

Codexify is currently intended for local development and evaluation.

Do not expose an unreviewed local instance to the public internet.

Do not commit secrets.

Do not treat local beta behavior as production hardening.

See `SECURITY.md` for the current reporting and handling policy.

---

## License

See `LICENSE`.

---

## Closing Note

Codexify is not just a chat interface.

It is a memory-bearing workspace for people who want their tools to be useful without becoming extractive.

It is early.

It is real.

It is being built in public where public is safe, and in private where privacy still matters.

```
