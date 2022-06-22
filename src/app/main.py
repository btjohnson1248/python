"""Application module."""

import logging
import os
from typing import List

logger = logging.basicConfig()


def main() -> str:
    """Main entrypint for the program.

    More details
    """
    a = [
        "safdsadddddddddddddddddddddddddddd",
        "sadfasfejaoiefjaoienoifansoinfasoienfoasienfoasienfoasinefoiasnefoisanefoisanefoisanefoiansefoniasefinasoiefnase",
    ]
    asa = os.getenv("TEST")
    if asa is not None:
        print("Test env not set")  # noqa: T201

    hello(a)

    return "hello"


def hello(arg_list: List[str]) -> None:
    """Prints the list passed into it.

    Examples:
        >>> hello(["hello", "world"])
        hello
        world

    Args:
        arg_list (List[str]): The list to process

    Returns
        None
    """
    for each in arg_list:
        print(each)  # noqa: T201


if __name__ == "__main__":  # pragma: no cover
    main()
