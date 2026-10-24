# Troubleshooting

## `Fatal error in launcher: Unable to create process...`

Your Python virtual environment points to an old/moved directory. Delete and recreate it:

```powershell
Remove-Item -Recurse -Force venv
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

## `chromadb` / `sentence_transformers` / `langgraph` is missing

Make sure the virtual environment is activated and install from the project root:

```powershell
python -m pip install -r requirements.txt
```

Do not use a Python version outside the recommended 3.10–3.12 range if a dependency fails to install.

## `GEMINI_API_KEY is not set`

Create `.env` from `.env.example` and add your Google Gemini API key:

```text
GEMINI_API_KEY=your_real_key_here
```

The Python SDK reads this variable when creating the Gemini client.

## Gemini returns model/API errors

Check the value of `LLM_MODEL`. The project defaults to `gemini-3.5-flash-lite`. Confirm that the model is available to your Gemini API project and that the API key is active.

## `No documents indexed yet`

Sign in as `admin`, open **Library**, upload a PDF/DOCX/TXT/MD file, and wait for the indexing confirmation.

## React says it cannot reach the backend

Start FastAPI first:

```powershell
.\venv\Scripts\Activate.ps1
uvicorn backend.main:app --reload --port 8000
```

Then make sure `frontend-react/.env` contains:

```text
VITE_API_BASE_URL=http://localhost:8000/api
```

Restart Vite after changing `.env`.

## `npm` / `node` is not recognized

Install Node.js LTS, restart the terminal, and verify:

```powershell
node --version
npm --version
```

Then run `npm install` inside `frontend-react`.

## `vite: Permission denied` or a broken `node_modules/.bin`

Do not copy `node_modules` between operating systems. Remove it and reinstall:

```powershell
cd frontend-react
Remove-Item -Recurse -Force node_modules
npm ci
npm run build
```

## `Address already in use`

Use another backend port:

```powershell
uvicorn backend.main:app --reload --port 8001
```

Then set `VITE_API_BASE_URL=http://localhost:8001/api` in `frontend-react/.env` and restart Vite.

## TTS fails

TTS is optional. The first request downloads the Piper voice model. Ensure the machine has internet access and write permission to `data/piper_models/`. Querying and document retrieval do not depend on TTS.

## Windows: easiest recovery

If PowerShell refuses to run `.ps1` files, use the included batch files instead:

1. Double-click `SETUP_WINDOWS.bat`.
2. Edit `.env` and add `GEMINI_API_KEY=...`.
3. Double-click `START_WINDOWS.bat`.

These launch the backend with `venv\Scripts\python.exe` directly, so they do not require activating the virtual environment.

If setup stops at `pip install`, copy the **first actual ERROR line** from the terminal. A network/DNS failure is different from a package compatibility failure.
