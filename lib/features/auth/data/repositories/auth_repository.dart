import '../../../../core/services/dio_service.dart';

class AuthRepository {
  final DioService dioService;

  AuthRepository(this.dioService);

  Future sendOtp({required String phone}) async {
    return await dioService.postData(
      endpoint: "/delivery/send-otp",
      data: {"phone": phone},
    );
  }

  Future verifyOtp({required String phone, required String code}) async {
    return await dioService.postData(
      endpoint: "/delivery/verify-otp",
      data: {"phone": phone, "code": code},
    );
  }
}
