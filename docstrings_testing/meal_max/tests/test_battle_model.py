import pytest
from meal_max.models.battle_model import BattleModel
from meal_max.models.kitchen_model import Meal

@pytest.fixture
def battle_model():
    return BattleModel()

@pytest.fixture
def meal_1():
    return Meal(id=1, meal="Burger", cuisine="American", price=10.0, difficulty="MED")

@pytest.fixture
def meal_2():
    return Meal(id=2, meal="Pizza", cuisine="Italian", price=12.0, difficulty="HIGH")

def test_battle_insufficient_combatants(battle_model):
    with pytest.raises(ValueError, match="Two combatants must be prepped for a battle."):
        battle_model.battle()

def test_battle_with_combatants(battle_model, meal_1, meal_2):
    battle_model.prep_combatant(meal_1)
    battle_model.prep_combatant(meal_2)
    winner = battle_model.battle()
    assert winner in [meal_1.meal, meal_2.meal]
    assert len(battle_model.combatants) == 1

def test_clear_combatants(battle_model, meal_1):
    battle_model.prep_combatant(meal_1)
    battle_model.clear_combatants()
    assert battle_model.combatants == []

def test_get_battle_score(battle_model, meal_1):
    score = battle_model.get_battle_score(meal_1)
    expected_score = (meal_1.price * len(meal_1.cuisine)) - 2  # MED difficulty modifier
    assert score == expected_score

def test_prep_combatant(battle_model, meal_1, meal_2):
    battle_model.prep_combatant(meal_1)
    battle_model.prep_combatant(meal_2)
    with pytest.raises(ValueError, match="Combatant list is full, cannot add more combatants."):
        battle_model.prep_combatant(Meal(id=3, meal="Sushi", cuisine="Japanese", price=15.0, difficulty="LOW"))