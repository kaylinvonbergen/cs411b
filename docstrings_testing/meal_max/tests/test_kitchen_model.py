import pytest
from meal_max.models.kitchen_model import create_meal, delete_meal, get_leaderboard, get_meal_by_id, get_meal_by_name, update_meal_stats, Meal

@pytest.fixture
def sample_meal():
    return Meal(id=1, meal="Burger", cuisine="American", price=10.0, difficulty="MED")

def test_create_meal(sample_meal):
    create_meal("Burger", "American", 10.0, "MED")
    meal = get_meal_by_name("Burger")
    assert meal.meal == sample_meal.meal
    assert meal.cuisine == sample_meal.cuisine
    assert meal.price == sample_meal.price
    assert meal.difficulty == sample_meal.difficulty

def test_create_meal_duplicate():
    create_meal("Burger", "American", 10.0, "MED")
    with pytest.raises(ValueError, match="Meal with name 'Burger' already exists"):
        create_meal("Burger", "American", 10.0, "MED")

def test_delete_meal():
    create_meal("Pizza", "Italian", 12.0, "HIGH")
    meal = get_meal_by_name("Pizza")
    delete_meal(meal.id)
    with pytest.raises(ValueError, match=f"Meal with ID {meal.id} has been deleted"):
        get_meal_by_id(meal.id)

def test_get_meal_by_id(sample_meal):
    create_meal(sample_meal.meal, sample_meal.cuisine, sample_meal.price, sample_meal.difficulty)
    meal = get_meal_by_id(1)  # Assuming ID is 1 for testing
    assert meal.meal == sample_meal.meal

def test_get_meal_by_name():
    create_meal("Pasta", "Italian", 8.0, "LOW")
    meal = get_meal_by_name("Pasta")
    assert meal.meal == "Pasta"

def test_update_meal_stats():
    create_meal("Taco", "Mexican", 5.0, "LOW")
    meal = get_meal_by_name("Taco")
    update_meal_stats(meal.id, "win")
    updated_meal = get_meal_by_id(meal.id)
    assert updated_meal.wins == 1