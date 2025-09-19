#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 同步代码库
echo "正在同步代码库..."
git pull origin main

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Git pull 失败，检测到分支分歧，自动使用远程版本...${NC}"
    echo -e "${YELLOW}警告：这将丢弃所有本地更改！${NC}"
    
    # 获取远程最新更改
    git fetch origin main
    
    # 重置到远程版本
    git reset --hard origin/main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}已成功重置到远程版本${NC}"
    else
        echo -e "${RED}重置失败，请手动解决冲突后重新运行脚本${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}代码库同步完成${NC}"

# 启动Velocity代理服务器
echo "正在启动Velocity服务器..."
"/data/program/java/java21/bin/java" -Xms512m -Xmx512m -javaagent:authlib-injector.jar=https://skin.mualliance.ltd/api/union/yggdrasil -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.country=CN -jar velocity.jar

echo "服务器已停止"