from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework import status
from django.contrib.auth import get_user_model
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes, throttle_classes
from rest_framework.response import Response
from rest_framework import status, throttling, pagination
from crm.models import Promotion,ServiceAvaiable, Service, Transaction, Wallet,FAQ, FAQCategory, Maghalat,Personnel,Portfolio,ServiceAvaiabledetail
from crm.serializers import PromotionSerializer, ServiceSerializer, UserSerializer, WalletWithTransactionsSerializer
from crm.serializers import MaghalatPreviewSerializer, MaghalatDetailSerializer, FAQCategorySerializer
from crm.serializers import ServiceAvaiableSerializer,InviteRequestSerializer, PersonnelSerializer,InviteRequest,PortfolioSerializer
from crm.serializers import ServiceAvaiableDetailSerializer
User = get_user_model()
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CurrentUserView(request):
    user = request.user 
    serializer = UserSerializer(user)
    return Response(serializer.data)


class PromotionThrottle(throttling.UserRateThrottle):
    scope = 'promotion'

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([PromotionThrottle])
def list_promotions(request):
    promotions = Promotion.objects.all().order_by('-created_at')
    paginator = pagination.LimitOffsetPagination()
    paginator.default_limit = 10 
    result_page = paginator.paginate_queryset(promotions, request)
    
    serializer = PromotionSerializer(result_page, many=True, context={'request': request})
    
    return paginator.get_paginated_response(serializer.data)

class PortfolioThrottle(throttling.UserRateThrottle):
    scope = 'Portfolio'

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([PortfolioThrottle])
def list_Portfolio(request):
    Portfolios = Portfolio.objects.all().order_by('-created_at')
    paginator = pagination.LimitOffsetPagination()
    paginator.default_limit = 10 
    result_page = paginator.paginate_queryset(Portfolios, request)
    serializer = PortfolioSerializer(result_page, many=True, context={'request': request})
    return paginator.get_paginated_response(serializer.data)
class TransactionThrottle(throttling.UserRateThrottle):
    scope = 'transaction'
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([TransactionThrottle])
def wallet_and_recent_transactions_view(request):
    user = request.user
    wallet = get_object_or_404(Wallet, user=user)
    transactions = Transaction.objects.filter(user=user).order_by('-created_at')[:100]

    serializer = WalletWithTransactionsSerializer({
        'balance': wallet.balance,
        'transactions': transactions
    })

    return Response(serializer.data)
class ServiceThrottle(throttling.UserRateThrottle):
    scope = 'service'
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([ServiceThrottle])
def user_services_view(request):
    user = request.user
    services = Service.objects.filter(user=user).order_by('-created_at')[:100]
    serializer = ServiceSerializer(services, many=True)
    return Response(serializer.data)

class maghalatThrottle(throttling.UserRateThrottle):
    scope = 'maghalat'

@api_view(['GET'])
@permission_classes([IsAuthenticated]) 
@throttle_classes([maghalatThrottle])
def maghalat_list_view(request):
    category_name = request.query_params.get('category')
    queryset = Maghalat.objects.all().order_by('-created_at')
    
    if category_name:
        queryset = queryset.filter(category__name__icontains=category_name)

    paginator = pagination.PageNumberPagination()
    paginator.page_size = 20 
    result_page = paginator.paginate_queryset(queryset, request)

    serializer = MaghalatPreviewSerializer(result_page, many=True)
    return paginator.get_paginated_response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([maghalatThrottle])
def maghalat_detail_view(request, id):
    try:
        maghale = Maghalat.objects.get(id=id)
    except Maghalat.DoesNotExist:
        return Response({'detail': 'مقاله یافت نشد'}, status=status.HTTP_404_NOT_FOUND)

    serializer = MaghalatDetailSerializer(maghale)
    return Response(serializer.data)
class FAQThrottle(throttling.UserRateThrottle):
    scope = 'faq'
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([FAQThrottle])
def faq_list_view(request):
    categories = FAQCategory.objects.prefetch_related('faqs').all()
    serializer = FAQCategorySerializer(categories, many=True)
    return Response(serializer.data)

class InviteThrottle(throttling.UserRateThrottle):
    scope = 'invite'

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
@throttle_classes([InviteThrottle])
def invite_list_create_view(request):
    user = request.user

    if request.method == 'GET':
        invites = InviteRequest.objects.filter(inviter=user).order_by('-created_at')
        serializer = InviteRequestSerializer(invites, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    serializer = InviteRequestSerializer(
        data=request.data,
        context={'request': request}
    )
    if serializer.is_valid():
        invite = serializer.save() 
        return Response(
            InviteRequestSerializer(invite).data,
            status=status.HTTP_201_CREATED
        )
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PersonnelThrottle(throttling.AnonRateThrottle):
    scope = 'personnel'
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([PersonnelThrottle])
def personnel_list_view(request):
    
    qs = Personnel.objects.all()
    serializer = PersonnelSerializer(qs, many=True, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)

class ServiceAvailableThrottle(throttling.UserRateThrottle):
    scope = 'servicesavailable'

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([ServiceAvailableThrottle])
def available_services_list_view(request):
    services = ServiceAvaiable.objects.filter(is_active=True).order_by('-created_at')
    serializer = ServiceAvaiableSerializer(services, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([ServiceAvailableThrottle])
def available_servicesdetail_list_view(request): 
    category_id = request.query_params.get('category', None)
    if category_id:
        services = ServiceAvaiabledetail.objects.filter(category__id=category_id, is_active=True).order_by('-created_at')
    else:
        services = ServiceAvaiabledetail.objects.filter(is_active=True).order_by('-created_at')
    serializer = ServiceAvaiableDetailSerializer(services, many=True)
    return Response(serializer.data)