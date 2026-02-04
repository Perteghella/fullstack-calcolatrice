# Docker Compose per Calcolatrice

Questo folder contiene un file `docker-compose.yml` per avviare l'immagine `calcolatrice:alpine` con TTY e input interattivo.

Esempi di utilizzo:

- Costruire l'immagine (se non è già presente):

```bash
docker build -f Dockerfile -t calcolatrice:alpine .
```

- Avviare e rimanere attaccati (equivalente a `docker run -it calcolatrice:alpine`):

```bash
docker compose up
```

- Eseguire un singolo container e rimuoverlo al termine (equivalente a `docker run --rm -it`):

```bash
docker compose run --rm calcolatrice
```

> Nota: `docker compose up` terrà il processo in foreground; per rilasciare il terminale usare `Ctrl+C` o avviare in background con `-d` se necessario.
