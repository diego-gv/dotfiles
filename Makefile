# ==============================================================================
# Dotfiles New Hope
#
# Test environments:
#
#   Docker          Fast tests / CI
#   Incus Container Linux environment with systemd
#   Incus VM        Full Ubuntu Desktop environment
#
# The Makefile is intentionally the main interface for developers.
# You should normally not need to know or use Incus directly.
#
# Quick start:
#
#   make check
#   make test
#   make test-vm
#   make vm-gui
#
# ==============================================================================

.DEFAULT_GOAL := help

SHELL := /bin/bash

# Fail early if a command used by a recipe fails.
.SHELLFLAGS := -eu -o pipefail -c


# ==============================================================================
# Configuration
# ==============================================================================

# ------------------------------------------------------------------------------
# Docker
# ------------------------------------------------------------------------------

IMAGE_NAME ?= dotfiles-new-hope
IMAGE_TAG ?= ubuntu-25.04

DOCKER_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
DOCKERFILE := .docker/ubuntu.Dockerfile


# ------------------------------------------------------------------------------
# Incus container
# ------------------------------------------------------------------------------

INCUS_CONTAINER ?= dotfiles-test
INCUS_IMAGE ?= images:ubuntu/24.04


# ------------------------------------------------------------------------------
# Incus VM
#
# The base image is intentionally a minimal Ubuntu image. The Makefile then
# provisions the VM as a normal Ubuntu Desktop installation.
# ------------------------------------------------------------------------------

INCUS_VM ?= dotfiles-vm
INCUS_VM_IMAGE ?= images:ubuntu/24.04

INCUS_VM_CPUS ?= 4
INCUS_VM_MEMORY ?= 8GiB
INCUS_VM_DISK ?= 40GiB

# Linux user used by the desktop session and by the dotfiles installation.
#
# This intentionally matches DOTFILES_PATH below.
INCUS_VM_USER ?= garvi

# Password used by the graphical login.
#
# This is a disposable test VM, not a production machine.
#
# Override it when desired:
#
#   make vm-gui INCUS_VM_PASSWORD='my-password'
#
INCUS_VM_PASSWORD ?= ubuntu

# Marker used to determine whether the VM has already been provisioned as
# Ubuntu Desktop.
INCUS_VM_DESKTOP_MARKER := /var/lib/dotfiles-vm-desktop


# ------------------------------------------------------------------------------
# Common paths
# ------------------------------------------------------------------------------

DOTFILES_PATH := /home/$(INCUS_VM_USER)
ARTIFACT := /tmp/dotfiles.tar.gz


# ==============================================================================
# Phony targets
# ==============================================================================

.PHONY: \
	help \
	check \
	test \
	test-docker \
	test-bootstrap \
	test-install \
	build \
	run \
	test-incus \
	test-bootstrap-incus \
	test-install-incus \
	run-incus \
	clean-incus \
	test-vm \
	vm-create \
	vm-start \
	vm-ready \
	vm-desktop \
	vm-stop \
	vm-shell \
	vm-gui \
	vm-install \
	vm-snapshot \
	vm-restore \
	run-vm \
	clean-vm \
	clean


# ==============================================================================
# Help
# ==============================================================================

help:
	@echo ""
	@echo "Dotfiles New Hope"
	@echo "================="
	@echo ""
	@echo "General"
	@echo "-------"
	@echo "  check                 Check required host dependencies"
	@echo "  test                  Run the main test suite"
	@echo ""
	@echo "Docker"
	@echo "------"
	@echo "  build                 Build Docker test image"
	@echo "  test-docker           Run Docker tests"
	@echo "  test-bootstrap        Test mounted repository installation"
	@echo "  test-install          Test archive-based installation"
	@echo "  run                   Open interactive Docker shell"
	@echo ""
	@echo "Incus Container"
	@echo "---------------"
	@echo "  test-incus            Run Incus container tests"
	@echo "  test-bootstrap-incus  Test mounted repository installation"
	@echo "  test-install-incus   Test archive-based installation"
	@echo "  run-incus             Open interactive shell"
	@echo "  clean-incus           Remove test container"
	@echo ""
	@echo "Incus VM"
	@echo "--------"
	@echo "  test-vm               Provision Ubuntu Desktop and install dotfiles"
	@echo "  vm-create             Create the VM if necessary"
	@echo "  vm-start              Start the VM"
	@echo "  vm-ready              Wait until the VM is accessible"
	@echo "  vm-desktop            Install/configure Ubuntu Desktop"
	@echo "  vm-stop               Stop the VM"
	@echo "  vm-install            Install dotfiles inside the VM"
	@echo "  vm-shell              Open shell inside the VM"
	@echo "  vm-gui                Open the graphical Ubuntu console"
	@echo "  vm-snapshot            Create a snapshot"
	@echo "  vm-restore             Restore the latest snapshot"
	@echo "  run-vm                Alias for vm-shell"
	@echo "  clean-vm              Remove the VM"
	@echo ""
	@echo "VM configuration"
	@echo "----------------"
	@echo "  User:                 $(INCUS_VM_USER)"
	@echo "  Password:             $(INCUS_VM_PASSWORD)"
	@echo "  CPUs:                 $(INCUS_VM_CPUS)"
	@echo "  Memory:               $(INCUS_VM_MEMORY)"
	@echo "  Disk:                 $(INCUS_VM_DISK)"
	@echo ""
	@echo "Cleanup"
	@echo "-------"
	@echo "  clean                 Remove all test environments"
	@echo ""


