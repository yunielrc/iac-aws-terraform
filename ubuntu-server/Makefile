.PHONY: check ssh

check:
	pre-commit run -a

ssh:
	ssh ubuntu@$$(echo "aws_instance.ubuntu_server[0].public_ip" | terraform console)
