# 🧠 OpenCode CLI — 智能终端编程助手（Ubuntu 24.04 + mgrep 完整版）

> **⚠️ 警告：这不是一个普通工具。错误使用可能导致代码泄露、费用失控或系统不稳定。请务必阅读以下指南！**

---

## 📋 项目概述

此 Docker 镜像提供两个强大的 AI 驱动开发工具：

- **🧠 OpenCode**：智能终端编程助手，用于代码生成、调试和开发任务
- **📋 OpenSpec**：AI 驱动的 API 规范生成器，用于创建全面的 API 文档

两个工具都通过 `mgrep` 预配置了增强的上下文理解能力，以获得最佳性能。

---

## 🔒 重要安全与使用须知

### ❗ 1. **不要在生产环境或敏感项目中直接运行**
- OpenCode 会**读取你当前目录下的所有文件**（用于上下文理解）。
- 如果你在包含密钥、私有代码或客户数据的目录中运行，**这些内容可能被发送到 LLM 服务**（取决于你的配置）。
- ✅ **正确做法**：仅在干净的、非敏感的开发目录中使用。

### ❗ 2. **必须先完成身份认证**
OpenCode **不会默认工作**。首次使用前，必须配置 API 密钥：

```bash
# 首次运行会提示你登录
docker run -it --rm \
  -v $HOME/.opencode:/root/.opencode \
  opencode-cli auth login
```

支持的服务：
- **OpenRouter**（推荐，聚合多模型）
- **Anthropic** (Claude 3.5 Sonnet / Opus)
- **OpenAI** (GPT-4o / GPT-4 Turbo)
- **Ollama**（本地模型，最安全，零隐私风险）

> 💡 **强烈建议优先使用 Ollama + 本地模型**（如 `codellama:34b`, `deepseek-coder:6.7b`）以避免隐私风险和 API 费用。

---

## 🐳 快速开始（Docker 方式）

### 1. 构建镜像
```bash
git clone https://github.com/yourname/opencode-docker.git
cd opencode-docker
docker build -t opencode-cli .
```

### 2. 配置 opencode shell 函数（推荐方式）
为了最便捷的使用，将以下 **shell 函数** 添加到你的 `~/.zshrc` 或 `~/.bashrc`：

```zsh
# OpenCode CLI - Shell 函数入口
opencode() {
    mkdir -p "$HOME/.opencode"
    docker run -it --rm \
        -v "$(pwd)":/workspace \
        -v "$HOME/.opencode":/root/.opencode \
        -w /workspace \
        opencode-cli "$@"
}
```

然后重新加载你的 shell：
```bash
source ~/.zshrc   # 或者 source ~/.bashrc
```

> ✅ **为什么使用 shell 函数？**  
> - 函数在 **运行时** 计算 `$(pwd)`，确保当前目录总是正确挂载  
> - 提供无缝的 CLI 体验，随处可使用 `opencode` 命令  
> - 自动处理卷挂载和工作目录设置  
> - **优于别名**，因为可以接受参数并动态改变目录

### 3. 配置认证
```bash
# 使用 shell 函数进行首次认证配置
opencode auth login
```

> 首次运行将引导你选择 LLM 提供商并输入 API 密钥。配置保存在 `$HOME/.opencode/config.json`。

### 4. 在项目目录中使用
```bash
cd /your/project
opencode                # 启动交互式界面
opencode explain main.py  # 解释文件
opencode chat "如何优化这段代码？"  # 询问问题
```

> ✅ **关键**：shell 函数已经自动处理了目录挂载，OpenCode 可以直接"看到"你的代码。

---

## ⚙️ 关于 `mgrep` 上下文增强

