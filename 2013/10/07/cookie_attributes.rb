require 'sinatra'

get '/' do
  response.set_cookie('none',      value: 'none')
  response.set_cookie('http-only', value: 'http-only', httponly: true)
  response.set_cookie('secure',    value: 'secure',                    secure: true)
  response.set_cookie('both',      value: 'both',      httponly: true, secure: true)
  erb :index
end

post '/new' do
  "params: #{params[:in]}, cookies: #{request.cookies}"
end

__END__

@@index
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
  <title>Cookie attributes</title>
</head>
<body>
  <title>Cookie attributes</title>
  <input type="text" id="input">
  <p>result:</p><span id="result"></span>
  <p>local cookie:</p><span id="local-cookie"</span>
  <script src="//code.jquery.com/jquery-2.0.3.min.js"></script>
  <script>
$(function() {
  $('#input').keyup(function() {
    $.post('/new',
           {
               in: $('#input').val()
           },
           function(ret) {
             $('#result').text(ret);
             $('#local-cookie').text(document.cookie)
           });
  });
});
  </script>
</body>
