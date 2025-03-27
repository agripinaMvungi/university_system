from django.contrib import admin
from .models import Student,Subject, Program,AcademicYear,Semester,YearProgram

# Register your models here
admin.site.register(Student)
admin.site.register(Subject)
admin.site.register(Program)
admin.site.register(AcademicYear)
admin.site.register(Semester)
admin.site.register(YearProgram)
