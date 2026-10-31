#!/bin/bash
# Xed-Editor 自用补丁：release 签名优先读项目内 signing.properties。
# 用法: projects/xed/apply-patches.sh check|apply
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$HERE/src"; [ -d "$ROOT/app" ] || ROOT="$(cd "$HERE/.." && pwd)"
SRC="$ROOT"
PD="$HERE/patches"; [ -d "$PD" ] || PD="$(cd "$HERE/.." && pwd)/patches"
ACTION="${1:-check}"
PATCHES=("signing.patch" "arm64-only.patch" "ai-providers.patch")

applied() { grep -q "自用签名" "$SRC/app/build.gradle.kts" 2>/dev/null && grep -q "arm64-v8a" "$SRC/terminal-emulator/build.gradle" 2>/dev/null && grep -q "api.z.ai" "$SRC/features/ai/src/main/java/com/rk/ai/provider/BuiltinProviders.kt" 2>/dev/null; }

case "$ACTION" in
    check) applied && echo "[ok] xed 补丁已应用" || { echo "[fail] xed 补丁缺失"; exit 1; } ;;
    apply)
        for p in "${PATCHES[@]}"; do
            if patch -d "$SRC" -p1 -R --dry-run -s -f < "$PD/$p" >/dev/null 2>&1; then echo "[ok] $p 已应用"
            elif patch -d "$SRC" -p1 --dry-run -s -f < "$PD/$p" >/dev/null 2>&1; then patch -d "$SRC" -p1 -s -f < "$PD/$p" && echo "[ok] $p 应用"
            else echo "[fail] $p 无法干净应用"; exit 1; fi
        done ;;
    *) echo "用法: $0 check|apply"; exit 2 ;;
esac
