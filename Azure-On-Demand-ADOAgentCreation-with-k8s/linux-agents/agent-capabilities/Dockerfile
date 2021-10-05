FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
ARG JFROG_PASSWORD
ARG JFROG_USER
ENV JFROG_USER=$JFROG_USER
ENV AILAB_JFROG_PASSWORD=$JFROG_PASSWORD
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

## Microsoft suggested capabilities for Agent setup ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
    gnupg \
    gnupg2 \
    wget \
    apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

## Additional agent-capabilities required ##
COPY ./linux-agents/agent-capabilities/* .
COPY ./linux-agents/agent-capabilities/requirements.txt .
RUN mkdir -p ./files
COPY ./files* ./files
RUN chmod +x bootstrap.sh pom_setup.sh mc_velero.sh && ./bootstrap.sh && pip3 install -r requirements.txt && ./pom_setup.sh && ./mc_velero.sh
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.185.1

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz
RUN az extension add --name azure-devops
COPY ./linux-agents/agent-capabilities/start.sh .
RUN chmod +x start.sh
ENTRYPOINT [ "./start.sh" ]
