import '../entities/onboarding_profile.dart';

class ComputeEligibilityTags {
  const ComputeEligibilityTags();

  List<String> call(OnboardingProfile profile) {
    final Set<String> tags = <String>{};

    switch (profile.occupation.toLowerCase()) {
      case 'business':
      case 'freelancer':
        tags.addAll(<String>['business', 'pm_mudra', 'startup_india']);
        break;
      case 'student':
        tags.addAll(<String>['student', 'education_support']);
        break;
      case 'salaried':
      default:
        tags.addAll(<String>['salaried', 'tax_saver', 'epf']);
        break;
    }

    final String income = profile.incomeRange.toLowerCase();
    if (income.contains('0-10k') || income.contains('10k-25k')) {
      tags.addAll(<String>['low_income', 'jan_dhan']);
    }
    if (income.contains('100k+')) {
      tags.addAll(<String>['high_income', 'investment']);
    }

    return tags.toList();
  }
}
