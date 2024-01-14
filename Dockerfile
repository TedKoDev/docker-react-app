# 기존의 Node.js 빌드 스테이지
FROM node:alpine as builder
WORKDIR '/usr/src/app'
COPY package.json ./
RUN npm install
COPY ./ ./
RUN npm run test -- --coverage
RUN npm run build

# Nginx 스테이지
FROM nginx
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