本镜像已集成 [`@mixedbread/mgrep`](https://www.npmjs.com/package/@mixedbread/mgrep)，由 [mixedbread.ai](https://mixedbread.ai) 提供，它能：
- 基于 AST（抽象语法树）理解代码结构
- 智能提取相关函数、类、变量
- 自动过滤无关文件（如 `node_modules/`, `dist/`）
- 显著减少 LLM token 消耗，提升响应质量

启动时你会看到：
```
🔧 自动启用 mgrep 作为上下文提供器...
```

无需额外配置。如果 `mgrep` 不可用，OpenCode 会回退到普通文本搜索（效果较差）。

---

## 🛠️ OpenCode - 智能编程助手

### 什么是 OpenCode？

OpenCode 是一个 AI 驱动的终端助手，帮助你：
- **代码生成**：编写函数、类和完整应用程序
- **代码解释**：理解复杂代码库和算法
- **调试**：识别并修复代码中的错误
- **重构**：改善代码结构和性能
- **测试**：生成单元测试和集成测试
- **文档**：创建全面的代码文档

### OpenCode 命令

```bash
# 交互模式
opencode

# 直接命令
opencode explain <file>           # 解释特定文件
opencode chat "<问题>"            # 询问编码问题
opencode generate "<提示>"        # 根据提示生成代码
opencode debug <file>             # 调试文件
opencode refactor <file>         # 重构代码
opencode test <file>              # 生成测试
opencode review                   # 审查当前更改
```

### OpenCode 使用示例

```bash
# 解释复杂算法
opencode explain src/algorithms/sorting.py

# 生成 REST API 端点
opencode generate "创建用于用户身份验证的 FastAPI 端点"

# 创建 Go HTTP 服务器
opencode generate "创建带中间件的 Go HTTP 服务器"

# 调试失败的函数
opencode debug src/utils/helpers.py

# 生成单元测试
opencode test src/models/user.py

# 生成 Go 测试
opencode test main.go

# 审查最近更改
opencode review
```

---

## 📋 OpenSpec - AI 驱动的 API 规范生成器

### 什么是 OpenSpec？

OpenSpec 是一个智能工具，可从你的代码库自动生成全面的 API 规范。它分析现有代码以创建：

- **OpenAPI/Swagger 规范**：标准 API 文档
- **端点文档**：详细的端点描述
- **请求/响应模式**：完整的数据模型
- **身份验证文档**：安全要求
- **使用示例**：实用的代码示例

### OpenSpec 命令

```bash
# 在项目中初始化 OpenSpec
opencode openspec init

# 生成 API 规范
opencode openspec generate

# 为特定路径生成
opencode openspec generate --path api/v1

# 导出为不同格式
opencode openspec export --format yaml
opencode openspec export --format json
opencode openspec export --format markdown

# 验证规范
opencode openspec validate

# 更新现有规范
opencode openspec update
```

### OpenSpec 配置

在项目根目录创建 `openspec.config.json`：

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

### OpenSpec 使用示例

```bash
# 使用默认值快速开始
opencode openspec init && opencode openspec generate

# 为特定 API 版本生成
opencode openspec generate --path api/v2 --output api-v2-spec.yaml

# 从 Go HTTP 处理器生成 API 规范
opencode openspec generate --path cmd/api --path internal/handlers

# 导出为多种格式
opencode openspec export --format yaml && opencode openspec export --format markdown

# 验证并修复问题
opencode openspec validate --fix
```

---

## 📦 镜像特性

| 特性 | 说明 |
|------|------|
| **基础系统** | Ubuntu 24.04 LTS（最新稳定版）|
| **包含工具** | OpenCode CLI + OpenSpec CLI |
| **运行时** | Bun（用于 OpenCode/OpenSpec） + Node.js 20（用于 mgrep） + Go 1.21+ |
| **上下文引擎** | `@mixedbread/mgrep`（全局安装）|
| **兼容性** | 支持 Intel/Apple Silicon Mac、Linux |
| **镜像大小** | ~320 MB（精简无冗余）|

---

## 🔄 OpenCode 与 OpenSpec 协同使用

### 典型工作流程

1. **初始化项目**，同时使用两个工具：
```bash
cd your-api-project
opencode                    # 启动编程辅助
opencode openspec init      # 初始化 API 文档
```

2. **开发 API**，借助 OpenCode 帮助：
```bash
opencode generate "创建 FastAPI 用户管理端点"
opencode debug src/api/users.py
```

3. **生成 API 文档**，使用 OpenSpec：
```bash
opencode openspec generate  # 创建全面的 API 规范
opencode openspec export --format markdown  # 导出用于 README
```

4. **审查和完善**代码和文档：
```bash
opencode review            # 审查代码更改
opencode openspec validate  # 验证 API 规范
```

### 集成示例

```bash
# 创建新 API 端点并记录文档
opencode generate "创建 Express.js GET /users 端点"
opencode openspec generate --path routes/users.js
opencode openspec export --format yaml

# 调试并更新文档
opencode debug src/api/auth.py
opencode openspec update --path src/api/auth.py
```

---

## 🚫 常见错误与禁忌

| 错误行为 | 后果 | 正确做法 |
|--------|------|--------|
| 直接 `docker run opencode-cli`（不挂载目录） | 无法访问你的代码 | 必须用 `-v $(pwd):/workspace` |
| 在 `$HOME`、`/` 或含敏感数据的目录运行 | 可能上传整个硬盘内容 | 仅在具体项目目录运行 |
| 使用免费 API 密钥高频调用 | 被封禁或产生高额账单 | 设置用量监控，或使用本地模型 |
| 忽略 `.opencode/config.json` | 每次都要重新登录 | 保留该配置文件，可跨机器同步 |
| 在容器内修改代码但未挂载卷 | 修改丢失 | 始终通过 `-v` 挂载工作目录 |

---

## 🔧 故障排查

### Q: 启动后立即退出？
A: 检查是否已配置认证：
```bash
ls $HOME/.opencode/config.json
```
如果没有，请先运行 `auth login`。

### Q: 提示 “mgrep not found” 或命令失败？
A: 确保构建日志中包含：
```
npm install -g @mixedbread/mgrep
```
Ubuntu 24.04 需要 `build-essential` 和 `python3` 才能编译原生模块。如仍失败，尝试：
```bash
docker run --rm opencode-cli which mgrep  # 应返回 /usr/local/bin/mgrep
```

### Q: 在老款 Mac（如 2012–2015）上构建失败？
A: 确保：
- **Colima ≥ v0.6.0**（`brew upgrade colima`）
- **系统时间正确**（macOS 设置 → 自动设置日期与时间）
- **重启 Colima**：`colima stop && colima start`

> 💡 若问题持续，可临时退回 `ubuntu:22.04`（修改 Dockerfile 第一行）。

### Q: OpenCode 无法调用 mgrep？
A: 检查配置文件是否启用：
```bash
jq '.contextProvider' $HOME/.opencode/config.json
```
应返回 `"mgrep"`。若不是，手动添加或删除配置让脚本自动修复。

### Q: OpenSpec 无法找到 API 端点？
A: 确保项目结构匹配配置：
```bash
# 检查 openspec 是否能找到你的 API 文件
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $HOME/.opencode:/root/.opencode \
  opencode-cli openspec validate
```

### Q: OpenSpec 生成不完整的规范？
A: 更新 `openspec.config.json` 中的路径和模式：
```json
{
  "input": {
    "paths": ["src", "api", "routes", "cmd", "internal"],
    "include_patterns": ["*.py", "*.js", "*.ts", "*.go"]
  }
}
```

---

## 🛠️ 高级用法

### 使用本地 Ollama 模型（推荐）
1. 在主机安装 [Ollama](https://ollama.com/)
2. 拉取模型：
   ```bash
   ollama pull codellama:34b-instruct-q6_K
   ```
3. 登录时选择 **Ollama** 作为提供商，填入模型名（如 `codellama:34b-instruct-q6_K`）
4. 运行容器时暴露 Ollama socket：
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     -v $HOME/.opencode:/root/.opencode \
     -v /var/run/docker.sock:/var/run/docker.sock \  # 仅 Linux
     --network host \  # 允许访问 localhost:11434
     opencode-cli
   ```

> macOS 用户：Ollama 默认监听 `localhost`，Docker Desktop 可直接访问。

---

## 🔧 高级配置：自定义提供商与自托管 LLM 服务器

OpenCode 支持 **75+ LLM 提供商**和任何 **OpenAI 兼容的 API**，非常适合自托管 LLM 服务器。这让你完全控制数据、成本和模型选择。

### 🚀 快速开始：自定义提供商设置

1. **添加自定义提供商**，使用 `/connect` 命令：
```bash
opencode
# 在 TUI 中运行：/connect
# 在底部选择"其他"
# 输入唯一的提供商 ID（如 "vllm", "tgi", "localai"）
# 输入你的 API 密钥（如果需要）
```

2. **在 `opencode.json` 中配置提供商**：
```bash
# 在项目目录中创建配置
cat > opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vllm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "vLLM 服务器（本地）",
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

3. **选择你的模型**：
```bash
opencode
# 运行：/models
# 选择你的自定义提供商和模型
```

### 📋 热门自托管解决方案

#### **vLLM 服务器**（推荐用于性能）
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vllm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "vLLM 服务器（本地）",
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

#### **Text Generation Inference (TGI)**（Hugging Face）
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "tgi": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "TGI 服务器（本地）",
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

#### **LocalAI**（OpenAI 开源替代方案）
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "localai": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LocalAI（本地）",
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

#### **通用 OpenAI 兼容 API**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "my-custom-llm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "我的自定义 LLM 服务器",
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
          "name": "我的自定义模型",
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

### 🐳 Docker 网络设置

要将 OpenCode 连接到本地 LLM 服务器，需要正确的 Docker 网络配置：

#### **选项 1：主机网关（推荐）**
更新你的 shell 函数以包含主机网关：
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

#### **选项 2：主机网络**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  --network host \
  -w /workspace \
  opencode-cli "$@"
```

#### **选项 3：端口映射**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  -p 8000:8000 \
  -p 8080:8080 \
  -w /workspace \
  opencode-cli "$@"
```

### ⚙️ 高级配置

#### **环境变量**
对敏感数据使用环境变量：
```json
{
  "options": {
    "baseURL": "{env:LLM_BASE_URL}",
    "apiKey": "{env:LLM_API_KEY}"
  }
}
```

#### **自定义头部**
添加身份验证或自定义头部：
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

#### **模型限制**
指定上下文和输出限制：
```json
{
  "models": {
    "my-model": {
      "name": "我的模型",
      "limit": {
        "context": 128000,
        "output": 8192
      }
    }
  }
}
```

### 🔧 自定义提供商故障排除

#### **Q: 无法连接到本地 LLM 服务器？**
A: 检查 Docker 网络：
```bash
# 从容器内测试连接
docker run --rm --add-host host.docker.internal:host-gateway \
  alpine/curl:latest curl -I http://host.docker.internal:8000/v1/models
```

#### **Q: 自定义提供商未在 /models 中显示？**
A: 验证你的配置：
```bash
# 检查配置语法
cat opencode.json | jq .

# 确保 /connect 和配置中的提供商 ID 匹配
opencode auth list
```

#### **Q: 收到"连接被拒绝"错误？**
A: 尝试不同的网络方法：
```bash
# 使用主机网络测试
docker run -it --rm --network host \
  -v "$(pwd)":/workspace \
  -v "$HOME/.opencode":/root/.opencode \
  opencode-cli "$@"
```

#### **Q: 模型响应不正确？**
A: 检查你的 LLM 服务器日志并确保：
- 服务器正在运行且可访问
- 模型已正确加载
- API 端点符合 OpenAI 格式
- 身份验证配置正确

### 🎯 自定义提供商最佳实践

✅ **要做**：
- 使用 `host.docker.internal` 访问本地服务器
- 设置适当的上下文和输出限制
- 对 API 密钥使用环境变量
- 在配置 OpenCode 前测试连接
- 监控你的 LLM 服务器性能

❌ **不要做**：
- 使用 `localhost` 或 `127.0.0.1`（在 Docker 中无效）
- 在配置文件中硬编码 API 密钥
- 忘记设置模型限制
- 故障排除时忽略服务器日志
- 使用不支持的模型格式

---

## 📜 许可与免责声明

- OpenCode 是 [OpenCode-AI](https://github.com/OpenCode-AI) 的开源项目。
- `@mixedbread/mgrep` 由 [mixedbread.ai](https://mixedbread.ai) 提供。
- **本镜像仅为方便使用而封装，作者不对任何数据泄露、费用损失或代码损坏负责。**
- 使用即表示你已理解并接受上述风险。

---

## 💡 最佳实践总结

✅ **做**：
- 在干净项目目录中运行  
- 优先使用 Ollama 本地模型  
- 定期检查 `$HOME/.opencode/config.json`  
- 用 `git` 管理代码，避免直接修改  
- 将 `.opencode/` 加入备份（但勿提交到 Git！）
- 使用 **OpenSpec** 维护 API 文档
- API 更改后运行 **opencode openspec validate**
- 将 **openspec.config.json** 加入版本控制

❌ **不做**：
- 在含敏感数据的目录运行  
- 共享你的 `config.json`（含 API 密钥）  
- 用 root 权限运行容器  
- 期望它 100% 正确（LLM 会幻觉！）  
- 代码更改后忘记更新 API 规范  
- 在 API 示例中提交敏感数据  

---

> **记住：OpenCode 是助手，不是替代者。始终审查它生成的代码！**  

📚 [OpenCode 官方文档](https://github.com/OpenCode-AI/opencode)  
📋 [OpenSpec 文档](https://github.com/fission-ai/openspec)  
🔗 [mgrep on npm (@mixedbread/mgrep)](https://www.npmjs.com/package/@mixedbread/mgrep)  
🐞 [提交 Issue](https://github.com/OpenCode-AI/opencode/issues)

---

*构建日期：2025 年 12 月 | 基础镜像：Ubuntu 24.04 LTS | OpenCode v1.x | OpenSpec v1.x | mgrep v1.x*
