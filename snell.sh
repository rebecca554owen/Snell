#!/bin/sh

BIN="/opt/snell/snell-server"
CONF="/opt/snell/snell-server.conf"
PORT=${PORT:-2024}

# 提示用户如何使用此镜像
echo "要运行此镜像，请使用以下命令："
echo "docker run -e PSK=<your_psk_here> -e PORT=<your_port_here> --restart unless-stopped -d rebecca554owen/snell:latest"
echo "例如："
echo "docker run -e PSK=your_psk -e PORT=2024 --restart unless-stopped -d snell-server:latest"

# 下载 snell 二进制文件
download_bin() {
    wget --no-check-certificate -O snell.zip $SNELL_URL
    unzip snell.zip
    rm -f snell.zip
    chmod +x snell-server
    mv snell-server /opt/snell/
}

# 容器重启时重新使用现有配置
run_bin() {
    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${BIN} ]; then
    echo "找到已有的二进制文件..."
    run_bin
fi

if [ -f ${CONF} ]; then
    echo "找到已有的配置文件..."
    download_bin
    run_bin
else
    if [ -z ${PSK} ]; then
        PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
        echo "使用生成的 PSK: ${PSK}"
    else
        echo "使用预定义的 PSK: ${PSK}"
    fi
    echo "生成新的配置文件..."
    echo "[Snell Server]" >> ${CONF}
    echo "interface = 0.0.0.0" >> ${CONF}
    echo "port = ${PORT}" >> ${CONF}
    echo "psk = ${PSK}" >> ${CONF}
    run_bin
fi
