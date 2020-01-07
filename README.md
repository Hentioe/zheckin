# zheckin

[![Build Status](https://cloud.drone.io/api/badges/Hentioe/zheckin/status.svg)](https://cloud.drone.io/Hentioe/zheckin)

ZheckIn 是 Zhihu 和 Check-In 的合并词，是一个用于托管「知乎圈子」自动签到的程序。

## 介绍

本项目使用原生语言 Crystal 和嵌入式数据库 Sqlite3 开发，占用极低，部署方便。你可以通过以下的方式自行部署，也可以选择直接使用[官方](https://zheckin.bluerain.io)（作者提供）服务。

## 部署

为了方便，请直接使用 DokcerHub 上的官方镜像。

1. 创建 `.env` 文件，写入以下必要变量：

   ```env
   ZHECKIN_ZHIHU_API_TOKEN="<Your_Zhihu_API_Token>"
   ZHECKIN_BASE_SECRET_KEY="<Secret_Key>"
   ZHECKIN_SCHEDULE_HOUR=0
   ZHECKIN_SCHEDULE_MINUTE=15
   ```

   变量说明：

   - ZHECKIN_ZHIHU_API_TOKEN: 知乎 Cookie 中的 "z_c0" 的值，用于认证身份（以下称“认证令牌”）。更多说明和提取方法请看[登入页面](https://zheckin.bluerain.io/sign_in)。
   - ZHECKIN_BASE_SECRET_KEY: 密钥，用于签名登录信息，它和 ZheckIn 内部帐号认证有关，和知乎的登录认证无关。通常使用较长的随机 Hash 字符串。
   - ZHECKIN_SCHEDULE_HOUR: 定时签到的时间（小时），24 小时制。
   - ZHECKIN_SCHEDULE_MINUTE: 定时签到的分钟。上面的模板内容指的是 00:15 分定时签到

   ZHECKIN_ZHIHU_API_TOKEN 变量中储存的认证令牌并不参与签到，它主要有两个目的：

   1. 管理员身份凭证
   1. 额外的 API 调用需要

2. 创建 `docker-compose.yml` 文件：

   ```yml
   version: "3"

   services:
   server:
     image: bluerain/zheckin
     stdin_open: true
     ports:
       - 8080:8080
     environment:
     ZHECKIN_ZHIHU_API_TOKEN: "${ZHECKIN_ZHIHU_API_TOKEN}"
     ZHECKIN_BASE_SECRET_KEY: "${ZHECKIN_BASE_SECRET_KEY}"
     ZHECKIN_SCHEDULE_HOUR: "${ZHECKIN_SCHEDULE_HOUR}"
     ZHECKIN_SCHEDULE_MINUTE: "${ZHECKIN_SCHEDULE_MINUTE}"
     restart: always
   ```

   注意，您不需要自行构建镜像。`bluerain/zheckin` 是已存在于 DockerHub 的官方镜像。

3. 启动服务：

   ```bash
   docker-compose up -d
   ```

4. 使用 Nginx 或其它工具反代 8080 端口，亦或直接访问即可使用。
