from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from . forms import UserRegisterForm
from django.http import HttpResponse
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .models import Item
import json
from django.http import FileResponse, JsonResponse
import mimetypes
from pathlib import Path
import random
import json

# Create your views here.

def home(request):
	return render(request, "study/home.html")

def study(request):
	return render(request, "study/timer.html")

def planner(request):
	return render(request, "study/Calendar.html")

def game(request):
	jsonData()
	return render(request, "study/studygame.html")

def aboutus(request):
	return render(request, "study/aboutus.html")

def profile(request):
	return render(request, "study/profile.html")

def addsection(request):
	return render(request, "study/addsection.html")

def algQuizz(request):
	return render(request, "study/algQuizz.html")

def calcQuizz(request):
	return render(request, "study/calcQuizz.html")

def trigQuizz(request):
	return render(request, "study/trigQuizz.html")

def openRewards(request):
	randomNumber1 = random.randint(1,10)
	randomNumber2 = random.randint(1,10)
	randomNumber3 = random.randint(1,10)

	randomNumbers = []
	randomNumbers.append(randomNumber1)
	randomNumbers.append(randomNumber2)
	randomNumbers.append(randomNumber3)

	item1 = "{}.png".format(randomNumber1)
	item2 = "{}.png".format(randomNumber2)
	item3 = "{}.png".format(randomNumber3)

	for i in range(0,3):
		if randomNumbers[i] == 1:
			Item.objects.create_item("alkhwarizmiDagger",1,request.user)
		if randomNumbers[i] == 2:
			Item.objects.create_item("apple",1,request.user)
		if randomNumbers[i] == 3:
			Item.objects.create_item("archimedesScythe",1,request.user)
		if randomNumbers[i] == 4:
			Item.objects.create_item("sircumferenceBow",1,request.user)
		if randomNumbers[i] == 5:
			Item.objects.create_item("mushroom",1,request.user)
		if randomNumbers[i] == 6:
			Item.objects.create_item("newtonHammer",1,request.user)
		if randomNumbers[i] == 7:
			Item.objects.create_item("pythagorasSpear",1,request.user)
		if randomNumbers[i] == 8:
			Item.objects.create_item("riemannAxe",1,request.user)
		if randomNumbers[i] == 9:
			Item.objects.create_item("strawberry",1,request.user)
		if randomNumbers[i] == 10:
			Item.objects.create_item("eulerSword",1,request.user)
		


	context = {'item1': item1,"item2":item2,"item3":item3}
	return render(request, "study/openRewards.html",context)

def register(request):
	if request.method == "POST":
		form = UserRegisterForm(request.POST)
		if form.is_valid():
			form.save()
			username = form.cleaned_data.get('username')
			messages.success(request, f'Hi {username}, your account created succesfully')
			return redirect('home')
	else:
		form = UserRegisterForm()


	return render(request, "study/register.html",{'form':form})
	

def inventory(request):
	eulerSword = Item.objects.filter(name="eulerSword").exists()
	sircumferenceBow = Item.objects.filter(name="sircumferenceBow").exists()
	newtonHammer = Item.objects.filter(name="newtonHammer").exists()
	riemannAxe = Item.objects.filter(name="riemannAxe").exists()
	achimedesScythe = Item.objects.filter(name="achimedesScythe").exists()
	alkhwarizmiDagger = Item.objects.filter(name="alkhwarizmiDagger").exists()
	pythagorasSpear = Item.objects.filter(name="pythagorasSpear").exists()
	mushroom = Item.objects.filter(name="mushroom").exists()
	strawberry = Item.objects.filter(name="strawberry").exists()
	apple = Item.objects.filter(name="apple").exists()

	print(eulerSword)
	return render(request, "study/inventory.html", {"eulerSword":eulerSword, "sircumferenceBow":sircumferenceBow,
			"newtonHammer":newtonHammer, "riemannAxe":riemannAxe, "achimedesScythe":achimedesScythe,
		   "alkhwarizmiDagger":alkhwarizmiDagger, "pythagorasSpear":pythagorasSpear, 
		   "mushroom":mushroom, "strawberry":strawberry, "apple":apple})

# Loads game files for Godot
def gameWasm(request):

	file_path = Path(__file__).parent / "templates/study/htmlExport/studygame.wasm"
	content_type, _ = mimetypes.guess_type(file_path)

	if content_type is None:
		content_type = 'application/octet-stream'  # Default content type

    # Read the file content
	with open(file_path, "rb") as file:
		file_content = file.read()

    # Set the appropriate content type and content disposition
	response = HttpResponse(file_content, content_type=content_type)
	response['Content-Disposition'] = 'attachment; filename="your_file.ext"'

	return response

def gamePck(request):

	file_path = Path(__file__).parent / "templates/study/htmlExport/studygame.pck"
	content_type, _ = mimetypes.guess_type(file_path)
	if content_type is None:
		content_type = 'application/octet-stream'  # Default content type

    # Read the file content
	with open(file_path, "rb") as file:
		file_content = file.read()

    # Set the appropriate content type and content disposition
	response = HttpResponse(file_content, content_type=content_type)
	response['Content-Disposition'] = 'attachment; filename="your_file.ext"'

	return response

def gameSideWasm(request):

	file_path = Path(__file__).parent / "templates/study/htmlExport/studygame.side.wasm"
	content_type, _ = mimetypes.guess_type(file_path)
	if content_type is None:
		content_type = 'application/octet-stream'  # Default content type

    # Read the file content
	with open(file_path, "rb") as file:
		file_content = file.read()

    # Set the appropriate content type and content disposition
	response = HttpResponse(file_content, content_type=content_type)
	response['Content-Disposition'] = 'attachment; filename="your_file.ext"'

	return response

def sqlWasm(request):

	file_path = Path(__file__).parent / "templates/study/htmlExport/libgdsqlite.wasm"
	content_type, _ = mimetypes.guess_type(file_path)
	if content_type is None:
		content_type = 'application/octet-stream'  # Default content type

    # Read the file content
	with open(file_path, "rb") as file:
		file_content = file.read()

    # Set the appropriate content type and content disposition
	response = HttpResponse(file_content, content_type=content_type)
	response['Content-Disposition'] = 'attachment; filename="your_file.ext"'

	return response

def jsonData():
	# Retrieve data from the Django database
    queryset = Item.objects.all()

    # Convert queryset to a list of dictionaries
    data = []
    for obj in queryset:
        data.append({
            'id': obj.id,
            'name': obj.name,
        })

    # Serialize the data to JSON format
    json_data = json.dumps(data)

    # Write JSON data to a file
    with open('database.json', 'w') as file:
        file.write(json_data)
	
def jsonDataAPI(request):
    with open('database.json') as file:
        data = json.load(file)

    return JsonResponse(data,safe=False)

def jsonRounds(request):
	with open('rounds.json') as file:
		data = json.load(file)

	return JsonResponse(data,safe=False)