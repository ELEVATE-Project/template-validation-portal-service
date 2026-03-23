FROM python:3.10-slim

# Create non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

WORKDIR /app

# Install system deps (for bcrypt etc.)
RUN apt-get update && apt-get install -y gcc libffi-dev && rm -rf /var/lib/apt/lists/*

# Copy requirements first
COPY apiServices/src/main/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir --prefer-binary -r requirements.txt

# Copy app code
COPY apiServices/src/main/ .
COPY backend/ ./backend  

# Fix permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root
USER appuser

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]