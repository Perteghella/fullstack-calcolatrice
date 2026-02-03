# Operazioni matematiche di base

from typing import Union
import warnings

Numeric = Union[int, float]


def somma(a: Numeric, b: Numeric) -> Numeric:
    """Restituisce la somma di a e b.

    Controlla in modo semplice che `a` e `b` siano numeri (int o float).
    In caso di argomento non numerico emette un avviso (UserWarning) e
    considera l'argomento non valido come 0 invece di sollevare un errore.
    """
    if not isinstance(a, (int, float)):
        warnings.warn(
            f"'a' non è un numero (ricevuto {type(a).__name__}); verrà considerato 0",
            UserWarning,
        )
        a = 0
    if not isinstance(b, (int, float)):
        warnings.warn(
            f"'b' non è un numero (ricevuto {type(b).__name__}); verrà considerato 0",
            UserWarning,
        )
        b = 0
    return a + b


def sottrazione(a: Numeric, b: Numeric) -> Numeric:
    """Restituisce la sottrazione di b da a (a - b).

    Controlla in modo semplice che `a` e `b` siano numeri (int o float).
    In caso di argomento non numerico emette un avviso (UserWarning) e
    considera l'argomento non valido come 0 invece di sollevare un errore.
    """
    if not isinstance(a, (int, float)):
        warnings.warn(
            f"'a' non è un numero (ricevuto {type(a).__name__}); verrà considerato 0",
            UserWarning,
        )
        a = 0
    if not isinstance(b, (int, float)):
        warnings.warn(
            f"'b' non è un numero (ricevuto {type(b).__name__}); verrà considerato 0",
            UserWarning,
        )
        b = 0
    return a - b