"""Проверка ЛР 7 при запущенном Apache Tomcat на порту 8081."""
from http.cookiejar import CookieJar
from urllib.parse import urlencode
from urllib.request import HTTPCookieProcessor, Request, build_opener

BASE = "http://localhost:8081/lab7-webapp/"
opener = build_opener(HTTPCookieProcessor(CookieJar()))

def text(request):
    with opener.open(request, timeout=10) as response:
        return response.read().decode("utf-8")

start = text(Request(BASE))
assert "Параметры пользователя" in start

first = text(Request(BASE, data=urlencode({"userName": "Опаш", "pageColor": "lightgreen"}).encode(), method="POST"))
assert "Здравствуйте, <strong>Опаш</strong>" in first
assert "lab7.pageColor</td><td>lightgreen" in first
assert "Количество обращений</td><td>1" in first
assert "Дата последнего обращения" in first

second = text(Request(BASE, data=urlencode({"userName": "Опаш", "pageColor": "lavender"}).encode(), method="POST"))
assert "lab7.pageColor</td><td>lavender" in second
assert "Количество обращений</td><td>2" in second
print("Проверка пройдена: Cookie, цвет и параметры сессии работают корректно.")
