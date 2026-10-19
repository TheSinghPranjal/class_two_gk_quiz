import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/quiz_section.dart';

/// The full list of available sections. Adding a new section is purely a
/// data change here plus a matching `assets/questions/<id>.json` file —
/// no quiz-engine or UI code needs to change.
const List<QuizSection> kSections = [
  QuizSection(
    id: 'mathematics',
    title: 'Mathematics',
    description: 'Numbers, addition & fun puzzles',
    icon: Icons.calculate_rounded,
    color: AppColors.sectionMath,
  ),
  QuizSection(
    id: 'english',
    title: 'English',
    description: 'Words, opposites & grammar fun',
    icon: Icons.menu_book_rounded,
    color: AppColors.sectionEnglish,
  ),
  QuizSection(
    id: 'science',
    title: 'Science',
    description: 'Our body, plants & the world',
    icon: Icons.science_rounded,
    color: AppColors.sectionScience,
  ),
  QuizSection(
    id: 'general_knowledge',
    title: 'General Knowledge',
    description: 'India, festivals & everyday facts',
    icon: Icons.public_rounded,
    color: AppColors.sectionGeneralKnowledge,
  ),
  QuizSection(
    id: 'animals',
    title: 'Animals',
    description: 'Wild friends & funny facts',
    icon: Icons.pets_rounded,
    color: AppColors.sectionAnimals,
  ),
  QuizSection(
    id: 'birds_insects',
    title: 'Birds & Insects',
    description: 'Feathered friends & tiny bugs',
    icon: Icons.flutter_dash_rounded,
    color: AppColors.sectionBirdsInsects,
  ),
  QuizSection(
    id: 'fruits_veggies',
    title: 'Fruits & Vegetables',
    description: 'Tasty, healthy things we eat',
    icon: Icons.eco_rounded,
    color: AppColors.sectionFruitsVeggies,
  ),
  QuizSection(
    id: 'my_body',
    title: 'My Body & Senses',
    description: 'Organs, bones & sense organs',
    icon: Icons.accessibility_new_rounded,
    color: AppColors.sectionMyBody,
  ),
  QuizSection(
    id: 'food_health',
    title: 'Food & Good Habits',
    description: 'Healthy food & clean habits',
    icon: Icons.restaurant_rounded,
    color: AppColors.sectionFoodHealth,
  ),
  QuizSection(
    id: 'colours_shapes',
    title: 'Colours & Shapes',
    description: 'Mixing colours & 2D/3D shapes',
    icon: Icons.category_rounded,
    color: AppColors.sectionColoursShapes,
  ),
  QuizSection(
    id: 'numbers_time',
    title: 'Numbers, Days & Months',
    description: 'Clock, calendar & counting',
    icon: Icons.schedule_rounded,
    color: AppColors.sectionNumbersTime,
  ),
  QuizSection(
    id: 'family_home',
    title: 'My Family & Home',
    description: 'Relatives, rooms & houses',
    icon: Icons.home_rounded,
    color: AppColors.sectionFamilyHome,
  ),
  QuizSection(
    id: 'helpers',
    title: 'Community Helpers',
    description: 'People who help us every day',
    icon: Icons.local_police_rounded,
    color: AppColors.sectionHelpers,
  ),
  QuizSection(
    id: 'transport',
    title: 'Transport',
    description: 'Land, water & air travel',
    icon: Icons.directions_bus_rounded,
    color: AppColors.sectionTransport,
  ),
  QuizSection(
    id: 'nature_weather',
    title: 'Nature, Seasons & Weather',
    description: 'Plants, seasons & the sky',
    icon: Icons.wb_sunny_rounded,
    color: AppColors.sectionNatureWeather,
  ),
  QuizSection(
    id: 'space',
    title: 'Sun, Moon & Stars',
    description: 'Planets, space & ISRO',
    icon: Icons.rocket_launch_rounded,
    color: AppColors.sectionSpace,
  ),
  QuizSection(
    id: 'india',
    title: 'Our India',
    description: 'Symbols, places & great leaders',
    icon: Icons.flag_rounded,
    color: AppColors.sectionIndia,
  ),
  QuizSection(
    id: 'festivals',
    title: 'Festivals',
    description: 'Festivals of every faith & state',
    icon: Icons.celebration_rounded,
    color: AppColors.sectionFestivals,
  ),
  QuizSection(
    id: 'sports_games',
    title: 'Sports & Games',
    description: 'Games, players & champions',
    icon: Icons.sports_soccer_rounded,
    color: AppColors.sectionSportsGames,
  ),
  QuizSection(
    id: 'safety',
    title: 'Safety Rules',
    description: 'Road, home & fire safety',
    icon: Icons.health_and_safety_rounded,
    color: AppColors.sectionSafety,
  ),
];

QuizSection sectionById(String id) => kSections.firstWhere(
      (s) => s.id == id,
      orElse: () => kSections.first,
    );
