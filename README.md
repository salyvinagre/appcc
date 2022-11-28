# README

Desde que gitbook ha pasado a ser código cerrado, este appcc ha tenido que migrar a soluciones FOSS. Se ha leegido para ello mkdocs y PDM como entorno para la puesta a punto de mkdocs y la generación de los escritos.

## Bootstrapping

Desde MacOS, usando brew:

```console
foo@bar:~$ brew install pdm
```

Para usar la verion actual de python:

```console
foo@bar:~$ curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 -
```

Una vez instalado PDM, regeneramos actualizamod los paquetes:

```console
foo@bar:~$ pdm update --no-sync
foo@bar:~$ pdm sync --clean
```

Y regeneramos el site:

```console
foo@bar:~$ pdm run mkdocs build
```

Para ver el contenido local en el puerto 8000:

```console
foo@bar:~$ pdm run mkdocs serve
```
