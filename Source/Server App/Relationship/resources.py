from tastypie import fields
from tastypie.authentication import BasicAuthentication
from tastypie.authorization import DjangoAuthorization
from tastypie.constants import ALL_WITH_RELATIONS, ALL
from tastypie.resources import ModelResource
from tastypie.api import Api

from Relationship.models import Relationship
from Person.resources import PersonResource


class RelationshipResource(ModelResource):

    to_person = fields.ForeignKey(PersonResource, 'person')

    class Meta:
        queryset = Relationship.objects.all()
        fields = ['id', 'to_person']
        allowed_methods = ['delete']
        resource_name = 'relation'
        include_resource_uri = False
        collection_name = 'relationships'
        authentication = BasicAuthentication()
        authorization = DjangoAuthorization()
        filtering = {
            'id': 'exact',
            'to_person': ALL_WITH_RELATIONS,
        }

v1_api_relation = Api(api_name='v1')
v1_api_relation.register(RelationshipResource())