# ==============================================================================
# Host dependency checks
# ==============================================================================

check:
	@echo "Checking required commands..."

	@command -v docker >/dev/null 2>&1 || { \
		echo "ERROR: docker is not installed."; \
		exit 1; \
	}

	@command -v incus >/dev/null 2>&1 || { \
		echo "ERROR: incus is not installed."; \
		exit 1; \
	}

	@command -v tar >/dev/null 2>&1 || { \
		echo "ERROR: tar is not installed."; \
		exit 1; \
	}

	@echo "✓ docker"
	@echo "✓ incus"
	@echo "✓ tar"

	@if command -v remote-viewer >/dev/null 2>&1; then \
		echo "✓ remote-viewer"; \
	else \
		echo "WARNING: remote-viewer is not installed."; \
		echo "         Install it with: sudo apt install virt-viewer"; \
	fi

	@echo ""
	@echo "Checking Incus..."

	@incus info >/dev/null 2>&1 || { \
		echo "ERROR: Incus is not initialized or is unavailable."; \
		echo "       Run: incus admin init"; \
		exit 1; \
	}

	@echo "✓ Incus is available"
	@echo ""


# ==============================================================================
# Main test target
# ==============================================================================

# Docker catches fast/basic problems.
# Incus catches problems that require a more complete Linux environment.
# The VM is kept separate because it is considerably slower.

test: test-docker test-incus


# ==============================================================================
# Docker
# ==============================================================================

build:
	@docker build \
		-t $(DOCKER_IMAGE) \
		-f $(DOCKERFILE) \
		.


# Only build the image when it doesn't already exist.
_docker-build:
	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || \
		$(MAKE) build


# ------------------------------------------------------------------------------
# Docker test suite
# ------------------------------------------------------------------------------

test-docker: test-bootstrap test-install


# ------------------------------------------------------------------------------
# Development scenario
# ------------------------------------------------------------------------------

test-bootstrap: _docker-build
	@docker run --rm --pull=never \
		-e TERM=xterm-256color \
		-v "$(CURDIR):$(DOTFILES_PATH)" \
		-w $(DOTFILES_PATH) \
		$(DOCKER_IMAGE) \
		bash -lc "\
			set -euo pipefail; \
			shellcheck bootstrap.sh scripts/*.sh core/*.sh; \
			bash ./bootstrap.sh"


# ------------------------------------------------------------------------------
# End-user installation scenario
# ------------------------------------------------------------------------------

test-install: _docker-build
	@docker run --rm --pull=never \
		-e TERM=xterm-256color \
		-v "$(CURDIR):/workspace" \
		-w /tmp \
		$(DOCKER_IMAGE) \
		bash -lc "\
			set -euo pipefail; \
			rm -rf \"\$$HOME/.dotfiles\"; \
			cp /workspace/bootstrap.sh /tmp/bootstrap.sh; \
			tar -czf $(ARTIFACT) -C /workspace .; \
			DOTFILES_ARCHIVE_URL=file://$(ARTIFACT) \
			bash /tmp/bootstrap.sh"


# ------------------------------------------------------------------------------
# Interactive Docker shell
# ------------------------------------------------------------------------------

run: _docker-build
	@docker run \
		--hostname $(DOCKER_IMAGE) \
		--rm -it \
		--pull=never \
		-v "$(CURDIR):/workspace" \
		-w /workspace \
		$(DOCKER_IMAGE)


# ==============================================================================
# Incus Container
# ==============================================================================

# Create the container only when it doesn't already exist.
_incus-create:
	@incus info $(INCUS_CONTAINER) >/dev/null 2>&1 || \
		incus launch $(INCUS_IMAGE) $(INCUS_CONTAINER)


# Mount the repository into the container.
_incus-mount: _incus-create
	@incus config device remove \
		$(INCUS_CONTAINER) \
		dotfiles >/dev/null 2>&1 || true

	@incus config device add \
		$(INCUS_CONTAINER) \
		dotfiles \
		disk \
		source="$(CURDIR)" \
		path="$(DOTFILES_PATH)"


