from django.urls import path
from university import views

urlpatterns = [
    path('students/', views.student_list),
    path('subjects/', views.subject_list),
]

