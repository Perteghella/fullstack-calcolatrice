import math
import warnings

import pytest

from operazioni import somma


def test_somma_with_ints():
    assert somma(2, 3) == 5


def test_somma_with_floats():
    assert somma(2.5, 3.25) == 5.75


def test_somma_with_mixed_int_and_float():
    assert somma(2, 3.5) == 5.5


def test_somma_with_negative_and_zero():
    assert somma(-1, 1) == 0
    assert somma(0, 0) == 0


def test_somma_with_large_numbers():
    assert somma(10**18, 10**18) == 2 * 10**18


def test_somma_with_nan_and_inf():
    # NaN propagates
    nan_result = somma(float('nan'), 1)
    assert math.isnan(nan_result)

    # infinity arithmetic
    assert somma(float('inf'), 1) == float('inf')
    assert somma(float('-inf'), float('inf')) != somma(0, 0)  # should be NaN


def test_non_numeric_a_warns_and_treated_as_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = somma("not-a-number", 5)

        assert result == 5
        assert len(w) == 1
        assert "'a' non è un numero" in str(w[0].message)
        assert "str" in str(w[0].message)


def test_non_numeric_b_warns_and_treated_as_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = somma(7, None)

        assert result == 7
        assert len(w) == 1
        assert "'b' non è un numero" in str(w[0].message)
        assert "NoneType" in str(w[0].message)


def test_both_non_numeric_warn_twice_and_return_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = somma([], {})

        assert result == 0
        # two warnings, one for 'a' and one for 'b'
        assert len(w) == 2
        msgs = "\n".join(str(x.message) for x in w)
        assert "'a' non è un numero" in msgs
        assert "'b' non è un numero" in msgs


# Additional tests to assert behaviour with objects that are not int/float but implement __int__
class IntLike:
    def __int__(self):
        return 9


def test_object_with_dunder_int_is_not_considered_numeric():
    # Since the function checks isinstance(..., (int, float)), objects with __int__ are non-numeric
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = somma(IntLike(), 1)

        assert result == 1  # IntLike treated as 0
        assert len(w) == 1
        assert "'a' non è un numero" in str(w[0].message)
