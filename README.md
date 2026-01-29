# Nginx Host 碰撞漏洞演示

## 📋 项目说明

这是一个存在 Host 碰撞漏洞的 Nginx 配置演示环境，用于安全测试和学习。

## 🚀 快速开始

### 1. 构建镜像

```bash
chmod +x build.sh
./build.sh
```

或手动构建：

```bash
docker build -t nginx-host-collision:demo .
```

### 2. 运行容器

```bash
docker run -d -p 8080:8080 --name host-collision-demo nginx-host-collision:demo
```

### 3. 测试漏洞

```bash
# 正常访问
curl -H "Host: test.com" http://localhost:8080/

# Host 碰撞 - 访问内部管理后台
curl -H "Host: admin.local" http://localhost:8080/

# Host 碰撞 - 访问内部 API
curl -H "Host: api.internal" http://localhost:8080/

# 查看响应头
curl -I -H "Host: admin.local" http://localhost:8080/ | grep X-Server
```

### 4. 浏览器访问

访问以下地址查看效果：

- **test.com**: http://localhost:8080/ (需配置 hosts 文件)
- **admin.local**: http://localhost:8080/ (需配置 hosts 文件)

### 5. 配置 hosts 文件（可选）

```bash
# macOS/Linux
sudo echo "127.0.0.1 test.com admin.local api.internal" >> /etc/hosts

# Windows (以管理员身份运行命令提示符)
echo 127.0.0.1 test.com admin.local api.internal >> C:\Windows\System32\drivers\etc\hosts
```

## 🕵️ 漏洞说明

### 为什么存在漏洞？

1. **没有 `default_server`**: 当 Host 头不匹配任何 `server_name` 时，Nginx 会使用第一个 server 块
2. **多个内部服务暴露**: `admin.local` 和 `api.internal` 本应是内部域名
3. **无 Host 头校验**: 没有 `if ($host)` 校验，任何 Host 头都能被接受

### 攻击场景

攻击者可以：
- 通过伪造 Host 头访问内部管理后台
- 获取敏感信息（数据库连接、API 密钥等）
- 访问本应隔离的内部服务

## 🔧 修复方案

在 `nginx.conf` 中添加：

```nginx
server {
    listen 8080 default_server;
    server_name _;
    return 444;
}
```

并在每个 server 块中添加：

```nginx
if ($host !~* ^(test\.com|www\.test\.com)$) {
    return 444;
}
```

## 📊 查看日志

```bash
# 查看访问日志
docker logs host-collision-demo

# 查看特定站点日志
docker exec host-collision-demo cat /var/log/nginx/admin.local.access.log
```

## 🗑️ 清理

```bash
docker stop host-collision-demo
docker rm host-collision-demo
docker rmi nginx-host-collision:demo
```

## ⚠️ 注意事项

- 仅用于学习和测试目的
- 请勿在生产环境中使用此配置
- 未经授权的渗透测试可能违法
```

---

## 🎯 一键测试命令

```bash
# 构建
docker build -t nginx-host-collision:demo .

# 运行
docker run -d -p 8080:8080 --name host-collision-demo nginx-host-collision:demo

# 等待启动
sleep 2

# 测试
echo "=== 测试 Host 碰撞 ==="
curl -s -H "Host: test.com" http://localhost:8080/ | grep title
curl -s -H "Host: admin.local" http://localhost:8080/ | grep title
curl -s -H "Host: api.internal" http://localhost:8080/

# 清理
docker stop host-collision-demo && docker rm host-collision-demo
```

---

这个 Docker 镜像完整演示了 Host 碰撞漏洞，你可以直接构建、运行并测试！🎉
