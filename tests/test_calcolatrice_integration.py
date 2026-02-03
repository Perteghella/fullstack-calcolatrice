import pytest

from calcolatrice import main


def run_with_inputs(monkeypatch, inputs):
    """Helper: esegue main() sostituendo builtins.input con una sequenza di risposte."""
    it = iter(inputs)
    monkeypatch.setattr("builtins.input", lambda prompt="": next(it))
    # main prints to stdout; capture with capsys in the caller
    main()


def test_integration_sum_ints(monkeypatch, capsys):
    run_with_inputs(monkeypatch, ["2", "3", "s"])
    out = capsys.readouterr().out
    assert "2 + 3 = 5" in out


def test_integration_subtraction(monkeypatch, capsys):
    run_with_inputs(monkeypatch, ["10", "4", "t"])
    out = capsys.readouterr().out
    assert "10 - 4 = 6" in out


def test_integration_non_numeric_treated_as_zero(monkeypatch, capsys):
    run_with_inputs(monkeypatch, ["not-a-number", "5", "s"])
    out = capsys.readouterr().out
    assert "Primo valore non numerico" in out
    assert "0 + 5 = 5" in out


def test_integration_invalid_operation(monkeypatch, capsys):
    run_with_inputs(monkeypatch, ["1", "2", "x"])
    out = capsys.readouterr().out
    assert "Operazione non riconosciuta" in out
