# RAG-Based Knowledge Management System — Level-3 Architecture

A modular, agentic Retrieval-Augmented Generation (RAG) system for a CSE(AI) major project. It combines FastAPI, React/Vite, ChromaDB, BM25, Sentence Transformers, cross-encoder reranking, LangGraph orchestration, Gemini generation, and optional Piper text-to-speech.

## What the system does

- **Ingestion:** PDF, DOCX, TXT, and Markdown documents
- **Chunking:** recursive character chunking with overlap
- **Hybrid retrieval:** dense vector search + BM25 keyword search
- **Reranking:** cross-encoder relevance scoring
- **Level-3 orchestration:** query routing, rewriting, multi-hop retrieval, and corrective retrieval
- **Groundedness verification:** checks generated answers against retrieved context
- **RBAC:** admin/viewer login with short-lived access tokens and refresh-token rotation
- **Interactive UI:** live pipeline trace, knowledge graph, quiz mode, showdown, guided demo, and document library
- **Optional TTS:** local Piper speech synthesis

## Architecture

```text
React/Vite UI
     │ REST + NDJSON streaming
     ▼
FastAPI API + RBAC
     │
     ▼
LangGraph Level-3 Orchestrator
     │
     ├── Router → Query Rewriter
     ├── Hybrid Retrieval (Chroma + BM25)
     ├── Cross-Encoder Reranker
     ├── Gemini Answer Generation
     └── Groundedness Verification → Corrective Hop
              │
              ▼
       Persistent ChromaDB
```

## Requirements

- **Python 3.10–3.12 recommended**
- **Node.js 18+** (Node.js LTS recommended)
- A **Google Gemini API key**
- Internet access during first setup so Python/Node dependencies and ML models can be downloaded

The default model is `gemini-3.5-flash-lite`. You can change `LLM_MODEL` in `.env` if your Gemini project uses another supported model.

## Windows — recommended setup

Open PowerShell in the project root:

```powershell
.\scripts\setup_windows.ps1
```

Then edit `.env` and set:

```text
GEMINI_API_KEY=your_real_key_here
```

Start both services:

```powershell
.\scripts\start_all_windows.ps1
```

Open:

- React UI: `http://localhost:5173`
- API docs: `http://localhost:8000/docs`
- API health: `http://localhost:8000/api/health`

### Manual Windows setup

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
Copy-Item .env.example .env
# edit .env and add GEMINI_API_KEY

cd frontend-react
npm install
npm run dev
```

In a second terminal, from the project root, run:

```powershell
.\venv\Scripts\Activate.ps1
uvicorn backend.main:app --reload --port 8000
```

## macOS / Linux

```bash
bash scripts/setup_unix.sh
bash scripts/start_all_unix.sh
```

Or manually:

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
cp .env.example .env
# edit .env and add GEMINI_API_KEY

uvicorn backend.main:app --reload --port 8000
# second terminal
cd frontend-react
npm install
npm run dev
```

## Authentication

The demo has two accounts, configured through `.env`:

| Username | Default password | Role | Permissions |
|---|---|---|---|
| `admin` | `admin123` | admin | upload, delete, query, quiz, graph, library |
| `viewer` | `viewer123` | viewer | query, quiz, graph, library read-only |

**Change the passwords and `JWT_SECRET` before sharing the project.**

## Frontend tabs

- **Live Pipeline:** watches router → rewrite → retrieval → rerank → generation → verification
- **Showdown:** compares the naive single-pass vector pipeline with the Level-3 pipeline
- **Quiz Me:** generates MCQs from indexed content
- **Knowledge Graph:** visualizes documents, chunks, and semantic links
- **Guided Demo:** step-by-step pipeline walkthrough
- **Library:** upload, list, and delete documents

## Streamlit fallback

A lightweight fallback UI remains in `frontend/streamlit_app.py`:

```bash
streamlit run frontend/streamlit_app.py
```

## Evaluation

Add real questions/answers to `evaluation/eval_dataset.json`, upload the corresponding documents, then run:

```bash
python -m evaluation.evaluate
```

The evaluation script includes custom retrieval/groundedness metrics and optional RAGAS metrics.

## Project structure

```text
rag_km_system/
├── backend/
│   ├── api/
│   ├── auth/
│   ├── generation/
│   ├── indexing/
│   ├── ingestion/
│   ├── models/
│   ├── orchestration/
│   └── retrieval/
├── frontend-react/
│   └── src/
├── frontend/
├── evaluation/
├── data/                 # runtime data; intentionally empty in the release ZIP
├── scripts/
├── .env.example
├── requirements.txt
└── README.md
```

## Important notes

- Do **not** commit `.env`, API keys, passwords, `node_modules`, Python virtual environments, Chroma runtime data, or generated model files.
- The first use of Sentence Transformers and the cross-encoder may download models from Hugging Face.
- Piper TTS downloads its voice model on first use.
- The included HMAC authentication is appropriate for a local/course demo, not a production identity system.

## Windows quick start (recommended)

If PowerShell gives execution-policy errors, use the two included batch files:

1. Double-click `SETUP_WINDOWS.bat`.
2. Put your real `GEMINI_API_KEY` in `.env`.
3. Double-click `START_WINDOWS.bat`.
4. Open `http://localhost:5173`.

The backend API is at `http://localhost:8000` and Swagger docs at `http://localhost:8000/docs`.
