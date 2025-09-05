import 'package:PARLACLINIC/core/failure/failure.dart';
import 'package:PARLACLINIC/features/home/model/InviteRequest.dart';
import 'package:PARLACLINIC/features/home/model/Portfolio.dart';
import 'package:PARLACLINIC/features/home/model/articlemodel.dart';
import 'package:PARLACLINIC/features/home/model/faq.dart';
import 'package:PARLACLINIC/features/home/model/personnel.dart';
import 'package:PARLACLINIC/features/home/model/promotion.dart';
import 'package:PARLACLINIC/features/home/model/service_model.dart';
import 'package:PARLACLINIC/features/home/model/serviceitem.dart';
import 'package:PARLACLINIC/features/home/model/tranaction.dart';
import 'package:PARLACLINIC/features/home/model/avaiableservicedetail.dart';
import 'package:PARLACLINIC/services/api_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(HomeRemoteRepositoryRef ref) {
  final apiService = ref.read(apiServiceProvider);
  return HomeRemoteRepository(apiService);
}

class HomeRemoteRepository {
  final ApiService _apiService;

  HomeRemoteRepository(this._apiService);

  Future<Either<AppFailure, WalletAndTransactions>>
      fetchWalletAndTransactions() async {
    try {
      final result = await _apiService.request<WalletAndTransactions>(
        method: 'GET',
        path: '/wallet-transactions/',
        responseConverter: (data) => WalletAndTransactions.fromJson(data),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<ServiceModel>>> getMyServices() async {
    try {
      final result = await _apiService.request<List<ServiceModel>>(
        method: 'GET',
        path: '/my-services/',
        responseConverter: (data) =>
            (data as List).map((item) => ServiceModel.fromJson(item)).toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<FAQCategoryModel>>> getFaqCategories() async {
    try {
      final result = await _apiService.request<List<FAQCategoryModel>>(
        method: 'GET',
        path: '/faq/',
        responseConverter: (data) => (data as List)
            .map((item) => FAQCategoryModel.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<PersonnelModel>>> getpersonnel() async {
    try {
      final result = await _apiService.request<List<PersonnelModel>>(
        method: 'GET',
        path: '/personnel/',
        responseConverter: (data) => (data as List)
            .map((item) => PersonnelModel.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<InviteRequestModel>>> fetchInvites() async {
    try {
      final result = await _apiService.request<List<InviteRequestModel>>(
        method: 'GET',
        path: '/invites/',
        responseConverter: (data) => (data as List)
            .map((item) => InviteRequestModel.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, InviteRequestModel>> createInvite({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final result = await _apiService.request<InviteRequestModel>(
        method: 'POST',
        path: '/invites/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
        },
        responseConverter: (data) => InviteRequestModel.fromJson(data),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<ArticlePreviewModel>>> fetchArticles() async {
    try {
      final result = await _apiService.request<List<ArticlePreviewModel>>(
        method: 'GET',
        path: '/maghalat/',
        responseConverter: (data) => (data['results'] as List)
            .map((item) => ArticlePreviewModel.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, ArticleDetailModel>> fetchArticleDetail(
      int id) async {
    try {
      final result = await _apiService.request<ArticleDetailModel>(
        method: 'GET',
        path: '/maghalat/$id/',
        responseConverter: (data) => ArticleDetailModel.fromJson(data),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<ServiceItem>>> fetchServices() async {
    try {
      final result = await _apiService.request<List<ServiceItem>>(
        method: 'GET',
        path: '/available-services/',
        responseConverter: (data) =>
            (data as List).map((item) => ServiceItem.fromJson(item)).toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<ServiceDetailModel>>>
      getAvailableServicesDetail({int? categoryId}) async {
    try {
      final Map<String, dynamic> queryParams =
          categoryId != null ? {'category': categoryId} : <String, dynamic>{};

      final result = await _apiService.request<List<ServiceDetailModel>>(
        method: 'GET',
        path: '/available-services-detail/', // مسیر جدید در API
        queryParameters:
            queryParams, // ارسال پارامترهای query (مانند categoryId)
        responseConverter: (data) => (data as List)
            .map((item) => ServiceDetailModel.fromJson(item))
            .toList(),
      );

      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<PortfolioItem>>> getportfolios({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await _apiService.request<List<PortfolioItem>>(
        method: 'GET',
        path: '/portfolio/',
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
        responseConverter: (data) => (data['results'] as List)
            .map((item) => PortfolioItem.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<Promotion>>> getPromotions({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await _apiService.request<List<Promotion>>(
        method: 'GET',
        path: '/promotions/',
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
        responseConverter: (data) => (data['results'] as List)
            .map((item) => Promotion.fromJson(item))
            .toList(),
      );
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
