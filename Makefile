ARTIFACTS = \
  _init.ok \
  _server.ok \
  _provision.ok \
  hosts.ini \
  known_hosts \
  provision.retry

SSH_OPTIONS = \
  -o UserKnownHostsFile=known_hosts \
  -o PasswordAuthentication=no \
  -o IdentitiesOnly=yes \
  -p $$(scripts/get ssh_port) \
  -l $$(scripts/get admin_user)

TF_INIT_OPTIONS = \
  -backend-config bucket=$$(scripts/get state_bucket)

TF_OPTIONS = \
  -var-file production/config.json


.PHONY: all clean destroy ssh

all: _provision.ok
	@:

clean:
	rm -f $(ARTIFACTS)

destroy:
	terraform destroy $(TF_OPTIONS)

ssh: _server.ok
	ssh $(SSH_OPTIONS) $$(terraform output ip)

_init.ok: *.tf
	terraform init $(TF_INIT_OPTIONS)
	@touch $@

_server.ok: _init.ok
	terraform apply $(TF_OPTIONS)
	@touch $@

_provision.ok: _server.ok hosts.ini provision.yml
	ansible-playbook -e @production/config.json provision.yml
	@touch $@

hosts.ini: _server.ok files/hosts.ini.in
	terraform output ansible_inventory > $@
