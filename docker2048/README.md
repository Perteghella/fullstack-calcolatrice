## 2048 (kubespheredev/2048:latest) 🕹️

All'interno di questa cartella ho aggiunto un `docker-compose` per eseguire l'immagine `kubespheredev/2048:latest` (server web che ascolta sulla porta 80 del container).

- File: `docker-compose.yml`
- Porta esposta sull'host: `8080` (mappata su `80` del container)

Comandi utili:

- Avvia in background:

```bash
docker compose up -d
```

- Arresta e rimuovi i container:

```bash
docker compose down
```

- Script di comodo per avvio rapido:

```bash
./run-2048.sh
```

Dopo l'avvio visita: `http://localhost:8080`