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
uv pip compile requirements.in -o requirements.txt
uv pip install -r requirements.txt
```


## Utilizzo 

```shell
uv run python calcolatrice.py
```


