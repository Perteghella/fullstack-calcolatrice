import math
import warnings

import pytest

from operazioni import sottrazione


def test_sottrazione_with_ints():
    assert sottrazione(5, 3) == 2


def test_sottrazione_with_floats():
    assert sottrazione(5.5, 2.25) == 3.25


def test_sottrazione_with_mixed_int_and_float():
    assert sottrazione(5, 2.5) == 2.5


def test_sottrazione_with_negative_and_zero():
    assert sottrazione(-1, 1) == -2
    assert sottrazione(0, 0) == 0


def test_sottrazione_with_large_numbers():
    assert sottrazione(10**18, 10**5) == 10**18 - 10**5


def test_sottrazione_with_nan_and_inf():
    # NaN propagates
    nan_result = sottrazione(float('nan'), 1)
    assert math.isnan(nan_result)

    # infinity arithmetic
    assert sottrazione(float('inf'), 1) == float('inf')
    assert math.isnan(sottrazione(float('inf'), float('inf')))


def test_non_numeric_a_warns_and_treated_as_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = sottrazione("not-a-number", 5)

        assert result == -5  # 'a' treated as 0 -> 0 - 5 == -5
        assert len(w) == 1
        assert "'a' non è un numero" in str(w[0].message)


def test_non_numeric_b_warns_and_treated_as_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = sottrazione(7, None)

        assert result == 7  # None treated as 0 -> 7 - 0 == 7
        assert len(w) == 1
        assert "'b' non è un numero" in str(w[0].message)


def test_both_non_numeric_warn_twice_and_return_zero_minus_zero():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = sottrazione([], {})

        assert result == 0
        # two warnings, one for 'a' and one for 'b'
        assert len(w) == 2
        msgs = "\n".join(str(x.message) for x in w)
        assert "'a' non è un numero" in msgs
        assert "'b' non è un numero" in msgs


class IntLike:
    def __int__(self):
        return 9


def test_object_with_dunder_int_is_not_considered_numeric():
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        result = sottrazione(IntLike(), 1)

        assert result == -1  # IntLike treated as 0 -> 0 - 1 == -1
        assert len(w) == 1
        assert "'a' non è un numero" in str(w[0].message)
