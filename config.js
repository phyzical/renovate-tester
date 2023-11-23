module.exports = {
    regexManagers: [
        {
            "description": "Update Kubernetes version for Amazon EKS",
            "fileMatch": [".+\\.tf$"],
            "matchStrings": [
                "\\s*#\\s*renovate:\\s*datasource=endoflife-date\\s*depName=(?<depName>.*?)( versioning=(?<versioning>.*?))?\\s.*?_version\\s*=\\s*\"(?<currentValue>.*)\""
            ],
            "datasourceTemplate": "endoflife-date",
            "versioningTemplate": "{{#if versioning}}{{{versioning}}}{{/if}}"
        },
        {
            "description": "Update dockerfile github releases",
            "fileMatch": [
                "Dockerfile"
            ],
            "datasourceTemplate": "github-releases",
            "matchStrings": [
                "\\s*#\\s*renovate:\\s*datasource=github-releases\\s*depName=(?<depName>.*?)\\s*ARG\\s.*?_VERSION\\s*=\\s*\"*(?<currentValue>.*)\"*"
            ]
        },
        {
            "fileMatch": ["Dockerfile"],
            "matchStrings": [
                "\\s*#\\s*renovate:\\s*datasource=yum\\s*repo=(?<registryUrl>[^\\s]+)\\s+(?<depName>[^\\s]+)-(?<currentValue>[^\\s-]+-[^\\s-]+)"
            ],
            "datasourceTemplate": "npm",
            "versioningTemplate": "loose",
            "registryUrlTemplate": "https://yum2npm.io/repos/{{replace '/' '/modules/' registryUrl}}/packages"
        }
    ],
    packageRules: [{
        "matchPackageNames": ["cost-analyzer"],
        "sourceUrl": "https://github.com/kubecost/cost-analyzer-helm-chart",
        "registryUrl": "https://kubecost.github.io/cost-analyzer",
    }, {
        "matchDatasources": ["endoflife-date"],
        "matchPackageNames": ["amazon-eks"],
        "extractVersion": "^(?<version>.*)-eks.+$"
    },
    {
        "matchDatasources": ["github-releases"],
        "extractVersion": "^v(?<version>.*)$"
    },
    {
        "matchFileNames": ["Dockerfile"],
        "matchDatasources": ["yum"],
        "groupName": "yumPackages"
    }
    ]
};
