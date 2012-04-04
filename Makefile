apply = puppet apply --noop --modulepath=tests/modules

smoke:
	$(apply) tests/smoke.pp
	$(apply) tests/client.pp

test: tests/*.pp
	find tests -name \*.pp | xargs -n 1 -t $(apply)

vm:
	vagrant up
