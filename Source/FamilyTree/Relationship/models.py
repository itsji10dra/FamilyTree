from django.db import models
from Person.models import Person

# Create your models here.


class Relationship(models.Model):

    RELATIONSHIP_CHOICE = (
        (1, 'Father'),
        (2, 'Mother'),
        (3, 'Brother'),
        (4, 'Sister'),
        (5, 'Husband'),
        (6, 'Wife'),
        (7, 'Uncle'),
        (8, 'Aunt'),
        (9, 'Son'),
        (10, 'Daughter'),
        (11, 'Grand Father'),
        (12, 'Grand Mother'),
        (13, 'Boy Friend'),
        (14, 'Girl Friend')
    )

    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='person')
    relation = models.IntegerField(choices=RELATIONSHIP_CHOICE)
    of_person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='of_person', verbose_name="Of Person")

    class Meta:
        verbose_name_plural = 'Relationships'
        unique_together = (('person', 'of_person'),)

    def to_json(self):
        return dict(id=self.id, relation=self.relation, person=self.of_person.to_json())
