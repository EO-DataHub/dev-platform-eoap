#!/bin/bash

set -x 

cd /workspace

git clone --no-checkout https://github.com/EO-DataHub/dev-platform-eoap.git eodh-uk
cd eodh-uk
git sparse-checkout init --cone
git sparse-checkout set getting-started 
git checkout

code-server --install-extension ms-python.python --install-extension redhat.vscode-yaml --install-extension sbg-rabix.benten-cwl --install-extension ms-toolsai.jupyter

mkdir -p /workspace/.cwlwrapper
cat <<EOF > /workspace/.cwlwrapper/default.conf
stagein="/etc/cwl-wrapper-conf/stagein.yaml"
stageout="/etc/cwl-wrapper-conf/stageout.yaml"
maincwl="/etc/cwl-wrapper-conf/main.yaml"
rulez="/etc/cwl-wrapper-conf/rules.yaml"
EOF

cat <<EOF > /workspace/pod-node-selector.yaml
eks.amazonaws.com/nodegroup: eodhp-nFi8LsXy-eu-west-2b-Services
EOF

ln -s /workspace/.local/share/code-server/extensions /workspace/extensions

mkdir -p /workspace/User/

echo '{"workbench.colorTheme": "Visual Studio Dark"}' > /workspace/User/settings.json
export UV_LINK_MODE=copy
python -m venv /workspace/.venv
source /workspace/.venv/bin/activate
/workspace/.venv/bin/pip install --upgrade uv
/workspace/.venv/bin/python -m uv pip install --no-cache-dir calrissian cwl-wrapper


export PATH=/workspace/.venv/bin:$PATH

echo "**** install kubectl ****" 
curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  
chmod +x kubectl                                                                                                    
mv ./kubectl /workspace/.venv/bin/kubectl
