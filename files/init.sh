#!/bin/bash

set -x 

mkdir -p /workspace/getting-started
cd /workspace/getting-started

curl -L https://github.com/EO-DataHub/dev-platform-eoap/archive/refs/heads/main.tar.gz \
| tar -xz \
    --strip-components=2 \
    dev-platform-eoap-main/getting-started

cp app-water-bodies-cloud-native.1.1.0.cwl /calrissian

cat << EOF > /calrissian/app-water-bodies-cloud-native-params.yaml
stac_items:
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2A_10TFK_20210708_0_L2A"
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2B_10TFK_20210713_0_L2A"
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2A_10TFK_20210718_0_L2A"
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2A_10TFK_20220524_0_L2A"
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2A_10TFK_20220514_0_L2A"
- "https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2A_10TFK_20220504_0_L2A"
aoi: -121.399,39.834,-120.74,40.472
epsg: "EPSG:4326"
EOF

cd /workspace

ln -s /calrissian 
code-server --install-extension ms-python.python --install-extension redhat.vscode-yaml --install-extension sbg-rabix.benten-cwl --install-extension ms-toolsai.jupyter

mkdir -p /workspace/.cwlwrapper
cat <<EOF > /workspace/.cwlwrapper/default.conf
stagein="/etc/cwl-wrapper-conf/stagein.yaml"
stageout="/etc/cwl-wrapper-conf/stageout.yaml"
maincwl="/etc/cwl-wrapper-conf/main.yaml"
rulez="/etc/cwl-wrapper-conf/rules.yaml"
EOF

cat <<EOF > /calrissian/pod-node-selector.yaml
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
