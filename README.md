# Software Engineering Project

A Django-based API for managing **students** and **subjects** using SQLite3.

## Features
- Student & Subject Management (CRUD)
- REST API with Django REST Framework
- SQLite3 Database

## Setup & Installation

1. **Clone the Repository**  
   ```bash
   git clone <repo-url>
   cd softwareengineeringproject
   ```

2. **Create a Virtual Environment**  
   ```bash
   python -m venv env
   source env/bin/activate  # Windows: env\Scripts\activate
   ```

3. **Install Dependencies**  
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure the Database** (SQLite3 is the default in Django, so no additional setup is required)
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.sqlite3',
           'NAME': BASE_DIR / 'db.sqlite3',
       }
   }
   ```

5. **Apply Migrations**  
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. **Run the Server**  
   ```bash
   python manage.py runserver
   ```
   - API: `http://3.85.238.66:8000/studentapi/students/`  
   - API: `http://3.85.238.66:8000/studentapi/subjects/`  

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|------------|
| GET    | `/studentapi/students/` | List all students |
| POST   | `/studentapi/students/` | Create a new student |
| GET    | `/studentapi/subjects/` | List all subjects |
| POST   | `/studentapi/subjects/` | Create a new subject |

## bash scripts
```bash
mkdir bash_scripts
```
For backups, write your scripts and save 
```bash
cd bash_scripts
nano backups_api.sh
sudo ./backups_api.sh
```
For updates, write your scripts and save 
```bash
cd bash_scripts
nano update_server.sh
sudo ./update_server.sh
```
For health checks, write your scripts and save 
```bash
cd bash_scripts
nano health_check.sh
sudo ./health_check.sh
```
create cron jobs 
# Health check every 6 hours
```bash
0 */6 * * * /home/ubuntu/university_system/bash_scripts/health_check.sh
```

# Daily backup at 2am

```bash
0 2 * * * /home/ubuntu/university_system/bash_scripts/backup_api.sh
```

# Server update every 3 days at 3am

```bash
0 3 */3 * * /home/ubuntu/university_system/bash_scripts/update_server.sh
```
Check that the cron jobs were added correctly:
```bash
sudo crontab -l -u ubuntu
```

## Building using Docker

# Step 1: Build the Docker image
```bash
sudo docker build -f Dockerfile -t your-dockerhub-username/your-repo-name:tag .
```

# Step 2: (Optional) Tag an existing image again if needed
```bash
sudo docker tag existing_image_id your-dockerhub-username/your-repo-name:new_tag
```

# Step 3: Login to Docker Hub
```bash
sudo docker login
```

# Step 4: Push the image to Docker Hub
```bash
sudo docker push your-dockerhub-username/your-repo-name:tag
```

# Step 5: (Optional) Delete unwanted local image/tag
```bash
sudo docker rmi image_id_or_name
```
# Step 6: (Optional) Save container logs to a file
```bash
sudo docker logs container_id_or_name > docker_logs.txt
```

## Deployment

To deploy the project on a production server:

1. **Collect Static Files**  
   ```bash
   python manage.py collectstatic
   ```

2. **Use Gunicorn for Deployment**  
   ```bash
   pip install gunicorn
   gunicorn --bind 0.0.0.0:8000 softwareengineeringproject.wsgi
   ```

3. **Set Up Reverse Proxy with Nginx**  
   Configure Nginx to forward requests to Gunicorn.

4. **Use a Process Manager (Optional)**  
   Use **supervisor** or **systemd** to keep Gunicorn running.

## License
MIT License. Feel free to use and modify. 🚀

