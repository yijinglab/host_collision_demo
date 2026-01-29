#!/bin/bash

echo "📦 构建 Host 碰撞漏洞演示镜像..."
docker build -t nginx-host-collision:demo .

echo "✅ 构建完成！"
echo ""
echo "🚀 运行容器："
echo "   docker run -d -p 8080:8080 --name host-collision-demo nginx-host-collision:demo"
echo ""
echo "🧪 测试漏洞："
echo "   curl -H  http://localhost:8080/"
echo "   curl -H 'Host: admin.local' http://localhost:8080/"
echo "   curl -H 'Host: api.internal' http://localhost:8080/"