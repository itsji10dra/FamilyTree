from django.db import models

# Create your models here.


class Person(models.Model):

    GENDER_CHOICES = (
        (0, 'Unknown'),
        (1, 'Male'),
        (2, 'Female'),
    )

    ssn = models.BigIntegerField("SSN", primary_key=True)
    name = models.CharField("Name", max_length=500)
    dob = models.DateField("Date of Birth", blank=True, null=True)
    dod = models.DateField("Date of Death", blank=True, null=True)
    sex = models.IntegerField("Gender", default=0, choices=GENDER_CHOICES)

    class Meta:
        verbose_name_plural = 'Person'
        ordering = ['ssn']

    def __str__(self):
        return self.name

    def to_json(self):
        from Relationship.models import Relationship

        relationships_objects = Relationship.objects.filter(person__ssn__exact=self.ssn)
        relationships = []

        for relation in relationships_objects:
            relationships.append(relation.to_json())

        return dict(ssn=self.ssn, name=self.name, dob=self.dob, dod=self.dod, sex=self.sex, relationships=relationships)
