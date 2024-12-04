FROM debian:bookworm-slim

ARG LFS_UID
ARG LFS_GID
ARG LFS_USER
ARG BUILD_DIR

RUN apt-get update && \
    apt-get -y install binutils bison bzip2 gawk gcc g++ \
        git gzip m4 make patch procps python3 sudo texinfo vim wget xz-utils && \
    apt-get clean all && \
    mv /bin/sh /bin/sh.orig && \
    ln -s bash /bin/sh && \
    useradd -M -d $BUILD_DIR -s /bin/bash \
            -u $LFS_UID -g $LFS_GID $LFS_USER && \
    echo "${LFS_USER} ALL=NOPASSWD: ALL" >/etc/sudoers.d/lfsuser && \
    chmod 0440 /etc/sudoers.d/lfsuser
COPY docker-entrypoint.sh /

USER $LFS_UID:$LFS_GID
WORKDIR $BUILD_DIR
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "start" ]
