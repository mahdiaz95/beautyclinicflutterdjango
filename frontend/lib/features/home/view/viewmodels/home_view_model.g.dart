// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createinviteHash() => r'218060b88a43dc7e8375cdaab4b90edc9ee7e2d2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [createinvite].
@ProviderFor(createinvite)
const createinviteProvider = CreateinviteFamily();

/// See also [createinvite].
class CreateinviteFamily extends Family<AsyncValue<InviteRequestModel>> {
  /// See also [createinvite].
  const CreateinviteFamily();

  /// See also [createinvite].
  CreateinviteProvider call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    return CreateinviteProvider(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }

  @override
  CreateinviteProvider getProviderOverride(
    covariant CreateinviteProvider provider,
  ) {
    return call(
      firstName: provider.firstName,
      lastName: provider.lastName,
      email: provider.email,
      phone: provider.phone,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createinviteProvider';
}

/// See also [createinvite].
class CreateinviteProvider
    extends AutoDisposeFutureProvider<InviteRequestModel> {
  /// See also [createinvite].
  CreateinviteProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) : this._internal(
          (ref) => createinvite(
            ref as CreateinviteRef,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
          ),
          from: createinviteProvider,
          name: r'createinviteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createinviteHash,
          dependencies: CreateinviteFamily._dependencies,
          allTransitiveDependencies:
              CreateinviteFamily._allTransitiveDependencies,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        );

  CreateinviteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  }) : super.internal();

  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  @override
  Override overrideWith(
    FutureOr<InviteRequestModel> Function(CreateinviteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateinviteProvider._internal(
        (ref) => create(ref as CreateinviteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InviteRequestModel> createElement() {
    return _CreateinviteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateinviteProvider &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firstName.hashCode);
    hash = _SystemHash.combine(hash, lastName.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, phone.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateinviteRef on AutoDisposeFutureProviderRef<InviteRequestModel> {
  /// The parameter `firstName` of this provider.
  String get firstName;

  /// The parameter `lastName` of this provider.
  String get lastName;

  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `phone` of this provider.
  String get phone;
}

class _CreateinviteProviderElement
    extends AutoDisposeFutureProviderElement<InviteRequestModel>
    with CreateinviteRef {
  _CreateinviteProviderElement(super.provider);

  @override
  String get firstName => (origin as CreateinviteProvider).firstName;
  @override
  String get lastName => (origin as CreateinviteProvider).lastName;
  @override
  String get email => (origin as CreateinviteProvider).email;
  @override
  String get phone => (origin as CreateinviteProvider).phone;
}

String _$homeViewModelHash() => r'7e1fb2f4fbd091060ca76af402b40ffb22e0420b';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider = AutoDisposeAsyncNotifierProvider<HomeViewModel,
    WalletAndTransactions>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeAsyncNotifier<WalletAndTransactions>;
String _$myServicesViewModelHash() =>
    r'74b9107103e126fc86cde3b90939690df2ee6503';

/// See also [MyServicesViewModel].
@ProviderFor(MyServicesViewModel)
final myServicesViewModelProvider = AutoDisposeAsyncNotifierProvider<
    MyServicesViewModel, List<ServiceModel>>.internal(
  MyServicesViewModel.new,
  name: r'myServicesViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myServicesViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyServicesViewModel = AutoDisposeAsyncNotifier<List<ServiceModel>>;
String _$faqViewModelHash() => r'8d1ed620b8e2d392ee72ffca29cfaf68fa16ad22';

/// See also [FaqViewModel].
@ProviderFor(FaqViewModel)
final faqViewModelProvider = AutoDisposeAsyncNotifierProvider<FaqViewModel,
    List<FAQCategoryModel>>.internal(
  FaqViewModel.new,
  name: r'faqViewModelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$faqViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FaqViewModel = AutoDisposeAsyncNotifier<List<FAQCategoryModel>>;
String _$personnelViewModelHash() =>
    r'd49697d19bb255a656c70a801705fd9e70d304dd';

/// See also [PersonnelViewModel].
@ProviderFor(PersonnelViewModel)
final personnelViewModelProvider = AutoDisposeAsyncNotifierProvider<
    PersonnelViewModel, List<PersonnelModel>>.internal(
  PersonnelViewModel.new,
  name: r'personnelViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personnelViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PersonnelViewModel = AutoDisposeAsyncNotifier<List<PersonnelModel>>;
String _$serviceViewModelHash() => r'6f06bf7398d97c8fb79b2152872cc4d71f56377f';

/// See also [ServiceViewModel].
@ProviderFor(ServiceViewModel)
final serviceViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ServiceViewModel, List<ServiceItem>>.internal(
  ServiceViewModel.new,
  name: r'serviceViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serviceViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServiceViewModel = AutoDisposeAsyncNotifier<List<ServiceItem>>;
String _$inviteRequestsViewModelHash() =>
    r'36785f530f8897d5418c3c4d04501fbca49cd2fb';

/// See also [InviteRequestsViewModel].
@ProviderFor(InviteRequestsViewModel)
final inviteRequestsViewModelProvider = AutoDisposeAsyncNotifierProvider<
    InviteRequestsViewModel, List<InviteRequestModel>>.internal(
  InviteRequestsViewModel.new,
  name: r'inviteRequestsViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inviteRequestsViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InviteRequestsViewModel
    = AutoDisposeAsyncNotifier<List<InviteRequestModel>>;
String _$portfolioViewModelHash() =>
    r'535ebdb4b0d0b815eebbf36ad7fc02c3490776e3';

/// See also [PortfolioViewModel].
@ProviderFor(PortfolioViewModel)
final portfolioViewModelProvider = AutoDisposeAsyncNotifierProvider<
    PortfolioViewModel, List<PortfolioItem>>.internal(
  PortfolioViewModel.new,
  name: r'portfolioViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PortfolioViewModel = AutoDisposeAsyncNotifier<List<PortfolioItem>>;
String _$promotionViewModelHash() =>
    r'3887132a968945618921220b16ddf3ba8d15f43d';

/// See also [PromotionViewModel].
@ProviderFor(PromotionViewModel)
final promotionViewModelProvider = AutoDisposeAsyncNotifierProvider<
    PromotionViewModel, List<Promotion>>.internal(
  PromotionViewModel.new,
  name: r'promotionViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PromotionViewModel = AutoDisposeAsyncNotifier<List<Promotion>>;
String _$articlesViewModelHash() => r'68a9f079dc8afce8cf55d01de40fa0a3c343d1d3';

/// See also [ArticlesViewModel].
@ProviderFor(ArticlesViewModel)
final articlesViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ArticlesViewModel, List<ArticlePreviewModel>>.internal(
  ArticlesViewModel.new,
  name: r'articlesViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$articlesViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArticlesViewModel
    = AutoDisposeAsyncNotifier<List<ArticlePreviewModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