# ------------------------------------------------------------------------------
# Incus test suite
# ------------------------------------------------------------------------------

test-incus: test-bootstrap-incus test-install-incus


# ------------------------------------------------------------------------------
# Development scenario
# ------------------------------------------------------------------------------

test-bootstrap-incus: _incus-mount
	@incus exec $(INCUS_CONTAINER) -- \
		bash -lc "\
			set -euo pipefail; \
			cd $(DOTFILES_PATH); \
			bash ./bootstrap.sh"


# ------------------------------------------------------------------------------
# End-user installation scenario
# ------------------------------------------------------------------------------

test-install-incus: _incus-create
	@tar -czf $(ARTIFACT) .

	@incus file push \
		$(ARTIFACT) \
		$(INCUS_CONTAINER)/tmp/dotfiles.tar.gz

	@incus file push \
		bootstrap.sh \
		$(INCUS_CONTAINER)/tmp/bootstrap.sh

	@incus exec $(INCUS_CONTAINER) -- \
		bash -lc "\
			set -euo pipefail; \
			rm -rf \"\$$HOME/.dotfiles\"; \
			DOTFILES_ARCHIVE_URL=file:///tmp/dotfiles.tar.gz \
			bash /tmp/bootstrap.sh"


# ------------------------------------------------------------------------------
# Interactive Incus container shell
# ------------------------------------------------------------------------------

run-incus: _incus-mount
	@incus exec $(INCUS_CONTAINER) -- bash


# ------------------------------------------------------------------------------
# Destroy container
# ------------------------------------------------------------------------------

clean-incus:
	-@incus stop $(INCUS_CONTAINER) --force
	-@incus delete $(INCUS_CONTAINER)


# ==============================================================================
# Incus VM
# ==============================================================================

# ------------------------------------------------------------------------------
# Create VM
# ------------------------------------------------------------------------------

_vm-create:
	@incus info $(INCUS_VM) >/dev/null 2>&1 || \
		incus launch \
			$(INCUS_VM_IMAGE) \
			$(INCUS_VM) \
			--vm \
			-c limits.cpu=$(INCUS_VM_CPUS) \
			-c limits.memory=$(INCUS_VM_MEMORY) \
			-d root,size=$(INCUS_VM_DISK)


vm-create: _vm-create
	@echo "VM '$(INCUS_VM)' exists."


# ------------------------------------------------------------------------------
# Start VM
# ------------------------------------------------------------------------------

vm-start: _vm-create
	@if incus info $(INCUS_VM) | grep -q "Status: RUNNING"; then \
		echo "VM '$(INCUS_VM)' is already running."; \
	else \
		incus start $(INCUS_VM); \
		echo "VM '$(INCUS_VM)' started."; \
	fi


# ------------------------------------------------------------------------------
# Wait until VM is accessible
#
# `incus exec` only succeeds once the Incus guest agent is available.
# ------------------------------------------------------------------------------

vm-ready: vm-start
	@echo "Waiting for VM to become ready..."

	@for i in {1..120}; do \
		if incus exec $(INCUS_VM) -- true >/dev/null 2>&1; then \
			echo "VM is ready."; \
			exit 0; \
		fi; \
		sleep 1; \
	done; \
	echo "ERROR: VM did not become ready after 120 seconds."; \
	exit 1


# ------------------------------------------------------------------------------
# Provision Ubuntu Desktop
#
# The base Incus Ubuntu image is not Ubuntu Desktop. This target turns it into
# a normal Ubuntu Desktop installation with:
#
#   - ubuntu-desktop
#   - GNOME
#   - GDM
#   - graphical.target
#   - a normal desktop user
#   - sudo access
#
# A marker makes the operation idempotent.
# ------------------------------------------------------------------------------

vm-desktop: vm-ready
	@echo "Checking Ubuntu Desktop installation..."

	@if incus exec $(INCUS_VM) -- test -f $(INCUS_VM_DESKTOP_MARKER); then \
		echo "Ubuntu Desktop is already provisioned."; \
		exit 0; \
	fi

	@echo "Provisioning Ubuntu Desktop..."
	@echo "This can take several minutes on the first run."

	@incus exec $(INCUS_VM) -- \
		bash -lc "\
			set -euo pipefail; \
			export DEBIAN_FRONTEND=noninteractive; \
			apt-get update; \
			apt-get install -y ubuntu-desktop gdm3; \
			systemctl set-default graphical.target; \
			systemctl enable gdm3; \
			systemctl unmask gdm3; \
			if ! id -u $(INCUS_VM_USER) >/dev/null 2>&1; then \
				useradd \
					--create-home \
					--shell /bin/bash \
					--groups sudo \
					$(INCUS_VM_USER); \
			else \
				usermod -aG sudo $(INCUS_VM_USER); \
			fi; \
			echo '$(INCUS_VM_USER):$(INCUS_VM_PASSWORD)' | chpasswd; \
			printf '%s\\n' \
				'$(INCUS_VM_USER) ALL=(ALL) NOPASSWD:ALL' \
				> /etc/sudoers.d/$(INCUS_VM_USER); \
			chmod 0440 /etc/sudoers.d/$(INCUS_VM_USER); \
			mkdir -p /etc/gdm3; \
			grep -q '^AutomaticLoginEnable=' /etc/gdm3/custom.conf 2>/dev/null || \
				true; \
			touch $(INCUS_VM_DESKTOP_MARKER); \
			systemctl start gdm3 || true"

	@echo "Ubuntu Desktop provisioned."


