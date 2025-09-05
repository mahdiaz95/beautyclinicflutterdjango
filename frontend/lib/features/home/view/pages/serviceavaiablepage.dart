import 'package:PARLACLINIC/features/home/repositories/home_remote_repository.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:PARLACLINIC/features/home/view/viewmodels/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:fpdart/fpdart.dart';
import 'package:PARLACLINIC/features/home/model/avaiableservicedetail.dart';
import 'package:PARLACLINIC/core/failure/failure.dart';
// Adjust import based on your structure

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serviceViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('خدمات قابل ارائه'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: state.when(
        data: (services) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(serviceViewModelProvider.notifier).refresh();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: () {
                    print(service.category);
                    // Navigate to ServiceDetailPage with service.category as serviceId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailPage(serviceId: service.category),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: service.photo,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطا: $e')),
      ),
    );
  }
}

class ServiceDetailPage extends ConsumerWidget {
  final int serviceId;

  ServiceDetailPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch service details directly using HomeRepository
    final homeRepository = ref.read(homeRemoteRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'جزئیات خدمت',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.shade100, Colors.white],
          ),
        ),
        child: FutureBuilder<Either<AppFailure, List<ServiceDetailModel>>>(
          future:
              homeRepository.getAvailableServicesDetail(categoryId: serviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'خطا: ${snapshot.error ?? "داده‌ای دریافت نشد"}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            final result = snapshot.data!;
            return result.fold(
              (failure) => Center(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'خطا: ${failure.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              (details) => details.isEmpty
                  ? Center(
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'جزئیات یافت نشد.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        final detail = details[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service Name
                                Text(
                                  detail.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueAccent.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Photo (if it's a valid URL)
                                if (detail.photo.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      detail.photo,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 200,
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: Text(
                                            'تصویر بارگذاری نشد',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                // Description
                                if (detail.description.isNotEmpty)
                                  Text(
                                    'توضیحات: ${detail.description}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                // Category

                                // Status
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
