# Déploiement AWS avec OpenTofu (K3s)

Ce dossier `infra/` contient le code nécessaire pour créer un serveur AWS EC2 et y installer automatiquement K3s (Kubernetes léger).

## Prérequis

1.  **AWS CLI** installé et configuré (`aws configure` avec vos clés d'accès).
2.  **OpenTofu** (ou Terraform) installé.

## Lancer l'infrastructure (Localement)

Depuis votre terminal, dans le dossier du projet :

```bash
cd infra

# 1. Initialiser (télécharge le provider AWS)
tofu init

# 2. Voir ce qui va être créé
tofu plan

# 3. Lancer la création (Tapez 'yes' pour confirmer)
tofu apply
```

Une fois terminé, Tofu affichera l'IP publique de votre serveur.

## Se connecter au serveur

Une clé SSH `k3s-key.pem` a été générée dans le dossier `~/.ssh/`.

```bash
# Se connecter en SSH
ssh -i ~/.ssh/k3s-key.pem ubuntu@<IP_PUBLIQUE>

# Voir si le cluster fonctionne (depuis le serveur)
sudo k3s kubectl get nodes
```

## Intégration CI/CD (GitHub Actions)

Pour que GitHub Actions puisse déployer sur ce nouveau cluster :

1.  Récupérez le fichier de config Kubernetes du serveur :
    ```bash
    # Commande magique pour afficher le config (depuis votre PC local)
    ssh -i ~/.ssh/k3s-key.pem ubuntu@<IP_PUBLIQUE> "sudo cat /etc/rancher/k3s/k3s.yaml"
    ```
2.  Copiez le contenu affiché.
3.  Modifiez la ligne `server: https://127.0.0.1:6443` en remplaçant `127.0.0.1` par l'**IP PUBLIQUE** du serveur AWS.
4.  Allez sur GitHub > Settings > Secrets > Actions.
5.  Créez un secret `KUBECONFIG` et collez le contenu modifié.

Le pipeline est déjà configuré (étape `Apply manifests`) mais il faut modifier le fichier `main.yml` pour utiliser ce secret (voir étape suivante).

## Nettoyage (Important pour éviter les frais !)

Quand vous avez fini :

```bash
tofu destroy
```