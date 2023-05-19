import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class JobRecommendationService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Job>> recommendJobs(Users user) async {
    // Get all jobs
    QuerySnapshot jobsSnapshot = await firestore.collection('jobs').get();
    List<Job> jobs =
        jobsSnapshot.docs.map((doc) => Job.fromDocumentSnapshot(doc)).toList();

    // Create user's interests vector
    List<String> userInterests = user.interests;
    Map<String, int> userInterestsVector = interestsToVector(userInterests);

    // Create user's location vector
    String userLocation = user.city;

    List<Job> recommendedJobs = [];

    for (Job job in jobs) {
      // Create job vector
      Map<String, dynamic> jobVector =
          jobToVector(job.title, job.description, job.location);

      // Calculate similarity scores
      double interestsScore =
          cosineSimilarity(userInterestsVector, jobVector['interests']);
      double locationScore = cosineSimilarity(
          userLocation as Map<String, dynamic>, jobVector['location']);

      // Calculate overall similarity score
      double overallScore = (interestsScore + locationScore) / 2;

      // Save recommendation to Firestore if score is greater than 0.5
      if (overallScore > 0.5) {
        Recommendation recommendation = Recommendation(
          userId: user.id,
          jobId: job.id,
          score: overallScore,
        );

        await firestore
            .collection('recommendations')
            .add(recommendation.toMap());

        // Add job to recommended jobs list
        job.score = overallScore;
        recommendedJobs.add(job);
      }
    }

    // Sort recommended jobs by score in descending order
    recommendedJobs.sort((a, b) => b.score.compareTo(a.score));

    return recommendedJobs;
  }

  Map<String, int> interestsToVector(List<String> interestsArray) {
    // Get all unique interests
    List<String> uniqueInterests = interestsArray.toSet().toList();

    // Create a vector with all zeros
    Map<String, int> vector = {};
    for (String interest in uniqueInterests) {
      vector[interest] = 0;
    }

    // Loop through the interests and set the corresponding vector value to 1
    for (String interest in interestsArray) {
      vector[interest] = 1;
    }

    return vector;
  }

  Map<String, dynamic> jobToVector(
      String title, String description, String location) {
    // Concatenate the job's title and description into a single string
    String text = '$title $description $location';

    // Remove special characters and convert to lowercase
    text = text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    text = text.toLowerCase();

    // Split the text into words
    List<String> words = text.split(' ');

    // Get all unique words
    List<String> uniqueWords = words.toSet().toList();

    // Create a vector
    Map<String, dynamic> vector = {
      'interests': {},
      'location': location,
    };

    // Loop through the words and set the corresponding vector value to 1
    for (String word in uniqueWords) {
      vector['interests'][word] = 0;
    }

    for (String word in words) {
      vector['interests'][word] = 1;
    }

    return vector;
  }

  double cosineSimilarity(
      Map<String, dynamic> vectorA, Map<String, dynamic> vectorB) {
    double dotProduct = 0;
    double magnitudeA = 0;
    double magnitudeB = 0;

    // Calculate the dot product and magnitude of vectors A and B
    vectorA.forEach((key, value) {
      if (vectorB.containsKey(key)) {
        dotProduct += (vectorA[key] * vectorB[key]);
        magnitudeA += pow(vectorA[key], 2);
        magnitudeB += pow(vectorB[key], 2);
      }
    });

    // Calculate the cosine similarity
    if (magnitudeA == 0 || magnitudeB == 0) {
      return 0;
    } else {
      return dotProduct / (sqrt(magnitudeA) * sqrt(magnitudeB));
    }
  }
}

class Users {
  String id;
  String city;
  List<String> interests;

  Users({required this.id, required this.city, required this.interests});
}

class Job {
  String id;
  String title;
  String description;
  String location;
  double score;

  Job(
      {required this.id,
      required this.title,
      required this.description,
      required this.location,
      required this.score});

  factory Job.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Job(
      id: snapshot.id,
      title: data!['title'],
      description: data['description'],
      location: data['city'],
      score: 0,
    );
  }
}

class Recommendation {
  String userId;
  String jobId;
  double score;

  Recommendation(
      {required this.userId, required this.jobId, required this.score});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'jobId': jobId,
      'score': score,
    };
  }
}
