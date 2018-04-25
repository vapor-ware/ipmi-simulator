FROM alpine
LABEL maintainer="vapor@vapor.io"

RUN apk --update --no-cache add openipmi-lanserv

COPY . /tmp/ipmisim

EXPOSE 623/udp

CMD ["ipmi_sim", "-n", "-c", "/tmp/ipmisim/lan.conf", "-f", "/tmp/ipmisim/sim.emu"]