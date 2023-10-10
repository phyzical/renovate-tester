#https://github.com/goodwithtech/dockle/releases
# renovate: datasource=github-releases depName=goodwithtech/dockle
ARG DOCKLE_VERSION=0.4.12

# https://github.com/aquasecurity/trivy/releases
# renovate: datasource=github-releases depName=aquasecurity/trivy
ARG TRIVY_VERSION=0.45.0

RUN yum update -y \
    && yum install -y \
    # renovate: datasource=yum repo=rocky-9-appstream
    jq \
    && yum -y clean all \
    && rm -rf /var/cache/yum