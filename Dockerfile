FROM alpine/helm:3.9.1

# Install kubectl on it's own for debugging during development
# RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
#   install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
#   rm -f kubectl

COPY entrypoint.sh /entrypoint.sh
COPY bump /bin/bump

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bump" ]