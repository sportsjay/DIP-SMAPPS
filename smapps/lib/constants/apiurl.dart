class service_url {
  static String ip_v4 = '192.168.0.101'; // use ipv4
  // get courses
  static String get_course_URL = 'http://$ip_v4:4000/discussions-data/';

  // get questions
  static String get_question_URL = 'http://$ip_v4:4000/questions-data/';
  static String question_post_URL = 'http://$ip_v4:4000/questions-data/add/';

  //get answers
  static String get_answer_URL = 'http://$ip_v4:4000/answers-data/';
  static String answer_post_URL = 'http://$ip_v4:4000/answers-data/add/';
  static String get_photo_URL = 'http://$ip_v4:4000/answers-data/files/';

  //get users
  static String login_URL = 'http://$ip_v4:4000/user/login/';
  static String logout_URL = 'http://$ip_v4:4000/user/logout/';
  static String register_URL = 'http://$ip_v4:4000/user/register/';
  static String get_user_URL = 'http://$ip_v4:4000/user/';
}
