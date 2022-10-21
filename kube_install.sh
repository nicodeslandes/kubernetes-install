# Install CRI-O
sudo pacman -Sy cri-o crun
sudo sed -i -E 's/^#\s*default_runtime.+/default_runtime = "crun"/' /etc/crio/crio.conf
sudo cat << EOF > /etc/crio/crio.conf.d/01-crio-crun.conf
[crio.runtime.runtimes.crun]
runtime_path = "/usr/bin/crun"
runtime_type = "oci"
runtime_root = "/run/crun"
EOF

# Start and enable crio.service
sudo systemctl start crio
sudo systemctl enable crio

# Install kube binaries
sudo pacman -R iptables	# Remove iptables, which is incompatible with iptables-nft, a dependency of kubelet
sudo pacman -S kubelet kubeadm kubectl

sudo systemctl enable kubelet.service

