from django.contrib import admin
from Relationship.models import Relationship

# Register your models here.


class RelationshipAdmin(admin.ModelAdmin):
    list_display = ('person', 'relation', 'of_person')

admin.site.register(Relationship, RelationshipAdmin)
