# README

Desde que gitbook ha pasado a ser código cerrado, este appcc ha tenido que
migrar a soluciones FOSS. Se ha leegido para ello mkdocs y PDM como entorno para
la puesta a punto de mkdocs y la generación de los escritos.

## Bootstrapping

Desde MacOS, usando brew:

```console
brew install pdm
```

o desde otro OS directamente con pip

```console
pip install pdm
```

Una vez instalado PDM, regeneramos actualizamod los paquetes:

```console
pdm update --no-sync
pdm sync --clean
```

Y regeneramos el site:

```console
pdm run mkdocs build
```

Para ver el contenido local en el puerto 8000:

```console
pdm run mkdocs serve
```

## Docker Usage

Para crear un sitio con el contenido del appcc simplemente..

```console
docker build -t appcc:latest --build-arg=USER=$id-u) .
```

Es posible crear una imagen docker desde la que invocar mkdocs:

```console
docker build --target mkdocs -t exmaple-mkdocs:v1 --build-arg=user=$(id -u) .
```

Para trabajar sobre el codigo de appcc

```console
cd /tmp/example/
docker run -it -p 8789:8000 \
-v /tmp/example:/build exmaple-mkdocs:v1 \
serve --dev-addr 0.0.0.0:8000 --config-file /build/mkdocs.yml
```

Para entrar en el contenedor y poder añadir plugins o actualizar dependencias:

```console
docker build --target mkdocs -t example-mkdocs:v1
docker run -it --entrypoint=/bin/bash example-mkdocs:v1
```
