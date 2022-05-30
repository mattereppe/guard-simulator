#
# A container for emulating access to the
# eHealth Medical Records application.
# 
# Copytirght (c) 2022, The GUARD Consortium
#

from debian:bullseye

# Simulator main parameters
ENV REPEAT=1
ENV MAXDELAY=4

# Clone the goldeneye repository from github
RUN apt-get update && \
	apt-get -y install python3 jq && \
	cd /usr/local/bin/ 
	
COPY simulator.sh /usr/local/bin
	
WORKDIR /usr/local/bin

CMD /usr/local/bin/simulator.sh -u $REPEAT -d $MAXDELAY
