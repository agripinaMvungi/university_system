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

