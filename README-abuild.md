# Xed-Editor — 自用补丁（abuild）

本分支只含**补丁与脚本**，不含上游源码。基于上游 `main`（3.4.9 / versionCode 112）。

## 内容

| 文件 | 用途 |
|---|---|
| `patches/signing.patch` | release 签名优先读项目根 `signing.properties`（上游只认作者本机/CI 路径） |
| `patches/arm64-only.patch` | `terminal-emulator` 的 ndkBuild 只编 `arm64-v8a`（4 ABI 并行配置会 EAGAIN） |
| `patches/ai-providers.patch` | 内置 AI 换成 Z.ai GLM Coding Plan（默认）+ OpenRouter；设置页可刷新模型列表 |
| `scripts/apply-patches.sh` | 幂等应用/检查 |
| `scripts/check.sh` | 供构建流水线调用 |

## 用法

在上游源码树根目录：

```bash
git submodule update --init --recursive        # 必需 soraX
scripts/apply-patches.sh apply                 # 打补丁
scripts/apply-patches.sh check                 # 只检查
```

本地准备（不入库）：`signing.properties`（600）指向自用 keystore。

## AI 供应商

- **Z.ai · GLM Coding Plan**（默认）：`https://api.z.ai/api/coding/paas/v4/chat/completions`
  内置模型 glm-4.6 / glm-4.5 / glm-4.5-air
- **OpenRouter**：`https://openrouter.ai/api/v1/chat/completions`
  内置 z-ai/glm-4.6、deepseek/deepseek-chat、qwen/qwen3-coder、moonshotai/kimi-k2

设置页「AI → 刷新模型列表」会 `GET {baseUrl}/models` 拉取并缓存（OpenAI 兼容格式）；
未刷新时用内置列表，刷新后优先用缓存。

## 构建

```bash
./gradlew :app:assembleCommunityRelease   # 需 JDK 21、SDK 36.1/37.1、soraX 子模块
```
