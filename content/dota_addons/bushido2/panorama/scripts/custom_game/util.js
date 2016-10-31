Game.OnEnterPressed = function() {
    for (var key in Game.enterListeners) {
        Game.enterListeners[key]();
    }
}