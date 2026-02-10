# ============================================================================
# webMethods DevOps Portfolio - Makefile
# ============================================================================

.PHONY: help docs docs-serve docs-build pdf docker-build docker-up docker-down \
        vagrant-up vagrant-down vagrant-ssh terraform-init terraform-apply \
        terraform-destroy clean

# Default target
help:
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║         webMethods DevOps Portfolio - Commandes disponibles       ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "  Documentation:"
	@echo "    make docs-serve     - Lancer le serveur MkDocs local (http://localhost:8000)"
	@echo "    make docs-build     - Construire le site statique dans ./site"
	@echo "    make pdf            - Générer le PDF du portfolio"
	@echo ""
	@echo "  Docker:"
	@echo "    make docker-build   - Construire les images Docker"
	@echo "    make docker-up      - Démarrer les containers"
	@echo "    make docker-down    - Arrêter les containers"
	@echo "    make docker-logs    - Voir les logs des containers"
	@echo "    make docker-status  - Status des services Supervisor"
	@echo ""
	@echo "  Vagrant:"
	@echo "    make vagrant-up     - Démarrer la VM Vagrant"
	@echo "    make vagrant-down   - Arrêter la VM Vagrant"
	@echo "    make vagrant-ssh    - SSH dans la VM"
	@echo "    make vagrant-destroy- Supprimer la VM"
	@echo ""
	@echo "  Terraform (AWS):"
	@echo "    make tf-init        - Initialiser Terraform"
	@echo "    make tf-plan        - Planifier les changements"
	@echo "    make tf-apply       - Appliquer l'infrastructure"
	@echo "    make tf-destroy     - Détruire l'infrastructure"
	@echo ""
	@echo "  Autre:"
	@echo "    make clean          - Nettoyer les fichiers générés"
	@echo "    make install-deps   - Installer les dépendances (docs)"
	@echo ""

# ============================================================================
# Documentation
# ============================================================================

install-deps:
	pip install -r requirements-docs.txt

docs-serve: install-deps
	mkdocs serve

docs-build: install-deps
	mkdocs build --strict

pdf:
	@echo "Génération du PDF..."
	@if command -v pandoc >/dev/null 2>&1; then \
		if command -v pdflatex >/dev/null 2>&1; then \
			pandoc PORTFOLIO-WEBMETHODS.md -o PORTFOLIO-WEBMETHODS.pdf --pdf-engine=pdflatex; \
		elif command -v wkhtmltopdf >/dev/null 2>&1; then \
			pandoc PORTFOLIO-WEBMETHODS.md -o PORTFOLIO-WEBMETHODS.pdf --pdf-engine=wkhtmltopdf; \
		else \
			pandoc PORTFOLIO-WEBMETHODS.md -t html -o PORTFOLIO-WEBMETHODS.html; \
			echo "PDF engine non trouvé. HTML généré à la place."; \
		fi; \
		echo "✅ Fichier généré: PORTFOLIO-WEBMETHODS.pdf"; \
	else \
		echo "❌ pandoc n'est pas installé. Installez-le avec: brew install pandoc"; \
		exit 1; \
	fi

# ============================================================================
# Docker
# ============================================================================

docker-build:
	docker compose build sagwm-cc

docker-up:
	docker compose up -d sagwm-cc sagwm-sql-server

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f sagwm-cc

docker-status:
	docker compose exec sagwm-cc supervisorctl status

docker-shell:
	docker compose exec sagwm-cc bash

docker-clean:
	docker compose down --rmi local -v

# ============================================================================
# Vagrant
# ============================================================================

vagrant-up:
	vagrant up

vagrant-down:
	vagrant halt

vagrant-ssh:
	vagrant ssh

vagrant-provision:
	vagrant provision

vagrant-destroy:
	vagrant destroy -f

vagrant-status:
	vagrant status

# ============================================================================
# Terraform
# ============================================================================

tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply

tf-destroy:
	cd terraform && terraform destroy

tf-output:
	cd terraform && terraform output

# ============================================================================
# Nettoyage
# ============================================================================

clean:
	rm -rf site/
	rm -f PORTFOLIO-WEBMETHODS.pdf
	rm -f PORTFOLIO-WEBMETHODS.html
	@echo "✅ Fichiers générés supprimés"

# ============================================================================
# Raccourcis
# ============================================================================

# Alias courts
serve: docs-serve
build: docs-build
up: docker-up
down: docker-down
logs: docker-logs
