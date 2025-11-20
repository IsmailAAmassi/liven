class Endpoints {
  Endpoints._();

  static const login = '/mobile/login';
  static const register = '/mobile/register';
  static const sendOtp = '/mobile/user/otp/send';
  static const verifyOtp = '/mobile/user/otp/verify';
  static const resetPassword = '/mobile/user/password/forget/update';
  static const forgotPassword = '/mobile/forgot';
  static const logout = '/mobile/logout';
  static const refreshToken = '/mobile/token/refresh';
  static const completeProfile = '/mobile/register/continue';

  static const settings = '/mobile/setting/tabs';
  static const terms = '/mobile/setting/conditions';
}
