import pytest
from unittest.mock import patch
import requests
from meal_max.utils.random_utils import get_random

@patch("meal_max.utils.random_utils.requests.get")
def test_get_random_success(mock_get):
    mock_get.return_value.status_code = 200
    mock_get.return_value.text = "0.42"
    random_number = get_random()
    assert random_number == 0.42

@patch("meal_max.utils.random_utils.requests.get")
def test_get_random_timeout(mock_get):
    mock_get.side_effect = requests.exceptions.Timeout
    with pytest.raises(RuntimeError, match="Request to random.org timed out."):
        get_random()

@patch("meal_max.utils.random_utils.requests.get")
def test_get_random_invalid_response(mock_get):
    mock_get.return_value.status_code = 200
    mock_get.return_value.text = "invalid"
    with pytest.raises(ValueError, match="Invalid response from random.org: invalid"):
        get_random()