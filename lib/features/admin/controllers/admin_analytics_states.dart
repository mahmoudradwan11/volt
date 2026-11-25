abstract class AdminAnalyticsStates {}

class AdminAnalyticsInitialState extends AdminAnalyticsStates {}

class AdminAnalyticsLoadingState extends AdminAnalyticsStates {}

class AdminAnalyticsSuccessState extends AdminAnalyticsStates {}

class AdminAnalyticsErrorState extends AdminAnalyticsStates {
  final String error;
  AdminAnalyticsErrorState(this.error);
}
