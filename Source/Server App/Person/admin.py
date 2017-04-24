from django.contrib import admin
from Person.models import Person
from Relationship.models import Relationship

# Register your models here.

class RelationshipInline(admin.StackedInline):
    model = Relationship
    verbose_name = 'Relationships'
    verbose_name_plural = 'Relationships'
    extra = 0
    fk_name = 'person'

class PersonAdmin(admin.ModelAdmin):
    inlines = [RelationshipInline, ]
    list_display = ('ssn', 'name', 'dob', 'dod', 'sex',)
    search_fields = ['ssn', 'name', 'gender']


admin.site.register(Person, PersonAdmin)
