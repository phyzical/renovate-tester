#https://github.com/goodwithtech/dockle/releases
# renovate: datasource=github-releases depName=goodwithtech/dockle
ARG DOCKLE_VERSION=0.4.12

# https://github.com/aquasecurity/trivy/releases
# renovate: datasource=github-releases depName=aquasecurity/trivy
ARG TRIVY_VERSION=0.45.0

RUN yum update -y \
    && yum install -y \
    # renovate: datasource=yum repo=rocky-9-appstream-x86_64
    jq-1.6-13.el9 \
    && yum -y clean all \
    && rm -rf /var/cache/yum

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager -y --add-repo "https://download.docker.com/linux/centos/docker-ce.repo" && \
    dnf install -y \
    # renovate: datasource=yum repo=docker-stable-centos-9-x86_64
    docker-ce-cli-24.0.5-1.el9 \
    && dnf clean all

RUN  yum -y update \
    && update-crypto-policies --set DEFAULT:SHA1 \
    && yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y \
    && yum install -y \
    # renovate: datasource=yum repo=rocky-9-appstream-x86_64/nodejs:16
    nodejs-16.20.1-2.el9