# Droplet Docker DigitalOcean

Ce dépôt provisionne un droplet DigitalOcean destiné à héberger un environnement
Docker de test, ainsi que son nom DNS.

## Ce que le projet crée

Terraform crée les ressources suivantes :

- un tag DigitalOcean, défini par `tag_name` ;
- un droplet nommé `<prefix>-docker` ;
- un enregistrement DNS de type `A` nommé `docker` dans `domain_name`, donc
  `docker.<domain_name>` ;
- une initialisation `cloud-init` exécutée au premier démarrage du droplet.

L’adresse IPv4 du droplet est utilisée comme cible de l’enregistrement DNS. Le
TTL DNS est fixé à 60 secondes.

## Pré-requis

- un compte DigitalOcean avec un token API disposant des droits nécessaires ;
- un domaine géré dans DigitalOcean DNS, ou au minimum une zone correspondant à
  `domain_name` ;
- une clé SSH déjà enregistrée dans DigitalOcean et son identifiant ;
- Terraform installé localement ;
- l’accès réseau permettant de joindre DigitalOcean et les dépôts téléchargés
  par `cloud-init`.

Le provider DigitalOcean est `digitalocean/digitalocean`, en version `>= 2.8.0`.

## Configuration

Les valeurs d’exemple se trouvent dans
[`common.auto.tfvars`](common.auto.tfvars) :

| Variable | Rôle |
| --- | --- |
| `prefix` | Préfixe du nom du droplet. |
| `region_name` | Région DigitalOcean, par exemple `ams3`. |
| `droplet_size` | Taille du droplet. |
| `droplet_image` | Image DigitalOcean, par exemple `docker-20-04`. |
| `tag_name` | Tag appliqué au droplet. |
| `domain_name` | Zone DNS dans laquelle créer `docker.<domaine>`. |
| `ssh_keys` | Liste des identifiants de clés SSH DigitalOcean. |
| `do_token` | Token API DigitalOcean. À fournir comme secret. |

Ne commitez pas le token API. La méthode recommandée est de l’injecter via une
variable d’environnement :

```bash
export TF_VAR_do_token='votre-token-digitalocean'
```

Adaptez ensuite les valeurs de `common.auto.tfvars`, en particulier
`domain_name`, `ssh_keys`, `droplet_size` et `droplet_image`.

## Déploiement

Depuis la racine du dépôt :

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Après l’application, le service DNS attendu est :

```text
http://docker.<domain_name>
```

La propagation DNS peut prendre quelques instants malgré le TTL court. Les
commandes `terraform plan` et `terraform apply` doivent être lancées avec le
token disponible dans l’environnement.

Pour supprimer les ressources créées par ce projet :

```bash
terraform destroy
```

Cette commande supprime le droplet, le tag et l’enregistrement DNS gérés par
Terraform.

## Initialisation du droplet

[`cloud-init.yaml`](cloud-init.yaml) est transmis au droplet au premier
démarrage. Il effectue notamment les opérations suivantes :

- mise à niveau des paquets APT ;
- création et activation d’un fichier swap de 4 Go ;
- lancement du conteneur `sagikazarmark/dvwa` sur le port HTTP 80 ;
- désactivation d’UFW ;
- installation de Docker Compose, Mosh, Atop, Net-tools et `yq` ;
- clonage de [`srnfr/vpp-lab`](https://github.com/srnfr/vpp-lab) dans
  `/home/vpplab` ;
- installation de Dive, Grype, du plugin Docker SBOM et de `xpid` ;
- remplacement de la configuration DNS locale par `1.1.1.1` avec
  `ndots:5`.

Le script d’installation de `xpid` installe Go 1.18.3, les dépendances de
compilation, puis compile `xpid` depuis
[`kris-nova/xpid`](https://github.com/kris-nova/xpid).

## Fichiers du dépôt

| Fichier | Description |
| --- | --- |
| `main.tf` | Variables, tag, droplet et enregistrement DNS. |
| `versions.tf` | Provider et variable du token DigitalOcean. |
| `common.auto.tfvars` | Paramètres d’exemple chargés automatiquement par Terraform. |
| `cloud-init.yaml` | Configuration exécutée au premier démarrage. |
| `install-xpid.sh` | Installation et compilation de `xpid`. |
| `faucet.yaml` | Exemple de configuration Faucet/Open vSwitch pour un lab réseau ; il n’est pas consommé directement par Terraform. |
| `.gitignore` | Fichiers d’état et de plan Terraform ignorés par Git. |

## Points d’attention

- DVWA est une application volontairement vulnérable : ce déploiement doit être
  réservé à un environnement de laboratoire isolé et ne doit pas être exposé
  publiquement sans contrôle d’accès et filtrage réseau adaptés.
- `cloud-init.yaml` désactive UFW et ouvre le port 80 via Docker. Vérifiez la
  configuration réseau DigitalOcean avant tout déploiement sur Internet.
- Les installations effectuées par `cloud-init` dépendent de ressources
  téléchargées depuis GitHub, Docker Hub, Go et Anchore ; une modification
  amont peut changer le résultat du provisionnement.
- Le fichier d’état Terraform contient des informations d’infrastructure : il
  doit rester privé et être sauvegardé de façon sécurisée.
- Le fichier `cloud-init` n’est exécuté automatiquement qu’au premier démarrage
  d’un droplet neuf. Consultez les journaux cloud-init sur la machine en cas de
  problème : `cloud-init status --long` et `/var/log/cloud-init-output.log`.
