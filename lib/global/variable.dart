import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

Logger logger = new Logger();
final Dio dio = Dio();
Response? response;

String baseUrl = "https://be.lms-staging.madrasahkemenag.com/api/v1/";

List<dynamic> userData = [];
List<dynamic> listfaq = [];
List<dynamic> detailfaq = [];

int menus = 0;
int? id_faq;

bool isEdited = false;
