# 1. Use an official Python runtime as a parent image
FROM python:3.9-slim

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy the file that lists your app's dependencies
#    (You must create this file if it doesn't exist)
COPY requirements.txt .

# 4. Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy your application's code into the container
COPY . .

# 6. Expose a port so the container can be accessed
#    (Change 8000 if your app runs on a different port)
EXPOSE 8000

# 7. Define the command to run your application when the container starts
#    (This example uses gunicorn to run a web app defined in a file called 'app.py')
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]