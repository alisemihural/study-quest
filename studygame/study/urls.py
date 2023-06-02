from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.home),
    path('home/', views.home, name='home'),
    path('study/', views.study, name='study'),
    path('plan/', views.planner),
    path('aboutus/', views.aboutus),
    path('addsection/', views.addsection),
    path('register/', views.register, name='register'),
    path('profile/', views.profile),
    path('inventory/', views.inventory),
    path('study/algquizz/', views.algQuizz,name="algQuizz"),
    path('study/calcquizz/', views.calcQuizz,name="calcQuizz"),
    path('study/trigquizz/', views.trigQuizz,name="trigQuizz"),

    path('openrewards/', views.openRewards,name="openRewards"),

    path('login/', auth_views.LoginView.as_view(template_name="study/login.html"), name="login"),
    path('logout/', auth_views.LogoutView.as_view(template_name="study/logout.html"), name="logout"),

    path('game/', views.game),
    path('game/studygame.wasm', views.gameWasm),
    path('game/studygame.pck', views.gamePck),
    path('game/studygame.side.wasm', views.gameSideWasm),
    path('game/libgdsqlite.wasm', views.sqlWasm),
    path('database.json/', views.jsonDataAPI),
    path('rounds.json/', views.jsonRounds)
]
