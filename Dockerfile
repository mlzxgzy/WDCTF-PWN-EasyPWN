FROM alpine as compiler

ENV BUILD_ARG="-z execstack -fno-stack-protector -no-pie -z norelro"

COPY ./pwn/ /pwn/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add gcc libc-dev \
    && gcc $BUILD_ARG /pwn/pwn.c -o /pwn/pwn \
    && strip /pwn/pwn

FROM alpine

COPY --from=compiler /pwn/pwn /pwn

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add socat \
    && rm -rf /var/cache/apk/* \
    && echo 'if [ ! $FLAG ]; then export FLAG="flag{Flag_System_Was_Broken_Please_Contect_To_Administrator}"; fi' >> /n2r.sh \
    && echo 'echo $FLAG > /flag' >> /n2r.sh \
    && echo 'socat tcp-listen:10000,fork exec:/pwn,reuseaddr' >> /n2r.sh \
    && chmod +x /n2r.sh

CMD "/n2r.sh"
