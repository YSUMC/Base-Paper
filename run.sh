#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 同步代码库
echo -e "${BLUE}正在同步代码库...${NC}"

# 首先获取远程更新
git fetch origin main

if [ $? -ne 0 ]; then
    echo -e "${RED}获取远程更新失败，请检查网络连接或仓库状态${NC}"
    exit 1
fi

# 尝试pull，如果有分支分歧则自动强制使用远程版本
git pull origin main

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}检测到分支分歧，自动强制使用远程版本...${NC}"
    echo -e "${YELLOW}警告：这将丢弃所有本地更改！${NC}"
    
    # 强制重置到远程版本
    git reset --hard origin/main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}已强制重置到远程版本${NC}"
    else
        echo -e "${RED}重置失败，请检查Git状态${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}代码库同步完成${NC}"

# 检查velocity.jar是否存在
if [ ! -f "server.jar" ]; then
    echo -e "${RED}错误：找不到 velocity.jar 文件${NC}"
    echo "请确保 velocity.jar 文件在当前目录中"
    exit 1
fi

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo -e "${RED}错误：未找到 Java 运行环境${NC}"
    echo "请安装 Java 8 或更高版本"
    exit 1
fi

# 显示Java版本信息
echo -e "${BLUE}Java版本信息：${NC}"
java -version

# 启动Velocity代理服务器
echo -e "${GREEN}正在启动lobby服务器...${NC}"
echo -e "${YELLOW}服务器端口：20000${NC}"
echo -e "${YELLOW}按 Ctrl+C 停止服务器${NC}"
echo "----------------------------------------"

# 启动服务器并捕获退出码
java -Xms1G -Xmx2G -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar server.jar
exit_code=$?

echo "----------------------------------------"
if [ $exit_code -eq 0 ]; then
    echo -e "${GREEN}服务器正常停止${NC}"
else
    echo -e "${RED}服务器异常退出，退出码：$exit_code${NC}"
    echo "请检查服务器日志以获取更多信息"
fi