import 'dart:html';
import 'dart:json' as JSON;

InputElement _gitUrlInput = query('#gitUrl');
InputElement _buildButton = query('#buildButton');
Element _textElement = query('#text');

main() {
  _gitUrlInput.value = "https://github.com/ggirou/higgins-server.git";
  _buildButton.onClick.listen((_) => build());
}

build() {
  var gitUrl = _gitUrlInput.value;
  _textElement.text = "Build $gitUrl";

  String data = JSON.stringify({"git_url": gitUrl});
  HttpRequest.request("/build/", method: "POST", sendData: data).then((request) {
    String responseData = request.responseText;
    print("responseData: $responseData");
    
    var response = JSON.parse(responseData);
    showCommandResult(response["build_id"]);
  });
}

void showCommandResult(String buildId) {
  var source = new EventSource('/command/$buildId/');
  source
  ..onOpen.listen((_) => print("Open EventSource"))
  ..onMessage.listen((MessageEvent me) {
    print(me.data);
    _textElement.innerHtml = "${_textElement.innerHtml}<br>${me.data}";
  })
  ..onError.listen((e) => print("Error $e"));
}