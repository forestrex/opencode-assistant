# 🧠 OpenCode CLI — Intelligent Terminal Programming Assistant  
*(Ubuntu 24.04 + mgrep Integrated)*

> **⚠️ Warning: This is not an ordinary tool. Misuse may lead to code leakage, unexpected costs, or system instability. Please read this guide carefully before use!**

---

## 🌐 Language Note

This README is in **English**.  
If you prefer **Chinese (简体中文)**, please see: [**README_CN.md**](./README_CN.md)

---

## 🔒 Critical Security & Usage Guidelines

### ❗ 1. **Never run in production or sensitive projects**
- OpenCode **reads all files in your current working directory** to provide context to the LLM.
- If you run it inside a folder containing secrets, private code, or customer data, **that content may be sent to the LLM provider** (depending on your configuration).
- ✅ **Do this instead**: Only run OpenCode in clean, non-sensitive project directories.

### ❗ 2. **Authentication is required before first use**
OpenCode **will not work out of the box**. You must configure an API key or local model first:

```bash
# First-time setup
opencode auth login
```

Supported providers:
- **OpenRouter** (recommended — aggregates multiple models)
- **Anthropic** (Claude 3.5 Sonnet / Opus)
- **OpenAI** (GPT-4o / GPT-4 Turbo)
- **Ollama** (local models — zero privacy risk, no cost)

> 💡 **Strongly recommended**: Use **Ollama with local models** (e.g., `codellama:34b`, `deepseek-coder:6.7b`) to avoid privacy risks and API bills.

---

## 🐳 Quick Start (Docker)

### 1. Build the image
```bash
git clone https://github.com/yourname/opencode-docker.git
cd opencode-docker
docker build -t opencode-cli .
```

### 2. Set up a shell function (one-time only)

To simplify usage, add a **shell function** (not an alias!) to your `~/.zshrc` or `~/.bashrc`:

```zsh
opencode() {
  mkdir -p "$HOME/.opencode"
  docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.opencode":/root/.opencode \
    -w /workspace \
    opencode-cli "$@"
}
```

Then reload your shell:
```bash
source ~/.zshrc   # or source ~/.bashrc
```

> ✅ **Why a function?**  
> Using `$(pwd)` in a function ensures the **current directory is evaluated at runtime**, so your project is always correctly mounted.

### 3. Initialize authentication (once)
```bash
opencode auth login
```
Your config will be saved to `$HOME/.opencode/config.json`.

### 4. Use anywhere
```bash
cd /your/project
opencode                # Launch interactive TUI
opencode explain main.py  # Explain a file
opencode chat "How can I optimize this?"
```

---

## ⚙️ About `mgrep` Context Enhancement

This image includes [`@mixedbread/mgrep`](https://www.npmjs.com/package/@mixedbread/mgrep) by [mixedbread.ai](https://mixedbread.ai), which:
- Parses code using **Abstract Syntax Trees (ASTs)**
- Intelligently extracts relevant functions, classes, and variables
- Automatically ignores `node_modules/`, `dist/`, `.git/`, etc.
- Reduces LLM token usage and improves response quality

You’ll see on startup:
```
🔧 Automatically enabling mgrep as context provider...
```

No extra setup needed. If `mgrep` fails, OpenCode falls back to basic text search.

---

## 📦 Image Features

| Feature | Details |
|--------|--------|
| **Base OS** | Ubuntu 24.04 LTS |
| **Runtimes** | Bun (for OpenCode) + Node.js 20 (for mgrep) |
| **Context Engine** | `@mixedbread/mgrep` (globally installed) |
| **Compatibility** | Intel & Apple Silicon Macs, Linux |
| **Image Size** | ~320 MB (minimal, no bloat) |

---

## 🚫 Common Pitfalls & Anti-Patterns

| Mistake | Consequence | Fix |
|--------|-----------|-----|
| Running in `$HOME` or root dir | May upload entire user directory | Only run inside specific project folders |
| Sharing `~/.opencode/config.json` | Exposes API keys | Never commit this file to Git |
| Using `alias` instead of function | Mounts wrong directory | Use the **function** shown above |
| Trusting output blindly | LLMs hallucinate | Always review generated code |

---

## 🔧 Troubleshooting

### Q: `opencode auth login` fails on first run?
A: Ensure you’re using the **function** (not alias) and that the Docker image built successfully. The entrypoint now allows `auth` commands to bypass config checks.

### Q: “mgrep not found” or poor context?
A: Verify the build log contains:
```text
npm install -g @mixedbread/mgrep
```
Also ensure `build-essential` and `python3` are installed (required for native modules).

### Q: Build fails on older Macs (2012–2015)?
A: Upgrade Colima:
```bash
brew upgrade colima && colima stop && colima start
```
As a fallback, switch to `FROM ubuntu:22.04` in the Dockerfile.

### Q: Can’t connect to Ollama on host?
A: On macOS, Docker Desktop can access `localhost:11434` by default.  
On Linux, add `--network host` to the `docker run` command in your function.

---

## 🛠️ Advanced: Use Local Models via Ollama (Recommended)

1. Install [Ollama](https://ollama.com/) on your host
2. Pull a model:
   ```bash
   ollama pull deepseek-coder:6.7b-instruct
   ```
3. Run setup:
   ```bash
   opencode auth login  # Choose "Ollama", enter model name
   ```
4. Use offline:
   ```bash
   cd my-project
   opencode  # Runs entirely locally — no internet needed
   ```

✅ All processing stays on your machine — **maximum privacy, zero cost**.

---

## 📜 License & Disclaimer

- OpenCode is an open-source project by [OpenCode-AI](https://github.com/OpenCode-AI).
- `@mixedbread/mgrep` is provided by [mixedbread.ai](https://mixedbread.ai).
- **This Docker image is provided “as-is”. The author is not liable for data leaks, financial loss, or code damage.**
- By using this software, you accept these terms.

---

## 💡 Best Practices Summary

✅ **Do**:
- Use the **shell function** (not alias)  
- Prefer **Ollama with local models**  
- Run only inside specific project directories  
- Back up `~/.opencode/config.json` (but never commit it!)

❌ **Don’t**:
- Run in `$HOME`, `/`, or sensitive directories  
- Share your config file (contains secrets)  
- Trust AI output without review  

---

> **Remember: OpenCode is an assistant — not a replacement. Always audit its output!**

📚 [Official OpenCode Docs](https://github.com/OpenCode-AI/opencode)  
🔗 [mgrep on npm (@mixedbread/mgrep)](https://www.npmjs.com/package/@mixedbread/mgrep)  
🐞 [Report an Issue](https://github.com/OpenCode-AI/opencode/issues)

---

*Built: December 2025 | Base: Ubuntu 24.04 LTS | OpenCode v1.x | mgrep v1.x*
