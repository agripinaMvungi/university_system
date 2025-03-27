from rest_framework import serializers
from .models import Student, Subject, Program

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['id', 'name', 'program', 'enrollment_date']
        extra_kwargs = {
            'enrollment_date': {'required': False}  # Make optional with default
        }

class SubjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subject
        fields = ['id', 'name', 'program', 'year', 'code', 'credits']