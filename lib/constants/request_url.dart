Uri url(String endPoint) {
  final url = Uri.parse('http://192.168.1.13:3000/$endPoint');
  //final url = Uri.parse('http://172.20.10.3:3000/$endPoint');
  return url;
}
