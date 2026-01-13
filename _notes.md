
curl -L https://github.com/eoap/mastering-app-package/releases/download/1.1.0/app-water-body.1.1.0.cwl > w.cwl

cwl-wrapper -c ~/.cwlwrapper/default.conf --workflow-id water-bodies w.cwl > wrapped.cwl