import logging
import os

logger = logging.basicConfig()


def main() -> str:
    a = [
        "safdsadddddddddddddddddddddddddddd",
        "sadfasfejaoiefjaoienoifansoinfasoienfoasienfoasienfoasinefoiasnefoisanefoisanefoisanefoiansefoniasefinasoiefnase",
    ]
    asa = os.getenv("TEST")
    print(asa)  # noqa: T201
    print(a)  # noqa: T201
    return "hello"


def hello() -> None:
    print("Hello")  # noqa: T201


if __name__ == "__main__":  # pragma: no cover
    main()
