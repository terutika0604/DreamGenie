# Flutter Web を Nginx で配信する Dockerfile
FROM nginx:alpine

# Flutter build の成果物をコピー
COPY build/web /usr/share/nginx/html

# Nginx が listen するポート（Cloud Run 用に 8080 を使用）
EXPOSE 8080

# デフォルトの nginx.conf を上書きして 8080 ポートを利用
RUN sed -i 's/80/8080/g' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
