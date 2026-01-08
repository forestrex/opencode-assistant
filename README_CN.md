# 🧠 OpenCode CLI — 智能终端编程助手（Ubuntu 24.04 + mgrep 完整版）

> **⚠️ 警告：这不是一个普通工具。错误使用可能导致代码泄露、费用失控或系统不稳定。请务必阅读以下指南！**

---

## 📋 项目概述

此 Docker 镜像提供四个强大的 AI 驱动开发工具：

- **🧠 OpenCode**：智能终端编程助手，用于代码生成、调试和开发任务
- **📋 OpenSpec**：AI 驱动的 API 规范生成器，用于创建全面的 API 文档
- **🌱 Spec Kit**：规范驱动开发工具包，用于结构化、意图驱动的软件开发
- **🚀 Oh-My-OpenCode**：高级 Agent 框架，配备西西弗斯协调器、后台 Agent 和增强 LSP 工具

所有工具都通过 `mgrep` 预配置了增强的上下文理解能力，以获得最佳性能。

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
  -v $HOME/.config/opencode:/root/.config/opencode \
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
    mkdir -p "$HOME/.config/opencode"
    docker run -it --rm \
        -v "$(pwd)":/workspace \
        -v "$HOME/.config/opencode":/root/.config/opencode \
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

> 首次运行将引导你选择 LLM 提供商并输入 API 密钥。配置保存在 `$HOME/.config/opencode/opencode.json`。

### 4. 在项目目录中使用
```bash
cd /your/project
opencode                # 启动交互式界面
opencode explain main.py  # 解释文件
opencode chat "如何优化这段代码？"  # 询问问题
```

> ✅ **关键**：shell 函数已经自动处理了目录挂载，OpenCode 可以直接"看到"你的代码。

---

## 🚀 本地开发

**📁 工作空间挂载**
```bash
# 直接工作空间挂载
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.config/opencode":/root/.config/opencode \
  opencode-cli
```

### 开发工作流

#### **🏗️ 应用程序开发**
```bash
opencode "ultrawork: 创建支持生产的完整 React 应用，包括：
- 多阶段构建流程
- nginx 反向代理配置
- 健康检查和监控设置"
```

#### **🧪 测试与集成**
```bash
opencode "ultrawork: 设置集成测试：
- 配置测试环境
- 实现测试数据播种
- 添加 CI/CD 流水线示例"
```

#### **📦 多组件应用**
```bash
opencode "ultrawork: 设计微服务架构：
- 实现服务发现
- 添加负载均衡配置
- 设置监控和日志记录"
```



---

## 🚀 Oh-My-OpenCode：高级 Agent 框架

此 Docker 镜像包含 **oh-my-opencode**，强大的 Agent 框架，大幅提升 OpenCode 使用体验，配备先进的编排能力。

### 核心功能：

- **🧠 西西弗斯 Agent**：主要协调器，持续执行任务直到完成
  - 使用 Claude Opus 4.5 扩展思考模式，提供最大推理能力
  - 自动将任务委托给专业子代理
  - 维护任务驱动工作流，确保完成所有工作

- **👥 后台 Agent**：像团队一样工作 - 并行执行以获得最大效率
  - **Oracle** (GPT-5.2)：架构设计、代码审查、战略规划
  - **Librarian** (Claude Sonnet 4.5)：多仓库分析、文档查找
  - **前端 UI/UX 工程师** (Gemini 3 Pro)：构建美观的用户界面
  - **Explore**：快速代码库探索和模式匹配

- **🔧 高级 LSP 工具**：为 Agent 提供真实 IDE 能力
  - `lsp_hover`、`lsp_goto_definition`、`lsp_find_references`
  - `lsp_code_actions`、`lsp_rename` 用于精确重构
  - `ast_grep_search` 用于 AST 感知代码模式匹配

- **⚡ 魔法关键字**：在提示中包含这些关键字以获得增强功能
  - `ultrawork` 或 `ulw`：完整编排，配备后台代理和持续执行
  - `ultrathink`：深度分析和规划模式

### Oh-My-OpenCode 快速开始：

```bash
# 在启用了 oh-my-opencode 的项目目录中：
opencode "ultrawork: 重构整个代码库并添加全面的测试"
opencode "ulw: 遵循最佳实践构建新功能，包含适当的文档"
opencode "ultrathink: 分析这个遗留系统并提出迁移策略"
```

### 高级用法示例：

```bash
# 使用专业代理进行团队式开发
opencode "请求 @oracle 审查这个架构并提出改进建议"
opencode "请求 @librarian 在类似的开源项目中如何实现这个功能"
opencode "请求 @frontend-ui-ux-engineer 为这些指标构建响应式仪表板"

# 并行后台处理
opencode "ultrawork: 在 GPT 调试身份验证问题时，让 Claude 实现支付集成"
```

