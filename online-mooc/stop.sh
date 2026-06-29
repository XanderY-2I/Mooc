#!/bin/bash
# ==========================================
# 智慧MOOC教育平台 - 一键关闭脚本
# ==========================================

PROJECT_DIR="/home/xandery/mooc/online-mooc"
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"; }

echo "========================================="
echo "  智慧MOOC教育平台 - 关闭"
echo "========================================="

# 1. 关闭前端
log "关闭前端..."
pkill -f "vite" 2>/dev/null || true

# 2. 关闭微服务
log "关闭微服务..."
pkill -f "tj-.*\.jar" 2>/dev/null || true
sleep 2

# 3. 确认 Java 进程已清
REMAINING=$(ps aux | grep "tj-.*\.jar" | grep -v grep | wc -l)
if [ "$REMAINING" -gt 0 ]; then
    log "强杀残留 Java 进程..."
    kill -9 $(ps aux | grep "tj-.*\.jar" | grep -v grep | awk '{print $2}') 2>/dev/null || true
fi
log "微服务已关闭 ✓"

# 4. 关闭 Docker 中间件
log "关闭 Docker 中间件..."
cd "$PROJECT_DIR"
docker compose -f docker-compose.yml down

echo ""
echo "========================================="
echo "  所有服务已关闭"
echo "========================================="
echo ""
echo "  下次启动: bash $PROJECT_DIR/start.sh"
