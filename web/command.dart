import 'dart:html';

Element _textElement = query('#text');

main() {
  _textElement.text = "ping -c 10 google.fr";
  var source = new EventSource('/command/');
  source
    ..onOpen.listen((_) => print("Open"))
    ..onMessage.listen((MessageEvent me)  => _textElement.innerHtml = "${_textElement.innerHtml}<br>${me.data}")
    ..onError.listen((e) => print("Error $e"));
}