> 💡 **注意**：oh-my-opencode 与你所有现有的 LLM 提供商兼容（OpenRouter、Anthropic、OpenAI、Ollama）。它智能地将任务路由到最合适的模型，同时尊重你配置的提供商。

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

## 🌱 Spec Kit - 规范驱动开发工具包

### 什么是 Spec Kit？

Spec Kit 是 GitHub 的开源工具包，用于**规范驱动开发**——一种通过使规范可执行而非仅仅描述来颠覆传统软件开发的方法论。它帮助你更快地构建高质量软件：

- **意图驱动开发**：先关注"做什么"和"为什么"，再考虑"怎么做"
- **结构化工作流**：多步骤优化而非一次性代码生成
- **AI 代理集成**：与 OpenCode 和其他 AI 编码助手无缝协作
- **基于模板**：使用经过验证的模式和最佳实践引导项目

### Spec Kit 命令

Spec Kit 提供 `specify` CLI 及其核心命令：

```bash
# 初始化新的规范驱动项目
specify init <项目名称>

# 在当前目录初始化
specify init . --ai opencode

# 检查系统要求和已安装工具
specify check

# 在非空目录强制初始化
specify init . --force --ai opencode
```

### Specify CLI 选项

| 选项 | 描述 |
|--------|-------------|
| `--ai <agent>` | 选择 AI 助手：`opencode`、`claude`、`gemini`、`copilot` 等 |
| `--here` | 在当前目录初始化而非创建新目录 |
| `--force` | 在当前目录初始化时强制合并/覆盖 |
| `--no-git` | 跳过 git 仓库初始化 |
| `--debug` | 启用详细调试输出用于故障排除 |

### Spec Kit 工作流

初始化后，Spec Kit 为 AI 代理提供结构化的斜杠命令：

#### 核心命令
```bash
# 建立项目原则和指导方针
/speckit.constitution

# 定义你想要构建的内容（需求）
/speckit.specify

# 创建技术实现计划
/speckit.plan

# 生成可操作的任务分解
/speckit.tasks

# 根据计划执行实现
/speckit.implement
```

#### 质量命令
```bash
# 澄清规范不足的区域
/speckit.clarify

# 分析一致性和覆盖度
/speckit.analyze

# 生成质量检查清单
/speckit.checklist
```

### Spec Kit 使用示例

```bash
# 使用规范驱动开发启动新的 Web 项目
specify init my-web-app --ai opencode
cd my-web-app
opencode  # 启动具有 Spec Kit 集成的 OpenCode

# 在现有项目中初始化 Spec Kit
cd existing-project
specify init . --force --ai opencode

# 使用结构化工作流创建新功能
opencode  # 在 OpenCode 内使用 /speckit 命令
```

### Spec Kit 配置

创建 `.specify/memory/constitution.md` 用于项目原则：

```markdown
# 项目章程

## 代码质量
- 编写干净、可维护的代码
- 遵循语言特定约定
- 包含全面的测试

## 测试标准
- 测试驱动开发方法
- 所有业务逻辑的单元测试
- API 端点的集成测试

## 用户体验
- 一致的 UI/UX 模式
- 可访问性合规
- 性能优化

## 性能要求
- API 调用响应时间 < 200ms
- 页面加载时间 < 2 秒
- 内存使用优化
```

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
| **包含工具** | OpenCode CLI + OpenSpec CLI + Spec Kit (specify-cli) |
| **运行时** | Bun（用于 OpenCode/OpenSpec） + Node.js 20（用于 mgrep） + Go 1.21+ |
| **上下文引擎** | `@mixedbread/mgrep`（全局安装）|
| **兼容性** | 支持 Intel/Apple Silicon Mac、Linux |
| **镜像大小** | ~320 MB（精简无冗余）|

---

## 🔄 OpenCode、OpenSpec 和 Spec Kit 协同使用

### 完整的规范驱动开发工作流

1. **初始化项目**，使用所有三个工具：
```bash
cd your-project
specify init . --ai opencode --force  # 初始化 Spec Kit
opencode openspec init                # 初始化 API 文档
opencode                              # 启动编程辅助
```

2. **建立项目原则**，使用 Spec Kit：
```bash
opencode  # 在 OpenCode 内运行：
# /speckit.constitution 创建专注于代码质量、测试和用户体验的原则
```

3. **定义规范**，使用 Spec Kit：
```bash
# 在 OpenCode 内运行：
# /speckit.specify 构建具有用户身份验证和实时更新的任务管理应用
```

