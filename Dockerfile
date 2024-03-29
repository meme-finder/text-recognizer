FROM python:3.10 as python-deps

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Install pipenv and compilation dependencies
RUN pip install pipenv

# Install python dependencies in /.venv
COPY Pipfile .
COPY Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy


FROM python:3.10-slim

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Install Tesseract OCR
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    tesseract-ocr tesseract-ocr-rus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy virtual env from python-deps stage
COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Create and switch to a new user
RUN useradd --create-home recognizer
WORKDIR /home/recognizer
USER recognizer

# Install application into container
COPY . .

# Run the application
CMD ["uvicorn", "recognizer.main:app", "--proxy-headers", "--host", "::", "--port", "8080"]
