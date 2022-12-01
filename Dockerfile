### PREPARE STAGE
FROM python:3 AS mkdocs
# Change to new created mkdocs user
RUN useradd -m -d /usr/src/mkdocs -u ${user:-1001} mkdocs
# Environment variables
ENV PATH="${PATH}:/usr/src/mkdocs/.local/bin"
USER mkdocs
# Set up Build directory
RUN mkdir -p /usr/src/mkdocs/build
WORKDIR /usr/src/mkdocs/build
# install PDM
RUN pip install --upgrade pip
RUN pip install setuptools
RUN pip install wheel
RUN pip install pdm
RUN pip install mkdocs
# Entry Point to mkdocs tool
ENTRYPOINT ["/usr/src/mkdocs/.local/bin/mkdocs"]

### BUILD STAGE
FROM mkdocs as appcc-builder
# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
# copy files
USER mkdocs
COPY docs docs
COPY mkdocs.yml mkdocs.yml
COPY pdm.lock pdm.lock
COPY pyproject.toml pyproject.toml
COPY README.md README.md
# install dependencies and project into the local packages directory
RUN mkdir -p __pypackages__
RUN pdm install --prod --no-lock --no-editable
RUN pdm run mkdocs build

### RUN STAGE
FROM nginx:latest
# retrieve packages from build stage and move into nginx server
COPY --from=appcc-builder /usr/src/mkdocs/build/site /usr/share/nginx/html
