PACMANCMD=sudo pacman --noconfirm

# Install CRI-O
$PACMANCMD -S cri-o crun
sudo sed -i -E 's/^#\s*default_runtime = .+/default_runtime = "crun"/' /etc/crio/crio.conf
cat << EOF > 01-crio-crun.conf
[crio.runtime.runtimes.crun]
runtime_path = "/usr/bin/crun"
runtime_type = "oci"
runtime_root = "/run/crun"
EOF

sudo mv 01-crio-crun.conf /etc/crio/crio.conf.d/
# Start and enable crio.service
sudo systemctl start crio
sudo systemctl enable crio

# Install kube binaries
$PACMANCMD -S kubelet kubeadm kubectl
sudo modprobe br_netfilter

sudo systemctl enable kubelet.service

