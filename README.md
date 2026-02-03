# Calcolatrice con pipeline di operazioni

## UV

installa uv da https://docs.astral.sh/uv/#installation

```shell
uv venv
```

Attivare l'ambiente virtuale

```shell
source .venv/bin/activate  (Linux/Mac)
.venv\Scripts\activate    (Windows)    
```

## Installare dipendenze

```shell
uv pip compile requirements/requirements-test.in -o requirements/requirements-test.txt
uv pip compile requirements/requirements.in -o requirements/requirements.txt
uv pip install -r requirements/requirements-test.txt
uv pip install -r requirements/requirements.txt
```


## Utilizzo 

```shell
uv run python calcolatrice.py
python3 calcolatrice.py
```


## Esecuzione dei test

```shell
pytest -v
```

## Dockerfile

Per costruire l'immagine Docker locale

```shell
docker build -f Dockerfile.debian -t calcolatrice:debian .
docker build -f Dockerfile -t calcolatrice:alpine .
```

Per eseguire il container

```shell
docker run -it --rm calcolatrice:local
docker run -it --rm calcolatrice:alpine
```

Per costruire l'immagine Docker e caricarla su Docker Hub

```shell
docker build -f Dockerfile -t perteghella/fullstack-calcolatrice:alpine .
docker push perteghella/fullstack-calcolatrice:alpine
```

Per costruire una immagine multiarchitettura e caricarla su Docker Hub

```shell
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile -t perteghella/fullstack-calcolatrice:alpine --push .
```