# ------------------------------------------------------------------------------
# Install dotfiles inside VM
#
# The repository is transferred as an archive rather than mounted.
#
# The bootstrap script runs as the normal desktop user, not root.
# ------------------------------------------------------------------------------

vm-install: vm-desktop
	@echo "Installing dotfiles for user '$(INCUS_VM_USER)'..."

	@tar -czf $(ARTIFACT) .

	@incus file push \
		$(ARTIFACT) \
		$(INCUS_VM)/tmp/dotfiles.tar.gz

	@incus file push \
		bootstrap.sh \
		$(INCUS_VM)/tmp/bootstrap.sh

	@incus exec $(INCUS_VM) -- \
		bash -lc "\
			set -euo pipefail; \
			chown $(INCUS_VM_USER):$(INCUS_VM_USER) \
				/tmp/dotfiles.tar.gz \
				/tmp/bootstrap.sh; \
			rm -rf $(DOTFILES_PATH); \
			mkdir -p $(DOTFILES_PATH); \
			chown $(INCUS_VM_USER):$(INCUS_VM_USER) $(DOTFILES_PATH); \
			su - $(INCUS_VM_USER) -c '\
				rm -rf \"\$$HOME/.dotfiles\"; \
				DOTFILES_ARCHIVE_URL=file:///tmp/dotfiles.tar.gz \
				bash /tmp/bootstrap.sh'"

	@echo "Dotfiles installed."


# ------------------------------------------------------------------------------
# Full VM test
#
# This is deliberately separate from `make test`: a full Ubuntu Desktop VM
# is considerably slower than Docker/containers.
# ------------------------------------------------------------------------------

test-vm: vm-install
	@echo ""
	@echo "VM installation test completed."
	@echo ""
	@echo "Ubuntu Desktop user: $(INCUS_VM_USER)"
	@echo "Run 'make vm-gui' to open the graphical console."
	@echo ""


# ------------------------------------------------------------------------------
# Interactive VM shell
# ------------------------------------------------------------------------------

vm-shell: vm-ready
	@incus exec $(INCUS_VM) -- \
		su - $(INCUS_VM_USER)


# Keep the old name as a convenient alias.
run-vm: vm-shell


# ------------------------------------------------------------------------------
# Graphical VM console
#
# Incus exposes the VM's VGA console through SPICE.
# The guest itself provides the actual Ubuntu/GNOME desktop.
# ------------------------------------------------------------------------------

vm-gui: vm-desktop
	@command -v remote-viewer >/dev/null 2>&1 || { \
		echo "ERROR: remote-viewer is not installed."; \
		echo ""; \
		echo "Install it with:"; \
		echo "  sudo apt install virt-viewer"; \
		exit 1; \
	}

	@echo "Opening Ubuntu Desktop..."
	@incus console $(INCUS_VM) --type=vga


# ------------------------------------------------------------------------------
# Stop VM
# ------------------------------------------------------------------------------

vm-stop:
	@incus stop $(INCUS_VM) --force


# ------------------------------------------------------------------------------
# VM snapshots
# ------------------------------------------------------------------------------

VM_SNAPSHOT ?= before-dotfiles

vm-snapshot: _vm-create
	@incus snapshot create $(INCUS_VM) $(VM_SNAPSHOT)
	@echo "Snapshot '$(VM_SNAPSHOT)' created."


# Restore the configured snapshot.
vm-restore: _vm-create
	@incus restore $(INCUS_VM) $(VM_SNAPSHOT)
	@echo "Snapshot '$(VM_SNAPSHOT)' restored."


# ------------------------------------------------------------------------------
# Destroy VM
# ------------------------------------------------------------------------------

clean-vm:
	-@incus stop $(INCUS_VM) --force
	-@incus delete $(INCUS_VM)


# ==============================================================================
# Cleanup
# ==============================================================================

clean: clean-incus clean-vm
