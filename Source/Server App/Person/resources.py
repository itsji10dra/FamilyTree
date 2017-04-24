from tastypie.resources import ModelResource
from tastypie.api import Api
from tastypie.authentication import BasicAuthentication
from tastypie.authorization import DjangoAuthorization
from tastypie.exceptions import ImmediateHttpResponse
from tastypie.http import HttpResponse

from Person.models import Person
from Relationship.models import Relationship


class PersonResource(ModelResource):

    class Meta:
        queryset = Person.objects.all()
        fields = ['ssn', 'name', 'dob', 'dod', 'sex']
        resource_name = 'person'
        detail_allowed_methods = ['get', 'post', 'delete']
        include_resource_uri = False
        collection_name = 'person'
        authentication = BasicAuthentication()
        authorization = DjangoAuthorization()
        filtering = {
            'ssn': 'exact',
        }

    def get_object_list(self, request):
        if request.method == 'GET':
            if 'ssn' not in request.GET:
                return None
        return super(PersonResource, self).get_object_list(request)

    def alter_deserialized_detail_data(self, request, data):

        if request.method == 'POST':
            ssn = int(data['person']['ssn'])

            try:
                person = Person.objects.get(ssn=ssn)
            except Person.DoesNotExist:
                person = None

            if person is None:
                name = data['person']['name']
                dob = data['person']['dob']
                dod = data['person']['dod']
                sex = int(data['person']['sex'])

                if len(dob) == 0:
                    dob = None
                if len(dod) == 0:
                    dod = None

                person = Person(ssn=ssn, name=name, dob=dob, dod=dod, sex=sex)
                person.save()

            if 'relationships' not in data['person']:
                raise ImmediateHttpResponse(self.create_response(request, dict(status='success')))
            else:
                relation = int(data['person']['relationships']['relation'])
                new_person_ssn = int(data['person']['relationships']['person'])
                new_person = Person.objects.get(ssn=new_person_ssn)

                if new_person is not None:
                    relationship = Relationship(person=new_person, relation=relation, of_person=person)
                    relationship.save()
                    raise ImmediateHttpResponse(self.create_response(request, dict(status='success')))

        return super(PersonResource, self).alter_deserialized_detail_data(request, data)

    def create_response(self, request, data, response_class=HttpResponse, **response_kwargs):

        if request.method == 'GET':
            person_array = data['person']
            if len(person_array) == 1:
                person = person_array[0].obj
                data = dict(status='success', person=person.to_json())
            else:
                data = dict(status='failure', message='SSN Id does not exist.')
        elif request.method == 'DELETE':
            if response_class.status_code == 204:
                data = dict(status='success')
            else:
                data = dict(status='failure', message='Something went wong.')

        return super(PersonResource, self).create_response(request, data)

v1_api_person = Api(api_name='v1')
v1_api_person.register(PersonResource())