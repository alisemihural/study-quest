from django.db import models
from django.contrib.auth.models import User

class ItemManager(models.Manager):
    def create_item(self, name,count,user):
        item = self.create(name=name,count=count,user=user)
        return item
    
class Item(models.Model):
    name = models.CharField(max_length=100)
    count = models.IntegerField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    objects = ItemManager()

    def __str__(self):
        return "Name: {}\n Count: {} \n User: {}".format(self.name,self.count,self.user.username)

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)

    def __str__(self):
        return "{}".format(self.user.username)

 