# 🧠 OpenCode CLI — Intelligent Terminal Programming Assistant  
*(Ubuntu 24.04 + mgrep Integrated)*

> **⚠️ Warning: This is not an ordinary tool. Misuse may lead to code leakage, unexpected costs, or system instability. Please read this guide carefully before use!**

---

## 🌐 Language Note

This README is in **English**.  
If you prefer **Chinese (简体中文)**, please see: [**README_CN.md**](./README_CN.md)

---

## 📋 Overview

This Docker image provides two powerful AI-powered development tools:

- **🧠 OpenCode**: Intelligent terminal programming assistant for code generation, debugging, and development tasks
- **📋 OpenSpec**: AI-powered API specification generator for creating comprehensive API documentation

Both tools are pre-configured with enhanced context understanding through `mgrep` for optimal performance.

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
opencode openspec init   # Initialize OpenSpec for API documentation
opencode openspec generate # Generate API specifications
```

---

## 🛠️ OpenCode - Intelligent Programming Assistant

### What is OpenCode?

OpenCode is an AI-powered terminal assistant that helps you with:
- **Code Generation**: Write functions, classes, and complete applications
- **Code Explanation**: Understand complex codebases and algorithms
- **Debugging**: Identify and fix bugs in your code
- **Refactoring**: Improve code structure and performance
- **Testing**: Generate unit tests and integration tests
- **Documentation**: Create comprehensive code documentation

### OpenCode Commands

```bash
# Interactive mode
opencode

# Direct commands
opencode explain <file>           # Explain a specific file
opencode chat "<question>"        # Ask a coding question
opencode generate "<prompt>"       # Generate code from prompt
opencode debug <file>              # Debug a file
opencode refactor <file>           # Refactor code
opencode test <file>               # Generate tests
opencode review                    # Review current changes
```

### OpenCode Examples

```bash
# Explain a complex algorithm
opencode explain src/algorithms/sorting.py

# Generate a REST API endpoint
opencode generate "Create a FastAPI endpoint for user authentication"

# Debug a failing function
opencode debug src/utils/helpers.py

# Generate unit tests
opencode test src/models/user.py

# Review recent changes
opencode review
```

---

## 📋 OpenSpec - AI-Powered API Specification Generator

### What is OpenSpec?

OpenSpec is an intelligent tool that automatically generates comprehensive API specifications from your codebase. It analyzes your existing code to create:

- **OpenAPI/Swagger Specifications**: Standard API documentation
- **Endpoint Documentation**: Detailed endpoint descriptions
- **Request/Response Schemas**: Complete data models
- **Authentication Documentation**: Security requirements
- **Usage Examples**: Practical code examples

### OpenSpec Commands

```bash
# Initialize OpenSpec in your project
opencode openspec init

# Generate API specifications
opencode openspec generate

# Generate for specific paths
opencode openspec generate --path api/v1

# Export to different formats
opencode openspec export --format yaml
opencode openspec export --format json
opencode openspec export --format markdown

# Validate specifications
opencode openspec validate

# Update existing specifications
opencode openspec update
```

### OpenSpec Configuration

Create `openspec.config.json` in your project root:

```json
{
  "input": {
    "paths": ["src/api", "routes"],
    "include_patterns": ["*.py", "*.js", "*.ts"],
    "exclude_patterns": ["*_test.py", "*.spec.js"]
  },
  "output": {
    "format": "yaml",
    "filename": "api-spec.yaml",
    "include_examples": true,
    "include_schemas": true
  },
  "analysis": {
    "infer_types": true,
    "extract_auth": true,
    "generate_examples": true
  }
}
```

### OpenSpec Examples

```bash
# Quick start with defaults
opencode openspec init && opencode openspec generate

# Generate for a specific API version
opencode openspec generate --path api/v2 --output api-v2-spec.yaml

# Export to multiple formats
opencode openspec export --format yaml && opencode openspec export --format markdown

# Validate and fix issues
opencode openspec validate --fix
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
| **Tools Included** | OpenCode CLI + OpenSpec CLI |
| **Runtimes** | Bun (for OpenCode/OpenSpec) + Node.js 20 (for mgrep) |
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

### Q: OpenSpec fails to find API endpoints?
A: Ensure your project structure matches the configuration:
```bash
# Check if openspec can find your API files
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $HOME/.opencode:/root/.opencode \
  opencode-cli openspec validate
```

### Q: OpenSpec generates incomplete specifications?
A: Update your `openspec.config.json` with proper paths and patterns:
```json
{
  "input": {
    "paths": ["src", "api", "routes"],
    "include_patterns": ["*.py", "*.js", "*.ts"]
  }
}
```

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

## 🔄 Using OpenCode & OpenSpec Together

### Typical Workflow

1. **Initialize your project** with both tools:
```bash
cd your-api-project
opencode                    # Start coding assistance
opencode openspec init      # Initialize API documentation
```

2. **Develop your API** with OpenCode help:
```bash
opencode generate "Create a FastAPI user management endpoint"
opencode debug src/api/users.py
```

3. **Generate API documentation** with OpenSpec:
```bash
opencode openspec generate  # Create comprehensive API specs
opencode openspec export --format markdown  # Export for README
```

4. **Review and refine** both code and documentation:
```bash
opencode review            # Review code changes
opencode openspec validate  # Validate API specs
```

### Integration Examples

```bash
# Create a new API endpoint and document it
opencode generate "Create Express.js GET /users endpoint"
opencode openspec generate --path routes/users.js
opencode openspec export --format yaml

# Debug and update documentation
opencode debug src/api/auth.py
opencode openspec update --path src/api/auth.py
```

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
- Use **OpenSpec** to maintain API documentation
- Run **opencode openspec validate** after API changes
- Keep **openspec.config.json** in version control

❌ **Don't**:
- Run in `$HOME`, `/`, or sensitive directories  
- Share your config file (contains secrets)  
- Trust AI output without review  
- Forget to update API specs after code changes
- Commit sensitive data in API examples

---

> **Remember: OpenCode is an assistant — not a replacement. Always audit its output!**

📚 [Official OpenCode Docs](https://github.com/OpenCode-AI/opencode)  
📋 [OpenSpec Documentation](https://github.com/fission-ai/openspec)  
🔗 [mgrep on npm (@mixedbread/mgrep)](https://www.npmjs.com/package/@mixedbread/mgrep)  
🐞 [Report an Issue](https://github.com/OpenCode-AI/opencode/issues)

---

*Built: December 2025 | Base: Ubuntu 24.04 LTS | OpenCode v1.x | OpenSpec v1.x | mgrep v1.x*
