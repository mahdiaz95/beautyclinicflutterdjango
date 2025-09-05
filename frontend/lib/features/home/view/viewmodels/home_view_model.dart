import 'package:PARLACLINIC/features/home/model/InviteRequest.dart';
import 'package:PARLACLINIC/features/home/model/Portfolio.dart';
import 'package:PARLACLINIC/features/home/model/articlemodel.dart';
import 'package:PARLACLINIC/features/home/model/personnel.dart';
import 'package:PARLACLINIC/features/home/model/promotion.dart';
import 'package:PARLACLINIC/features/home/model/service_model.dart';
import 'package:PARLACLINIC/features/home/model/serviceitem.dart';
import 'package:PARLACLINIC/features/home/model/tranaction.dart';
import 'package:PARLACLINIC/features/home/model/avaiableservicedetail.dart';
import 'package:PARLACLINIC/features/home/repositories/home_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:PARLACLINIC/features/home/model/faq.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<WalletAndTransactions> build() async {
    return await _loadData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadData());
  }

  Future<WalletAndTransactions> _loadData() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.fetchWalletAndTransactions();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}

// Provider for service details, parameterized by serviceId
final serviceDetailViewModelProvider =
    FutureProvider.family<List<ServiceDetailModel>, int>(
  (ref, serviceId) async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getAvailableServicesDetail(categoryId: serviceId);
    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  },
);

@riverpod
class MyServicesViewModel extends _$MyServicesViewModel {
  @override
  Future<List<ServiceModel>> build() async {
    return await _load();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _load());
  }

  Future<List<ServiceModel>> _load() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getMyServices();

    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  }
}

@riverpod
class FaqViewModel extends _$FaqViewModel {
  @override
  Future<List<FAQCategoryModel>> build() async {
    return await _load();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _load());
  }

  Future<List<FAQCategoryModel>> _load() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getFaqCategories();

    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  }
}

@riverpod
class PersonnelViewModel extends _$PersonnelViewModel {
  @override
  Future<List<PersonnelModel>> build() async {
    return await _load();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _load());
  }

  Future<List<PersonnelModel>> _load() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getpersonnel();

    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  }
}

@riverpod
class ServiceViewModel extends _$ServiceViewModel {
  @override
  Future<List<ServiceItem>> build() async {
    return await _load();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _load());
  }

  Future<List<ServiceItem>> _load() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.fetchServices();

    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  }
}

@riverpod
class InviteRequestsViewModel extends _$InviteRequestsViewModel {
  @override
  Future<List<InviteRequestModel>> build() async {
    return await _load();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _load());
  }

  Future<List<InviteRequestModel>> _load() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.fetchInvites();

    return result.fold(
      (fail) => throw Exception(fail.message),
      (list) => list,
    );
  }
}

@riverpod
Future<InviteRequestModel> createinvite(
  CreateinviteRef ref, {
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
}) async {
  final res = await ref.read(homeRemoteRepositoryProvider).createInvite(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );

  return switch (res) {
    Left(value: final l) => throw Exception(l.message),
    Right(value: final r) => r,
  };
}

@riverpod
class PortfolioViewModel extends _$PortfolioViewModel {
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  FutureOr<List<PortfolioItem>> build() async {
    return await _fetchInitialPortfolios();
  }

  Future<List<PortfolioItem>> _fetchInitialPortfolios() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getportfolios(limit: _limit, offset: _offset);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        _offset += data.length;
        _hasMore = data.length == _limit;
        return data;
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getportfolios(limit: _limit, offset: _offset);
    result.fold(
      (failure) => null,
      (data) {
        _offset += data.length;
        _hasMore = data.length == _limit;
        state = AsyncData([...state.valueOrNull ?? [], ...data]);
      },
    );
  }

  void refreshList() async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    state = AsyncData(await _fetchInitialPortfolios());
  }
}

@riverpod
class PromotionViewModel extends _$PromotionViewModel {
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  FutureOr<List<Promotion>> build() async {
    return await _fetchInitialPromotions();
  }

  Future<List<Promotion>> _fetchInitialPromotions() async {
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getPromotions(limit: _limit, offset: _offset);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        _offset += data.length;
        _hasMore = data.length == _limit;
        return data;
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final repo = ref.read(homeRemoteRepositoryProvider);
    final result = await repo.getPromotions(limit: _limit, offset: _offset);
    result.fold(
      (failure) => null,
      (data) {
        _offset += data.length;
        _hasMore = data.length == _limit;
        state = AsyncData([...state.valueOrNull ?? [], ...data]);
      },
    );
  }

  void refreshList() async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    state = AsyncData(await _fetchInitialPromotions());
  }
}

@riverpod
class ArticlesViewModel extends _$ArticlesViewModel {
  @override
  Future<List<ArticlePreviewModel>> build() async => await _load();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load());
  }

  Future<List<ArticlePreviewModel>> _load() async {
    final result = await ref.read(homeRemoteRepositoryProvider).fetchArticles();
    return result.fold(
      (l) => throw Exception(l.message),
      (r) => r,
    );
  }
}

final articleDetailViewModelProvider =
    FutureProvider.family<ArticleDetailModel, int>((ref, id) async {
  final repo = ref.read(homeRemoteRepositoryProvider);
  final result = await repo.fetchArticleDetail(id);
  return result.fold(
    (l) => throw Exception(l.message),
    (r) => r,
  );
});
