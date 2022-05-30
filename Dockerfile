#
# A container for emulating access to the
# eHealth Medical Records application.
# 
# Copytirght (c) 2022, The GUARD Consortium
#

from debian:bullseye

# Simulator main parameters
ENV WORKERS=10
ENV SOCKETS=500
ENV METHOD=get

# Default to MAGGIOLI testbed
ENV URL="https://guard-test-department-0.maggiolicloud.it/"

# Clone the goldeneye repository from github
RUN apt-get update && \
	apt-get -y install python3 jq && \
	cd /usr/src/ && \
	mkdir goldeneye && \
	cd goldeneye && \
	git clone https://github.com/jseidl/GoldenEye.git . 
	

WORKDIR /usr/src/goldeneye


CMD ./goldeneye.py $URL -w $WORKERS -s $SOCKETS -m $METHOD
