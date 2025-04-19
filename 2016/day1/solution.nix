rec {
  pkgs = import <nixpkgs> { }; # pin this??
  lib = pkgs.lib;
  s = pkgs.lib.strings;
  l = pkgs.lib.lists;

  inputToDirectionDiff = i:
    let
      splitted = s.stringToCharacters i;
      direction = builtins.elemAt splitted 0;
      directionTable = {
        "R" = 1;
        "L" = -1;
      };
    in
    {
      turn = directionTable."${direction}";
      steps = s.toInt (s.concatStrings (l.drop 1 splitted));
    };

  # 0 = UP # 1 = RIGHT # 2 = DOWN # 3 = LEFT
  compassTable = [
    (coords: steps: { x = coords.x; y = coords.y + steps; })
    (coords: steps: { x = coords.x + steps; y = coords.y; })
    (coords: steps: { x = coords.x; y = coords.y - steps; })
    (coords: steps: { x = coords.x - steps; y = coords.y; })
  ];

  parseInput = input: map inputToDirectionDiff (lib.splitString ", " input);

  initialState = { compass = 0; x = 0; y = 0; passedBy = [ ]; };

  foldFn = acc: step:
    let
      x = acc.compass + step.turn;
      nextCompass = lib.trivial.mod (if x < 0 then x + 4 else x) 4;
      transitionFn = builtins.elemAt compassTable nextCompass;
      pathWalked = l.map (x: transitionFn acc x) (l.range 1 step.steps);
      newCoords = l.last pathWalked;
    in
    {
      compass = nextCompass;
      x = newCoords.x;
      y = newCoords.y;
      passedBy = acc.passedBy ++ (l.map (x: "${builtins.toString x.x},${builtins.toString x.y}") pathWalked);
    };

  abs = x: if x < 0 then (-x) else x;

  distanceFrom0 = coords: (abs coords.x) + (abs coords.y);

  inputData = s.removeSuffix "\n" (builtins.readFile ./input);

  foldedState = input: lib.foldl foldFn initialState (parseInput input);

  solve1 = input: distanceFrom0 (foldedState input);

  solve2 = input:
    let
      state = { currIdx = 0; paths = [{ coord = "0,0"; idx = 0; hadPassed = false; }]; hadPassed = { "0,0" = true; }; };
      foldfn = acc: step:
        let
        in {
          currIdx = acc.currIdx + 1;
          paths = acc.paths ++ [{
            coord = step;
            idx = acc.currIdx + 1;
            hadPassed = builtins.hasAttr step acc.hadPassed;
          }];
          hadPassed = acc.hadPassed // { "${step}" = true; };
        };
      passedByPaths = lib.foldl foldfn state (foldedState input).passedBy;
      duplicatedPaths = l.filter (x: x.hadPassed) passedByPaths.paths;
    in
    distanceFrom0 l.head duplicatedPaths;
}
