from django.urls import path
import crm.views as views
from .views import list_promotions, user_services_view, wallet_and_recent_transactions_view
from .views import maghalat_list_view, maghalat_detail_view,faq_list_view
from .views import invite_list_create_view, personnel_list_view, available_services_list_view,list_Portfolio
from .views import available_servicesdetail_list_view
urlpatterns = [
     path('auth/', views.CurrentUserView, name='current-user'),
     path('promotions/', list_promotions, name='promotion-list'),
     path('wallet-transactions/', wallet_and_recent_transactions_view, name='wallet-transactions'),
     path('my-services/', user_services_view, name='my-services'),
     path('maghalat/', maghalat_list_view, name='maghalat-list'),
     path('maghalat/<int:id>/', maghalat_detail_view, name='maghalat-detail'),
     path('faq/', faq_list_view, name='faq-list'),
     path('invites/', invite_list_create_view, name='invite-list-create'),
     path('portfolio/', list_Portfolio, name='portfolio-list'),
     path('personnel/', personnel_list_view, name='personnel-list'),
     path('available-services/', available_services_list_view, name='available-services-list'),
     path('available-services-detail/', views.available_servicesdetail_list_view, name='available-services-detail-list'),
]