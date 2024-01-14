<!--  2024.01.14  도커 리액트 앱 만들기 -->

1. 리액트 설치
2. 도커파일 개발용 작성 Dockerfile.dev
3. 개발환경용 도커파일 빌드 docker build -f Dockerfile.dev -t tedkov2024/docker-react-app ./

4. 도커를 빌드할때 node_modules를 제거하여 연결하여 빌드시간을 단축시킨다.

5. 도커 컨테이너 실행 docker run -p 3000:3000 tedkov2024/docker-react-app

6. 우선 사용중인 도커를 정지한다.
   docker ps  
   docker stop [CONTAINER ID]

7. volume을 이용하여 도커 컨테이너와 로컬의 파일을 연결하여 수정시 자동으로 반영되도록 한다. 이때 경로는 동일하게
   docker run -it -p 3000:3000 -v /usr/src/app/node_modules -v $(pwd):/usr/src/app tedkov2024/docker-react-app

7-1. 볼륨을 이용하는 이유 : 도커 컨테이너는 파일을 수정하면 컨테이너에 있는 파일이 수정되고 로컬에 있는 파일은 수정되지 않는다. 이때 볼륨을 이용하면 컨테이너와 로컬의 파일을 연결하여 수정시 자동으로 반영되도록 한다. 이때 경로는 동일하게 적용해야한다.

8. 도커 compose로 간편하게 컨테이너를 관리한다.
   docker-compose.yml 파일을 작성한다.
   예시 :
   version: '3' # 버전
   services: # 서비스
   react: # 서비스 이름
   build: # 빌드
   context: . # 현재 디렉토리
   dockerfile: Dockerfile.dev # 도커파일
   ports: # 포트

   - "3000:3000" # 로컬포트:컨테이너포트
     volumes: # 볼륨
   - /usr/src/app/node_modules # 컨테이너 경로
   - .:/usr/src/app # 로컬 경로
     stdin_open: true # 리액트앱 끌떄 필요

9. 도커 컴포즈로 컨테이너를 실행한다.
   docker compose up

10. 도커 컴포즈로 컨테이너를 정지한다.
    docker compose down

11. 도커를 이용한 리액트 앱에서 테스트를 진행하려면 도커 컴포즈로 컨테이너를 실행한 후 다른 터미널에서 테스트를 진행한다.
    docker exec -it [CONTAINER ID] npm run test

    // docker exex 와 docker run의 차이는 ?
    // docker exec는 실행중인 컨테이너에 접속하는 명령어이고 docker run은 컨테이너를 실행하는 명령어이다.
    그럼 위에 docker exec -it [CONTAINER ID] npm run test 는 무슨 명령어일까?
    docker exec -it [CONTAINER ID] npm run test 는 실행중인 컨테이너에 접속하여 npm run test 명령어를 실행하는 명령어이다.

    docker run -it [CONTAINER ID] npm run test 는 컨테이너를 실행하여 npm run test 명령어를 실행하는 명령어이다.

12. ngix 를 이용하여 리액트 앱을 배포한다.
    도커 파일을 작성한다.
    예시 :
    FROM node:alpine as builder
    WORKDIR '/app'
    COPY package.json .
    RUN npm install
    COPY . .
    RUN npm run build

    FROM nginx
    COPY --from=builder /app/build /usr/share/nginx/html

13. 도커 파일을 빌드한다.
    docker build . -t tedkov2024/docker-react-app 이름 꼭 넣어줘야한다.

14. 도커 컨테이너를 실행한다.
    docker run -p 8080:80 tedkov2024/docker-react-app

15. git hub에 도커 이미지를 올린다.
    docker login
    docker push tedkov2024/docker-react-app
