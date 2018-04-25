FROM alpine
LABEL maintainer="vapor@vapor.io"

RUN apk --update --no-cache add openipmi-lanserv

# Create the directories that will be used to persist state information
# for the IPMI simulator instance.
RUN mkdir -p /tmp/chassis

COPY . /tmp/ipmisim

EXPOSE 623/udp

CMD ["ipmi_sim", "-n", "-c", "/tmp/ipmisim/lan.conf", "-f", "/tmp/ipmisim/sim.emu"]