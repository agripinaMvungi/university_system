from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Student, Subject, Program
from .serializers import StudentSerializer, SubjectSerializer

@api_view(['GET', 'POST'])
def student_list(request):
    if request.method == 'GET':
        students = Student.objects.all()[:10]  # Get first 10 students
        serializer = StudentSerializer(students, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = StudentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'POST'])
def subject_list(request):
    if request.method == 'GET':
        # Assuming 'Software Engineering' is the program name
        subjects = Subject.objects.filter(program__name='Software Engineering').order_by('year')
        serializer = SubjectSerializer(subjects, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        # Handle program association automatically
        data = request.data.copy()
        if 'program' not in data:
            # Default to Software Engineering program if not specified
            program = Program.objects.get(name='Software Engineering')
            data['program'] = program.id
            
        serializer = SubjectSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
