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

### 2. Set up the opencode shell function (recommended)

For the most convenient usage, add this **shell function** to your `~/.zshrc` or `~/.bashrc`:

```zsh
# OpenCode CLI - Shell Function Entrypoint
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

> ✅ **Why use a shell function?**  
> - The function evaluates `$(pwd)` at **runtime**, ensuring your current directory is always correctly mounted  
> - Provides a seamless CLI experience with `opencode` command anywhere  
> - Automatically handles volume mounting and working directory setup  
> - **Better than aliases** because it can accept arguments and change directories dynamically

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

# Create a Go HTTP server
opencode generate "Create a Go HTTP server with middleware"

# Debug a failing function
opencode debug src/utils/helpers.py

# Generate unit tests
opencode test src/models/user.py

# Generate Go tests
opencode test main.go

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
    "paths": ["src/api", "routes", "cmd", "internal"],
    "include_patterns": ["*.py", "*.js", "*.ts", "*.go"],
    "exclude_patterns": ["*_test.py", "*.spec.js", "*_test.go"]
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

# Generate API specs from Go HTTP handlers
opencode openspec generate --path cmd/api --path internal/handlers

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
| **Runtimes** | Bun (for OpenCode/OpenSpec) + Node.js 20 (for mgrep) + Go 1.21+ |
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
    "paths": ["src", "api", "routes", "cmd", "internal"],
    "include_patterns": ["*.py", "*.js", "*.ts", "*.go"]
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

## 🔧 Advanced: Configure Custom Providers & Self-Hosted LLM Servers

OpenCode supports **75+ LLM providers** and any **OpenAI-compatible API**, making it perfect for self-hosted LLM servers. This gives you complete control over your data, costs, and model choices.

### 🚀 Quick Start: Custom Provider Setup

1. **Add your custom provider** using the `/connect` command:
```bash
opencode
# In the TUI, run: /connect
# Select "Other" at the bottom
# Enter a unique provider ID (e.g., "vllm", "tgi", "localai")
# Enter your API key (if required)
```

2. **Configure the provider** in `opencode.json`:
```bash
# Create config in your project directory
cat > opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vllm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "vLLM Server (local)",
      "options": {
        "baseURL": "http://host.docker.internal:8000/v1"
      },
      "models": {
        "mistral-7b-instruct": {
          "name": "Mistral 7B Instruct (vLLM)",
          "limit": {
            "context": 32768,
            "output": 4096
          }
        }
      }
    }
  }
}
EOF
```

3. **Select your model**:
```bash
opencode
# Run: /models
# Choose your custom provider and model
```

### 📋 Popular Self-Hosted Solutions

#### **vLLM Server** (Recommended for performance)
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vllm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "vLLM Server (local)",
      "options": {
        "baseURL": "http://host.docker.internal:8000/v1"
      },
      "models": {
        "mistral-7b-instruct": {
          "name": "Mistral 7B Instruct (vLLM)",
          "limit": {
            "context": 32768,
            "output": 4096
          }
        },
        "codellama-34b-instruct": {
          "name": "CodeLlama 34B Instruct (vLLM)",
          "limit": {
            "context": 32768,
            "output": 4096
          }
        }
      }
    }
  }
}
```

#### **Text Generation Inference (TGI)** (Hugging Face)
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "tgi": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "TGI Server (local)",
      "options": {
        "baseURL": "http://host.docker.internal:8080/v1"
      },
      "models": {
        "codellama-34b-instruct": {
          "name": "CodeLlama 34B Instruct (TGI)"
        },
        "llama-2-70b-chat": {
          "name": "Llama 2 70B Chat (TGI)"
        }
      }
    }
  }
}
```

#### **LocalAI** (OpenAI drop-in replacement)
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "localai": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LocalAI (local)",
      "options": {
        "baseURL": "http://host.docker.internal:8080/v1"
      },
      "models": {
        "gpt-3.5-turbo": {
          "name": "GPT-3.5 Turbo (LocalAI)"
        },
        "gpt-4": {
          "name": "GPT-4 (LocalAI)"
        }
      }
    }
  }
}
```

#### **Generic OpenAI-Compatible API**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "my-custom-llm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "My Custom LLM Server",
      "options": {
        "baseURL": "https://my-llm-server.com/v1",
        "apiKey": "{env:MY_LLM_API_KEY}",
        "headers": {
          "User-Agent": "OpenCode/1.0",
          "Custom-Header": "custom-value"
        }
      },
      "models": {
        "my-model": {
          "name": "My Custom Model",
          "limit": {
            "context": 32000,
            "output": 4000
          }
        }
      }
    }
  }
}
```

### 🐳 Docker Networking Setup

To connect OpenCode to your local LLM server, you need proper Docker networking:

#### **Option 1: Host Gateway (Recommended)**
Update your shell function to include host gateway:
```bash
opencode() {
    mkdir -p "$HOME/.opencode"
    docker run -it --rm \
        -v "$(pwd)":/workspace \
        -v "$HOME/.opencode":/root/.opencode \
        --add-host host.docker.internal:host-gateway \
        -w /workspace \
        opencode-cli "$@"
}
```

#### **Option 2: Host Networking**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  --network host \
  -w /workspace \
  opencode-cli "$@"
```

#### **Option 3: Port Mapping**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  -p 8000:8000 \
  -p 8080:8080 \
  -w /workspace \
  opencode-cli "$@"
```

### ⚙️ Advanced Configuration

#### **Environment Variables**
Use environment variables for sensitive data:
```json
{
  "options": {
    "baseURL": "{env:LLM_BASE_URL}",
    "apiKey": "{env:LLM_API_KEY}"
  }
}
```

#### **Custom Headers**
Add authentication or custom headers:
```json
{
  "options": {
    "headers": {
      "Authorization": "Bearer {env:API_TOKEN}",
      "X-Custom-Header": "custom-value"
    }
  }
}
```

#### **Model Limits**
Specify context and output limits:
```json
{
  "models": {
    "my-model": {
      "name": "My Model",
      "limit": {
        "context": 128000,
        "output": 8192
      }
    }
  }
}
```

### 🔧 Troubleshooting Custom Providers

#### **Q: Cannot connect to local LLM server?**
A: Check Docker networking:
```bash
# Test connectivity from within container
docker run --rm --add-host host.docker.internal:host-gateway \
  alpine/curl:latest curl -I http://host.docker.internal:8000/v1/models
```

#### **Q: Custom provider not showing in /models?**
A: Verify your configuration:
```bash
# Check config syntax
cat opencode.json | jq .

# Ensure provider ID matches between /connect and config
opencode auth list
```

#### **Q: Getting "connection refused" errors?**
A: Try different networking approaches:
```bash
# Test with host networking
docker run -it --rm --network host \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  opencode-cli "$@"
```

#### **Q: Model not responding correctly?**
A: Check your LLM server logs and ensure:
- Server is running and accessible
- Model is loaded properly
- API endpoint matches OpenAI format
- Authentication is configured correctly

### 🎯 Best Practices for Custom Providers

✅ **Do**:
- Use `host.docker.internal` for local server access
- Set appropriate context and output limits
- Use environment variables for API keys
- Test connectivity before configuring OpenCode
- Monitor your LLM server performance

❌ **Don't**:
- Use `localhost` or `127.0.0.1` (won't work in Docker)
- Hardcode API keys in config files
- Forget to set model limits
- Ignore server logs when troubleshooting
- Use unsupported model formats

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
