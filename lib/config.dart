
const gameWidth = 360.0;
const gameHeight = 640.0;
const Gravity = 0;
const JumpVelocity = -300;

// score
const ScoreAdjust = 80;

// obstacle
const spawnRate = 1.1;
const obstacleSpeed = 140;

// player
const HorizontalSpeed = 200;
const AccVelo = 460; // how fast it speeds up when pressing
const Drag = 6.0;   // counterforce that slows vy back to 0
const BiasG = 40; // tiny downward bias so it slowly sinks when idle (set to 0 if you want none)
const MaxVy = 260; // clamp vertical speed