
setup:
	ansible-playbook -i inventory.ini host/setup.yml

reboot:
	ansible-playbook -i inventory.ini host/reboot.yml

createvm:
	ansible-playbook -i inventory.ini guest/createvm.yml

destroyvm:
	ansible-playbook -i inventory.ini guest/destroyvm.yml

createmasters:
	ansible-playbook -i inventory.ini guest/createmaster.yml

destroymasters:
	ansible-playbook -i inventory.ini guest/destroymaster.yml

createworkers:
	ansible-playbook -i inventory.ini guest/createworker.yml

destroyworkers:
	ansible-playbook -i inventory.ini guest/destroyworker.yml
