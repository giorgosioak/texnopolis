import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/event.dart';
import '../models/offer.dart';

class ApiService {
  static const String baseUrl = 'https://www.texnopolis.net/api';

  // Caching variables to store the API responses in memory
  static List<Movie>? cachedNowShowingMovies;
  static List<Movie>? cachedComingSoonMovies;
  static List<Event>? cachedEvents;
  static List<Offer>? cachedOffers;

  // Fetch Now Showing Movies with caching
  static Future<List<Movie>> fetchNowShowingMovies() async {
    if (cachedNowShowingMovies != null) {
      return cachedNowShowingMovies!; // Return cached data if available
    } else {
      final response = await http.get(Uri.parse('$baseUrl/movies/get_movies/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cachedNowShowingMovies = data.map((json) => Movie.fromJson(json)).toList();
        return cachedNowShowingMovies!;
      } else {
        throw Exception('Failed to load now showing movies');
      }
    }
  }

  // Fetch Coming Soon Movies with caching
  static Future<List<Movie>> fetchComingSoonMovies() async {
    if (cachedComingSoonMovies != null) {
      return cachedComingSoonMovies!; // Return cached data if available
    } else {
      final response = await http.get(Uri.parse('$baseUrl/movies/comingsoon_movies/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cachedComingSoonMovies = data.map((json) => Movie.fromJson(json)).toList();
        return cachedComingSoonMovies!;
      } else {
        throw Exception('Failed to load coming soon movies');
      }
    }
  }

  // Fetch Events with caching
  static Future<List<Event>> fetchEvents() async {
    if (cachedEvents != null) {
      return cachedEvents!; // Return cached data if available
    } else {
      final response = await http.get(Uri.parse('$baseUrl/events/get_events/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cachedEvents = data.map((json) => Event.fromJson(json)).toList();
        return cachedEvents!;
      } else {
        throw Exception('Failed to load events');
      }
    }
  }

  // Fetch Offers with caching
  static Future<List<Offer>> fetchOffers() async {
    if (cachedOffers != null) {
      return cachedOffers!; // Return cached data if available
    } else {
      final response = await http.get(Uri.parse('$baseUrl/offers/get_offers/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cachedOffers = data.map((json) => Offer.fromJson(json)).toList();
        return cachedOffers!;
      } else {
        throw Exception('Failed to load offers');
      }
    }
  }

  // Clear cache manually if needed
  static void clearCache() {
    cachedNowShowingMovies = null;
    cachedComingSoonMovies = null;
    cachedEvents = null;
    cachedOffers = null;
  }
}