4. **创建技术计划**，使用 Spec Kit：
```bash
# 在 OpenCode 内运行：
# /speckit.plan 使用 FastAPI 与 PostgreSQL、React 前端、WebSocket 实现实时功能
```

5. **生成任务**并实现：
```bash
# 在 OpenCode 内运行：
# /speckit.tasks
# /speckit.implement
```

6. **生成 API 文档**，使用 OpenSpec：
```bash
opencode openspec generate  # 创建全面的 API 规范
opencode openspec export --format markdown  # 导出用于 README
```

7. **审查和完善**所有工件：
```bash
opencode review            # 审查代码更改
opencode openspec validate  # 验证 API 规范
# 在 OpenCode 内：/speckit.analyze  # 分析规范一致性
```

### 集成示例

```bash
# 使用完整工具链启动新项目
specify init my-api-project --ai opencode
cd my-api-project
opencode openspec init
opencode

# 使用规范驱动开发创建新功能
opencode  # 使用 /speckit 命令进行结构化开发
# /speckit.specify 添加具有头像上传的用户配置文件管理
# /speckit.plan 使用现有 FastAPI 结构，添加 S3 集成
# /speckit.tasks
# /speckit.implement

# 记录新 API 端点
opencode openspec generate --path src/api/users.py
opencode openspec export --format yaml

# 质量保证工作流
opencode review
opencode openspec validate
# /speckit.checklist  # 生成质量检查清单
```

### 工具互补性

| 工具 | 主要角色 | 使用时机 |
|------|--------------|------------|
| **Spec Kit** | 需求与规划 | 项目初始化、功能规划 |
| **OpenCode** | 代码生成与调试 | 实现、问题解决 |
| **OpenSpec** | API 文档 | API 开发后、文档更新 |

### 组合使用最佳实践

✅ **要做**：
- 使用 Spec Kit 进行项目初始化和功能规划
- 使用 OpenCode 进行实现和调试
- 在 API 端点开发后应用 OpenSpec
- 在实现前运行 `/speckit.analyze` 以捕获不一致性
- 将所有三个工具的配置纳入版本控制

❌ **不要做**：
- 跳过规范阶段（导致返工）
- 在未验证规范的情况下生成代码
- 代码更改后忘记更新 API 文档
- 忽略 Spec Kit 的质量检查清单

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
ls $HOME/.config/opencode/opencode.json
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
  -v $HOME/.config/opencode:/root/.config/opencode \
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
      -v $HOME/.config/opencode:/root/.config/opencode \
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
    mkdir -p "$HOME/.config/opencode"
    docker run -it --rm \
        -v "$(pwd)":/workspace \
        -v "$HOME/.config/opencode":/root/.config/opencode \
        --add-host host.docker.internal:host-gateway \
        -w /workspace \
        opencode-cli "$@"
}
```

#### **选项 2：主机网络**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.config/opencode":/root/.config/opencode \
  --network host \
  -w /workspace \
  opencode-cli "$@"
```

#### **选项 3：端口映射**
```bash
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.config/opencode":/root/.config/opencode \
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
  -v "$HOME/.config/opencode":/root/.config/opencode \
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
- 使用 **Spec Kit** 进行项目初始化和功能规划
- 使用 **OpenSpec** 维护 API 文档
- API 更改后运行 **opencode openspec validate**
- 将 **openspec.config.json** 加入版本控制
- 遵循 **规范驱动开发工作流** 开发新功能

❌ **不做**：
- 在含敏感数据的目录运行  
- 共享你的 `config.json`（含 API 密钥）  
- 用 root 权限运行容器  
- 期望它 100% 正确（LLM 会幻觉！）  
- 跳过规范阶段（导致返工）
- 代码更改后忘记更新 API 规范  
- 在 API 示例中提交敏感数据
- 忽略 Spec Kit 的质量检查清单  

---

> **记住：OpenCode 是助手，不是替代者。始终审查它生成的代码！**  

📚 [OpenCode 官方文档](https://github.com/OpenCode-AI/opencode)  
📋 [OpenSpec 文档](https://github.com/fission-ai/openspec)  
🌱 [Spec Kit 文档](https://github.com/github/spec-kit)  
🔗 [mgrep on npm (@mixedbread/mgrep)](https://www.npmjs.com/package/@mixedbread/mgrep)  
🐞 [提交 Issue](https://github.com/OpenCode-AI/opencode/issues)

---

*构建日期：2025 年 12 月 | 基础镜像：Ubuntu 24.04 LTS | OpenCode v1.x | OpenSpec v1.x | Spec Kit v0.x | mgrep v1.x*
