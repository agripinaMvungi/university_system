from django.core.management.base import BaseCommand
from university.models import Program, Student, Subject
import random
from datetime import date, timedelta

class Command(BaseCommand):
    help = 'Load sample data into the database'

    def handle(self, *args, **options):
        # Create programs
        programs = [
            'Software Engineering',
            'Computer Science',
            'Information Technology',
            'Data Science'
        ]
        
        for program in programs:
            p, created = Program.objects.get_or_create(name=program)
            if created:
                self.stdout.write(self.style.SUCCESS(f'Created program: {p.name}'))
        
        # Software Engineering subjects by year
        se_program = Program.objects.get(name='Software Engineering')
        subjects_data = {
            1: [
                {'name': 'Introduction to Programming', 'code': 'SE101', 'credits': 6},
                {'name': 'Discrete Mathematics', 'code': 'SE102', 'credits': 5},
                # ... rest of your subjects data ...
            ],
            # ... other years ...
        }
        
        for year, subjects in subjects_data.items():
            for subject in subjects:
                s, created = Subject.objects.get_or_create(
                    program=se_program,
                    year=year,
                    defaults=subject
                )
                if created:
                    self.stdout.write(self.style.SUCCESS(f'Created subject: {s.name} (Year {year})'))
        
        # Create students
        first_names = ['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Jennifer', 'William', 'Lisa']
        last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Wilson']
        
        for i in range(10):
            name = f"{first_names[i]} {last_names[i]}"
            program = random.choice(Program.objects.all())
            enrollment_date = date(2020, 1, 1) + timedelta(days=random.randint(0, 365*3))
            
            student, created = Student.objects.get_or_create(
                name=name,
                defaults={
                    'program': program,
                    'enrollment_date': enrollment_date
                }
            )
            if created:
                self.stdout.write(self.style.SUCCESS(f'Created student: {student.name}'))