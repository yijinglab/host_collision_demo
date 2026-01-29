# 使用官方 Nginx Alpine 镜像
FROM nginx:1.24-alpine

# 维护者信息
LABEL maintainer="demo@example.com"
LABEL description="Nginx Host Collision Vulnerability Demo"

# 创建必要的目录
# 关键：删除默认配置，避免干扰
RUN rm -f /etc/nginx/conf.d/default.conf && \
    mkdir -p /usr/share/nginx/admin

# 复制 Nginx 主配置文件
#COPY nginx.conf /etc/nginx/nginx.conf

# 复制站点配置文件
COPY sites-available/collision.conf /etc/nginx/conf.d/collision.conf

# 复制 HTML 文件
COPY html/index.html /usr/share/nginx/html/index.html
COPY html/admin/index.html /usr/share/nginx/admin/index.html

# 暴露端口
EXPOSE 80

# 健康检查
#HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
 #   CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# 启动 Nginx
#CMD ["nginx", "-g", "daemon off;"]
