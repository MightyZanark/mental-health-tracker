FROM python:3.10-slim-buster

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=game_inventory.settings \
    PORT=8000 \
    WEB_CONCURRENCY=2

# Install system packages required by Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get install -y socat

RUN addgroup --system django \
    && adduser --system --ingroup django django

# RUN cat /etc/resolv.conf

COPY ./test.py .
#RUN python test.py
CMD ["socat", "TCP-LISTEN:8000,fork", "EXEC:'test.py'"]

# Requirements are installed here to ensure they will be cached.
#COPY ./requirements.txt /requirements.txt
#RUN pip install -r /requirements.txt

# Copy project code
#COPY . .

#RUN python manage.py collectstatic --noinput --clear

# Run as non-root user
#RUN chown -R django:django /app
#USER django

# Run application
#CMD gunicorn game_inventory.wsgi:application
