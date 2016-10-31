function OnExecuteAbility1ButtonPressed()
{
  $.Msg("'S' Pressed or Released");
}

function OnTestButtonPressed()
{
  $.Msg("'Z' Pressed");
}

function OnTestButtonReleased()
{
  $.Msg("'Z' Released");
}

(function() {
  Game.AddCommand( "CustomGameExecuteAbility1", OnExecuteAbility1ButtonPressed, "", 0 );
  Game.AddCommand( "+CustomGameTestButton", OnTestButtonPressed, "", 0 );
  Game.AddCommand( "-CustomGameTestButton", OnTestButtonReleased, "", 0 );
})();