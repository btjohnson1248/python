import app.main


def test_main() -> None:
    resp = app.main.main()
    assert resp == "hello"


def test_hello() -> None:
    app.main.hello()
