FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Tell Cloud Run which port to listen on. Default to 8080 for local development.
ENV PORT 8080

# Run the application. Use sh -c to allow environment variable expansion.
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port $PORT"]