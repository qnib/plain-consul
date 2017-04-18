FROM qnib/alplain-init

ARG CONSUL_VER=0.8.1
ARG CT_VER=0.18.2

RUN apk add --no-cache curl unzip jq nmap openssl \
 && curl -fso /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip \
 && mkdir -p /opt/qnib/consul/bin/ \
 && cd /opt/qnib/consul/bin/ \
 && ln -s /opt/qnib/consul/bin/consul /usr/local/bin/ \
 && unzip /tmp/consul.zip \
 && rm -f /tmp/consul.zip \
 && mkdir -p /opt/consul-web-ui \
 && curl -Lso /tmp/consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_web_ui.zip \
 && cd /opt/consul-web-ui \
 && unzip /tmp/consul-web-ui.zip \
 && rm -f /tmp/consul-web-ui.zip \
 && apk --no-cache del unzip
COPY etc/consul.d/agent.json /etc/consul.d/
COPY opt/qnib/entry/*.sh /opt/qnib/entry/
COPY opt/qnib/consul/bin/start.sh /opt/qnib/consul/bin/
CMD ["/opt/qnib/consul/bin/start.sh"]
HEALTHCHECK --interval=2s --retries=15 --timeout=1s \
  CMD consul members
