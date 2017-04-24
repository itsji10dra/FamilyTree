from tastypie.resources import ModelResource
from tastypie.api import Api

from Relationship.models import Relationship


class RelationshipResource(ModelResource):

    class Meta:
        queryset = Relationship.objects.all()
        fields = ['id']
        allowed_methods = ['delete']
        resource_name = 'relation'
        include_resource_uri = False
        collection_name = 'relationships'

v1_api_relation = Api(api_name='v1')
v1_api_relation.register(RelationshipResource())