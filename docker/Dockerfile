FROM debian:bookworm-slim

ARG LFS_UID
ARG LFS_GID
ARG LFS_USER

RUN apt-get update && \
    apt-get -y install binutils bison bzip2 gawk gcc g++ \
        git gzip m4 make patch psmisc python3 sudo texinfo vim wget xz-utils && \
    apt-get clean all && \
    mv /bin/sh /bin/sh.orig && \
    ln -s bash /bin/sh && \
    useradd -M -d /home/$LFS_USER -s /bin/bash \
            -u $LFS_UID -g $LFS_GID $LFS_USER && \
    echo "${LFS_USER} ALL=NOPASSWD: ALL" >/etc/sudoers.d/lfs_user && \
    chmod 0440 /etc/sudoers.d/lfs_user
COPY docker-entrypoint.sh /

USER $LFS_UID:$LFS_GID
WORKDIR /home/$LFS_USER
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "start" ]
