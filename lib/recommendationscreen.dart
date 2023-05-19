import 'package:akalimu/recommender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'customcardscreen.dart';

// class RecommendationCardListView extends StatefulWidget {
//   const RecommendationCardListView({super.key});

//   @override
//   State<RecommendationCardListView> createState() =>
//       _RecommendationCardListViewState();
// }

// class _RecommendationCardListViewState
//     extends State<RecommendationCardListView> {
//   final List<Map<String, String>> cardData = [
//     {
//       'name': 'John Doe',
//       'location': 'New York',
//       'phone': '+1 123-456-7890',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     {
//       'name': 'Jane Smith',
//       'location': 'Los Angeles',
//       'phone': '+1 234-567-8901',
//     },
//     // Add more data as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: cardData.length,
//         itemBuilder: (context, index) {
//           final data = cardData[index];
//           return CustomCard(
//             name: data['name'] ?? '',
//             location: data['location'] ?? '',
//             phone: data['phone'] ?? '',
//           );
//         },
//       ),
//     );
//   }
// }

class RecommendedJobsScreen extends StatelessWidget {
  final User user;

  const RecommendedJobsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Jobs'),
      ),
      body: FutureBuilder<List<Job>>(
        future: JobRecommendationService().recommendJobs(user as Users),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Job>? recommendedJobs = snapshot.data;
            if (recommendedJobs!.isEmpty) {
              return const Center(
                child: Text('No recommended jobs found.'),
              );
            } else {
              return ListView.builder(
                itemCount: recommendedJobs.length,
                itemBuilder: (context, index) {
                  Job job = recommendedJobs[index];
                  return ListTile(
                    title: Text(job.title),
                    subtitle: Text(job.description),
                    trailing: Text('Score: ${job.score.toStringAsFixed(2)}'),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
