from django.db import models

class Program(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    
    def __str__(self):
        return self.name

class AcademicYear(models.Model):
    year = models.PositiveIntegerField(unique=True)
    programs = models.ManyToManyField(Program, through='YearProgram')
    
    def __str__(self):
        return f"Year {self.year}"

class Semester(models.Model):
    SEMESTER_CHOICES = [
        (1, 'Semester 1'),
        (2, 'Semester 2'),
    ]
    
    academic_year = models.ForeignKey(AcademicYear, on_delete=models.CASCADE)
    semester_number = models.IntegerField(choices=SEMESTER_CHOICES)
    
    class Meta:
        unique_together = ('academic_year', 'semester_number')
    
    def __str__(self):
        return f"{self.academic_year} - {self.get_semester_number_display()}"

class YearProgram(models.Model):
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    academic_year = models.ForeignKey(AcademicYear, on_delete=models.CASCADE)
    is_core = models.BooleanField(default=True)
    
    class Meta:
        unique_together = ('program', 'academic_year')
    
    def __str__(self):
        return f"{self.program} - {self.academic_year}"

class Student(models.Model):
    name = models.CharField(max_length=100)
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    current_year = models.ForeignKey(AcademicYear, on_delete=models.SET_NULL, null=True)
    enrollment_date = models.DateField()
    
    def __str__(self):
        return self.name

class Subject(models.Model):
    name = models.CharField(max_length=100)
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    year = models.ForeignKey(AcademicYear, on_delete=models.CASCADE)
    semester = models.ForeignKey(Semester, on_delete=models.CASCADE,default=1)
    code = models.CharField(max_length=20)
    credits = models.DecimalField(
        max_digits=5,  # Total number of digits
        decimal_places=2,  # Digits after decimal point
        default=0.00
    )
    is_core = models.BooleanField(default=True)
    
    def __str__(self):
        return f"{self.code} - {self.name} ({self.year}, {self.semester})"