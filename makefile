.PHONY verify:
verify:
	gcloud config configurations describe default
	cfssl version
	cfssljson --version
	test -n "$(ETCD_VERSION)"
	test -n "$(KUBERNETES_VERSION)"
	test -n "$(RUNC_VERSION)"
	test -n "$(CONTAINERD_VERSION)"
	test -n "$(CRICTL_VERSION)"
	test -n "$(CNI_PLUGINS_VERSION)"
	test -n "$(PREFIX)"
	echo "Training Environment successfully verified"

# TODO
# .PHONY teardown:
# teardown:
# 	./teardown.sh
	rm -rf secrets/*.pem
	rm -rf secrets/*.csr
	rm -rf secrets/*.kubeconfig
	rm -rf secrets/*.yaml