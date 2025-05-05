class PageConfiguration {
  final bool unknown;
  final bool? loggedIn;
  final bool isRegister;
  final bool addStory;
  final bool notification;
  final String? storyId;

  PageConfiguration.splash()
      : unknown = false,
        loggedIn = null,
        isRegister = false,
        addStory = false,
        notification = true,
        storyId = null;

  PageConfiguration.login()
      : unknown = false,
        loggedIn = false,
        isRegister = false,
        addStory = false,
        notification = true,
        storyId = null;

  PageConfiguration.register()
      : unknown = false,
        loggedIn = false,
        isRegister = true,
        addStory = false,
        notification = true,
        storyId = null;

  PageConfiguration.story()
      : unknown = false,
        loggedIn = true,
        isRegister = false,
        addStory = false,
        notification = true,
        storyId = null;

  PageConfiguration.addStory()
      : unknown = false,
        loggedIn = true,
        isRegister = false,
        addStory = true,
        notification = true,
        storyId = null;

  PageConfiguration.storyDetail(String id)
      : unknown = false,
        loggedIn = true,
        isRegister = false,
        addStory = false,
        notification = true,
        storyId = id;

  PageConfiguration.unknown()
      : unknown = true,
        loggedIn = null,
        isRegister = false,
        addStory = false,
        notification = false,
        storyId = null;

  bool get isSplashPage => unknown == false && loggedIn == null;
  bool get isLoginPage => unknown == false && loggedIn == false;
  bool get isRegisterPage => isRegister == true;
  bool get isStoryPage =>
      unknown == false && loggedIn == true && addStory == false;
  bool get isAddStoryPage =>
      unknown == false && loggedIn == true && addStory == true;
  bool get isStoryDetailPage =>
      unknown == false && loggedIn == true && storyId != null;
  bool get isUnknownPage => unknown == true;
}
