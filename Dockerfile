# Use official Python 3.12 image as base
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy Django project
COPY . ./myproject/


EXPOSE 8000

WORKDIR /app/myproject

RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]