# 使用官方的 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV SNELL_URL="https://github.com/rebecca554owen/Others/blob/master/snell/v3.0.1/snell-server-v3.0.1-linux-amd64.zip"
ENV TZ=Asia/Shanghai

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# 将 shell 脚本复制到容器的 /opt/snell 目录下
COPY snell.sh /opt/snell/snell.sh

# 确保脚本具有可执行权限
RUN chmod +x /opt/snell/snell.sh

# 设置入口点为该脚本
ENTRYPOINT ["/opt/snell/snell.sh"]
