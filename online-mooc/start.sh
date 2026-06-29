#!/bin/bash
# ==========================================
# 智慧MOOC教育平台 - 一键启动脚本
# ==========================================
set -e

PROJECT_DIR="/home/xandery/mooc/online-mooc"
LOG_DIR="/tmp"
WSL_IP=$(ip addr show eth0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
JAVA_OPTS="-Xms128m -Xmx256m"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "========================================="
echo "  智慧MOOC教育平台 - 一键启动"
echo "========================================="

# Step 1: 启动中间件
log "Step 1/5: 启动 Docker 中间件..."
cd "$PROJECT_DIR"
docker compose -f docker-compose.yml up -d

# Step 2: 等待中间件就绪
log "Step 2/5: 等待中间件就绪..."
log "  -> MySQL..."
until docker exec tj-mysql mysql -uroot -p123 -e "SELECT 1" 2>/dev/null | grep -q "1"; do sleep 2; done
log "  -> Redis..."
until [ "$(docker exec tj-redis redis-cli -a 123321 ping 2>/dev/null)" = "PONG" ]; do sleep 1; done
log "  -> Nacos..."
until [ "$(curl -s http://localhost:8848/nacos/v1/console/health/readiness 2>/dev/null)" = "ok" ]; do sleep 2; done
log "  -> RabbitMQ..."
until curl -s -u tjxt:123321 http://localhost:15672/api/overview > /dev/null 2>&1; do sleep 2; done
log "  -> Elasticsearch..."
until curl -s http://localhost:9200 > /dev/null 2>&1; do sleep 2; done
log "  -> InfluxDB..."
until docker exec tj-influxdb influx -execute "SHOW DATABASES" > /dev/null 2>&1; do sleep 2; done

log " 所有中间件就绪 ✓"

# Step 3: 修复前端代理（WSL IP 可能变了）
log "Step 3/5: 配置前端代理..."
if [ -n "$WSL_IP" ]; then
    for f in "$PROJECT_DIR/tj-front/tj-protal/src/config/proxy.js" "$PROJECT_DIR/tj-front/tj-admin/src/config/proxy.js"; do
        # 把任意 IP 都替换为当前 WSL IP
        sed -i -E "s|http://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:10010|http://${WSL_IP}:10010|g" "$f" 2>/dev/null
    done
    log " 前端 API 地址: http://${WSL_IP}:10010"
else
    warn " 无法获取 WSL IP，使用 localhost"
fi

# Step 4: 启动微服务
log "Step 4/5: 启动微服务 (16个)..."

start_svc() {
    local jar="$1"
    local name="$2"
    nohup java $JAVA_OPTS -jar "$jar" > "${LOG_DIR}/tj-${name}.log" 2>&1 &
    echo -n "."
}

# 网关（最先）
start_svc "$PROJECT_DIR/tj-gateway/target/tj-gateway.jar" "gw"
sleep 6

# 基础服务
start_svc "$PROJECT_DIR/tj-auth/tj-auth-service/target/tj-auth-service.jar" "auth"
start_svc "$PROJECT_DIR/tj-user/target/tj-user.jar" "user"
start_svc "$PROJECT_DIR/tj-course/target/tj-course.jar" "course"
sleep 4

# 业务服务
start_svc "$PROJECT_DIR/tj-learning/target/tj-learning.jar" "learning"
start_svc "$PROJECT_DIR/tj-trade/target/tj-trade.jar" "trade"
start_svc "$PROJECT_DIR/tj-pay/tj-pay-service/target/tj-pay-service.jar" "pay"
start_svc "$PROJECT_DIR/tj-exam/target/tj-exam.jar" "exam"
start_svc "$PROJECT_DIR/tj-message/tj-message-service/target/tj-message-service.jar" "msg"
start_svc "$PROJECT_DIR/tj-remark/target/tj-remark.jar" "remark"
start_svc "$PROJECT_DIR/tj-media/target/tj-media.jar" "media"
start_svc "$PROJECT_DIR/tj-live/target/tj-live.jar" "live"
start_svc "$PROJECT_DIR/tj-chat/target/tj-chat.jar" "chat"
start_svc "$PROJECT_DIR/tj-promotion/target/tj-promotion.jar" "promotion"
start_svc "$PROJECT_DIR/tj-search/target/tj-search.jar" "search"
start_svc "$PROJECT_DIR/tj-data/target/tj-data.jar" "data"

echo ""
log " 等待服务注册到 Nacos..."

# Step 5: 验证
log "Step 5/5: 验证服务状态..."
sleep 20

COUNT=$(curl -s "http://localhost:8848/nacos/v1/ns/service/list?pageNo=1&pageSize=50" | python3 -c "import sys,json;print(json.load(sys.stdin)['count'])" 2>/dev/null || echo 0)

echo ""
echo "========================================="
echo -e "  ${GREEN}启动完成！已注册 ${COUNT}/16 个服务${NC}"
echo ""
echo "  用户端:     http://${WSL_IP:-localhost}:18082"
echo "  管理端:     http://${WSL_IP:-localhost}:18081"
echo "  Nacos:     http://localhost:8848/nacos"
echo "  RabbitMQ:  http://localhost:15672"
echo ""
echo "  启动前端:"
echo "    cd $PROJECT_DIR/tj-front/tj-protal && npm run dev"
echo "    cd $PROJECT_DIR/tj-front/tj-admin && npm run dev"
echo ""
echo "  查看日志: tail -f /tmp/tj-gw.log"
echo "  关闭项目: bash $PROJECT_DIR/stop.sh"
echo "========================================="

# 可选：自动启动前端
read -p "是否启动前端？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "启动用户端 (18082)..."
    cd "$PROJECT_DIR/tj-front/tj-protal" && npm run dev &
    log "启动管理端 (18081)..."
    cd "$PROJECT_DIR/tj-front/tj-admin" && npm run dev &
fi
