echo "export PATH=\$PATH:~/.local/bin" >> ~/.bash_profile
source ~/.bash_profile
VERSION=0.16.1 OS=linux && \
    curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_${OS}_amd64.tar.gz" --output sonobuoy.tar.gz && \
    tar -xzf sonobuoy.tar.gz -C ./ && \
    chmod +x sonobuoy && \
    mv sonobuoy ~/.local/bin/ &&
    rm sonobuoy.tar.gz LICENSE
