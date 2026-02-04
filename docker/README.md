# Docker Compose per Calcolatrice

Questo folder contiene un file `docker-compose.yml` per avviare l'immagine `calcolatrice:alpine` con TTY e input interattivo.

Esempi di utilizzo:

- Costruire l'immagine (se non è già presente):

```bash
docker build -f Dockerfile -t calcolatrice:alpine .
```

- Avviare e rimanere attaccati — mostra i log ma **non sempre** permette l'input interattivo:

```bash
docker compose run calcolatrice
```

- Eseguire interattivamente un singolo container (equivalente a `docker run --rm -it`):

```bash
docker compose run --rm calcolatrice
```

> Nota: `docker compose up` terrà il processo in foreground; per rilasciare il terminale usare `Ctrl+C` o avviare in background con `-d` se necessario.

Per comodità è incluso uno script `run-interactive.sh` che esegue il comando interattivo:

```bash
./run-interactive.sh
```