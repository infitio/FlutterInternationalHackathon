class URLS{
  static final String login = "/login";
  static final String home = "/home";
  static final String profileHome = "/home/profile";
  static final String notification = "/notification";

  static final String userProfile = "^users/{{userId}}([0-9]+)/profile\$";
  static final String profileSettings = "/profile/settings";
  static final String languageSettings = "/profile/settings/language";
  static final String notificationSettings = "/profile/settings/notification";

  static final String postComment = "^posts/{{postId}}([0-9]+)/comment\$";

  static final String logoutLoading = "/logout_loading";
  static final String postDetails = "^posts/{{postId}}([0-9]+)/details\$";
  static final String fullScreenMedia = "^fullscreen/{{mediaFrom}}(.*)/{{id}}([0-9a-f]+)/{{mediaType}}([0-2])/{{mediaUrl}}(.*)\$";

  static final String searchPage = "/search";

  static final String createChat = "/interaction/new_chat";
  static final String newChat = "/interaction/new_chat/{{threadId}}([0-9a-zA-Z]+)";
  static final String chatScreen = "/interaction/threads/{{threadId}}([0-9a-zA-Z]+)";
  static final String interactionProfile = "^threads/{{threadId}}([0-9a-zA-Z]+)/profile\$";

}