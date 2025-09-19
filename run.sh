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

# 尝试pull，如果有分支分歧则提供选择
git pull origin main

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}检测到分支分歧，需要选择合并策略：${NC}"
    echo "1) Merge (合并) - 保留完整的提交历史"
    echo "2) Rebase (变基) - 将本地提交重新应用到远程分支之上"
    echo "3) Reset (重置) - 强制使用远程版本，丢弃本地更改"
    echo "4) 退出脚本，手动处理"
    
    read -p "请选择 (1-4): " choice
    
    case $choice in
        1)
            echo -e "${BLUE}使用 merge 策略...${NC}"
            git config pull.rebase false
            git pull origin main
            ;;
        2)
            echo -e "${BLUE}使用 rebase 策略...${NC}"
            git config pull.rebase true
            git pull origin main
            ;;
        3)
            echo -e "${YELLOW}警告：这将丢弃所有本地更改！${NC}"
            read -p "确认要重置到远程版本吗？(y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                git reset --hard origin/main
                echo -e "${GREEN}已重置到远程版本${NC}"
            else
                echo "操作已取消"
                exit 1
            fi
            ;;
        4)
            echo "请手动解决分支分歧后再运行此脚本"
            exit 1
            ;;
        *)
            echo -e "${RED}无效选择，退出脚本${NC}"
            exit 1
            ;;
    esac
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}合并失败，请手动解决冲突后重新运行脚本${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}代码库同步完成${NC}"

# 启动Velocity代理服务器
echo "正在启动Velocity服务器..."
"/data/program/java/java21/bin/java" -Xms512m -Xmx512m -javaagent:authlib-injector.jar=https://skin.mualliance.ltd/api/union/yggdrasil -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.country=CN -jar velocity.jar

echo "服务器已停止"