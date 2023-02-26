ARG DEBIAN_RELEASE=buster
FROM docker.io/debian:$DEBIAN_RELEASE-slim
ARG DEBIAN_RELEASE
COPY entrypoint.sh /
ENV DEBIAN_FRONTEND noninteractive
RUN true && \
	apt update && \
	apt install -y libcap2-bin haproxy curl gnupg && \
	curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
	echo "deb [arch=arm64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $DEBIAN_RELEASE main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
	apt update && \
	apt install cloudflare-warp -y && \
	apt clean -y && \
	chmod +x /entrypoint.sh
COPY haproxy.cfg /etc/haproxy/haproxy.cfg

EXPOSE 40000/tcp
ENTRYPOINT [ "/entrypoint.sh" ]
